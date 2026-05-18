package com.vehiclerental.filter;

import com.vehiclerental.auth.Auth;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/users", "/vehicles", "/bookings", "/rentals", "/payments", "/feedbacks"})
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        if (!Auth.isAdmin(session)) {
            String ctx = req.getContextPath();
            res.sendRedirect(ctx + "/login.jsp?reason=admin");
            return;
        }
        chain.doFilter(request, response);
    }
}
