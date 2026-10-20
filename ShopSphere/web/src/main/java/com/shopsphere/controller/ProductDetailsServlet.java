package com.shopsphere.controller;

import com.shopsphere.dao.ReviewDAO;
import com.shopsphere.dao.WishlistDAO;
import com.shopsphere.model.Product;
import com.shopsphere.model.Review;
import com.shopsphere.model.User;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailsServlet", urlPatterns = {"/product-details"})
public class ProductDetailsServlet extends HttpServlet {

    private ProductService productService;
    private ReviewDAO reviewDAO;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
        this.reviewDAO = new ReviewDAO();
        this.wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            Product product = productService.getProduct(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            // Demonstrate Cookies: Recently Viewed Product IDs
            Cookie recentCookie = new Cookie("lastViewedProduct", String.valueOf(productId));
            recentCookie.setMaxAge(7 * 24 * 60 * 60);
            recentCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            response.addCookie(recentCookie);

            List<Review> reviews = reviewDAO.getReviewsByProductId(productId);
            double avgRating = reviewDAO.getAverageRating(productId);
            int reviewCount = reviewDAO.getReviewCount(productId);

            boolean inWishlist = false;
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                inWishlist = wishlistDAO.isInWishlist(user.getUserId(), productId);
            }

            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviewCount);
            request.setAttribute("inWishlist", inWishlist);

            request.getRequestDispatcher("/product-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
