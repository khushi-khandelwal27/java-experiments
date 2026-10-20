package com.shopsphere.swing.model;

public class OrderItem {
    private int orderId;
    private String customerName;
    private double amount;
    private String paymentMethod;
    private String orderStatus;
    private String createdAt;

    public OrderItem(int orderId, String customerName, double amount, String paymentMethod, String orderStatus, String createdAt) {
        this.orderId = orderId;
        this.customerName = customerName;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.orderStatus = orderStatus;
        this.createdAt = createdAt;
    }

    public int getOrderId() { return orderId; }
    public String getCustomerName() { return customerName; }
    public double getAmount() { return amount; }
    public String getPaymentMethod() { return paymentMethod; }
    public String getOrderStatus() { return orderStatus; }
    public String getCreatedAt() { return createdAt; }
}
