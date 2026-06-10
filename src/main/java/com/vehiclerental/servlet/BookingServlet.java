package com.vehiclerental.servlet;

import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.dao.RentalReturnDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.service.BookingConfirmation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/bookings")
public class BookingServlet extends BaseServlet {
    private BookingDAO bookingDAO;
    private VehicleDAO vehicleDAO;
    private PaymentDAO paymentDAO;
    private RentalReturnDAO rentalReturnDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO(dbPath);
        vehicleDAO = new VehicleDAO(dbPath);
        paymentDAO = new PaymentDAO(dbPath);
        rentalReturnDAO = new RentalReturnDAO(dbPath);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBooking(request, response);
                break;
            default:
                listBookings(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            updateBooking(request, response);
        } else {
            insertBooking(request, response);
        }
    }

    private void listBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Booking> listBooking = bookingDAO.getAll();
        java.util.Map<String, String> vehicleNames = new java.util.HashMap<>();
        for (com.vehiclerental.model.Vehicle v : vehicleDAO.getAll()) {
            vehicleNames.put(v.getId(), v.getBrand() + " " + v.getModel());
        }
        request.setAttribute("vehicleNames", vehicleNames);
        request.setAttribute("listBooking", listBooking);
        request.getRequestDispatcher("booking-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("booking-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        Booking existingBooking = bookingDAO.getById(id);
        request.setAttribute("booking", existingBooking);
        request.getRequestDispatcher("booking-form.jsp").forward(request, response);
    }

    private void insertBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = trimOrEmpty(request.getParameter("userId"));
        String vehicleId = trimOrEmpty(request.getParameter("vehicleId"));
        String startDate = trimOrEmpty(request.getParameter("startDate"));
        String endDate = trimOrEmpty(request.getParameter("endDate"));
        String status = trimOrEmpty(request.getParameter("status"));

        Booking newBooking = new Booking(UUID.randomUUID().toString(), userId, vehicleId, startDate, endDate, status);
        bookingDAO.add(newBooking);
        if ("Confirmed".equalsIgnoreCase(status)) {
            BookingConfirmation.ensurePaymentAndRentalPlaceholder(newBooking, vehicleDAO, paymentDAO, rentalReturnDAO);
        }
        response.sendRedirect("bookings");
    }

    private void updateBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = trimOrEmpty(request.getParameter("id"));
        String userId = trimOrEmpty(request.getParameter("userId"));
        String vehicleId = trimOrEmpty(request.getParameter("vehicleId"));
        String startDate = trimOrEmpty(request.getParameter("startDate"));
        String endDate = trimOrEmpty(request.getParameter("endDate"));
        String status = trimOrEmpty(request.getParameter("status"));

        Booking booking = new Booking(id, userId, vehicleId, startDate, endDate, status);
        bookingDAO.update(booking);
        // Admin confirms: create payment + rental placeholder whenever booking ends up Confirmed
        if ("Confirmed".equalsIgnoreCase(status)) {
            BookingConfirmation.ensurePaymentAndRentalPlaceholder(booking, vehicleDAO, paymentDAO, rentalReturnDAO);
        }
        response.sendRedirect("bookings");
    }

    private static String trimOrEmpty(String s) {
        return s == null ? "" : s.trim();
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        paymentDAO.deleteAllByBookingId(id);
        rentalReturnDAO.deleteByBookingId(id);
        bookingDAO.delete(id);
        response.sendRedirect("bookings");
    }
}

