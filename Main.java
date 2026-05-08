package vehicle_Rental;

package com.rental;

import com.rental.model.Booking;
import com.rental.service.BookingService;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        Scanner input = new Scanner(System.in);

        BookingService service = new BookingService();

        while (true) {

            System.out.println("\n===== BOOKING MANAGEMENT =====");
            System.out.println("1. Add Booking");
            System.out.println("2. View Bookings");
            System.out.println("3. Update Booking");
            System.out.println("4. Delete Booking");
            System.out.println("5. Exit");

            System.out.print("Choose: ");
            int choice = input.nextInt();
            input.nextLine();

            switch (choice) {

                case 1:

                    System.out.print("Booking ID: ");
                    String id = input.nextLine();

                    System.out.print("Customer Name: ");
                    String customer = input.nextLine();

                    System.out.print("Vehicle Type: ");
                    String type = input.nextLine();

                    System.out.print("Vehicle Name: ");
                    String vehicle = input.nextLine();

                    System.out.print("Start Date: ");
                    String start = input.nextLine();

                    System.out.print("End Date: ");
                    String end = input.nextLine();

                    System.out.print("Status: ");
                    String status = input.nextLine();

                    Booking booking = new Booking(
                            id, customer, type,
                            vehicle, start, end, status
                    );

                    service.addBooking(booking);
                    break;

                case 2:
                    service.viewBookings();
                    break;

                case 3:

                    System.out.print("Enter Booking ID: ");
                    String updateId = input.nextLine();

                    System.out.print("New Status: ");
                    String newStatus = input.nextLine();

                    service.updateBooking(updateId, newStatus);
                    break;

                case 4:

                    System.out.print("Enter Booking ID: ");
                    String deleteId = input.nextLine();

                    service.deleteBooking(deleteId);
                    break;

                case 5:
                    System.exit(0);

                default:
                    System.out.println("Invalid Choice");
            }
        }
    }
}