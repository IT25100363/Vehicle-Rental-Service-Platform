package com.vehiclerental.service;

import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Vehicle;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;

/**
 * Booking/rental rules: customer cancellation and late-fee calculation from scheduled end date.
 */
public final class RentalLifecycle {

    private RentalLifecycle() {}

    public static boolean canCustomerCancel(Booking b) {
        if (b == null) {
            return false;
        }
        String s = b.getStatus();
        if ("Cancelled".equals(s) || "Completed".equals(s) || "Active".equals(s)) {
            return false;
        }
        if ("Pending".equals(s)) {
            return true;
        }
        if ("Confirmed".equals(s)) {
            LocalDate start = parseDate(b.getStartDate());
            if (start == null) {
                return false;
            }
            return LocalDate.now().isBefore(start);
        }
        return false;
    }

    /**
     * Inclusive calendar days from start through end (same day = 1 day).
     */
    public static int countScheduledRentalDays(Booking b) {
        if (b == null) {
            return 0;
        }
        LocalDate start = parseDate(b.getStartDate());
        LocalDate end = parseDate(b.getEndDate());
        if (start == null || end == null || end.isBefore(start)) {
            return 0;
        }
        return (int) ChronoUnit.DAYS.between(start, end) + 1;
    }

    /**
     * Estimated rental charge for the scheduled window (daily rate × days).
     */
    public static double computeScheduledRentalTotal(Booking b, Vehicle vehicle) {
        if (vehicle == null) {
            return 0;
        }
        int days = countScheduledRentalDays(b);
        if (days <= 0) {
            return 0;
        }
        return days * vehicle.getRentalPricePerDay();
    }

    /**
     * Late fee = days after scheduled {@link Booking#getEndDate()} × vehicle daily rate.
     */
    public static double computeLateFee(Booking booking, Vehicle vehicle, String actualReturnDateYmd) {
        if (booking == null || vehicle == null) {
            return 0;
        }
        LocalDate scheduledEnd = parseDate(booking.getEndDate());
        LocalDate actualReturn = parseDate(actualReturnDateYmd);
        if (scheduledEnd == null || actualReturn == null) {
            return 0;
        }
        long lateDays = java.time.temporal.ChronoUnit.DAYS.between(scheduledEnd, actualReturn);
        if (lateDays <= 0) {
            return 0;
        }
        return lateDays * vehicle.getRentalPricePerDay();
    }

    public static LocalDate parseDate(String ymd) {
        if (ymd == null || ymd.isBlank()) {
            return null;
        }
        try {
            return LocalDate.parse(ymd.trim());
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    public static double parseAmount(String raw, double defaultVal) {
        if (raw == null || raw.isBlank()) {
            return defaultVal;
        }
        try {
            return Double.parseDouble(raw.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    public static boolean isBlank(String s) {
        return s == null || s.isBlank();
    }
}
