package com.shopsphere.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Intercepts requests to protected customer areas (cart, checkout, profile, orders, wishlist)
 * and verifies active authentication session.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
        "/cart", "/cart.jsp",
        "/checkout", "/checkout.jsp",
        "/orders", "/orders.jsp",
        "/order-details", "/order-details.jsp",
        "/order-success.jsp",
        "/profile", "/profile.jsp",
        "/wishlist", "/wishlist.jsp"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            String uri = httpRequest.getRequestURI();
            String query = httpRequest.getQueryString();
            String redirectUrl = uri + (query != null ? "?" + query : "");
            httpRequest.getSession(true).setAttribute("redirectAfterLogin", redirectUrl);

            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?msg=auth_required");
        }
    }

    @Override
    public void destroy() {}
}
