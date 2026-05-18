package com.vehiclerental.model;

import java.io.Serializable;

public class Booking implements Serializable {
    private String id;
    private String userId;
    private String vehicleId;
    private String startDate;
    private String endDate;
    private String status; // Pending, Confirmed, Active (picked up), Completed (returned), Cancelled

    public Booking() {}

    public Booking(String id, String userId, String vehicleId, String startDate, String endDate, String status) {
        this.id = id;
        this.userId = userId;
        this.vehicleId = vehicleId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getVehicleId() { return vehicleId; }
    public void setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return id + "," + userId + "," + vehicleId + "," + startDate + "," + endDate + "," + status;
    }

    public static Booking fromString(String line) {
        String[] parts = line.split(",");
        if (parts.length >= 6) {
            return new Booking(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);
        }
        return null;
    }
}