<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.cafeaura.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    DecimalFormat rupiah = new DecimalFormat("Rp #,##0");
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null || activeTab.isBlank()) activeTab = "home";
    int pendingCount = 0;
    int unpaidCount = 0;
    BigDecimal paidTotal = BigDecimal.ZERO;
    if (orders != null) {
        for (Order order : orders) {
            if (!"SERVED".equalsIgnoreCase(order.getStatus())) pendingCount++;
            if (!"PAID".equalsIgnoreCase(order.getPaymentStatus())) unpaidCount++;
        }
    }
    if (payments != null) {
        for (Payment payment : payments) {
            if ("PAID".equalsIgnoreCase(payment.getStatus())) {
                paidTotal = paidTotal.add(payment.getAmount());
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff - 2F</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css?v=green-blue-v3">
</head>
<body>
<div class="page">
    <div class="topbar">
        <div class="brand"><span class="brand-mark">2F</span> <span>2F Staff</span></div>
        <div class="nav">
            <span>Staff: <b><%= user.getName() %></b></span>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <% if (request.getAttribute("success") != null) { %>
        <div class="message success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="message error"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="role-nav">
            <a class="role-tab <%= "home".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=home">Dashboard</a>
            <a class="role-tab <%= "orders".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=orders">Kelola Pesanan</a>
            <a class="role-tab <%= "payment".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=payment">Konfirmasi Pembayaran</a>
            <a class="role-tab <%= "report".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=report">Laporan Harian</a>
        </div>

        <% if ("home".equals(activeTab)) { %>
        <div class="hero">
            <div class="panel">
                <p>LIVE UPDATES</p>
                <h1>Staff<br>Operation Center</h1>
                <p>Pilih kategori kerja staff: kelola pesanan dapur, konfirmasi pembayaran, atau lihat laporan harian.</p>
            </div>
            <div class="grid-2">
                <div class="stat"><div class="label">Order Aktif</div><div class="value"><%= pendingCount %></div><div class="trend">perlu diproses</div></div>
                <div class="stat"><div class="label">Belum Dibayar</div><div class="value"><%= unpaidCount %></div><div class="trend">perlu payment</div></div>
            </div>
        </div>
        <div class="action-grid">
            <a class="action-card" href="${pageContext.request.contextPath}/dashboard?tab=orders"><div class="action-icon">🍳</div><h3>Kelola Pesanan</h3><p>Update status PENDING, PREPARING, READY, dan SERVED.</p></a>
            <a class="action-card" href="${pageContext.request.contextPath}/dashboard?tab=payment"><div class="action-icon">💳</div><h3>Konfirmasi Pembayaran</h3><p>Buka QRIS/payment dan set transaksi menjadi PAID.</p></a>
            <a class="action-card" href="${pageContext.request.contextPath}/dashboard?tab=report"><div class="action-icon">📋</div><h3>Laporan Harian</h3><p>Lihat ringkasan order dan payment yang tercatat.</p></a>
        </div>
        <% } %>

        <% if ("orders".equals(activeTab)) { %>
        <div class="section-title"><h2>Kelola Pesanan Masuk</h2><span class="meta">Live kitchen queue</span></div>
        <div class="table-panel">
            <table>
                <thead>
                <tr><th>Order</th><th>Customer</th><th>Meja</th><th>Detail Pesanan</th><th>Status</th><th>Total</th><th>Aksi Status</th></tr>
                </thead>
                <tbody>
                <% if (orders != null && !orders.isEmpty()) { for (Order order : orders) { %>
                <tr>
                    <td>#<%= order.getId() %></td>
                    <td><%= order.getCustomerName() %></td>
                    <td><%= order.getTableNumber() %></td>
                    <td><ul class="item-list"><% for (OrderItem item : order.getItems()) { %><li><%= item.getQuantity() %>x <%= item.getMenuName() %></li><% } %></ul></td>
                    <td><span class="badge <%= order.getStatus() %>"><%= order.getStatus() %></span></td>
                    <td><b><%= rupiah.format(order.getTotalPrice()) %></b></td>
                    <td>
                        <div class="actions">
                            <form class="inline-form" action="${pageContext.request.contextPath}/order" method="post"><input type="hidden" name="action" value="status"><input type="hidden" name="orderId" value="<%= order.getId() %>"><input type="hidden" name="status" value="PREPARING"><button type="submit">Preparing</button></form>
                            <form class="inline-form" action="${pageContext.request.contextPath}/order" method="post"><input type="hidden" name="action" value="status"><input type="hidden" name="orderId" value="<%= order.getId() %>"><input type="hidden" name="status" value="READY"><button type="submit">Ready</button></form>
                            <form class="inline-form" action="${pageContext.request.contextPath}/order" method="post"><input type="hidden" name="action" value="status"><input type="hidden" name="orderId" value="<%= order.getId() %>"><input type="hidden" name="status" value="SERVED"><button type="submit">Served</button></form>
                        </div>
                    </td>
                </tr>
                <% }} else { %>
                <tr><td colspan="7">Belum ada pesanan aktif.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% if ("payment".equals(activeTab)) { %>
        <div class="section-title"><h2>Konfirmasi Pembayaran</h2><span class="meta">QRIS / Cash / Debit / Credit</span></div>
        <div class="table-panel">
            <table>
                <thead>
                <tr><th>Order</th><th>Customer</th><th>Meja</th><th>Payment</th><th>Total</th><th>Aksi</th></tr>
                </thead>
                <tbody>
                <% if (orders != null && !orders.isEmpty()) { for (Order order : orders) { %>
                <tr>
                    <td>#<%= order.getId() %></td>
                    <td><%= order.getCustomerName() %></td>
                    <td><%= order.getTableNumber() %></td>
                    <td><%= order.getPaymentMethod() == null ? "Belum Dipilih" : order.getPaymentMethod() + " - " + order.getPaymentStatus() %></td>
                    <td><b><%= rupiah.format(order.getTotalPrice()) %></b></td>
                    <td>
                        <div class="actions">
                            <% if (!"PAID".equalsIgnoreCase(order.getPaymentStatus())) { %>
                            <a class="btn btn-outline" href="${pageContext.request.contextPath}/payment?orderId=<%= order.getId() %>">Lihat Payment</a>
                            <form class="inline-form" action="${pageContext.request.contextPath}/payment" method="post"><input type="hidden" name="orderId" value="<%= order.getId() %>"><input type="hidden" name="method" value='<%= order.getPaymentMethod() == null ? "CASH" : order.getPaymentMethod() %>'><button type="submit">Konfirmasi Pay</button></form>
                            <% } else { %>
                            <a class="btn btn-outline" href="${pageContext.request.contextPath}/payment-success?orderId=<%= order.getId() %>">Struk</a>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% }} else { %>
                <tr><td colspan="6">Belum ada data order.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% if ("report".equals(activeTab)) { %>
        <div class="panel page-heading">
            <p>LAPORAN HARIAN STAFF</p>
            <h1>Ringkasan Operasional</h1>
            <p>Laporan ini menampilkan jumlah order aktif, payment tercatat, dan total transaksi yang sudah PAID.</p>
            <div class="grid-3">
                <div class="stat"><div class="label">Total Order Queue</div><div class="value"><%= orders == null ? 0 : orders.size() %></div><div class="trend">daftar pesanan</div></div>
                <div class="stat"><div class="label">Payment Tercatat</div><div class="value"><%= payments == null ? 0 : payments.size() %></div><div class="trend">data payment</div></div>
                <div class="stat"><div class="label">Total Paid</div><div class="value"><%= rupiah.format(paidTotal) %></div><div class="trend">akumulasi</div></div>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
