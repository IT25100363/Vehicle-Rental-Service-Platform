package com.vehiclerental.model;

public class Payment {
    package com.vehiclerental.model;

import java.io.Serializable;

    public class Payment implements Serializable {
        private String id;
        private String bookingId;
        private double amount;
        private String paymentDate;
        private String paymentMethod; // Cash, Card, Online
        private String status; // Pending, Paid

        public Payment() {}

        public Payment(String id, String bookingId, double amount, String paymentDate, String paymentMethod, String status) {
            this.id = id;
            this.bookingId = bookingId;
            this.amount = amount;
            this.paymentDate = paymentDate;
            this.paymentMethod = paymentMethod;
            this.status = status;
        }

        // Getters and Setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        public String getBookingId() { return bookingId; }
        public void setBookingId(String bookingId) { this.bookingId = bookingId; }
        public double getAmount() { return amount; }
        public void setAmount(double amount) { this.amount = amount; }
        public String getPaymentDate() { return paymentDate; }
        public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }
        public String getPaymentMethod() { return paymentMethod; }
        public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        @Override
        public String toString() {
            return id + "," + bookingId + "," + amount + "," + paymentDate + "," + paymentMethod + "," + status;
        }

        public static com.vehiclerental.model.Payment fromString(String line) {
            String[] parts = line.split(",");
            if (parts.length >= 6) {
                return new com.vehiclerental.model.Payment(parts[0], parts[1], Double.parseDouble(parts[2]), parts[3], parts[4], parts[5]);
            }
            return null;
        }
    }

}
