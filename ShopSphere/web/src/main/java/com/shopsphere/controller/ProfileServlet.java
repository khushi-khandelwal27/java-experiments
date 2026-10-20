package com.shopsphere.controller;

import com.shopsphere.dao.AddressDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Address;
import com.shopsphere.model.User;
import com.shopsphere.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO;
    private AddressDAO addressDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAO();
        this.addressDAO = new AddressDAO();
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

        User freshUser = userDAO.findById(user.getUserId());
        List<Address> addresses = addressDAO.getAddressesByUserId(user.getUserId());

        request.setAttribute("profileUser", freshUser);
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
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
        if ("updateProfile".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String mobile = request.getParameter("mobile");
            user.setName(name);
            user.setMobile(mobile);
            userDAO.updateProfile(user);
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/profile?msg=updated");
        } else if ("changePassword".equalsIgnoreCase(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String hashedCurrent = DBConnection.hashPassword(currentPassword);

            User authenticated = userDAO.authenticate(user.getEmail(), hashedCurrent);
            if (authenticated != null && newPassword != null && newPassword.length() >= 6) {
                userDAO.updatePassword(user.getUserId(), DBConnection.hashPassword(newPassword));
                response.sendRedirect(request.getContextPath() + "/profile?msg=pwd_changed");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=invalid_current_pwd");
            }
        } else if ("addAddress".equalsIgnoreCase(action)) {
            String addressLine = request.getParameter("addressLine");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String pincode = request.getParameter("pincode");
            String addressType = request.getParameter("addressType");

            Address addr = new Address();
            addr.setUserId(user.getUserId());
            addr.setAddressLine(addressLine);
            addr.setCity(city);
            addr.setState(state);
            addr.setPincode(pincode);
            addr.setAddressType(addressType);
            addressDAO.addAddress(addr);

            response.sendRedirect(request.getContextPath() + "/profile?msg=addr_added");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
