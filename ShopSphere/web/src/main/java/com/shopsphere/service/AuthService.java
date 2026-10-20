package com.shopsphere.service;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;
import com.shopsphere.util.DBConnection;

public class AuthService {

    private final UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public AuthService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public User login(String email, String plainPassword) {
        if (email == null || plainPassword == null || email.trim().isEmpty() || plainPassword.isEmpty()) {
            return null;
        }
        String hashedPassword = DBConnection.hashPassword(plainPassword);
        return userDAO.authenticate(email.trim().toLowerCase(), plainPassword, hashedPassword);
    }

    public boolean register(String name, String email, String plainPassword, String mobile) {
        if (name == null || email == null || plainPassword == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || plainPassword.length() < 6) {
            return false;
        }
        if (userDAO.findByEmail(email.trim().toLowerCase()) != null) {
            return false; // Email already exists
        }
        String hashedPassword = DBConnection.hashPassword(plainPassword);
        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(hashedPassword);
        user.setMobile(mobile != null ? mobile.trim() : "");
        user.setRole("CUSTOMER");
        user.setStatus("ACTIVE");
        return userDAO.register(user);
    }

    public User getUserById(int userId) {
        return userDAO.findById(userId);
    }
}

