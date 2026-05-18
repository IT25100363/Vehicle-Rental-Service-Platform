package com.vehiclerental.servlet;

import com.vehiclerental.auth.Auth;
import com.vehiclerental.dao.BookingDAO;
import com.vehiclerental.dao.FeedbackDAO;
import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.dao.RentalReturnDAO;
import com.vehiclerental.dao.UserDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Feedback;
import com.vehiclerental.model.User;
import com.vehiclerental.model.Vehicle;
import com.vehiclerental.service.RentalLifecycle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet("/account")
public class AccountServlet extends BaseServlet {
    private UserDAO userDAO;
    private BookingDAO bookingDAO;
    private VehicleDAO vehicleDAO;
    private FeedbackDAO feedbackDAO;
    private PaymentDAO paymentDAO;
    private RentalReturnDAO rentalReturnDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO(dbPath);
        bookingDAO = new BookingDAO(dbPath);
        vehicleDAO = new VehicleDAO(dbPath);
        feedbackDAO = new FeedbackDAO(dbPath);
        paymentDAO = new PaymentDAO(dbPath);
        rentalReturnDAO = new RentalReturnDAO(dbPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!Auth.isLoggedIn(session)) {
            String ctx = request.getContextPath();
            String qs = request.getQueryString();
            if (qs != null && !qs.isBlank()) {
                String ret = "/account?" + qs;
                response.sendRedirect(ctx + "/login.jsp?reason=account&redirect="
                        + URLEncoder.encode(ret, StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(ctx + "/login.jsp?reason=account");
            }
            return;
        }
        String userId = (String) session.getAttribute(Auth.SESSION_USER_ID);
        User user = userDAO.getById(userId);
        if (user == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=session");
            return;
        }
        request.setAttribute("user", user);
        List<Booking> myBookings = bookingDAO.findByUserId(userId);
        request.setAttribute("myBookings", myBookings);
        Map<String, Boolean> cancelEligibility = new HashMap<>();
        for (Booking b : myBookings) {
            cancelEligibility.put(b.getId(), RentalLifecycle.canCustomerCancel(b));
        }
        request.setAttribute("cancelEligibility", cancelEligibility);
        request.setAttribute("myFeedbacks", feedbackDAO.findByUserId(userId));
        var fleet = vehicleDAO.getAll();
        request.setAttribute("vehicles", fleet);
        Map<String, String> vehicleLabels = new HashMap<>();
        for (Vehicle v : fleet) {
            vehicleLabels.put(v.getId(), v.getBrand() + " " + v.getModel());
        }
        request.setAttribute("vehicleLabels", vehicleLabels);
        request.setAttribute("pageTitle", "My account");

        String vehicleIdParam = request.getParameter("vehicleId");
        if (vehicleIdParam != null && !vehicleIdParam.isBlank()) {
            Vehicle picked = vehicleDAO.getById(vehicleIdParam.trim());
            if (picked != null && "Available".equals(picked.getStatus())) {
                request.setAttribute("prefillVehicleId", picked.getId());
            }
        }
        if ("book".equals(request.getParameter("focus"))) {
            request.setAttribute("focusBookingSection", Boolean.TRUE);
        }

        request.getRequestDispatcher("/account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (!Auth.isLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String userId = (String) session.getAttribute(Auth.SESSION_USER_ID);
        String action = request.getParameter("formAction");

        if ("updateProfile".equals(action)) {
            User existing = userDAO.getById(userId);
            if (existing == null) {
                response.sendRedirect(request.getContextPath() + "/logout");
                return;
            }
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String newPassword = request.getParameter("password");
            String password = (newPassword != null && !newPassword.isBlank()) ? newPassword : existing.getPassword();

            User emailOwner = userDAO.findByEmail(email);
            if (emailOwner != null && !emailOwner.getId().equals(userId)) {
                response.sendRedirect(request.getContextPath() + "/account?error=email");
                return;
            }
            User updated = new User(userId,
                    name != null ? name.trim() : existing.getName(),
                    email != null ? email.trim() : existing.getEmail(),
                    password,
                    existing.getRole(),
                    phoneNumber != null ? phoneNumber.trim() : existing.getPhoneNumber());
            userDAO.update(updated);
            session.setAttribute(Auth.SESSION_USER_NAME, updated.getName());
            session.setAttribute(Auth.SESSION_USER_EMAIL, updated.getEmail());
            response.sendRedirect(request.getContextPath() + "/account?saved=1");
            return;
        }

        if ("createBooking".equals(action)) {
            String vehicleId = request.getParameter("vehicleId");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            if (vehicleId == null || vehicleId.isBlank() || startDate == null || endDate == null) {
                response.sendRedirect(request.getContextPath() + "/account?error=booking");
                return;
            }
            Booking booking = new Booking(UUID.randomUUID().toString(), userId, vehicleId.trim(),
                    startDate, endDate, "Pending");
            bookingDAO.add(booking);
            response.sendRedirect(request.getContextPath() + "/account?booked=1");
            return;
        }

        if ("cancelBooking".equals(action)) {
            String bookingId = request.getParameter("bookingId");
            if (bookingId == null || bookingId.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/account?error=cancel");
                return;
            }
            Booking existing = bookingDAO.getById(bookingId.trim());
            if (existing == null || !userId.equals(existing.getUserId())) {
                response.sendRedirect(request.getContextPath() + "/account?error=cancelAuth");
                return;
            }
            if (!RentalLifecycle.canCustomerCancel(existing)) {
                response.sendRedirect(request.getContextPath() + "/account?error=cancelPolicy");
                return;
            }
            existing.setStatus("Cancelled");
            bookingDAO.update(existing);
            paymentDAO.deletePendingByBookingId(existing.getId());
            rentalReturnDAO.deleteByBookingId(existing.getId());
            response.sendRedirect(request.getContextPath() + "/account?cancelled=1");
            return;
        }

        if ("submitFeedback".equals(action)) {
            String vehicleId = request.getParameter("vehicleId");
            String ratingStr = request.getParameter("rating");
            String comments = request.getParameter("comments");
            if (vehicleId == null || vehicleId.isBlank() || ratingStr == null) {
                response.sendRedirect(request.getContextPath() + "/account?error=feedback");
                return;
            }
            int rating = Integer.parseInt(ratingStr);
            String date = java.time.LocalDate.now().toString();
            Feedback feedback = new Feedback(UUID.randomUUID().toString(), userId, vehicleId.trim(),
                    rating, comments != null ? comments.trim().replace(",", " ") : "", date);
            feedbackDAO.add(feedback);
            response.sendRedirect(request.getContextPath() + "/account?feedbackSaved=1");
            return;
        }

        if ("deleteFeedback".equals(action)) {
            String feedbackId = request.getParameter("feedbackId");
            Feedback fb = feedbackDAO.getById(feedbackId);
            if (fb != null && fb.getUserId().equals(userId)) {
                feedbackDAO.delete(feedbackId);
                response.sendRedirect(request.getContextPath() + "/account?feedbackDeleted=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/account?error=auth");
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + "/account");
    }
}
