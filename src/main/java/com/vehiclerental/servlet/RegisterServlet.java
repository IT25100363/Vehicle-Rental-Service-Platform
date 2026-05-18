package com.vehiclerental.servlet;

import com.vehiclerental.dao.UserDAO;
import com.vehiclerental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@WebServlet("/register")
public class RegisterServlet extends BaseServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO(dbPath);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        String redirectAfterLogin = request.getParameter("redirect");

        if (name == null || email == null || password == null
                || name.isBlank() || email.isBlank() || password.isBlank()) {
            redirectRegister(request, response, "missing");
            return;
        }
        if (userDAO.findByEmail(email) != null) {
            redirectRegister(request, response, "exists");
            return;
        }
        User user = new User(UUID.randomUUID().toString(), name.trim(), email.trim(), password,
                "User", phoneNumber != null ? phoneNumber.trim() : "");
        userDAO.add(user);

        String ctx = request.getContextPath();
        String loc = ctx + "/login.jsp?registered=1";
        if (redirectAfterLogin != null && !redirectAfterLogin.isBlank()
                && redirectAfterLogin.startsWith("/") && !redirectAfterLogin.startsWith("//")) {
            loc += "&redirect=" + URLEncoder.encode(redirectAfterLogin, StandardCharsets.UTF_8);
        }
        response.sendRedirect(loc);
    }

    private void redirectRegister(HttpServletRequest request, HttpServletResponse response, String code)
            throws IOException {
        String ctx = request.getContextPath();
        String redirect = request.getParameter("redirect");
        String url = ctx + "/register.jsp?error=" + code;
        if (redirect != null && !redirect.isBlank() && redirect.startsWith("/") && !redirect.startsWith("//")) {
            url += "&redirect=" + URLEncoder.encode(redirect, StandardCharsets.UTF_8);
        }
        response.sendRedirect(url);
    }
}
