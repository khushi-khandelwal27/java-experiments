package com.shopsphere.controller;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        this.cartDAO = new CartDAO();
        this.productDAO = new ProductDAO();
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
        double subtotal = 0.0;
        for (CartItem item : cartItems) {
            subtotal += item.getItemTotal();
        }
        subtotal = Math.round(subtotal * 100.0) / 100.0;

        session.setAttribute("cartCount", cartDAO.getCartCount(user.getUserId()));
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
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

        String action = request.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = 1;
                if (request.getParameter("quantity") != null) {
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                }
                Product p = productDAO.getProductById(productId);
                if (p != null && p.getStock() >= quantity) {
                    cartDAO.addToCart(user.getUserId(), productId, quantity);
                }
            } catch (Exception ignored) {}
            session.setAttribute("cartCount", cartDAO.getCartCount(user.getUserId()));
            response.sendRedirect(request.getContextPath() + "/cart");
        } else if ("update".equalsIgnoreCase(action)) {
            try {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cartDAO.updateQuantity(cartId, quantity);
            } catch (Exception ignored) {}
            session.setAttribute("cartCount", cartDAO.getCartCount(user.getUserId()));
            response.sendRedirect(request.getContextPath() + "/cart");
        } else if ("remove".equalsIgnoreCase(action)) {
            try {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                cartDAO.removeFromCart(cartId);
            } catch (Exception ignored) {}
            session.setAttribute("cartCount", cartDAO.getCartCount(user.getUserId()));
            response.sendRedirect(request.getContextPath() + "/cart");
        } else if ("clear".equalsIgnoreCase(action)) {
            cartDAO.clearCart(user.getUserId());
            session.setAttribute("cartCount", 0);
            response.sendRedirect(request.getContextPath() + "/cart");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
