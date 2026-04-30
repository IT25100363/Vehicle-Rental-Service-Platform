package servlet;

import model.Vehicle;
import service.VehicleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/vehicles")
public class VehicleServlet extends HttpServlet {

    private VehicleService vehicleService;

    @Override
    public void init() {
        vehicleService = new VehicleService();
    }

    // READ, EDIT PAGE, DELETE
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                request.getRequestDispatcher("/vehicles/addVehicle.jsp").forward(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deleteVehicle(request, response);
                break;

            default:
                listVehicles(request, response);
                break;
        }
    }

    // CREATE and UPDATE
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            addVehicle(request, response);
        } else if ("update".equals(action)) {
            updateVehicle(request, response);
        }
    }

    private void listVehicles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("vehicleList", vehicleService.getAllVehicles());
        request.getRequestDispatcher("/vehicles/listVehicles.jsp").forward(request, response);
    }

    private void addVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String brand = request.getParameter("brand");
        String vehicleType = request.getParameter("vehicleType");
        String model = request.getParameter("model");
        String plateNumber = request.getParameter("plateNumber");
        String fuelType = request.getParameter("fuelType");

        Vehicle vehicle = new Vehicle(0, brand, vehicleType, model, plateNumber, fuelType);
        vehicleService.addVehicle(vehicle);

        response.sendRedirect("vehicles");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Vehicle existingVehicle = vehicleService.getVehicleById(id);

        request.setAttribute("vehicle", existingVehicle);
        request.getRequestDispatcher("/vehicles/editVehicle.jsp").forward(request, response);
    }

    private void updateVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String brand = request.getParameter("brand");
        String vehicleType = request.getParameter("vehicleType");
        String model = request.getParameter("model");
        String plateNumber = request.getParameter("plateNumber");
        String fuelType = request.getParameter("fuelType");

        Vehicle vehicle = new Vehicle(id, brand, vehicleType, model, plateNumber, fuelType);
        vehicleService.updateVehicle(vehicle);

        response.sendRedirect("vehicles");
    }

    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        vehicleService.deleteVehicle(id);

        response.sendRedirect("vehicles");
    }
}
