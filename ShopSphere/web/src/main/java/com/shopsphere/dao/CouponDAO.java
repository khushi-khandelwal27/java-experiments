package com.shopsphere.dao;

import com.shopsphere.model.Coupon;
import com.shopsphere.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CouponDAO {

    public Coupon getCouponByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE UPPER(code) = UPPER(?) AND status = 'ACTIVE' AND (expiry_date IS NULL OR expiry_date >= CURRENT_DATE)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCoupon(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Coupon> getAllCoupons() {
        List<Coupon> list = new ArrayList<>();
        String sql = "SELECT * FROM coupons ORDER BY coupon_id DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapCoupon(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addCoupon(Coupon coupon) {
        String sql = "INSERT INTO coupons (code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, coupon.getCode().trim().toUpperCase());
            ps.setString(2, coupon.getDiscountType());
            ps.setDouble(3, coupon.getDiscountValue());
            ps.setDouble(4, coupon.getMinimumOrder());
            ps.setDouble(5, coupon.getMaximumDiscount());
            ps.setDate(6, coupon.getExpiryDate());
            ps.setString(7, coupon.getStatus() != null ? coupon.getStatus() : "ACTIVE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean recordUsage(int couponId, int userId, int orderId) {
        String sql = "INSERT INTO coupon_usage (coupon_id, user_id, order_id) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            ps.setInt(2, userId);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Coupon mapCoupon(ResultSet rs) throws SQLException {
        return new Coupon(
                rs.getInt("coupon_id"),
                rs.getString("code"),
                rs.getString("discount_type"),
                rs.getDouble("discount_value"),
                rs.getDouble("minimum_order"),
                rs.getDouble("maximum_discount"),
                rs.getDate("expiry_date"),
                rs.getString("status")
        );
    }
}
