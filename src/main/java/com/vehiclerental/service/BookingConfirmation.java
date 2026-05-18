package com.vehiclerental.service;

import com.vehiclerental.dao.PaymentDAO;
import com.vehiclerental.dao.RentalReturnDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Payment;
import com.vehiclerental.model.RentalReturn;
import com.vehiclerental.model.Vehicle;

import java.time.LocalDate;
import java.util.UUID;

/**
 * Side effects when a booking is confirmed: estimated payment line + rental/return placeholder (no vehicle state change).
 */
public final class BookingConfirmation {

    private BookingConfirmation() {}

    /**
     * When status is Confirmed: ensure scheduled rental payment exists (if none yet) and a rental row
     * with scheduled pickup date, empty return (pickup/return completed later in Rent/Return).
     */
    public static void ensurePaymentAndRentalPlaceholder(
            Booking booking,
            VehicleDAO vehicleDAO,
            PaymentDAO paymentDAO,
            RentalReturnDAO rentalReturnDAO) {
        if (booking == null) {
            return;
        }
        String st = booking.getStatus();
        if (st == null || !"confirmed".equalsIgnoreCase(st.trim())) {
            return;
        }
        String vehicleKey = booking.getVehicleId() != null ? booking.getVehicleId().trim() : "";
        Vehicle vehicle = vehicleKey.isEmpty() ? null : vehicleDAO.getById(vehicleKey);
        if (paymentDAO.findByBookingId(booking.getId()).isEmpty()) {
            double estimated = RentalLifecycle.computeScheduledRentalTotal(booking, vehicle);
            if (estimated <= 0 && vehicle != null) {
                // Fallback so a payment row still exists when dates do not yield positive days (bad data)
                estimated = vehicle.getRentalPricePerDay();
            }
            if (estimated > 0) {
                String payDate = RentalLifecycle.isBlank(booking.getStartDate())
                        ? LocalDate.now().toString()
                        : booking.getStartDate().trim();
                paymentDAO.add(new Payment(
                        UUID.randomUUID().toString(),
                        booking.getId(),
                        estimated,
                        payDate,
                        "Cash",
                        "Pending"));
            }
        }
        if (rentalReturnDAO.findByBookingId(booking.getId()).isEmpty()) {
            String rentalDate = RentalLifecycle.isBlank(booking.getStartDate())
                    ? LocalDate.now().toString()
                    : booking.getStartDate().trim();
            rentalReturnDAO.add(new RentalReturn(
                    UUID.randomUUID().toString(),
                    booking.getId(),
                    rentalDate,
                    "",
                    "",
                    0));
        }
    }
}
