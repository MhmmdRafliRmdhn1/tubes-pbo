package com.cafeaura.servlet;

import com.cafeaura.dao.MenuDAO;
import com.cafeaura.model.MenuItem;
import com.cafeaura.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "MenuServlet", urlPatterns = {"/menu"})
public class MenuServlet extends HttpServlet {
    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + encode("Akses menu admin ditolak."));
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                MenuItem menu = readMenu(request, false);
                menuDAO.add(menu);
            } else if ("update".equals(action)) {
                MenuItem menu = readMenu(request, true);
                menuDAO.update(menu);
            } else if ("delete".equals(action)) {
                menuDAO.delete(Integer.parseInt(request.getParameter("id")));
            }
            response.sendRedirect(request.getContextPath() + "/dashboard?success=" + encode("Data menu berhasil diproses."));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + encode(e.getMessage()));
        }
    }

    private MenuItem readMenu(HttpServletRequest request, boolean withId) {
        MenuItem menu = new MenuItem();
        if (withId) {
            menu.setId(Integer.parseInt(request.getParameter("id")));
        }
        menu.setName(request.getParameter("name"));
        menu.setCategory(request.getParameter("category"));
        menu.setPrice(new BigDecimal(request.getParameter("price")));
        menu.setStock(Integer.parseInt(request.getParameter("stock")));
        menu.setAvailable("on".equals(request.getParameter("available")) || "true".equals(request.getParameter("available")));
        menu.setImageUrl(request.getParameter("imageUrl"));
        return menu;
    }

    private String encode(String text) {
        return URLEncoder.encode(text, StandardCharsets.UTF_8);
    }
}
