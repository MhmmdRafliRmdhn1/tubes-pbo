package com.cafeaura.dao;

import com.cafeaura.config.DBConnection;
import com.cafeaura.model.MenuItem;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {
    public List<MenuItem> findAll() throws SQLException {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT * FROM menus ORDER BY category, name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapMenu(rs));
            }
        }
        return list;
    }

    public List<MenuItem> findAvailable() throws SQLException {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT * FROM menus WHERE is_available=1 AND stock > 0 ORDER BY category, name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapMenu(rs));
            }
        }
        return list;
    }

    public MenuItem findById(Connection con, int id) throws SQLException {
        String sql = "SELECT * FROM menus WHERE id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapMenu(rs);
                }
            }
        }
        return null;
    }

    public void add(MenuItem menu) throws SQLException {
        String sql = "INSERT INTO menus(name, category, price, stock, is_available, image_url) VALUES(?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, menu.getName());
            ps.setString(2, menu.getCategory());
            ps.setBigDecimal(3, menu.getPrice());
            ps.setInt(4, menu.getStock());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImageUrl());
            ps.executeUpdate();
        }
    }

    public void update(MenuItem menu) throws SQLException {
        String sql = "UPDATE menus SET name=?, category=?, price=?, stock=?, is_available=?, image_url=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, menu.getName());
            ps.setString(2, menu.getCategory());
            ps.setBigDecimal(3, menu.getPrice());
            ps.setInt(4, menu.getStock());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImageUrl());
            ps.setInt(7, menu.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM menus WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void reduceStock(Connection con, int menuId, int qty) throws SQLException {
        String sql = "UPDATE menus SET stock = stock - ? WHERE id=? AND stock >= ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, menuId);
            ps.setInt(3, qty);
            int updated = ps.executeUpdate();
            if (updated == 0) {
                throw new SQLException("Stok menu tidak cukup untuk menu ID " + menuId);
            }
        }
    }

    private MenuItem mapMenu(ResultSet rs) throws SQLException {
        BigDecimal price = rs.getBigDecimal("price");
        return new MenuItem(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("category"),
                price,
                rs.getInt("stock"),
                rs.getBoolean("is_available"),
                rs.getString("image_url")
        );
    }
}
