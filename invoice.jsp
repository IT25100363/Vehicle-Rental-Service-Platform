package com.vehiclerental.payment.controller;

import com.vehiclerental.payment.dao.PaymentDAO;
import com.vehiclerental.payment.model.CardPayment;
import com.vehiclerental.payment.model.CashPayment;
import com.vehiclerental.payment.model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

// ─────────────────────────────────────────────────────────────────────────────
// MVC PATTERN: CONTROLLER
// PaymentServlet is the single entry-point for all payment-related HTTP
// requests. It reads the "action" parameter to decide which operation to
// perform and which view (JSP) to forward to.
//
// URL pattern: /payment
// ─────────────────────────────────────────────────────────────────────────────
@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    // Path to payments.txt, resolved at init-time relative to webapp root
    private String dataFilePath;
    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        // ── FIX: store payments.txt in the USER'S HOME directory, NOT inside the WAR.
        // getRealPath("/WEB-INF/data") points inside the Cargo-extracted WAR, which
        // gets wiped on every redeploy. Using user.home gives us a persistent location.
        String dataDir = System.getProperty("user.home") + File.separator + ".vehiclerental";
        dataFilePath   = dataDir + File.separator + "payments.txt";
        paymentDAO     = new PaymentDAO(dataFilePath);

        // Seed sample data the first time the app starts (only if file is empty)
        try {
            paymentDAO.seedIfEmpty();
        } catch (IOException e) {
            log("Warning: could not seed payments data – " + e.getMessage());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // doGet — handles navigation / display requests
    // ─────────────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            // Show the create payment form
            case "create":
                request.getRequestDispatcher("/WEB-INF/views/payment.jsp")
                       .forward(request, response);
                break;

            // Show invoice for a specific payment
            case "invoice":
                String invoiceId = request.getParameter("paymentId");
                Payment payment  = paymentDAO.getPaymentById(invoiceId);
                if (payment == null) {
                    request.setAttribute("errorMessage", "Payment not found: " + invoiceId);
                    loadHistoryPage(request, response);
                    return;
                }
                // Pass the polymorphic details string to the JSP
                request.setAttribute("payment", payment);
                request.setAttribute("paymentDetails", payment.getPaymentDetails());
                request.getRequestDispatcher("/WEB-INF/views/invoice.jsp")
                       .forward(request, response);
                break;

            // Show payment history (default)
            case "list":
            default:
                loadHistoryPage(request, response);
                break;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // doPost — handles form submissions and data-mutation requests
    // ─────────────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            // ── CREATE ───────────────────────────────────────────────────────
            case "create":
                handleCreate(request, response);
                break;

            // ── UPDATE STATUS ────────────────────────────────────────────────
            case "updateStatus":
                String updateId = request.getParameter("paymentId");
                String newStatus = request.getParameter("newStatus");
                if (updateId != null && newStatus != null) {
                    paymentDAO.updatePaymentStatus(updateId, newStatus);
                }
                response.sendRedirect(request.getContextPath() + "/payment?action=list&success=updated");
                break;

            // ── DELETE ───────────────────────────────────────────────────────
            case "delete":
                String deleteId = request.getParameter("paymentId");
                if (deleteId != null) {
                    paymentDAO.deletePayment(deleteId);
                }
                response.sendRedirect(request.getContextPath() + "/payment?action=list&success=deleted");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/payment?action=list");
                break;
        }
    }

    // ── Handle the payment creation form submission ────────────────────────────
    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String amountStr      = request.getParameter("amount");
        String paymentType    = request.getParameter("paymentType");   // "CASH" or "CARD"
        String cardNumber     = request.getParameter("cardNumber");
        String cardHolderName = request.getParameter("cardHolderName");
        String expiryDate     = request.getParameter("expiryDate");

        // Basic validation
        if (amountStr == null || amountStr.trim().isEmpty() || paymentType == null) {
            request.setAttribute("errorMessage", "Please fill in all required fields.");
            request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
            return;
        }

        double amount;
        try {
            amount = Double.parseDouble(amountStr.trim());
            if (amount <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Amount must be a positive number.");
            request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
            return;
        }

        String paymentId = PaymentDAO.generatePaymentId();
        String date      = LocalDate.now().toString();  // yyyy-MM-dd

        // OOP CONCEPT: POLYMORPHISM — we create the correct subclass at runtime
        Payment newPayment;

        if (CardPayment.TYPE.equals(paymentType)) {
            if (cardNumber == null || cardNumber.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Card number is required for card payments.");
                request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
                return;
            }
            newPayment = new CardPayment(paymentId, amount, date, Payment.STATUS_PENDING,
                    cardNumber.trim(), cardHolderName, expiryDate);
        } else {
            newPayment = new CashPayment(paymentId, amount, date, Payment.STATUS_PENDING);
        }

        paymentDAO.savePayment(newPayment);
        response.sendRedirect(request.getContextPath() + "/payment?action=list&success=created");
    }

    // ── Load all payments and forward to history view ─────────────────────────
    private void loadHistoryPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Payment> payments = paymentDAO.getAllPayments();
        request.setAttribute("payments", payments);
        request.getRequestDispatcher("/WEB-INF/views/payment-history.jsp")
               .forward(request, response);
    }
}

