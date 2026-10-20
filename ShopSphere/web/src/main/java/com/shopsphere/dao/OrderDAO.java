package com.shopsphere.dao;

import com.shopsphere.model.*;
import com.shopsphere.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean placeOrder(Order order, List<OrderItem> items, Payment payment) {
        String insertOrderSql = "INSERT INTO orders (user_id, address_id, total_amount, discount, payment_method, payment_status, order_status) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        String insertPaymentSql = "INSERT INTO payments (order_id, payment_method, transaction_reference, amount, payment_status) " +
                                  "VALUES (?, ?, ?, ?, ?)";
        String updateStockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";
        String clearCartSql = "DELETE FROM cart WHERE user_id = ?";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Begin transaction

            // 1. Insert Order
            int generatedOrderId = 0;
            try (PreparedStatement psOrder = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                if (order.getAddressId() != null) {
                    psOrder.setInt(2, order.getAddressId());
                } else {
                    psOrder.setNull(2, Types.INTEGER);
                }
                psOrder.setDouble(3, order.getTotalAmount());
                psOrder.setDouble(4, order.getDiscount());
                psOrder.setString(5, order.getPaymentMethod());
                psOrder.setString(6, order.getPaymentStatus());
                psOrder.setString(7, order.getOrderStatus() != null ? order.getOrderStatus() : "PLACED");

                int affected = psOrder.executeUpdate();
                if (affected == 0) {
                    con.rollback();
                    return false;
                }
                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                        order.setOrderId(generatedOrderId);
                    }
                }
            }

            // 2. Insert Order Items & Update Product Stock
            try (PreparedStatement psItem = con.prepareStatement(insertItemSql);
                 PreparedStatement psStock = con.prepareStatement(updateStockSql)) {
                for (OrderItem item : items) {
                    psItem.setInt(1, generatedOrderId);
                    psItem.setInt(2, item.getProductId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getPrice());
                    psItem.addBatch();

                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getProductId());
                    psStock.setInt(3, item.getQuantity());
                    int stockUpdated = psStock.executeUpdate();
                    if (stockUpdated == 0) {
                        // Insufficient stock or product not found
                        con.rollback();
                        return false;
                    }
                }
                psItem.executeBatch();
            }

            // 3. Insert Payment Record
            if (payment != null) {
                try (PreparedStatement psPay = con.prepareStatement(insertPaymentSql)) {
                    psPay.setInt(1, generatedOrderId);
                    psPay.setString(2, payment.getPaymentMethod());
                    psPay.setString(3, payment.getTransactionReference() != null ? 
                            payment.getTransactionReference() : "TXN_" + System.currentTimeMillis());
                    psPay.setDouble(4, payment.getAmount());
                    psPay.setString(5, payment.getPaymentStatus());
                    psPay.executeUpdate();
                }
            }

            // 4. Clear User Cart
            try (PreparedStatement psCart = con.prepareStatement(clearCartSql)) {
                psCart.setInt(1, order.getUserId());
                psCart.executeUpdate();
            }

            con.commit(); // Commit transaction
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getOrderItems(con, o.getOrderId()));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.name AS user_name, u.email AS user_email FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id WHERE o.order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setUserName(rs.getString("user_name"));
                    o.setUserEmail(rs.getString("user_email"));
                    o.setItems(getOrderItems(con, orderId));
                    if (o.getAddressId() != null) {
                        o.setAddress(getAddress(con, o.getAddressId()));
                    }
                    o.setPayment(getPayment(con, orderId));
                    return o;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS user_name, u.email AS user_email FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id ORDER BY o.order_id DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setUserName(rs.getString("user_name"));
                o.setUserEmail(rs.getString("user_email"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE order_status != 'CANCELLED'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public int getTotalOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private List<OrderItem> getOrderItems(Connection con, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name, p.brand, p.image_url FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem(
                            rs.getInt("order_item_id"),
                            rs.getInt("order_id"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getDouble("price")
                    );
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setBrand(rs.getString("brand"));
                    p.setImageUrl(rs.getString("image_url"));
                    item.setProduct(p);
                    items.add(item);
                }
            }
        }
        return items;
    }

    private Address getAddress(Connection con, int addressId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE address_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Address(
                            rs.getInt("address_id"),
                            rs.getInt("user_id"),
                            rs.getString("address_line"),
                            rs.getString("city"),
                            rs.getString("state"),
                            rs.getString("pincode"),
                            rs.getString("address_type")
                    );
                }
            }
        }
        return null;
    }

    private Payment getPayment(Connection con, int orderId) throws SQLException {
        String sql = "SELECT * FROM payments WHERE order_id = ? ORDER BY payment_id DESC LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Payment(
                            rs.getInt("payment_id"),
                            rs.getInt("order_id"),
                            rs.getString("payment_method"),
                            rs.getString("transaction_reference"),
                            rs.getDouble("amount"),
                            rs.getString("payment_status"),
                            rs.getTimestamp("created_at")
                    );
                }
            }
        }
        return null;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        int addr = rs.getInt("address_id");
        Integer addressId = rs.wasNull() ? null : addr;
        return new Order(
                rs.getInt("order_id"),
                rs.getInt("user_id"),
                addressId,
                rs.getDouble("total_amount"),
                rs.getDouble("discount"),
                rs.getString("payment_method"),
                rs.getString("payment_status"),
                rs.getString("order_status"),
                rs.getTimestamp("created_at")
        );
    }
}
