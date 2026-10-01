<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.cafeaura.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    Order order = (Order) request.getAttribute("order");
    DecimalFormat rupiah = new DecimalFormat("Rp #,##0");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Success - 2F</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css?v=green-blue-v3">
</head>
<body>
<div class="page success-page">
    <div class="topbar">
        <div class="brand"><span class="brand-mark">2F</span> <span>2F</span></div>
        <div class="nav">
            <span><%= user == null ? "" : user.getRole() + ": " %><b><%= user == null ? "" : user.getName() %></b></span>
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container narrow">
        <% if (order == null) { %>
        <div class="panel"><h2>Order tidak ditemukan.</h2></div>
        <% } else { %>
        <div class="panel success-card">
            <div class="success-icon">✓</div>
            <h1>Pembayaran Berhasil</h1>
            <p>Terima kasih. Payment untuk Order #<%= order.getId() %> sudah tercatat di sistem 2F.</p>

            <div class="receipt-box receipt-large">
                <div><span>Order</span><b>#<%= order.getId() %></b></div>
                <div><span>Customer</span><b><%= order.getCustomerName() %></b></div>
                <div><span>Nomor Meja</span><b><%= order.getTableNumber() %></b></div>
                <div><span>Metode Payment</span><b><%= order.getPaymentMethod() %></b></div>
                <div><span>Status Payment</span><b class="badge PAID"><%= order.getPaymentStatus() == null ? "PAID" : order.getPaymentStatus() %></b></div>
                <div><span>Tanggal Order</span><b><%= order.getCreatedAt() %></b></div>
            </div>

            <div class="table-panel mini-table">
                <table>
                    <thead>
                    <tr>
                        <th>Item</th>
                        <th>Qty</th>
                        <th>Subtotal</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (OrderItem item : order.getItems()) { %>
                    <tr>
                        <td><%= item.getMenuName() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td><%= rupiah.format(item.getSubtotal()) %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <div class="total-box">
                <div><span>Subtotal</span><b><%= rupiah.format(order.getSubtotal()) %></b></div>
                <div><span>Pajak 11%</span><b><%= rupiah.format(order.getTax()) %></b></div>
                <div class="grand"><span>Total Dibayar</span><b><%= rupiah.format(order.getTotalPrice()) %></b></div>
            </div>

            <div class="actions center-actions">
                <a class="btn" href="${pageContext.request.contextPath}/dashboard">Kembali ke Dashboard</a>
                <button onclick="window.print()" class="btn-outline">Cetak Struk</button>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
