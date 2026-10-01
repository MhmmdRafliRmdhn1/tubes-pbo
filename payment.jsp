<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.cafeaura.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    Order order = (Order) request.getAttribute("order");
    DecimalFormat rupiah = new DecimalFormat("Rp #,##0");
    String method = order == null || order.getPaymentMethod() == null ? "QRIS" : order.getPaymentMethod();
    boolean isPaid = order != null && "PAID".equalsIgnoreCase(order.getPaymentStatus());
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - 2F</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css?v=green-blue-v3">
</head>
<body>
<div class="page">
    <div class="topbar">
        <div class="brand"><span class="brand-mark">2F</span> <span>2F Payment</span></div>
        <div class="nav">
            <span><%= user == null ? "Guest" : user.getRole() + ": " %><b><%= user == null ? "" : user.getName() %></b></span>
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <% if (request.getAttribute("error") != null) { %>
        <div class="message error"><%= request.getAttribute("error") %></div>
        <% } %>

        <% if (order == null) { %>
        <div class="panel"><h2>Order tidak ditemukan.</h2></div>
        <% } else { %>
        <div class="payment-layout">
            <div class="panel payment-card">
                <p>PAYMENT CHECKOUT</p>
                <h1>Bayar Order #<%= order.getId() %></h1>
                <p>Periksa detail pesanan. Jika metode QRIS, scan tampilan QR di bawah ini lalu klik tombol konfirmasi pembayaran.</p>

                <div class="receipt-box">
                    <div><span>Nama Customer</span><b><%= order.getCustomerName() %></b></div>
                    <div><span>Nomor Meja</span><b><%= order.getTableNumber() %></b></div>
                    <div><span>Metode</span><b><%= method %></b></div>
                    <div><span>Status Payment</span><b class="badge <%= order.getPaymentStatus() == null ? "PENDING" : order.getPaymentStatus() %>"><%= order.getPaymentStatus() == null ? "PENDING" : order.getPaymentStatus() %></b></div>
                </div>

                <div class="table-panel mini-table">
                    <table>
                        <thead>
                        <tr>
                            <th>Item</th>
                            <th>Qty</th>
                            <th>Harga</th>
                            <th>Subtotal</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (OrderItem item : order.getItems()) { %>
                        <tr>
                            <td><%= item.getMenuName() %></td>
                            <td><%= item.getQuantity() %></td>
                            <td><%= rupiah.format(item.getPriceEach()) %></td>
                            <td><%= rupiah.format(item.getSubtotal()) %></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="total-box">
                    <div><span>Subtotal</span><b><%= rupiah.format(order.getSubtotal()) %></b></div>
                    <div><span>Pajak 11%</span><b><%= rupiah.format(order.getTax()) %></b></div>
                    <div class="grand"><span>Total Bayar</span><b><%= rupiah.format(order.getTotalPrice()) %></b></div>
                </div>
            </div>

            <div class="panel pay-panel">
                <% if ("QRIS".equalsIgnoreCase(method)) { %>
                    <div class="qris-badge">QRIS 2F</div>
                    <div class="qr-frame" aria-label="QRIS Payment Code">
                        <svg class="qr-svg" viewBox="0 0 210 210" xmlns="http://www.w3.org/2000/svg">
                            <rect width="210" height="210" fill="white"/>
                            <rect x="12" y="12" width="52" height="52" fill="#111827"/>
                            <rect x="22" y="22" width="32" height="32" fill="white"/>
                            <rect x="30" y="30" width="16" height="16" fill="#111827"/>
                            <rect x="146" y="12" width="52" height="52" fill="#111827"/>
                            <rect x="156" y="22" width="32" height="32" fill="white"/>
                            <rect x="164" y="30" width="16" height="16" fill="#111827"/>
                            <rect x="12" y="146" width="52" height="52" fill="#111827"/>
                            <rect x="22" y="156" width="32" height="32" fill="white"/>
                            <rect x="30" y="164" width="16" height="16" fill="#111827"/>
                            <rect x="82" y="18" width="12" height="12" fill="#111827"/><rect x="104" y="18" width="24" height="12" fill="#111827"/>
                            <rect x="82" y="42" width="36" height="12" fill="#111827"/><rect x="128" y="42" width="10" height="10" fill="#111827"/>
                            <rect x="76" y="76" width="14" height="14" fill="#111827"/><rect x="100" y="76" width="12" height="34" fill="#111827"/><rect x="124" y="76" width="30" height="12" fill="#111827"/><rect x="174" y="76" width="12" height="24" fill="#111827"/>
                            <rect x="74" y="102" width="18" height="12" fill="#111827"/><rect x="118" y="102" width="14" height="14" fill="#111827"/><rect x="146" y="100" width="38" height="12" fill="#111827"/>
                            <rect x="80" y="126" width="28" height="14" fill="#111827"/><rect x="130" y="124" width="12" height="36" fill="#111827"/><rect x="154" y="128" width="34" height="12" fill="#111827"/>
                            <rect x="78" y="154" width="12" height="36" fill="#111827"/><rect x="100" y="154" width="18" height="12" fill="#111827"/><rect x="146" y="154" width="16" height="16" fill="#111827"/><rect x="178" y="156" width="20" height="12" fill="#111827"/>
                            <rect x="100" y="180" width="42" height="12" fill="#111827"/><rect x="160" y="180" width="14" height="14" fill="#111827"/><rect x="188" y="182" width="10" height="10" fill="#111827"/>
                        </svg>
                    </div>
                    <h2>Scan QR untuk Bayar</h2>
                    <p class="meta center">Nominal QRIS: <b><%= rupiah.format(order.getTotalPrice()) %></b><br>Kode: CA-<%= order.getId() %>-<%= order.getTableNumber() %></p>
                <% } else if ("CASH".equalsIgnoreCase(method)) { %>
                    <div class="method-icon">💵</div>
                    <h2>Bayar Cash di Kasir</h2>
                    <p class="meta center">Tunjukkan Order #<%= order.getId() %> ke kasir, lalu klik konfirmasi setelah pembayaran diterima.</p>
                <% } else { %>
                    <div class="method-icon">💳</div>
                    <h2>Pembayaran <%= method %></h2>
                    <p class="meta center">Masukkan kartu pada mesin kasir/EDC, lalu klik konfirmasi pembayaran setelah transaksi berhasil.</p>
                <% } %>

                <% if (isPaid) { %>
                    <div class="message success center">Pembayaran order ini sudah berhasil.</div>
                    <a class="btn full" href="${pageContext.request.contextPath}/payment-success?orderId=<%= order.getId() %>">Lihat Bukti Pembayaran</a>
                <% } else { %>
                    <form action="${pageContext.request.contextPath}/payment" method="post">
                        <input type="hidden" name="orderId" value="<%= order.getId() %>">
                        <input type="hidden" name="method" value="<%= method %>">
                        <button type="submit" class="full">Konfirmasi Pembayaran Berhasil</button>
                    </form>
                <% } %>
                <a class="btn btn-outline full" href="${pageContext.request.contextPath}/dashboard">Kembali ke Dashboard</a>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
