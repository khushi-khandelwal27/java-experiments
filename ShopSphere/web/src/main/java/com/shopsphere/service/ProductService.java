package com.shopsphere.service;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;

import java.util.List;

public class ProductService {

    private final ProductDAO productDAO;
    private final CategoryDAO categoryDAO;

    public ProductService() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
    }

    public List<Product> getAllActiveProducts() {
        return productDAO.getActiveProducts();
    }

    public List<Product> getAllProductsForAdmin() {
        return productDAO.getAllProducts();
    }

    public Product getProduct(int productId) {
        return productDAO.getProductById(productId);
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return productDAO.getProductsByCategory(categoryId);
    }

    public List<Product> searchAndFilter(String query, Integer categoryId, String sort) {
        return productDAO.searchProducts(query, categoryId, sort);
    }

    public List<Category> getAllCategories() {
        return categoryDAO.getActiveCategories();
    }

    public boolean saveProduct(Product p) {
        if (p.getProductId() > 0) {
            return productDAO.updateProduct(p);
        } else {
            return productDAO.addProduct(p);
        }
    }

    public boolean deleteProduct(int productId) {
        return productDAO.deleteProduct(productId);
    }

    public boolean updateStock(int productId, int stock) {
        return productDAO.setStock(productId, stock);
    }

    public List<Product> getLowStockProducts(int threshold) {
        return productDAO.getLowStockProducts(threshold);
    }
}
