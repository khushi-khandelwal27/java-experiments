package com.shopsphere.controller;

import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Order;
import com.shopsphere.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.orderDAO = new OrderDAO();
        this.productDAO = new ProductDAO();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        double totalRevenue = orderDAO.getTotalRevenue();
        int totalOrders = orderDAO.getTotalOrderCount();
        int totalProducts = productDAO.getAllProducts().size();
        int totalUsers = userDAO.getAllUsers().size();

        List<Product> lowStockProducts = productDAO.getLowStockProducts(15);
        List<Order> recentOrders = orderDAO.getAllOrders();
        if (recentOrders.size() > 5) {
            recentOrders = recentOrders.subList(0, 5);
        }

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("recentOrders", recentOrders);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
