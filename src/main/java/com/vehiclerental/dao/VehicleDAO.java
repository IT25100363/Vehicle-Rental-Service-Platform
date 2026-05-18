package com.vehiclerental.dao;

import com.vehiclerental.model.Vehicle;

public class VehicleDAO extends GenericDAO<Vehicle> {
    public VehicleDAO(String dbPath) {
        super(dbPath + "/vehicles.txt", Vehicle::fromString);
    }
    public Vehicle getById(String id) { return super.getById(id, Vehicle::getId); }
    public void update(Vehicle vehicle) { super.update(vehicle, Vehicle::getId); }
    public void delete(String id) { super.delete(id, Vehicle::getId); }
}
