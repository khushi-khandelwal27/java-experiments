package com.shopsphere.controller;

import com.shopsphere.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        this.authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String mobile = request.getParameter("mobile");

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            preserveForm(request, name, email, mobile);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            preserveForm(request, name, email, mobile);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        boolean registered = authService.register(name, email, password, mobile);
        if (registered) {
            request.setAttribute("successMessage", "Account created successfully! Please sign in with your credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed. That email may already be in use.");
            preserveForm(request, name, email, mobile);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveForm(HttpServletRequest request, String name, String email, String mobile) {
        request.setAttribute("enteredName", name);
        request.setAttribute("enteredEmail", email);
        request.setAttribute("enteredMobile", mobile);
    }
}
