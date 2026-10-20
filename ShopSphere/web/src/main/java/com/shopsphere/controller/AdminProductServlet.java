package com.shopsphere.controller;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products"})
public class AdminProductServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getProductById(id);
                request.setAttribute("editProduct", product);
            } catch (Exception ignored) {}
        }

        List<Product> products = productDAO.getAllProducts();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                productDAO.deleteProduct(id);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin/products?msg=deleted");
            return;
        }

        // Add or Update
        try {
            String idParam = request.getParameter("productId");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            double discount = Double.parseDouble(request.getParameter("discount"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String imageUrl = request.getParameter("imageUrl");
            String status = request.getParameter("status");

            Product p = new Product();
            p.setCategoryId(categoryId);
            p.setName(name);
            p.setBrand(brand);
            p.setDescription(description);
            p.setPrice(price);
            p.setDiscount(discount);
            p.setStock(stock);
            p.setImageUrl(imageUrl);
            p.setStatus(status != null ? status : "ACTIVE");

            if (idParam != null && !idParam.trim().isEmpty()) {
                p.setProductId(Integer.parseInt(idParam));
                productDAO.updateProduct(p);
                response.sendRedirect(request.getContextPath() + "/admin/products?msg=updated");
            } else {
                productDAO.addProduct(p);
                response.sendRedirect(request.getContextPath() + "/admin/products?msg=created");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=failed");
        }
    }
}
