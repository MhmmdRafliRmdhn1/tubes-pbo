<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.cafeaura.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    List<MenuItem> menus = (List<MenuItem>) request.getAttribute("menus");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    List<User> users = (List<User>) request.getAttribute("users");
    Object salesObj = request.getAttribute("totalSalesToday");
    Object orderCountObj = request.getAttribute("orderCountToday");
    DecimalFormat rupiah = new DecimalFormat("Rp #,##0");
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null || activeTab.isBlank()) activeTab = "home";
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - 2F Foodies Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css?v=green-blue-v3">
</head>
<body>
<div class="foodies-shell">
    <aside class="foodies-sidebar">
        <a class="side-brand" href="${pageContext.request.contextPath}/dashboard?tab=home">2F</a>
        <a class="side-link <%= "home".equals(activeTab) ? "active" : "" %>" title="Dashboard" href="${pageContext.request.contextPath}/dashboard?tab=home">🏠</a>
        <a class="side-link <%= "menu".equals(activeTab) ? "active" : "" %>" title="Kelola Menu" href="${pageContext.request.contextPath}/dashboard?tab=menu">🍽️</a>
        <a class="side-link <%= "orders".equals(activeTab) ? "active" : "" %>" title="Order" href="${pageContext.request.contextPath}/dashboard?tab=orders">📦</a>
        <a class="side-link <%= "payment".equals(activeTab) ? "active" : "" %>" title="Payment" href="${pageContext.request.contextPath}/dashboard?tab=payment">💳</a>
        <a class="side-link <%= "users".equals(activeTab) ? "active" : "" %>" title="User" href="${pageContext.request.contextPath}/dashboard?tab=users">👥</a>
        <a class="side-link <%= "report".equals(activeTab) ? "active" : "" %>" title="Laporan" href="${pageContext.request.contextPath}/dashboard?tab=report">📈</a>
        <div class="side-spacer"></div>
        <a class="side-link" title="Logout" href="${pageContext.request.contextPath}/logout">⏻</a>
    </aside>

    <main class="app-main">
        <header class="foodies-header">
            <div class="foodies-title">
                <span class="eyebrow">2F ADMIN CONTROL</span>
                <h1>Hello, <%= user.getName() %>!</h1>
                <p>Manage menu, customer order, payment, user, and report in one modern dashboard.</p>
            </div>
            <div class="search-bar">🔎 Search something you need...</div>
            <div class="profile-pill"><span class="avatar">👨‍💼</span><div><b><%= user.getName() %></b><br><span class="meta">Admin</span></div></div>
        </header>

        <% if (request.getAttribute("success") != null) { %>
        <div class="message success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="message error"><%= request.getAttribute("error") %></div>
        <% } %>

        <nav class="role-nav">
            <a class="role-tab <%= "home".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=home">Dashboard</a>
            <a class="role-tab <%= "menu".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=menu">Kelola Menu</a>
            <a class="role-tab <%= "orders".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=orders">Kelola Order</a>
            <a class="role-tab <%= "payment".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=payment">Payment</a>
            <a class="role-tab <%= "users".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=users">Kelola User</a>
            <a class="role-tab <%= "report".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=report">Laporan</a>
        </nav>

        <% if ("home".equals(activeTab)) { %>
        <div class="admin-dashboard-grid">
            <section class="dashboard-hero">
                <span class="eyebrow">REAL-TIME INSIGHTS</span>
                <h1>Performance Overview</h1>
                <p class="meta">Tampilan dashboard dibuat lebih mirip Foodies: ringkasan penjualan, order, menu, dan navigasi cepat.</p>
                <div class="grid-3">
                    <div class="stat soft-orange"><div class="label">Total Sales Hari Ini</div><div class="value"><%= salesObj == null ? "Rp 0" : rupiah.format(salesObj) %></div><div class="trend">payment PAID</div></div>
                    <div class="stat soft-blue"><div class="label">Order Hari Ini</div><div class="value"><%= orderCountObj == null ? 0 : orderCountObj %></div><div class="trend">order masuk</div></div>
                    <div class="stat soft-green"><div class="label">Jumlah Menu</div><div class="value"><%= menus == null ? 0 : menus.size() %></div><div class="trend">aktif/nonaktif</div></div>
                </div>
                <div class="chart-card">
                    <div class="section-title"><h2>Revenue Trends</h2><span class="meta">Daily overview</span></div>
                    <div class="bars"><span class="bar"></span><span class="bar"></span><span class="bar"></span><span class="bar"></span><span class="bar"></span><span class="bar"></span><span class="bar"></span></div>
                </div>
            </section>
            <aside class="today-panel">
                <span class="eyebrow">TODAY SUMMARY</span>
                <h2>Current Cafe Status</h2>
                <p>Gunakan menu cepat di bawah untuk masuk ke fitur utama admin.</p>
                <div class="stat"><div class="label">Payment Tercatat</div><div class="value"><%= payments == null ? 0 : payments.size() %></div><div class="trend">all transactions</div></div>
                <div class="stat"><div class="label">User Terdaftar</div><div class="value"><%= users == null ? 0 : users.size() %></div><div class="trend">all roles</div></div>
            </aside>
        </div>
        <div class="quick-grid">
            <a class="quick-card" href="${pageContext.request.contextPath}/dashboard?tab=menu"><div class="emoji">🍽️</div><h3>Kelola Menu</h3><p>Tambah, edit, hapus, dan atur stok menu.</p></a>
            <a class="quick-card" href="${pageContext.request.contextPath}/dashboard?tab=orders"><div class="emoji">📦</div><h3>Kelola Order</h3><p>Pantau dan ubah status pesanan.</p></a>
            <a class="quick-card" href="${pageContext.request.contextPath}/dashboard?tab=payment"><div class="emoji">💳</div><h3>Payment</h3><p>Lihat semua transaksi pembayaran.</p></a>
            <a class="quick-card" href="${pageContext.request.contextPath}/dashboard?tab=users"><div class="emoji">👥</div><h3>Kelola User</h3><p>Tambah akun dan aktif/nonaktifkan user.</p></a>
            <a class="quick-card" href="${pageContext.request.contextPath}/dashboard?tab=report"><div class="emoji">📈</div><h3>Laporan</h3><p>Lihat rekap order dan penjualan.</p></a>
        </div>
        <% } %>

