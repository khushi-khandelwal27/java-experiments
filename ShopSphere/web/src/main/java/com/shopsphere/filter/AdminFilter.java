package com.shopsphere.filter;

import com.shopsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Intercepts requests to /admin/* and validates that the authenticated user possesses the ADMIN role.
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
            chain.doFilter(request, response);
        } else {
            // Unauthorized access to administrative portal
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=admin_access_required");
        }
    }

    @Override
    public void destroy() {}
}
