package com.shopsphere.service;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.dao.CouponDAO;
import com.shopsphere.dao.OrderDAO;
import com.shopsphere.model.*;

import java.util.ArrayList;
import java.util.List;

public class CheckoutService {

    private final CartDAO cartDAO;
    private final CouponDAO couponDAO;
    private final OrderDAO orderDAO;

    public CheckoutService() {
        this.cartDAO = new CartDAO();
        this.couponDAO = new CouponDAO();
        this.orderDAO = new OrderDAO();
    }

    public OrderResult processCheckout(int userId, Integer addressId, String couponCode, String paymentMethod) {
        return processCheckout(userId, addressId, couponCode, paymentMethod, null);
    }

    public OrderResult processCheckout(int userId, Integer addressId, String couponCode, String paymentMethod, String customTxnRef) {
        List<CartItem> cartItems = cartDAO.getCartByUserId(userId);
        if (cartItems == null || cartItems.isEmpty()) {
            return new OrderResult(false, "Your shopping cart is empty.", null);
        }

        // Validate stock and calculate subtotal
        double subtotal = 0.0;
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cartItems) {
            Product p = ci.getProduct();
            if (p == null || p.getStock() < ci.getQuantity()) {
                return new OrderResult(false, "Item '" + (p != null ? p.getName() : "Item") + "' has insufficient stock.", null);
            }
            double itemPrice = p.getDiscountedPrice();
            subtotal += itemPrice * ci.getQuantity();

            OrderItem oi = new OrderItem();
            oi.setProductId(ci.getProductId());
            oi.setQuantity(ci.getQuantity());
            oi.setPrice(itemPrice);
            orderItems.add(oi);
        }
        subtotal = Math.round(subtotal * 100.0) / 100.0;

        // Apply Coupon on server
        double discount = 0.0;
        Coupon appliedCoupon = null;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            appliedCoupon = couponDAO.getCouponByCode(couponCode.trim());
            if (appliedCoupon != null) {
                discount = appliedCoupon.calculateDiscount(subtotal);
            }
        }

        double finalAmount = Math.max(0.0, Math.round((subtotal - discount) * 100.0) / 100.0);

        // Build Order
        Order order = new Order();
        order.setUserId(userId);
        order.setAddressId(addressId);
        order.setTotalAmount(finalAmount);
        order.setDiscount(discount);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
        order.setPaymentStatus("COD".equalsIgnoreCase(paymentMethod) ? "PENDING" : "COMPLETED");
        order.setOrderStatus("PLACED");

        // Build Payment
        Payment payment = new Payment();
        payment.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
        payment.setAmount(finalAmount);
        payment.setPaymentStatus(order.getPaymentStatus());

        String txnRef;
        if (customTxnRef != null && !customTxnRef.trim().isEmpty()) {
            txnRef = customTxnRef.trim();
        } else if ("COD".equalsIgnoreCase(paymentMethod)) {
            txnRef = "COD-" + (System.currentTimeMillis() % 1000000);
        } else if ("UPI".equalsIgnoreCase(paymentMethod)) {
            txnRef = "UPI-REF-" + (System.currentTimeMillis() % 100000000);
        } else if ("CARD".equalsIgnoreCase(paymentMethod)) {
            txnRef = "CARD-AUTH-" + (System.currentTimeMillis() % 100000000);
        } else {
            txnRef = "TXN-" + System.currentTimeMillis();
        }
        payment.setTransactionReference(txnRef);

        boolean success = orderDAO.placeOrder(order, orderItems, payment);
        if (success) {
            order.setPayment(payment);
            if (appliedCoupon != null && discount > 0) {
                couponDAO.recordUsage(appliedCoupon.getCouponId(), userId, order.getOrderId());
            }
            return new OrderResult(true, "Order placed successfully!", order);
        } else {
            return new OrderResult(false, "Failed to place order due to inventory or database error.", null);
        }
    }

    public static class OrderResult {
        private final boolean success;
        private final String message;
        private final Order order;

        public OrderResult(boolean success, String message, Order order) {
            this.success = success;
            this.message = message;
            this.order = order;
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Order getOrder() { return order; }
    }
}