<% if ("menu".equals(activeTab)) { %>
        <div class="panel">
            <div class="section-title"><h2>Tambah Menu</h2></div>
            <form action="${pageContext.request.contextPath}/menu" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-row">
                    <input type="text" name="name" placeholder="Nama menu" required>
                    <select name="category" required><option value="Coffee">Coffee</option><option value="Tea">Tea</option><option value="Food">Food</option></select>
                    <input type="number" step="0.01" name="price" placeholder="Harga" required>
                    <input type="number" name="stock" placeholder="Stok" required>
                </div>
                <div class="form-row form-row-2">
                    <input type="text" name="imageUrl" placeholder="URL gambar / optional">
                    <label class="check-row"><input type="checkbox" name="available" checked> Tersedia</label>
                    <button type="submit">Tambah Menu</button>
                </div>
            </form>
        </div>

        <div class="section-title"><h2>Daftar Menu</h2><span class="meta">Edit data menu per baris</span></div>
        <div class="table-panel">
            <table>
                <thead><tr><th>ID</th><th>Nama</th><th>Kategori</th><th>Harga</th><th>Stok</th><th>Available</th><th>Aksi</th></tr></thead>
                <tbody>
                <% if (menus != null && !menus.isEmpty()) { for (MenuItem menu : menus) { %>
                <tr>
                    <form action="${pageContext.request.contextPath}/menu" method="post">
                        <td>#<%= menu.getId() %><input type="hidden" name="id" value="<%= menu.getId() %>"><input type="hidden" name="action" value="update"></td>
                        <td><input type="text" name="name" value="<%= menu.getName() %>" required></td>
                        <td><select name="category"><option value="Coffee" <%= "Coffee".equals(menu.getCategory()) ? "selected" : "" %>>Coffee</option><option value="Tea" <%= "Tea".equals(menu.getCategory()) ? "selected" : "" %>>Tea</option><option value="Food" <%= "Food".equals(menu.getCategory()) ? "selected" : "" %>>Food</option></select></td>
                        <td><input type="number" step="0.01" name="price" value="<%= menu.getPrice() %>" required></td>
                        <td><input type="number" name="stock" value="<%= menu.getStock() %>" required></td>
                        <td><input type="checkbox" name="available" <%= menu.isAvailable() ? "checked" : "" %>><input type="hidden" name="imageUrl" value="<%= menu.getImageUrl() == null ? "" : menu.getImageUrl() %>"></td>
                        <td><div class="actions"><button type="submit">Update</button></form><form class="inline-form" action="${pageContext.request.contextPath}/menu" method="post"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= menu.getId() %>"><button type="submit" class="btn-danger">Hapus</button></form></div></td>
                </tr>
                <% }} else { %>
                <tr><td colspan="7">Belum ada data menu.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% if ("orders".equals(activeTab)) { %>
        <div class="section-title"><h2>Kelola Semua Order</h2><span class="meta">Admin dapat update status atau hapus order</span></div>
        <div class="table-panel">
            <table>
                <thead><tr><th>Order</th><th>Customer</th><th>Meja</th><th>Detail</th><th>Status</th><th>Payment</th><th>Total</th><th>Aksi</th></tr></thead>
                <tbody>
                <% if (orders != null && !orders.isEmpty()) { for (Order order : orders) { %>
                <tr>
                    <td>#<%= order.getId() %></td>
                    <td><%= order.getCustomerName() %></td>
                    <td><%= order.getTableNumber() %></td>
                    <td><ul class="item-list"><% for (OrderItem item : order.getItems()) { %><li><%= item.getQuantity() %>x <%= item.getMenuName() %></li><% } %></ul></td>
                    <td><span class="badge <%= order.getStatus() %>"><%= order.getStatus() %></span></td>
                    <td><%= order.getPaymentMethod() == null ? "Belum bayar" : order.getPaymentMethod() + " - " + order.getPaymentStatus() %></td>
                    <td><b><%= rupiah.format(order.getTotalPrice()) %></b></td>
                    <td><div class="actions">
                        <form class="inline-form" action="${pageContext.request.contextPath}/order" method="post"><input type="hidden" name="action" value="status"><input type="hidden" name="orderId" value="<%= order.getId() %>"><select name="status"><option value="PENDING">PENDING</option><option value="PREPARING">PREPARING</option><option value="READY">READY</option><option value="SERVED">SERVED</option></select><button type="submit">Update</button></form>
                        <a class="btn btn-outline" href="${pageContext.request.contextPath}/payment?orderId=<%= order.getId() %>">Payment</a>
                        <form class="inline-form" action="${pageContext.request.contextPath}/order" method="post"><input type="hidden" name="action" value="delete"><input type="hidden" name="orderId" value="<%= order.getId() %>"><button type="submit" class="btn-danger">Hapus</button></form>
                    </div></td>
                </tr>
                <% }} else { %>
                <tr><td colspan="8">Belum ada order.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% if ("payment".equals(activeTab)) { %>
        <div class="section-title"><h2>Daftar Payment</h2><span class="meta">Semua transaksi pembayaran</span></div>
        <div class="table-panel">
            <table>
                <thead><tr><th>ID</th><th>Order</th><th>Method</th><th>Status</th><th>Amount</th><th>Paid At</th><th>Aksi</th></tr></thead>
                <tbody>
                <% if (payments != null && !payments.isEmpty()) { for (Payment p : payments) { %>
                <tr>
                    <td>#<%= p.getId() %></td>
                    <td>#<%= p.getOrderId() %></td>
                    <td><%= p.getMethod() %></td>
                    <td><span class="badge <%= p.getStatus() %>"><%= p.getStatus() %></span></td>
                    <td><b><%= rupiah.format(p.getAmount()) %></b></td>
                    <td><%= p.getPaidAt() %></td>
                    <td><a class="btn btn-outline" href="${pageContext.request.contextPath}/payment-success?orderId=<%= p.getOrderId() %>">Struk</a></td>
                </tr>
                <% }} else { %>
                <tr><td colspan="7">Belum ada payment.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% if ("users".equals(activeTab)) { %>
        <div class="panel">
            <div class="section-title"><h2>Tambah User</h2></div>
            <form action="${pageContext.request.contextPath}/user" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-row">
                    <input type="text" name="name" placeholder="Nama" required>
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <select name="role"><option value="CUSTOMER">Customer</option><option value="STAFF">Staff</option><option value="ADMIN">Admin</option></select>
                </div>
                <button type="submit">Tambah User</button>
            </form>
        </div>
        <div class="section-title"><h2>Daftar User</h2></div>
        <div class="table-panel">
            <table>
                <thead><tr><th>ID</th><th>Nama</th><th>Email</th><th>Role</th><th>Status</th><th>Aksi</th></tr></thead>
                <tbody>
                <% if (users != null && !users.isEmpty()) { for (User u : users) { %>
                <tr>
                    <td>#<%= u.getId() %></td><td><%= u.getName() %></td><td><%= u.getEmail() %></td><td><%= u.getRole() %></td><td><%= u.isActive() ? "Aktif" : "Nonaktif" %></td>
                    <td><form class="inline-form" action="${pageContext.request.contextPath}/user" method="post"><input type="hidden" name="action" value="toggle"><input type="hidden" name="id" value="<%= u.getId() %>"><button type="submit" class="btn-muted"><%= u.isActive() ? "Nonaktifkan" : "Aktifkan" %></button></form></td>
                </tr>
                <% }} else { %>
                <tr><td colspan="6">Belum ada user.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% if ("report".equals(activeTab)) { %>
        <div class="panel page-heading">
            <p>LAPORAN PENJUALAN</p>
            <h1>Rekap 2F</h1>
            <p>Ringkasan data untuk membantu admin mengambil keputusan bisnis berdasarkan data order dan payment.</p>
            <div class="grid-3">
                <div class="stat"><div class="label">Total Sales Hari Ini</div><div class="value"><%= salesObj == null ? "Rp 0" : rupiah.format(salesObj) %></div><div class="trend">payment paid hari ini</div></div>
                <div class="stat"><div class="label">Jumlah Order Hari Ini</div><div class="value"><%= orderCountObj == null ? 0 : orderCountObj %></div><div class="trend">order masuk</div></div>
                <div class="stat"><div class="label">Total Payment</div><div class="value"><%= payments == null ? 0 : payments.size() %></div><div class="trend">semua transaksi</div></div>
            </div>
        </div>
        <% } %>

    </main>
</div>
</body>
</html>
