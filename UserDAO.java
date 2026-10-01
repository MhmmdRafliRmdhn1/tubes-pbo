package com.cafeaura.dao;

import com.cafeaura.config.DBConnection;
import com.cafeaura.model.Admin;
import com.cafeaura.model.Customer;
import com.cafeaura.model.Staff;
import com.cafeaura.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public User login(String email, String password) throws SQLException {
        String cleanEmail = email == null ? "" : email.trim().toLowerCase();
        String cleanPassword = password == null ? "" : password.trim();

        User user = findUserByLogin(cleanEmail, cleanPassword);
        if (user != null) {
            return user;
        }

        // Jika database yang dipakai masih database lama / user default belum ada,
        // sistem otomatis membuat akun 2F default lalu mencoba login ulang.
        ensureDefaultUsers();
        return findUserByLogin(cleanEmail, cleanPassword);
    }

    private User findUserByLogin(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE LOWER(email)=? AND password=? AND active=1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    public void ensureDefaultUsers() throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            insertUserIfMissing(con, "Admin 2F", "admin@2f.com", "admin123", "ADMIN");
            insertUserIfMissing(con, "Staff Dapur 2F", "staff@2f.com", "staff123", "STAFF");
            insertUserIfMissing(con, "Sam", "customer@2f.com", "customer123", "CUSTOMER");
        }
    }

    private void insertUserIfMissing(Connection con, String name, String email, String password, String role) throws SQLException {
        String check = "SELECT id FROM users WHERE LOWER(email)=LOWER(?) LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(check)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return;
                }
            }
        }

        String insert = "INSERT INTO users(name,email,password,role,active) VALUES(?,?,?,?,1)";
        try (PreparedStatement ps = con.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int userId = keys.getInt(1);
                    if ("CUSTOMER".equals(role)) {
                        createCustomerProfile(con, userId);
                    } else if ("STAFF".equals(role)) {
                        createStaffProfile(con, userId);
                    }
                }
            }
        }
    }

    public List<User> findAll() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY role, name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }
        return users;
    }

    public void addUser(String name, String email, String password, String role) throws SQLException {
        String sql = "INSERT INTO users(name,email,password,role,active) VALUES(?,?,?,?,1)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name == null ? "" : name.trim());
            ps.setString(2, email == null ? "" : email.trim().toLowerCase());
            ps.setString(3, password == null ? "" : password.trim());
            ps.setString(4, role);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int userId = keys.getInt(1);
                    if ("CUSTOMER".equals(role)) {
                        createCustomerProfile(con, userId);
                    } else if ("STAFF".equals(role)) {
                        createStaffProfile(con, userId);
                    }
                }
            }
        }
    }

    public void toggleActive(int id) throws SQLException {
        String sql = "UPDATE users SET active = IF(active=1,0,1) WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private void createCustomerProfile(Connection con, int userId) throws SQLException {
        String sql = "INSERT IGNORE INTO customer_profiles(user_id,address,phone) VALUES(?,?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, "Bandung");
            ps.setString(3, "081234567890");
            ps.executeUpdate();
        }
    }

    private void createStaffProfile(Connection con, int userId) throws SQLException {
        String sql = "INSERT IGNORE INTO staff_profiles(user_id,shift,position) VALUES(?,?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, "Pagi");
            ps.setString(3, "Kitchen Staff");
            ps.executeUpdate();
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        String role = rs.getString("role");
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String email = rs.getString("email");
        String password = rs.getString("password");
        boolean active = rs.getBoolean("active");

        if ("ADMIN".equals(role)) {
            return new Admin(id, name, email, password, active);
        }
        if ("STAFF".equals(role)) {
            return new Staff(id, name, email, password, active);
        }
        return new Customer(id, name, email, password, active);
    }
}
