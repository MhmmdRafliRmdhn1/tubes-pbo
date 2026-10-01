<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Error - 2F</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css?v=green-blue-v3">
</head>
<body>
<div class="container">
    <div class="panel">
        <h1>Terjadi Error</h1>
        <p><%= request.getAttribute("error") == null ? "Kesalahan tidak diketahui." : request.getAttribute("error") %></p>
        <br>
        <a class="btn" href="${pageContext.request.contextPath}/dashboard">Kembali</a>
    </div>
</div>
</body>
</html>
