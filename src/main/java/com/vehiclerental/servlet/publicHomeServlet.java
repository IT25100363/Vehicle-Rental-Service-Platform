package com.vehiclerental.servlet;

import com.vehiclerental.dao.VehicleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/public-home")
public class PublicHomeServlet extends BaseServlet {
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        vehicleDAO = new VehicleDAO(dbPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("listVehicle", vehicleDAO.getAll());
        request.setAttribute("pageTitle", "Browse our fleet");
        request.getRequestDispatcher("/public-home.jsp").forward(request, response);
    }
}
