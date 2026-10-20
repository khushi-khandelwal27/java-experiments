package com.shopsphere.dao;

import com.shopsphere.model.Address;
import com.shopsphere.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {

    public List<Address> getAddressesByUserId(int userId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY address_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Address(
                            rs.getInt("address_id"),
                            rs.getInt("user_id"),
                            rs.getString("address_line"),
                            rs.getString("city"),
                            rs.getString("state"),
                            rs.getString("pincode"),
                            rs.getString("address_type")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Address getAddressById(int addressId) {
        String sql = "SELECT * FROM addresses WHERE address_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addAddress(Address address) {
        String sql = "INSERT INTO addresses (user_id, address_line, city, state, pincode, address_type) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getAddressLine());
            ps.setString(3, address.getCity());
            ps.setString(4, address.getState());
            ps.setString(5, address.getPincode());
            ps.setString(6, address.getAddressType() != null ? address.getAddressType() : "HOME");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        address.setAddressId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
