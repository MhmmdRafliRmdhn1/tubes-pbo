package com.cafeaura.servlet;

import com.cafeaura.dao.OrderDAO;
import com.cafeaura.model.OrderItem;
import com.cafeaura.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                createOrder(request, response, user);
                return;
            }
            if ("status".equals(action)) {
                updateStatus(request, response, user);
                return;
            }
            if ("delete".equals(action)) {
                deleteOrder(request, response, user);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } catch (Exception e) {
            redirectError(request, response, e.getMessage());
        }
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        String tableNumber = request.getParameter("tableNumber");
        String paymentMethod = request.getParameter("paymentMethod");
        String[] menuIds = request.getParameterValues("menuId");
        List<OrderItem> items = new ArrayList<>();

        if (menuIds != null) {
            for (String idText : menuIds) {
                int menuId = Integer.parseInt(idText);
                String qtyText = request.getParameter("qty_" + menuId);
                int qty = 0;
                if (qtyText != null && !qtyText.isBlank()) {
                    qty = Integer.parseInt(qtyText);
                }
                if (qty > 0) {
                    OrderItem item = new OrderItem();
                    item.setMenuId(menuId);
                    item.setQuantity(qty);
                    items.add(item);
                }
            }
        }

        int orderId = orderDAO.createOrder(user, user.getName(), tableNumber, items, paymentMethod);
        response.sendRedirect(request.getContextPath() + "/payment?orderId=" + orderId);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        if (!("STAFF".equals(user.getRole()) || "ADMIN".equals(user.getRole()))) {
            throw new SecurityException("Akses ditolak.");
        }
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        orderDAO.updateStatus(orderId, user.getId(), status);
        response.sendRedirect(request.getContextPath() + "/dashboard?success=" + encode("Status pesanan berhasil diperbarui."));
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        if (!"ADMIN".equals(user.getRole())) {
            throw new SecurityException("Hanya admin yang boleh menghapus order.");
        }
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        orderDAO.deleteOrder(orderId);
        response.sendRedirect(request.getContextPath() + "/dashboard?success=" + encode("Order berhasil dihapus."));
    }

    private void redirectError(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        response.sendRedirect(request.getContextPath() + "/dashboard?error=" + encode(message));
    }

    private String encode(String text) {
        return URLEncoder.encode(text, StandardCharsets.UTF_8);
    }
}
