package com.shopsphere.controller;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

    private ProductService productService;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
        this.categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String catParam = request.getParameter("category");
        String sort = request.getParameter("sort");

        Integer categoryId = null;
        if (catParam != null && !catParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(catParam);
            } catch (NumberFormatException ignored) {}
        }

        List<Product> products = productService.searchAndFilter(query, categoryId, sort);
        List<Category> categories = categoryDAO.getActiveCategories();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("searchQuery", query);
        request.setAttribute("currentSort", sort);

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }
}
