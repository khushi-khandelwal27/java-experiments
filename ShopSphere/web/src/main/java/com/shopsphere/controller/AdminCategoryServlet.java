package com.shopsphere.controller;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {"/admin/categories"})
public class AdminCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        this.categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Category cat = categoryDAO.getCategoryById(id);
                request.setAttribute("editCategory", cat);
            } catch (Exception ignored) {}
        }

        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.deleteCategory(id);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin/categories?msg=deleted");
            return;
        }

        try {
            String idParam = request.getParameter("categoryId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            Category cat = new Category();
            cat.setName(name);
            cat.setDescription(description);
            cat.setStatus(status != null ? status : "ACTIVE");

            if (idParam != null && !idParam.trim().isEmpty()) {
                cat.setCategoryId(Integer.parseInt(idParam));
                categoryDAO.updateCategory(cat);
                response.sendRedirect(request.getContextPath() + "/admin/categories?msg=updated");
            } else {
                categoryDAO.addCategory(cat);
                response.sendRedirect(request.getContextPath() + "/admin/categories?msg=created");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=failed");
        }
    }
}
