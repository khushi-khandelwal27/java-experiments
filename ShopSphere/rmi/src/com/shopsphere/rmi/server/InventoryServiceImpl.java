package com.shopsphere.rmi.server;

import com.shopsphere.rmi.remote.InventoryService;
import com.shopsphere.rmi.remote.ProductDTO;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Remote Implementation of InventoryService extending UnicastRemoteObject.
 */
public class InventoryServiceImpl extends UnicastRemoteObject implements InventoryService {

    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/shopsphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String DB_PASS = System.getenv().getOrDefault("DB_PASSWORD", "root");

    public InventoryServiceImpl() throws RemoteException {
        super();
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    @Override
    public ProductDTO getProduct(int productId) throws RemoteException {
        String sql = "SELECT product_id, name, brand, price, stock FROM products WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ProductDTO(
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getString("brand"),
                            rs.getDouble("price"),
                            rs.getInt("stock")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RemoteException("Database query error: " + e.getMessage(), e);
        }
        return null;
    }

    @Override
    public int getStock(int productId) throws RemoteException {
        String sql = "SELECT stock FROM products WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("stock");
                }
            }
        } catch (SQLException e) {
            throw new RemoteException("Database query error: " + e.getMessage(), e);
        }
        return -1;
    }

    @Override
    public boolean updateStock(int productId, int newStock) throws RemoteException {
        String sql = "UPDATE products SET stock = ? WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newStock);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RemoteException("Database update error: " + e.getMessage(), e);
        }
    }

    @Override
    public List<ProductDTO> getAllProducts() throws RemoteException {
        List<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT product_id, name, brand, price, stock FROM products ORDER BY product_id ASC";
        try (Connection con = getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new ProductDTO(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getInt("stock")
                ));
            }
        } catch (SQLException e) {
            throw new RemoteException("Database query error: " + e.getMessage(), e);
        }
        return list;
    }
}
