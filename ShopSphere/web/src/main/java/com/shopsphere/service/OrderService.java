package com.shopsphere.service;

import com.shopsphere.dao.OrderDAO;
import com.shopsphere.model.Order;

import java.util.List;

public class OrderService {

    private final OrderDAO orderDAO;

    public OrderService() {
        this.orderDAO = new OrderDAO();
    }

    public List<Order> getUserOrders(int userId) {
        return orderDAO.getOrdersByUserId(userId);
    }

    public Order getOrderDetails(int orderId) {
        return orderDAO.getOrderById(orderId);
    }

    public List<Order> getAllOrdersForAdmin() {
        return orderDAO.getAllOrders();
    }

    public boolean updateStatus(int orderId, String newStatus) {
        return orderDAO.updateOrderStatus(orderId, newStatus);
    }

    public double getTotalRevenue() {
        return orderDAO.getTotalRevenue();
    }

    public int getTotalOrderCount() {
        return orderDAO.getTotalOrderCount();
    }
}
