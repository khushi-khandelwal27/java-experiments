package com.shopsphere.controller;

import com.shopsphere.dao.WishlistDAO;
import com.shopsphere.model.User;
import com.shopsphere.model.WishlistItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/wishlist"})
public class WishlistServlet extends HttpServlet {

    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        this.wishlistDAO = new WishlistDAO();
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

        List<WishlistItem> items = wishlistDAO.getWishlistByUserId(user.getUserId());
        request.setAttribute("wishlistItems", items);
        request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
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
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            if ("add".equalsIgnoreCase(action)) {
                wishlistDAO.addToWishlist(user.getUserId(), productId);
            } else if ("remove".equalsIgnoreCase(action)) {
                wishlistDAO.removeFromWishlist(user.getUserId(), productId);
            }
        } catch (Exception ignored) {}

        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl != null && !returnUrl.isEmpty()) {
            response.sendRedirect(returnUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }
}
