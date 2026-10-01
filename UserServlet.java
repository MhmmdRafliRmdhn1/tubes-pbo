package com.cafeaura.servlet;

import com.cafeaura.dao.UserDAO;
import com.cafeaura.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + encode("Akses kelola user ditolak."));
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                userDAO.addUser(
                        request.getParameter("name"),
                        request.getParameter("email"),
                        request.getParameter("password"),
                        request.getParameter("role")
                );
            } else if ("toggle".equals(action)) {
                userDAO.toggleActive(Integer.parseInt(request.getParameter("id")));
            }
            response.sendRedirect(request.getContextPath() + "/dashboard?success=" + encode("Data user berhasil diproses."));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + encode(e.getMessage()));
        }
    }

    private String encode(String text) {
        return URLEncoder.encode(text, StandardCharsets.UTF_8);
    }
}
