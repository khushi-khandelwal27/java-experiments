package com.shopsphere.controller;

import com.shopsphere.dao.ReviewDAO;
import com.shopsphere.model.Review;
import com.shopsphere.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        this.reviewDAO = new ReviewDAO();
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

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String reviewText = request.getParameter("reviewText");

            Review review = new Review();
            review.setUserId(user.getUserId());
            review.setProductId(productId);
            review.setRating(Math.max(1, Math.min(5, rating)));
            review.setReviewText(reviewText != null ? reviewText.trim() : "");

            reviewDAO.addReview(review);
            response.sendRedirect(request.getContextPath() + "/product-details?id=" + productId + "&msg=review_added");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
