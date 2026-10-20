package com.shopsphere.swing.dao;

import com.shopsphere.swing.model.*;
import com.shopsphere.swing.util.DBHelper;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SwingAdminDAO {

    public boolean authenticateAdmin(String email, String plainPassword) {
        String hashed = DBHelper.hashPassword(plainPassword);
        String sql = "SELECT role FROM users WHERE email = ? AND password = ? AND status = 'ACTIVE'";
        try (Connection con = DBHelper.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());
            ps.setString(2, hashed);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return "ADMIN".equalsIgnoreCase(rs.getString("role"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ProductItem> getProducts() {
        List<ProductItem> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name as cat_name FROM products p JOIN categories c ON p.category_id = c.category_id ORDER BY p.product_id ASC";
        try (Connection con = DBHelper.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new ProductItem(
                        rs.getInt("product_id"),
                        rs.getInt("category_id"),
                        rs.getString("cat_name"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getDouble("discount"),
                        rs.getInt("stock"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addProduct(int categoryId, String name, String brand, double price, double discount, int stock) {
        String sql = "INSERT INTO products (category_id, name, brand, description, price, discount, stock, status) " +
                     "VALUES (?, ?, ?, 'Added via Swing Desktop Admin', ?, ?, ?, 'ACTIVE')";
        try (Connection con = DBHelper.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setString(2, name);
            ps.setString(3, brand);
            ps.setDouble(4, price);
            ps.setDouble(5, discount);
            ps.setInt(6, stock);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStock(int productId, int newStock) {
        String sql = "UPDATE products SET stock = ? WHERE product_id = ?";
        try (Connection con = DBHelper.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newStock);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection con = DBHelper.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CategoryItem> getCategories() {
        List<CategoryItem> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY category_id ASC";
        try (Connection con = DBHelper.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new CategoryItem(
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addCategory(String name, String desc) {
        String sql = "INSERT INTO categories (name, description, status) VALUES (?, ?, 'ACTIVE')";
        try (Connection con = DBHelper.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, desc);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<OrderItem> getOrders() {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT o.*, u.name as cust_name FROM orders o JOIN users u ON o.user_id = u.user_id ORDER BY o.order_id DESC";
        try (Connection con = DBHelper.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new OrderItem(
                        rs.getInt("order_id"),
                        rs.getString("cust_name"),
                        rs.getDouble("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("order_status"),
                        rs.getString("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection con = DBHelper.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<UserItem> getUsers() {
        List<UserItem> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY user_id ASC";
        try (Connection con = DBHelper.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new UserItem(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("mobile"),
                        rs.getString("role"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
