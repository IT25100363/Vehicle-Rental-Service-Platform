package com.vehiclerental.model;

import java.io.Serializable;

public class RentalReturn implements Serializable {
    private String id;
    private String bookingId;
    private String rentalDate;
    private String returnDate;
    private String conditionOnReturn;
    private double additionalCharges;

    public RentalReturn() {}

    public RentalReturn(String id, String bookingId, String rentalDate, String returnDate, String conditionOnReturn, double additionalCharges) {
        this.id = id;
        this.bookingId = bookingId;
        this.rentalDate = rentalDate;
        this.returnDate = returnDate;
        this.conditionOnReturn = conditionOnReturn;
        this.additionalCharges = additionalCharges;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }
    public String getRentalDate() { return rentalDate; }
    public void setRentalDate(String rentalDate) { this.rentalDate = rentalDate; }
    public String getReturnDate() { return returnDate; }
    public void setReturnDate(String returnDate) { this.returnDate = returnDate; }
    public String getConditionOnReturn() { return conditionOnReturn; }
    public void setConditionOnReturn(String conditionOnReturn) { this.conditionOnReturn = conditionOnReturn; }
    public double getAdditionalCharges() { return additionalCharges; }
    public void setAdditionalCharges(double additionalCharges) { this.additionalCharges = additionalCharges; }

    @Override
    public String toString() {
        return id + "," + bookingId + "," + rentalDate + "," + returnDate + "," + conditionOnReturn + "," + additionalCharges;
    }

    public static RentalReturn fromString(String line) {
        String[] parts = line.split(",");
        if (parts.length >= 6) {
            return new RentalReturn(parts[0], parts[1], parts[2], parts[3], parts[4], Double.parseDouble(parts[5]));
        }
        return null;
    }
}
