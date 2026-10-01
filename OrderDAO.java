package com.cafeaura.dao;

import com.cafeaura.config.DBConnection;
import com.cafeaura.model.MenuItem;
import com.cafeaura.model.Order;
import com.cafeaura.model.OrderItem;
import com.cafeaura.model.User;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private final MenuDAO menuDAO = new MenuDAO();

    public int createOrder(User customer, String customerName, String tableNumber, List<OrderItem> requestItems, String paymentMethod) throws SQLException {
        if (requestItems == null || requestItems.isEmpty()) {
            throw new SQLException("Pesanan masih kosong. Pilih minimal satu menu.");
        }

        try (Connection con = DBConnection.getConnection()) {
            try {
                con.setAutoCommit(false);

                List<OrderItem> finalItems = new ArrayList<>();
                Order order = new Order();
                order.setCustomerId(customer == null ? null : customer.getId());
                order.setCustomerName(customerName);
                order.setTableNumber(tableNumber);
                order.setStatus("PENDING");

                for (OrderItem item : requestItems) {
                    if (item.getQuantity() <= 0) {
                        continue;
                    }
                    MenuItem menu = menuDAO.findById(con, item.getMenuId());
                    if (menu == null || !menu.isAvailable()) {
                        throw new SQLException("Menu tidak tersedia.");
                    }
                    if (menu.getStock() < item.getQuantity()) {
                        throw new SQLException("Stok " + menu.getName() + " tidak cukup. Stok saat ini: " + menu.getStock());
                    }
                    OrderItem detail = new OrderItem(menu.getId(), menu.getName(), item.getQuantity(), menu.getPrice());
                    finalItems.add(detail);
                }

                order.setItems(finalItems);
                order.calculateTotal();

                String orderSql = "INSERT INTO orders(customer_id, customer_name, table_number, status, subtotal, tax, total_price) VALUES(?,?,?,?,?,?,?)";
                int orderId;
                try (PreparedStatement ps = con.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    if (order.getCustomerId() == null) {
                        ps.setNull(1, java.sql.Types.INTEGER);
                    } else {
                        ps.setInt(1, order.getCustomerId());
                    }
                    ps.setString(2, order.getCustomerName());
                    ps.setString(3, order.getTableNumber());
                    ps.setString(4, order.getStatus());
                    ps.setBigDecimal(5, order.getSubtotal());
                    ps.setBigDecimal(6, order.getTax());
                    ps.setBigDecimal(7, order.getTotalPrice());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException("Gagal membuat order.");
                        }
                        orderId = keys.getInt(1);
                    }
                }

                String itemSql = "INSERT INTO order_items(order_id, menu_id, quantity, price_each, subtotal) VALUES(?,?,?,?,?)";
                try (PreparedStatement ps = con.prepareStatement(itemSql)) {
                    for (OrderItem item : finalItems) {
                        ps.setInt(1, orderId);
                        ps.setInt(2, item.getMenuId());
                        ps.setInt(3, item.getQuantity());
                        ps.setBigDecimal(4, item.getPriceEach());
                        ps.setBigDecimal(5, item.getSubtotal());
                        ps.addBatch();
                        menuDAO.reduceStock(con, item.getMenuId(), item.getQuantity());
                    }
                    ps.executeBatch();
                }

                if (paymentMethod != null && !paymentMethod.isBlank()) {
                    String paymentSql = "INSERT INTO payments(order_id, amount, method, status) VALUES(?,?,?, 'PENDING')";
                    try (PreparedStatement ps = con.prepareStatement(paymentSql)) {
                        ps.setInt(1, orderId);
                        ps.setBigDecimal(2, order.getTotalPrice());
                        ps.setString(3, paymentMethod);
                        ps.executeUpdate();
                    }
                }

                con.commit();
                return orderId;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public List<Order> findAll() throws SQLException {
        String sql = "SELECT o.*, p.method AS payment_method, p.status AS payment_status " +
                "FROM orders o LEFT JOIN payments p ON o.id=p.order_id ORDER BY o.created_at DESC";
        return queryOrders(sql, null);
    }

    public List<Order> findKitchenQueue() throws SQLException {
        String sql = "SELECT o.*, p.method AS payment_method, p.status AS payment_status " +
                "FROM orders o LEFT JOIN payments p ON o.id=p.order_id " +
                "WHERE o.status IN ('PENDING','PREPARING','READY','SERVED') ORDER BY o.created_at ASC";
        return queryOrders(sql, null);
    }

    public List<Order> findByCustomer(int customerId) throws SQLException {
        String sql = "SELECT o.*, p.method AS payment_method, p.status AS payment_status " +
                "FROM orders o LEFT JOIN payments p ON o.id=p.order_id WHERE o.customer_id=? ORDER BY o.created_at DESC";
        return queryOrders(sql, customerId);
    }

    public Order findById(int id) throws SQLException {
        String sql = "SELECT o.*, p.method AS payment_method, p.status AS payment_status " +
                "FROM orders o LEFT JOIN payments p ON o.id=p.order_id WHERE o.id=?";
        List<Order> result = queryOrders(sql, id);
        return result.isEmpty() ? null : result.get(0);
    }

    public void updateStatus(int orderId, int staffId, String status) throws SQLException {
        String sql = "UPDATE orders SET status=?, staff_id=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, staffId);
            ps.setInt(3, orderId);
            ps.executeUpdate();
        }
    }

    public void deleteOrder(int orderId) throws SQLException {
        String sql = "DELETE FROM orders WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        }
    }

    private List<Order> queryOrders(String sql, Integer parameter) throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (parameter != null) {
                ps.setInt(1, parameter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    int customerId = rs.getInt("customer_id");
                    order.setCustomerId(rs.wasNull() ? null : customerId);
                    int staffId = rs.getInt("staff_id");
                    order.setStaffId(rs.wasNull() ? null : staffId);
                    order.setCustomerName(rs.getString("customer_name"));
                    order.setTableNumber(rs.getString("table_number"));
                    order.setStatus(rs.getString("status"));
                    order.setSubtotal(rs.getBigDecimal("subtotal"));
                    order.setTax(rs.getBigDecimal("tax"));
                    order.setTotalPrice(rs.getBigDecimal("total_price"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setPaymentStatus(rs.getString("payment_status"));
                    order.setItems(findItems(con, order.getId()));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    private List<OrderItem> findItems(Connection con, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, m.name AS menu_name FROM order_items oi JOIN menus m ON oi.menu_id=m.id WHERE oi.order_id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setMenuId(rs.getInt("menu_id"));
                    item.setMenuName(rs.getString("menu_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPriceEach(rs.getBigDecimal("price_each"));
                    item.setSubtotalValue(rs.getBigDecimal("subtotal"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    public BigDecimal getTotalSalesToday() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount),0) AS total FROM payments WHERE DATE(paid_at)=CURDATE() AND status='PAID'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }

    public int getOrderCountToday() throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM orders WHERE DATE(created_at)=CURDATE()";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
}
