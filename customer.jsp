<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.cafeaura.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    List<MenuItem> menus = (List<MenuItem>) request.getAttribute("availableMenus");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    DecimalFormat rupiah = new DecimalFormat("Rp #,##0");
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null || activeTab.isBlank()) activeTab = "home";
    String activeCategory = (String) request.getAttribute("activeCategory");
    if (activeCategory == null || activeCategory.isBlank()) activeCategory = "All";

    Set<String> categories = new LinkedHashSet<>();
    if (menus != null) {
        for (MenuItem menu : menus) {
            categories.add(menu.getCategory());
        }
    }

    int unpaidCount = 0;
    int paidCount = 0;
    int activeOrderCount = 0;
    if (orders != null) {
        for (Order order : orders) {
            if ("PAID".equalsIgnoreCase(order.getPaymentStatus())) paidCount++;
            else unpaidCount++;
            if (!"SERVED".equalsIgnoreCase(order.getStatus()) && !"CANCELLED".equalsIgnoreCase(order.getStatus())) activeOrderCount++;
        }
    }
    String displayName = "customer@2f.com".equalsIgnoreCase(user.getEmail()) ? "Sam" : user.getName();
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer - 2F</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css?v=green-blue-v3">
</head>
<body>
<div class="page">
    <div class="topbar glass-topbar">
        <div class="brand"><span class="brand-mark">2F</span> <span>2F</span></div>
        <div class="nav">
            <span>Customer: <b><%= displayName %></b></span>
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

        <div class="role-nav modern-tabs">
            <a class="role-tab <%= "home".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=home">🏠 Dashboard</a>
            <a class="role-tab <%= "order".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=order">➕ Tambah Pesanan</a>
            <a class="role-tab <%= "payment".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=payment">💳 Lakukan Pembayaran</a>
            <a class="role-tab <%= "history".equals(activeTab) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=history">🧾 Riwayat Pesanan</a>
        </div>

        <% if ("home".equals(activeTab)) { %>
        <div class="home-hero">
            <div class="hero-copy">
                <span class="eyebrow">2F ORDER MANAGEMENT</span>
                <h1>Hello, <%= displayName %>!</h1>
                <p>Pilih menu, tambah pesanan, lakukan pembayaran QRIS/Cash/Debit/Credit, lalu pantau status pesanan dalam satu sistem yang lebih rapi.</p>
                <div class="hero-actions">
                    <a class="btn" href="${pageContext.request.contextPath}/dashboard?tab=order">Tambah Pesanan</a>
                    <a class="btn btn-outline" href="${pageContext.request.contextPath}/dashboard?tab=payment">Lakukan Pembayaran</a>
                </div>
            </div>
            <div class="hero-stats">
                <div class="stat soft-orange"><div class="label">Order Aktif</div><div class="value"><%= activeOrderCount %></div><div class="trend">diproses dapur</div></div>
                <div class="stat soft-blue"><div class="label">Belum Dibayar</div><div class="value"><%= unpaidCount %></div><div class="trend">perlu payment</div></div>
                <div class="stat soft-green"><div class="label">Pembayaran Berhasil</div><div class="value"><%= paidCount %></div><div class="trend">status PAID</div></div>
            </div>
        </div>

        <div class="action-grid">
            <a class="action-card feature-card" href="${pageContext.request.contextPath}/dashboard?tab=order">
                <div class="action-icon">🍽️</div>
                <h3>Tambah Pesanan</h3>
                <p>Menu ditampilkan per kategori agar tidak penuh dalam satu halaman.</p>
            </a>
            <a class="action-card feature-card" href="${pageContext.request.contextPath}/dashboard?tab=payment">
                <div class="action-icon">💳</div>
                <h3>Lakukan Pembayaran</h3>
                <p>Buka halaman QRIS/payment dan konfirmasi pembayaran berhasil.</p>
            </a>
            <a class="action-card feature-card" href="${pageContext.request.contextPath}/dashboard?tab=history">
                <div class="action-icon">🧾</div>
                <h3>Riwayat Pesanan</h3>
                <p>Lihat detail pesanan, status dapur, dan bukti pembayaran.</p>
            </a>
        </div>
        <% } %>

        <% if ("order".equals(activeTab)) { %>
        <form action="${pageContext.request.contextPath}/order" method="post" id="orderForm">
            <input type="hidden" name="action" value="create">
            <div class="pos-layout">
                <aside class="side-rail">
                    <div class="rail-logo">2F</div>
                    <a title="Dashboard" href="${pageContext.request.contextPath}/dashboard?tab=home">🏠</a>
                    <a title="Tambah Pesanan" class="active" href="${pageContext.request.contextPath}/dashboard?tab=order">🍽️</a>
                    <a title="Pembayaran" href="${pageContext.request.contextPath}/dashboard?tab=payment">💳</a>
                    <a title="Riwayat" href="${pageContext.request.contextPath}/dashboard?tab=history">🧾</a>
                </aside>

                <main class="pos-main">
                    <div class="pos-header">
                        <div>
                            <span class="eyebrow">ORDER MENU</span>
                            <h1>Hello, <%= displayName %>!</h1>
                            <p>Kelola pesanan customer dengan tampilan dashboard Foodies: pilih kategori, tambah item, dan lanjut ke pembayaran.</p>
                        </div>
                        <div class="search-pill">🔎 Search menu or order...</div>
                    </div>

                    <div class="category-tabs pos-categories">
                        <a class="category-tab <%= "All".equalsIgnoreCase(activeCategory) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=order&category=All">✨ Semua</a>
                        <% for (String category : categories) { 
                            String icon = "☕";
                            if ("Food".equalsIgnoreCase(category)) icon = "🥐";
                            else if ("Tea".equalsIgnoreCase(category)) icon = "🍵";
                        %>
                        <a class="category-tab <%= category.equalsIgnoreCase(activeCategory) ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard?tab=order&category=<%= category %>"><%= icon %> <%= category %></a>
                        <% } %>
                    </div>

                    <div class="section-title clean-title">
                        <h2><%= "All".equalsIgnoreCase(activeCategory) ? "All Menu" : activeCategory %></h2>
                        <span class="meta">Stok otomatis berkurang saat order dibuat</span>
                    </div>

                    <div class="pos-menu-grid">
                        <%
                            boolean hasMenu = false;
                            if (menus != null) {
                                for (MenuItem menu : menus) {
                                    if (!"All".equalsIgnoreCase(activeCategory) && !menu.getCategory().equalsIgnoreCase(activeCategory)) {
                                        continue;
                                    }
                                    hasMenu = true;
                                    String visualClass = "coffee-card";
                                    String visualEmoji = "☕";
                                    String menuNameLower = menu.getName().toLowerCase();
                                    if ("Food".equalsIgnoreCase(menu.getCategory())) {
                                        visualClass = "food-card";
                                        visualEmoji = menuNameLower.contains("croissant") ? "🥐" : (menuNameLower.contains("muffin") ? "🧁" : "🍽️");
                                    } else if ("Tea".equalsIgnoreCase(menu.getCategory())) {
                                        visualClass = "tea-card";
                                        visualEmoji = menuNameLower.contains("matcha") ? "🍵" : "🧋";
                                    } else if (menuNameLower.contains("bean") || menuNameLower.contains("roast")) {
                                        visualClass = "coffee-card";
                                        visualEmoji = "🫘";
                                    } else if (menuNameLower.contains("latte") || menuNameLower.contains("white")) {
                                        visualClass = "coffee-card";
                                        visualEmoji = "☕";
                                    }
                        %>
                        <div class="pos-card">
                            <input type="hidden" name="menuId" value="<%= menu.getId() %>">
                            <div class="pos-photo <%= visualClass %>"><span><%= visualEmoji %></span></div>
                            <div class="pos-info">
                                <h3><%= menu.getName() %></h3>
                                <p><%= menu.getCategory() %> • Stok <%= menu.getStock() %></p>
                            </div>
                            <div class="pos-card-footer">
                                <span class="price"><%= rupiah.format(menu.getPrice()) %></span>
                                <div class="qty-stepper">
                                    <button type="button" onclick="changeQty(<%= menu.getId() %>, -1)">−</button>
                                    <input class="qty-input" id="qty_<%= menu.getId() %>" type="number" name="qty_<%= menu.getId() %>" value="0" min="0" max="<%= menu.getStock() %>" data-menu-id="<%= menu.getId() %>" data-name="<%= menu.getName() %>" data-price="<%= menu.getPrice() %>" data-stock="<%= menu.getStock() %>" oninput="updateCurrentOrder()">
                                    <button type="button" onclick="changeQty(<%= menu.getId() %>, 1)">+</button>
                                </div>
                            </div>
                        </div>
                        <% }} %>
                        <% if (!hasMenu) { %>
                        <div class="panel empty-state">Belum ada menu pada kategori ini.</div>
                        <% } %>
                    </div>
                </main>

                <aside class="current-order-panel">
                    <div class="current-head">
                        <div>
                            <span class="eyebrow">CURRENT ORDER</span>
                            <h2>Current Order</h2>
                        </div>
                        <span class="cart-dot" id="itemCount">0</span>
                    </div>
                    <div id="currentOrderList" class="current-list empty-cart">
                        Belum ada menu dipilih. Tekan + pada kartu menu untuk membuat current order.
                    </div>

                    <div class="checkout-fields">
                        <label>Nomor Meja</label>
                        <input type="text" name="tableNumber" placeholder="Contoh: 12" required>
                        <label>Metode Payment</label>
                        <select name="paymentMethod" required>
                            <option value="QRIS">QRIS</option>
                            <option value="CASH">Cash</option>
                            <option value="DEBIT">Debit</option>
                            <option value="CREDIT">Credit</option>
                        </select>
                    </div>

                    <div class="order-summary-box">
                        <div><span>Subtotal</span><b id="subtotalText">Rp 0</b></div>
                        <div><span>Pajak 11%</span><b id="taxText">Rp 0</b></div>
                        <div class="grand"><span>Total</span><b id="totalText">Rp 0</b></div>
                    </div>
                    <button type="submit" class="continue-btn">Continue to payment →</button>
                    <p class="meta center">Setelah klik tombol ini, sistem langsung membuka halaman payment QRIS/instruksi pembayaran.</p>
                </aside>
            </div>
        </form>
        <% } %>

        <% if ("payment".equals(activeTab)) { %>
        <div class="panel page-heading aesthetic-heading">
            <p>LAKUKAN PEMBAYARAN</p>
            <h1>Daftar Pesanan Belum Dibayar</h1>
            <p>Pilih tombol Bayar untuk membuka tampilan QRIS/instruksi pembayaran dan konfirmasi pembayaran berhasil.</p>
        </div>
        <div class="table-panel">
            <table>
                <thead>
                <tr><th>Order</th><th>Meja</th><th>Item</th><th>Status</th><th>Metode</th><th>Total</th><th>Aksi</th></tr>
                </thead>
                <tbody>
                <%
                    boolean hasUnpaid = false;
                    if (orders != null) {
                        for (Order order : orders) {
                            if ("PAID".equalsIgnoreCase(order.getPaymentStatus())) continue;
                            hasUnpaid = true;
                %>
                <tr>
                    <td>#<%= order.getId() %></td>
                    <td><%= order.getTableNumber() %></td>
                    <td><ul class="item-list"><% for (OrderItem item : order.getItems()) { %><li><%= item.getQuantity() %>x <%= item.getMenuName() %></li><% } %></ul></td>
                    <td><span class="badge <%= order.getStatus() %>"><%= order.getStatus() %></span></td>
                    <td><%= order.getPaymentMethod() == null ? "Belum dipilih" : order.getPaymentMethod() %></td>
                    <td><b><%= rupiah.format(order.getTotalPrice()) %></b></td>
                    <td><a class="btn" href="${pageContext.request.contextPath}/payment?orderId=<%= order.getId() %>">Bayar Sekarang</a></td>
                </tr>
                <% }} %>
                <% if (!hasUnpaid) { %>
                <tr><td colspan="7">Tidak ada pesanan yang perlu dibayar.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% if ("history".equals(activeTab)) { %>
        <div class="section-title"><h2>Riwayat Pesanan Saya</h2></div>
        <div class="table-panel">
            <table>
                <thead>
                <tr>
                    <th>Order</th><th>Meja</th><th>Item</th><th>Status</th><th>Payment</th><th>Total</th><th>Tanggal</th><th>Aksi</th>
                </tr>
                </thead>
                <tbody>
                <% if (orders != null && !orders.isEmpty()) { for (Order order : orders) { %>
                <tr>
                    <td>#<%= order.getId() %></td>
                    <td><%= order.getTableNumber() %></td>
                    <td><ul class="item-list"><% for (OrderItem item : order.getItems()) { %><li><%= item.getQuantity() %>x <%= item.getMenuName() %></li><% } %></ul></td>
                    <td><span class="badge <%= order.getStatus() %>"><%= order.getStatus() %></span></td>
                    <td><%= order.getPaymentMethod() == null ? "Belum bayar" : order.getPaymentMethod() + " - " + order.getPaymentStatus() %></td>
                    <td><b><%= rupiah.format(order.getTotalPrice()) %></b></td>
                    <td><%= order.getCreatedAt() %></td>
                    <td>
                        <% if (!"PAID".equalsIgnoreCase(order.getPaymentStatus())) { %>
                        <a class="btn btn-outline" href="${pageContext.request.contextPath}/payment?orderId=<%= order.getId() %>">Bayar</a>
                        <% } else { %>
                        <a class="btn btn-outline" href="${pageContext.request.contextPath}/payment-success?orderId=<%= order.getId() %>">Struk</a>
                        <% } %>
                    </td>
                </tr>
                <% }} else { %>
                <tr><td colspan="8">Belum ada pesanan.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>
<script>
function rupiah(value) {
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(value).replace('IDR', 'Rp');
}
function changeQty(id, delta) {
    const input = document.getElementById('qty_' + id);
    if (!input) return;
    const max = parseInt(input.dataset.stock || input.max || '99');
    let value = parseInt(input.value || '0') + delta;
    if (value < 0) value = 0;
    if (value > max) value = max;
    input.value = value;
    updateCurrentOrder();
}
function updateCurrentOrder() {
    const list = document.getElementById('currentOrderList');
    const subtotalText = document.getElementById('subtotalText');
    const taxText = document.getElementById('taxText');
    const totalText = document.getElementById('totalText');
    const itemCount = document.getElementById('itemCount');
    if (!list) return;
    let html = '';
    let subtotal = 0;
    let count = 0;
    document.querySelectorAll('.qty-input').forEach(input => {
        const qty = parseInt(input.value || '0');
        if (qty > 0) {
            const price = parseFloat(input.dataset.price || '0');
            const name = input.dataset.name || 'Menu';
            const line = qty * price;
            subtotal += line;
            count += qty;
            html += '<div class="current-item"><div class="thumb">🍽️</div><div><b>' + name + '</b><span>' + qty + ' x ' + rupiah(price) + '</span></div><strong>' + rupiah(line) + '</strong></div>';
        }
    });
    if (!html) {
        list.className = 'current-list empty-cart';
        list.innerHTML = 'Belum ada menu dipilih. Tekan + pada kartu menu untuk membuat current order.';
    } else {
        list.className = 'current-list';
        list.innerHTML = html;
    }
    const tax = subtotal * 0.11;
    const total = subtotal + tax;
    subtotalText.textContent = rupiah(subtotal);
    taxText.textContent = rupiah(tax);
    totalText.textContent = rupiah(total);
    itemCount.textContent = count;
}
document.addEventListener('DOMContentLoaded', updateCurrentOrder);
</script>
</body>
</html>
