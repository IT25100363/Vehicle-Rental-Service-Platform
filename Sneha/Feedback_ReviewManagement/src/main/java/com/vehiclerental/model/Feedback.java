package com.vehiclerental.model;

import java.io.Serializable;

public class Feedback implements Serializable {
    private String id;
    private String userId;
    private String vehicleId;
    private int rating; // 1 to 5
    private String comments;
    private String date;

    public Feedback() {}

    public Feedback(String id, String userId, String vehicleId, int rating, String comments, String date) {
        this.id = id;
        this.userId = userId;
        this.vehicleId = vehicleId;
        this.rating = rating;
        this.comments = comments;
        this.date = date;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getVehicleId() { return vehicleId; }
    public void setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    @Override
    public String toString() {
        return id + "," + userId + "," + vehicleId + "," + rating + "," + comments + "," + date;
    }

    public static Feedback fromString(String line) {
        String[] parts = line.split(",");
        if (parts.length >= 6) {
            return new Feedback(parts[0], parts[1], parts[2], Integer.parseInt(parts[3]), parts[4], parts[5]);
        }
        return null;
    }
}

