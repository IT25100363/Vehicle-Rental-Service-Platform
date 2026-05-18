package com.vehiclerental.model;

import java.io.Serializable;

public class Vehicle implements Serializable {
    private String id;
    private String brand;
    private String model;
    private String plateNumber;
    private double rentalPricePerDay;
    private String status; // Available, Rented, Maintenance
    private String imageUrl;

    public Vehicle() {}

    public Vehicle(String id, String brand, String model, String plateNumber, double rentalPricePerDay, String status) {
        this(id, brand, model, plateNumber, rentalPricePerDay, status, "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=600&q=80"); // default image
    }

    public Vehicle(String id, String brand, String model, String plateNumber, double rentalPricePerDay, String status, String imageUrl) {
        this.id = id;
        this.brand = brand;
        this.model = model;
        this.plateNumber = plateNumber;
        this.rentalPricePerDay = rentalPricePerDay;
        this.status = status;
        this.imageUrl = imageUrl != null && !imageUrl.trim().isEmpty() ? imageUrl : "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=600&q=80";
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    public String getPlateNumber() { return plateNumber; }
    public void setPlateNumber(String plateNumber) { this.plateNumber = plateNumber; }
    public double getRentalPricePerDay() { return rentalPricePerDay; }
    public void setRentalPricePerDay(double rentalPricePerDay) { this.rentalPricePerDay = rentalPricePerDay; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    @Override
    public String toString() {
        return id + "," + brand + "," + model + "," + plateNumber + "," + rentalPricePerDay + "," + status + "," + imageUrl;
    }

    public static Vehicle fromString(String line) {
        String[] parts = line.split(",", -1);
        if (parts.length >= 6) {
            String imgUrl = parts.length >= 7 ? parts[6] : "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=600&q=80";
            return new Vehicle(parts[0], parts[1], parts[2], parts[3], Double.parseDouble(parts[4]), parts[5], imgUrl);
        }
        return null;
    }
}

