package com.vehiclerental.dao;

import com.vehiclerental.model.Payment;

import java.util.List;
import java.util.stream.Collectors;

public class PaymentDAO extends GenericDAO<Payment> {
    public PaymentDAO(String dbPath) {
        super(dbPath + "/payments.txt", Payment::fromString);
    }
    public Payment getById(String id) { return super.getById(id, Payment::getId); }
    public void update(Payment payment) { super.update(payment, Payment::getId); }
    public void delete(String id) { super.delete(id, Payment::getId); }

    public List<Payment> findByBookingId(String bookingId) {
        if (bookingId == null) {
            return List.of();
        }
        return getAll().stream()
                .filter(p -> bookingId.equals(p.getBookingId()))
                .collect(Collectors.toList());
    }

    /** Removes pending payment lines for a booking (e.g. after customer cancellation). */
    public void deletePendingByBookingId(String bookingId) {
        if (bookingId == null) {
            return;
        }
        List<Payment> next = getAll().stream()
                .filter(p -> !(bookingId.equals(p.getBookingId()) && "Pending".equals(p.getStatus())))
                .collect(Collectors.toList());
        saveAll(next);
    }

    /** Removes every payment row for a booking (when the booking record is deleted). */
    public void deleteAllByBookingId(String bookingId) {
        if (bookingId == null) {
            return;
        }
        List<Payment> next = getAll().stream()
                .filter(p -> !bookingId.equals(p.getBookingId()))
                .collect(Collectors.toList());
        saveAll(next);
    }
}
