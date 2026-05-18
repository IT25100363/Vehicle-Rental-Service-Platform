package com.vehiclerental.servlet;

import com.vehiclerental.auth.Auth;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Starts the booking flow from the public fleet page: validates vehicle,
 * sends guests to login/signup with return URL, or sends signed-in users to account with vehicle pre-selected.
 */
@WebServlet("/book-vehicle")
public class BookVehicleServlet extends BaseServlet {
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        vehicleDAO = new VehicleDAO(dbPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String ctx = request.getContextPath();
        if (id == null || id.isBlank()) {
            response.sendRedirect(ctx + "/home.jsp");
            return;
        }
        String trimmedId = id.trim();
        Vehicle vehicle = vehicleDAO.getById(trimmedId);
        if (vehicle == null || !"Available".equals(vehicle.getStatus())) {
            response.sendRedirect(ctx + "/home.jsp?bookingError=unavailable");
            return;
        }

        String accountPath = "/account?vehicleId=" + trimmedId + "&focus=book";
        HttpSession session = request.getSession(false);
        if (!Auth.isLoggedIn(session)) {
            String encodedReturn = URLEncoder.encode(accountPath, StandardCharsets.UTF_8);
            response.sendRedirect(ctx + "/login.jsp?reason=book&redirect=" + encodedReturn);
            return;
        }
        response.sendRedirect(ctx + accountPath);
    }
}


