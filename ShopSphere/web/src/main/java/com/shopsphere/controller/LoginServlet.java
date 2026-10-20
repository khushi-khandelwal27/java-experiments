package com.shopsphere.controller;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.model.User;
import com.shopsphere.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private AuthService authService;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        this.authService = new AuthService();
        this.cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        User user = authService.login(email, password);
        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            // Update cart count in session
            int count = cartDAO.getCartCount(user.getUserId());
            session.setAttribute("cartCount", count);

            // Handle Cookies (safe usage: store email for convenience, never passwords)
            if ("on".equalsIgnoreCase(rememberMe)) {
                Cookie emailCookie = new Cookie("savedUserEmail", user.getEmail());
                emailCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                emailCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                response.addCookie(emailCookie);
            }

            String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
            if (redirectAfterLogin != null && !redirectAfterLogin.isEmpty()) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectAfterLogin);
                return;
            }

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email address or password. Please try again.");
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
