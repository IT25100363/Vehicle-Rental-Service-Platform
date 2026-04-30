package service;

import model.Vehicle;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleService {

    private static final String FILE_PATH =
            System.getProperty("user.home") + File.separator + "vehicles.txt";

    public VehicleService() {
        createFileIfNotExists();
    }

    private void createFileIfNotExists() {
        try {
            File file = new File(FILE_PATH);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // CREATE
    public void addVehicle(Vehicle vehicle) {
        vehicle.setId(generateNewId());

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(vehicle.toFileString());
            writer.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // READ ALL
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;

            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    vehicles.add(Vehicle.fromFileString(line));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    // READ BY ID
    public Vehicle getVehicleById(int id) {
        List<Vehicle> vehicles = getAllVehicles();

        for (Vehicle vehicle : vehicles) {
            if (vehicle.getId() == id) {
                return vehicle;
            }
        }

        return null;
    }

    // UPDATE
    public void updateVehicle(Vehicle updatedVehicle) {
        List<Vehicle> vehicles = getAllVehicles();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Vehicle vehicle : vehicles) {
                if (vehicle.getId() == updatedVehicle.getId()) {
                    writer.write(updatedVehicle.toFileString());
                } else {
                    writer.write(vehicle.toFileString());
                }
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // DELETE
    public void deleteVehicle(int id) {
        List<Vehicle> vehicles = getAllVehicles();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Vehicle vehicle : vehicles) {
                if (vehicle.getId() != id) {
                    writer.write(vehicle.toFileString());
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private int generateNewId() {
        List<Vehicle> vehicles = getAllVehicles();
        int maxId = 0;

        for (Vehicle vehicle : vehicles) {
            if (vehicle.getId() > maxId) {
                maxId = vehicle.getId();
            }
        }

        return maxId + 1;
    }
}

