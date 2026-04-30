package model;

public class Vehicle {
    private int id;
    private String brand;
    private String vehicleType;
    private String model;
    private String plateNumber;
    private String fuelType;

    public Vehicle() {
    }

    public Vehicle(int id, String brand, String vehicleType, String model, String plateNumber, String fuelType) {
        this.id = id;
        this.brand = brand;
        this.vehicleType = vehicleType;
        this.model = model;
        this.plateNumber = plateNumber;
        this.fuelType = fuelType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }


    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }


    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }


    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }


    public String getFuelType() {
        return fuelType;
    }

    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }

    public String toFileString() {
        return id + "," + brand + "," + vehicleType + "," + model + "," + plateNumber + "," + fuelType;
    }

    public static Vehicle fromFileString(String line) {
        String[] data = line.split(",");
        return new Vehicle(
                Integer.parseInt(data[0]),
                data[1],
                data[2],
                data[3],
                data[4],
                data[5]
        );
    }
}
