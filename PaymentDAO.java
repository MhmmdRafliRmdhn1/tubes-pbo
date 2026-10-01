package com.cafeaura.dao;

import com.cafeaura.config.DBConnection;
import com.cafeaura.model.Payment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    public void payOrder(int orderId, int staffId, String method) throws SQLException {
        String findSql = "SELECT total_price FROM orders WHERE id=?";
        String insertSql = "INSERT INTO payments(order_id, staff_id, amount, method, status, paid_at) VALUES(?,?,?,?, 'PAID', CURRENT_TIMESTAMP) " +
                "ON DUPLICATE KEY UPDATE staff_id=VALUES(staff_id), amount=VALUES(amount), method=VALUES(method), status='PAID', paid_at=CURRENT_TIMESTAMP";
        try (Connection con = DBConnection.getConnection()) {
            java.math.BigDecimal amount;
            try (PreparedStatement ps = con.prepareStatement(findSql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        throw new SQLException("Order tidak ditemukan.");
                    }
                    amount = rs.getBigDecimal("total_price");
                }
            }
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, orderId);
                ps.setInt(2, staffId);
                ps.setBigDecimal(3, amount);
                ps.setString(4, method);
                ps.executeUpdate();
            }
        }
    }

    public List<Payment> findAll() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY paid_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment p = new Payment();
                p.setId(rs.getInt("id"));
                p.setOrderId(rs.getInt("order_id"));
                int staffId = rs.getInt("staff_id");
                p.setStaffId(rs.wasNull() ? null : staffId);
                p.setAmount(rs.getBigDecimal("amount"));
                p.setMethod(rs.getString("method"));
                p.setStatus(rs.getString("status"));
                p.setPaidAt(rs.getTimestamp("paid_at"));
                payments.add(p);
            }
        }
        return payments;
    }
}
