package com.cafeaura.servlet;

import com.cafeaura.dao.OrderDAO;
import com.cafeaura.dao.PaymentDAO;
import com.cafeaura.model.Order;
import com.cafeaura.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            Order order = orderDAO.findById(orderId);
            validateAccess(user, order);

            request.setAttribute("order", order);
            request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + encode(e.getMessage()));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String method = request.getParameter("method");

            Order order = orderDAO.findById(orderId);
            validateAccess(user, order);

            if (method == null || method.isBlank()) {
                method = order.getPaymentMethod() == null ? "QRIS" : order.getPaymentMethod();
            }

            paymentDAO.payOrder(orderId, user.getId(), method);
            response.sendRedirect(request.getContextPath() + "/payment-success?orderId=" + orderId);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + encode(e.getMessage()));
        }
    }

    private void validateAccess(User user, Order order) {
        if (order == null) {
            throw new IllegalArgumentException("Order tidak ditemukan.");
        }
        if ("CUSTOMER".equals(user.getRole())) {
            if (order.getCustomerId() == null || order.getCustomerId() != user.getId()) {
                throw new SecurityException("Kamu tidak punya akses ke payment order ini.");
            }
        }
    }

    private String encode(String text) {
        return URLEncoder.encode(text, StandardCharsets.UTF_8);
    }
}
