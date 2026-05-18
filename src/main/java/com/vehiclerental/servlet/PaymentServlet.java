package com.vehiclerental.servlet;

import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.model.Payment;

public class PaymentServlet {
    package com.vehiclerental.servlet;

import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.dao.RentalReturnDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Payment;
import com.vehiclerental.model.RentalReturn;
import com.vehiclerental.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

    @WebServlet("/payments")
    public class PaymentServlet extends BaseServlet {
        private PaymentDAO paymentDAO;
        private BookingDAO bookingDAO;
        private VehicleDAO vehicleDAO;
        private RentalReturnDAO rentalReturnDAO;

        @Override
        public void init() throws ServletException {
            super.init();
            paymentDAO = new PaymentDAO(dbPath);
            bookingDAO = new BookingDAO(dbPath);
            vehicleDAO = new VehicleDAO(dbPath);
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
                    deletePayment(request, response);
                    break;
                default:
                    listPayments(request, response);
                    break;
            }
        }

        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String action = request.getParameter("action");
            if ("update".equals(action)) {
                updatePayment(request, response);
            } else {
                insertPayment(request, response);
            }
        }

        private void listPayments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            List<Payment> listPayment = paymentDAO.getAll();
            request.setAttribute("listPayment", listPayment);
            request.getRequestDispatcher("payment-list.jsp").forward(request, response);
        }

        private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String bookingId = request.getParameter("bookingId");
            if (bookingId != null) {
                Booking booking = bookingDAO.getById(bookingId);
                if (booking != null) {
                    Vehicle vehicle = vehicleDAO.getById(booking.getVehicleId());
                    if (vehicle != null) {
                        try {
                            LocalDate start = LocalDate.parse(booking.getStartDate());
                            LocalDate end = LocalDate.parse(booking.getEndDate());
                            long days = ChronoUnit.DAYS.between(start, end);
                            if (days <= 0) days = 1; // Count as 1 day minimum

                            double rentalAmount = days * vehicle.getRentalPricePerDay();

                            // Add extra charges from rental return if exists
                            double extraCharges = 0;
                            Optional<RentalReturn> rr = rentalReturnDAO.findByBookingId(bookingId);
                            if (rr.isPresent()) {
                                extraCharges = rr.get().getAdditionalCharges();
                            }

                            double totalAmount = rentalAmount + extraCharges;

                            Payment preFilled = new Payment();
                            preFilled.setBookingId(bookingId);
                            preFilled.setAmount(totalAmount);
                            preFilled.setPaymentDate(LocalDate.now().toString());
                            preFilled.setPaymentMethod("Cash");
                            preFilled.setStatus("Paid");

                            request.setAttribute("payment", preFilled);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
            request.getRequestDispatcher("payment-form.jsp").forward(request, response);
        }

        private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String id = request.getParameter("id");
            Payment existingPayment = paymentDAO.getById(id);
            request.setAttribute("payment", existingPayment);
            request.getRequestDispatcher("payment-form.jsp").forward(request, response);
        }

        private void insertPayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
            String bookingId = request.getParameter("bookingId");
            double amount = Double.parseDouble(request.getParameter("amount"));
            String date = request.getParameter("paymentDate");
            String method = request.getParameter("paymentMethod");
            String status = request.getParameter("status");

            Payment newPayment = new Payment(UUID.randomUUID().toString(), bookingId, amount, date, method, status);
            paymentDAO.add(newPayment);
            response.sendRedirect("payments");
        }

        private void updatePayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
            String id = request.getParameter("id");
            String bookingId = request.getParameter("bookingId");
            double amount = Double.parseDouble(request.getParameter("amount"));
            String date = request.getParameter("paymentDate");
            String method = request.getParameter("paymentMethod");
            String status = request.getParameter("status");

            Payment payment = new Payment(id, bookingId, amount, date, method, status);
            paymentDAO.update(payment);
            response.sendRedirect("payments");
        }

        private void deletePayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
            String id = request.getParameter("id");
            paymentDAO.delete(id);
            response.sendRedirect("payments");
        }
    }


}
