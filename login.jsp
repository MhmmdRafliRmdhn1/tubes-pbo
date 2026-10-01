<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - 2F Cafe Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css?v=coffee-login-clean-v2">
</head>
<body class="coffee-login-page">
<div class="coffee-login-bg-orb orb-one"></div>
<div class="coffee-login-bg-orb orb-two"></div>

<main class="coffee-login-wrapper">
    <section class="coffee-photo-panel">
        <div class="coffee-photo-overlay"></div>
        <div class="coffee-photo-content">
            <div class="coffee-brand-line">
                <span class="coffee-brand-badge">2F</span>
                <span>Cafe Management</span>
            </div>

        </div>
    </section>

    <section class="coffee-form-panel">
        <div class="coffee-form-card">
            <div class="coffee-form-logo">2F</div>
            <p class="coffee-form-kicker">Selamat Datang</p>
            <h2>Masuk Sistem</h2>
            <p class="coffee-form-desc">
                Login sesuai role untuk membuka halaman Customer, Staff, atau Admin.
            </p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="message error coffee-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post" class="coffee-login-form">
                <label>Email</label>
                <div class="coffee-input-group">
                    <span>✉</span>
                    <input type="email" name="email" placeholder="contoh: admin@2f.com" value="${param.email}" required>
                </div>

                <label>Password</label>
                <div class="coffee-input-group">
                    <span>🔒</span>
                    <input type="password" name="password" placeholder="Ketik password Anda" required>
                </div>

                <div class="coffee-form-options">
                    <label class="coffee-remember">
                        <input type="checkbox" checked>
                        <span>Ingat saya</span>
                    </label>
                    <a href="#">Lupa password?</a>
                </div>

                <button type="submit" class="coffee-login-button">
                    <span>Login</span>
                    <span>→</span>
                </button>
            </form>

            <div class="coffee-accounts">
                <div class="coffee-account-icon">👥</div>
                <div>
                    <b>Akun Default</b>
                    <p>Admin: admin@2f.com / admin123</p>
                    <p>Staff: staff@2f.com / staff123</p>
                    <p>Customer: customer@2f.com / customer123</p>
                </div>
            </div>
        </div>
    </section>
</main>
</body>
</html>
