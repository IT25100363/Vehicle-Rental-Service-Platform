package com.vehiclerental.dao;

import com.vehiclerental.model.RentalReturn;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class RentalReturnDAO extends GenericDAO<RentalReturn> {
    public RentalReturnDAO(String dbPath) {
        super(dbPath + "/rentalreturns.txt", RentalReturn::fromString);
    }
    public RentalReturn getById(String id) { return super.getById(id, RentalReturn::getId); }
    public void update(RentalReturn rr) { super.update(rr, RentalReturn::getId); }
    public void delete(String id) { super.delete(id, RentalReturn::getId); }

    public Optional<RentalReturn> findByBookingId(String bookingId) {
        if (bookingId == null) {
            return Optional.empty();
        }
        return getAll().stream()
                .filter(r -> bookingId.equals(r.getBookingId()))
                .findFirst();
    }

    public void deleteByBookingId(String bookingId) {
        if (bookingId == null) {
            return;
        }
        List<RentalReturn> next = getAll().stream()
                .filter(r -> !bookingId.equals(r.getBookingId()))
                .collect(Collectors.toList());
        saveAll(next);
    }
}
