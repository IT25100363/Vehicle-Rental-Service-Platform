package com.vehiclerental.servlet;

import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.dao.RentalReturnDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Payment;
import com.vehiclerental.model.RentalReturn;
import com.vehiclerental.model.Vehicle;
import com.vehiclerental.service.RentalLifecycle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/rentals")
public class RentalReturnServlet extends BaseServlet {
    private RentalReturnDAO rentalReturnDAO;
    private BookingDAO bookingDAO;
    private VehicleDAO vehicleDAO;
    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        rentalReturnDAO = new RentalReturnDAO(dbPath);
        bookingDAO = new BookingDAO(dbPath);
        vehicleDAO = new VehicleDAO(dbPath);
        paymentDAO = new PaymentDAO(dbPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteRental(request, response);
                break;
            default:
                listRentals(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            updateRental(request, response);
        } else {
            insertRental(request, response);
        }
    }

    private void listRentals(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<RentalReturn> listRental = rentalReturnDAO.getAll();
        request.setAttribute("listRental", listRental);
        request.getRequestDispatcher("rental-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String err = request.getParameter("error");
        if (err != null && !err.isBlank()) {
            request.setAttribute("formError", err);
        }
        String bid = request.getParameter("bookingId");
        if (bid != null && !bid.isBlank()) {
            var existingRr = rentalReturnDAO.findByBookingId(bid.trim());
            if (existingRr.isPresent()) {
                response.sendRedirect("rentals?action=edit&id=" + existingRr.get().getId());
                return;
            }
            Booking b = bookingDAO.getById(bid.trim());
            if (b != null) {
                request.setAttribute("prefillBooking", b);
                Vehicle v = vehicleDAO.getById(b.getVehicleId());
                request.setAttribute("vehicleForLate", v);
            }
        }
        request.getRequestDispatcher("rental-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        RentalReturn existingRental = rentalReturnDAO.getById(id);
        if (existingRental == null) {
            response.sendRedirect("rentals");
            return;
        }
        request.setAttribute("rental", existingRental);
        Booking b = bookingDAO.getById(existingRental.getBookingId());
        Vehicle v = b != null ? vehicleDAO.getById(b.getVehicleId()) : null;
        request.setAttribute("prefillBooking", b);
        request.setAttribute("vehicleForLate", v);
        if (b != null && v != null && !RentalLifecycle.isBlank(existingRental.getReturnDate())) {
            double late = RentalLifecycle.computeLateFee(b, v, existingRental.getReturnDate());
            request.setAttribute("computedLateFee", late);
            double manual = Math.max(0, existingRental.getAdditionalCharges() - late);
            request.setAttribute("manualChargesPrefill", manual);
        } else {
            request.setAttribute("manualChargesPrefill", existingRental.getAdditionalCharges());
        }
        request.getRequestDispatcher("rental-form.jsp").forward(request, response);
    }

    private void insertRental(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String bookingId = request.getParameter("bookingId");
        if (bookingId == null || bookingId.isBlank()) {
            response.sendRedirect("rentals?action=new&error=booking");
            return;
        }
        bookingId = bookingId.trim();
        if (rentalReturnDAO.findByBookingId(bookingId).isPresent()) {
            response.sendRedirect("rentals?action=new&error=duplicate");
            return;
        }
        Booking booking = bookingDAO.getById(bookingId);
        if (booking == null) {
            response.sendRedirect("rentals?action=new&error=booking");
            return;
        }
        if (!"Confirmed".equals(booking.getStatus())) {
            response.sendRedirect("rentals?action=new&error=notconfirmed");
            return;
        }
        Vehicle vehicle = vehicleDAO.getById(booking.getVehicleId());
        if (vehicle == null) {
            response.sendRedirect("rentals?action=new&error=vehicle");
            return;
        }

        String rentalDate = trimToNull(request.getParameter("rentalDate"));
        String returnDate = trimToNull(request.getParameter("returnDate"));
        if (rentalDate == null) {
            response.sendRedirect("rentals?action=new&error=rentaldate");
            return;
        }
        String condition = request.getParameter("conditionOnReturn");
        if (condition == null) {
            condition = "";
        }
        double manual = readManualCharges(request);
        double lateFee = RentalLifecycle.computeLateFee(booking, vehicle, returnDate != null ? returnDate : "");
        double totalCharges = lateFee + manual;

        RentalReturn created = new RentalReturn(
                UUID.randomUUID().toString(),
                bookingId,
                rentalDate,
                returnDate != null ? returnDate : "",
                condition,
                totalCharges);
        rentalReturnDAO.add(created);

        boolean returnJustCompleted = returnDate != null && !returnDate.isBlank();
        applyBookingAndVehicleAfterSave(booking, vehicle, returnDate);
        syncAdditionalChargesPayment(booking, returnDate, totalCharges, returnJustCompleted);

        response.sendRedirect("rentals");
    }

    private void updateRental(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        RentalReturn previous = rentalReturnDAO.getById(id);
        if (previous == null) {
            response.sendRedirect("rentals");
            return;
        }

        String bookingId = request.getParameter("bookingId");
        if (bookingId == null || bookingId.isBlank()) {
            response.sendRedirect("rentals?action=edit&id=" + id + "&error=booking");
            return;
        }
        bookingId = bookingId.trim();
        if (!bookingId.equals(previous.getBookingId()) && rentalReturnDAO.findByBookingId(bookingId).isPresent()) {
            response.sendRedirect("rentals?action=edit&id=" + id + "&error=duplicate");
            return;
        }

        Booking booking = bookingDAO.getById(bookingId);
        if (booking == null) {
            response.sendRedirect("rentals?action=edit&id=" + id + "&error=booking");
            return;
        }
        Vehicle vehicle = vehicleDAO.getById(booking.getVehicleId());
        if (vehicle == null) {
            response.sendRedirect("rentals?action=edit&id=" + id + "&error=vehicle");
            return;
        }

        String rentalDate = trimToNull(request.getParameter("rentalDate"));
        String returnDate = trimToNull(request.getParameter("returnDate"));
        if (rentalDate == null) {
            response.sendRedirect("rentals?action=edit&id=" + id + "&error=rentaldate");
            return;
        }
        String condition = request.getParameter("conditionOnReturn");
        if (condition == null) {
            condition = "";
        }
        double manual = readManualCharges(request);
        double lateFee = RentalLifecycle.computeLateFee(booking, vehicle, returnDate != null ? returnDate : "");
        double totalCharges = lateFee + manual;

        boolean hadReturnBefore = !RentalLifecycle.isBlank(previous.getReturnDate());
        boolean hasReturnNow = returnDate != null && !returnDate.isBlank();
        boolean returnJustCompleted = hasReturnNow && !hadReturnBefore;

        RentalReturn updated = new RentalReturn(
                id,
                bookingId,
                rentalDate,
                returnDate != null ? returnDate : "",
                condition,
                totalCharges);
        rentalReturnDAO.update(updated);

        applyBookingAndVehicleAfterSave(booking, vehicle, returnDate);
        syncAdditionalChargesPayment(booking, returnDate, totalCharges, returnJustCompleted);

        response.sendRedirect("rentals");
    }

    /**
     * Pickup without return: Active + Rented. With return: Completed + Available.
     */
    private void applyBookingAndVehicleAfterSave(Booking booking, Vehicle vehicle, String returnDateNorm) {
        if (!RentalLifecycle.isBlank(returnDateNorm)) {
            booking.setStatus("Completed");
            vehicle.setStatus("Available");
        } else {
            booking.setStatus("Active");
            vehicle.setStatus("Rented");
        }
        bookingDAO.update(booking);
        vehicleDAO.update(vehicle);
    }

    /**
     * Adds a Pending row for extra charges (late + other) once, when return is first recorded.
     * Further changes to charges should be edited in Payment Management to avoid clobbering other pending lines.
     */
    private void syncAdditionalChargesPayment(Booking booking, String returnDateYmd, double totalCharges,
                                             boolean returnJustCompleted) {
        if (RentalLifecycle.isBlank(returnDateYmd) || totalCharges <= 0) {
            return;
        }
        if (returnJustCompleted) {
            paymentDAO.add(new Payment(
                    UUID.randomUUID().toString(),
                    booking.getId(),
                    totalCharges,
                    returnDateYmd,
                    "Cash",
                    "Pending"));
        }
    }

    private void deleteRental(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        rentalReturnDAO.delete(id);
        response.sendRedirect("rentals");
    }

    private double readManualCharges(HttpServletRequest request) {
        String manual = request.getParameter("manualCharges");
        if (manual != null && !manual.isBlank()) {
            return RentalLifecycle.parseAmount(manual, 0);
        }
        return RentalLifecycle.parseAmount(request.getParameter("additionalCharges"), 0);
    }

    private static String trimToNull(String s) {
        if (s == null) {
            return null;
        }
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}
