package com.shopsphere.controller;

import com.shopsphere.dao.AddressDAO;
import com.shopsphere.dao.CartDAO;
import com.shopsphere.dao.CouponDAO;
import com.shopsphere.model.*;
import com.shopsphere.service.CheckoutService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/place-order"})
public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO;
    private AddressDAO addressDAO;
    private CouponDAO couponDAO;
    private CheckoutService checkoutService;

    @Override
    public void init() throws ServletException {
        this.cartDAO = new CartDAO();
        this.addressDAO = new AddressDAO();
        this.couponDAO = new CouponDAO();
        this.checkoutService = new CheckoutService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=auth_required");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartByUserId(user.getUserId());
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double subtotal = 0.0;
        for (CartItem ci : cartItems) {
            subtotal += ci.getItemTotal();
        }
        subtotal = Math.round(subtotal * 100.0) / 100.0;

        List<Address> addresses = addressDAO.getAddressesByUserId(user.getUserId());
        List<Coupon> coupons = couponDAO.getAllCoupons();

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("addresses", addresses);
        request.setAttribute("coupons", coupons);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=auth_required");
            return;
        }

        String addressOption = request.getParameter("addressOption");
        Integer addressId = null;

        if ("new".equalsIgnoreCase(addressOption)) {
            String addressLine = request.getParameter("addressLine");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String pincode = request.getParameter("pincode");
            String addressType = request.getParameter("addressType");

            if (addressLine != null && !addressLine.trim().isEmpty() &&
                city != null && !city.trim().isEmpty() &&
                pincode != null && !pincode.trim().isEmpty()) {
                Address newAddr = new Address();
                newAddr.setUserId(user.getUserId());
                newAddr.setAddressLine(addressLine.trim());
                newAddr.setCity(city.trim());
                newAddr.setState(state != null ? state.trim() : "Rajasthan");
                newAddr.setPincode(pincode.trim());
                newAddr.setAddressType(addressType != null ? addressType : "HOME");
                if (addressDAO.addAddress(newAddr)) {
                    addressId = newAddr.getAddressId();
                }
            }
        } else {
            String existingAddrParam = request.getParameter("addressId");
            if (existingAddrParam != null && !existingAddrParam.isEmpty()) {
                try {
                    addressId = Integer.parseInt(existingAddrParam);
                } catch (NumberFormatException ignored) {}
            }
        }

        String couponCode = request.getParameter("couponCode");
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }

        String customTxnRef = null;
        if ("UPI".equalsIgnoreCase(paymentMethod)) {
            String upiId = request.getParameter("upiId");
            if (upiId != null && !upiId.trim().isEmpty()) {
                String cleanUpi = upiId.trim().replaceAll("[^a-zA-Z0-9@.]", "");
                customTxnRef = "UPI/" + cleanUpi + "/" + (System.currentTimeMillis() % 10000000);
            } else {
                customTxnRef = "UPI-APP-" + (System.currentTimeMillis() % 10000000);
            }
        } else if ("CARD".equalsIgnoreCase(paymentMethod)) {
            String cardNumber = request.getParameter("cardNumber");
            String cardHolder = request.getParameter("cardHolder");
            String last4 = "8899";
            if (cardNumber != null && cardNumber.replaceAll("\\s+", "").length() >= 4) {
                String cleaned = cardNumber.replaceAll("\\s+", "");
                last4 = cleaned.substring(cleaned.length() - 4);
            }
            customTxnRef = "CARD-AUTH-" + last4 + "-" + (System.currentTimeMillis() % 100000);
        } else if ("NETBANKING".equalsIgnoreCase(paymentMethod)) {
            String bank = request.getParameter("bankName");
            if (bank == null || bank.trim().isEmpty()) bank = "HDFC";
            customTxnRef = "NB-" + bank.toUpperCase() + "-" + (System.currentTimeMillis() % 1000000);
        } else {
            customTxnRef = "COD-VERIFIED-" + (System.currentTimeMillis() % 1000000);
        }

        CheckoutService.OrderResult result = checkoutService.processCheckout(
                user.getUserId(),
                addressId,
                couponCode,
                paymentMethod,
                customTxnRef
        );

        if (result.isSuccess()) {
            session.setAttribute("cartCount", 0);
            response.sendRedirect(request.getContextPath() + "/order-success.jsp?orderId=" + result.getOrder().getOrderId());
        } else {
            request.setAttribute("errorMessage", result.getMessage());
            doGet(request, response);
        }
    }
}
