package com.vehiclerental.dao;

import com.vehiclerental.model.Booking;

import java.util.List;
import java.util.stream.Collectors;

public class BookingDAO extends GenericDAO<Booking> {
    public BookingDAO(String dbPath) {
        super(dbPath + "/bookings.txt", Booking::fromString);
    }
    public Booking getById(String id) { return super.getById(id, Booking::getId); }
    public void update(Booking booking) { super.update(booking, Booking::getId); }
    public void delete(String id) { super.delete(id, Booking::getId); }

    public List<Booking> findByUserId(String userId) {
        if (userId == null) return List.of();
        return getAll().stream()
                .filter(b -> userId.equals(b.getUserId()))
                .collect(Collectors.toList());
    }
}