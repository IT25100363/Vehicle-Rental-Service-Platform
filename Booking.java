package vehicle_Rental;

public class Booking {

    private int bookingId;
    private String customerName;
    private String vehicleType;
    private String startDate;
    private String endDate;
    private String status;
    private String bookingType;

    public Booking(int bookingId, String customerName, String vehicleType,
                   String startDate, String endDate,
                   String status, String bookingType) {

        this.bookingId = bookingId;
        this.customerName = customerName;
        this.vehicleType = vehicleType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.bookingType = bookingType;
    }

    public int getBookingId() {
        return bookingId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public String getStartDate() {
        return startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public String getStatus() {
        return status;
    }

    public String getBookingType() {
        return bookingType;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    @Override
    public String toString() {
        return bookingId + "," + customerName + "," + vehicleType + ","
                + startDate + "," + endDate + ","
                + status + "," + bookingType;
    }
}