package com.vehiclerental.servlet;

import com.vehiclerental.auth.Auth;
import com.vehiclerental.dao.UserDAO;
import com.vehiclerental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO(dbPath);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        User user = userDAO.findByEmail(email);
        if (user == null || user.getPassword() == null || !user.getPassword().equals(password)) {
            String ctx = request.getContextPath();
            String redirect = request.getParameter("redirect");
            String url = ctx + "/login.jsp?error=1";
            if (redirect != null && !redirect.isBlank() && redirect.startsWith("/") && !redirect.startsWith("//")) {
                url += "&redirect=" + URLEncoder.encode(redirect, StandardCharsets.UTF_8);
            }
            response.sendRedirect(url);
            return;
        }
        HttpSession session = request.getSession();
        session.setAttribute(Auth.SESSION_USER_ID, user.getId());
        session.setAttribute(Auth.SESSION_USER_NAME, user.getName());
        session.setAttribute(Auth.SESSION_USER_EMAIL, user.getEmail());
        session.setAttribute(Auth.SESSION_USER_ROLE, user.getRole());

        String redirect = request.getParameter("redirect");
        String ctx = request.getContextPath();
        if (redirect != null && !redirect.isBlank() && redirect.startsWith("/") && !redirect.startsWith("//")) {
            response.sendRedirect(ctx + redirect);
            return;
        }
        if ("Admin".equals(user.getRole())) {
            response.sendRedirect(ctx + "/index.jsp");
        } else {
            response.sendRedirect(ctx + "/account");
        }
    }
}
