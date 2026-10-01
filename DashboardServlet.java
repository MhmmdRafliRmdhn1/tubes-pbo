package com.cafeaura.servlet;

import com.cafeaura.dao.MenuDAO;
import com.cafeaura.dao.OrderDAO;
import com.cafeaura.dao.PaymentDAO;
import com.cafeaura.dao.UserDAO;
import com.cafeaura.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
    private final MenuDAO menuDAO = new MenuDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String tab = request.getParameter("tab");
            if (tab == null || tab.isBlank()) {
                tab = "home";
            }
            String category = request.getParameter("category");
            if (category == null || category.isBlank()) {
                category = "All";
            }

            request.setAttribute("activeTab", tab);
            request.setAttribute("activeCategory", category);
            request.setAttribute("menus", menuDAO.findAll());
            request.setAttribute("success", request.getParameter("success"));
            request.setAttribute("error", request.getParameter("error"));

            if ("CUSTOMER".equals(user.getRole())) {
                request.setAttribute("availableMenus", menuDAO.findAvailable());
                request.setAttribute("orders", orderDAO.findByCustomer(user.getId()));
                request.getRequestDispatcher("/WEB-INF/views/customer.jsp").forward(request, response);
                return;
            }

            if ("STAFF".equals(user.getRole())) {
                request.setAttribute("orders", orderDAO.findKitchenQueue());
                request.setAttribute("payments", paymentDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/staff.jsp").forward(request, response);
                return;
            }

            request.setAttribute("orders", orderDAO.findAll());
            request.setAttribute("payments", paymentDAO.findAll());
            request.setAttribute("users", userDAO.findAll());
            request.setAttribute("totalSalesToday", orderDAO.getTotalSalesToday());
            request.setAttribute("orderCountToday", orderDAO.getOrderCountToday());
            request.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
