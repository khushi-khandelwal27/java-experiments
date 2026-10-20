package com.shopsphere.controller;

import com.shopsphere.model.Order;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/invoice"})
public class InvoiceServlet extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        this.orderService = new OrderService();
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

        String idParam = request.getParameter("orderId");
        if (idParam == null || idParam.isEmpty()) {
            idParam = request.getParameter("id");
        }

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = orderService.getOrderDetails(orderId);
                if (order != null && (order.getUserId() == user.getUserId() || user.isAdmin())) {
                    // Calculate 18% GST breakdown (CGST 9% + SGST 9%)
                    double total = order.getTotalAmount();
                    double taxableAmount = Math.round((total / 1.18) * 100.0) / 100.0;
                    double totalGst = Math.round((total - taxableAmount) * 100.0) / 100.0;
                    double cgst = Math.round((totalGst / 2.0) * 100.0) / 100.0;
                    double sgst = Math.round((totalGst - cgst) * 100.0) / 100.0;

                    request.setAttribute("order", order);
                    request.setAttribute("taxableAmount", taxableAmount);
                    request.setAttribute("cgst", cgst);
                    request.setAttribute("sgst", sgst);
                    request.setAttribute("totalGst", totalGst);

                    request.getRequestDispatcher("/invoice.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/orders");
    }
}
