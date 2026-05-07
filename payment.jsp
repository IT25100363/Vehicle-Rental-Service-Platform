package com.vehiclerental.payment.dao;

import com.vehiclerental.payment.model.CardPayment;
import com.vehiclerental.payment.model.CashPayment;
import com.vehiclerental.payment.model.Payment;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

// ─────────────────────────────────────────────────────────────────────────────
// DATA ACCESS OBJECT (DAO) PATTERN
// File format (pipe-delimited):
//   paymentId|type|amount|paymentDate|status|cardNumber|cardHolderName|expiryDate
//
// CASH payments: cardNumber=N/A, cardHolderName=N/A, expiryDate=N/A
// Backward compatible: old 6-field records default missing fields to "N/A"
// ─────────────────────────────────────────────────────────────────────────────
public class PaymentDAO {

    private final String filePath;
    private static final String DELIMITER       = "\\|";  // regex for split
    private static final String DELIMITER_WRITE = "|";

    public PaymentDAO(String filePath) {
        this.filePath = filePath;
        ensureFileExists();
    }

    private void ensureFileExists() {
        File file = new File(filePath);
        File parentDir = file.getParentFile();
        if (parentDir != null && !parentDir.exists()) parentDir.mkdirs();
        if (!file.exists()) {
            try { file.createNewFile(); }
            catch (IOException e) { throw new RuntimeException("Could not create payments.txt at: " + filePath, e); }
        }
    }

    // ── Serialise ─────────────────────────────────────────────────────────────
    private String serialise(Payment payment) {
        String type           = (payment instanceof CardPayment) ? CardPayment.TYPE : CashPayment.TYPE;
        String cardNumber     = "N/A";
        String cardHolderName = "N/A";
        String expiryDate     = "N/A";

        if (payment instanceof CardPayment cp) {
            cardNumber     = cp.getCardNumber()     != null ? cp.getCardNumber()     : "N/A";
            cardHolderName = cp.getCardHolderName() != null ? cp.getCardHolderName() : "N/A";
            expiryDate     = cp.getExpiryDate()     != null ? cp.getExpiryDate()     : "N/A";
        }

        return String.join(DELIMITER_WRITE,
                payment.getPaymentId(),
                type,
                String.valueOf(payment.getAmount()),
                payment.getPaymentDate(),
                payment.getStatus(),
                cardNumber,
                cardHolderName,
                expiryDate
        );
    }

    // ── Deserialise — backward compatible with 6-field old records ────────────
    private Payment deserialise(String line) {
        if (line == null || line.trim().isEmpty()) return null;

        String[] parts = line.split(DELIMITER, -1);
        if (parts.length < 6) return null;

        String paymentId       = parts[0].trim();
        String type            = parts[1].trim();
        double amount          = Double.parseDouble(parts[2].trim());
        String paymentDate     = parts[3].trim();
        String status          = parts[4].trim();
        String cardNumber      = parts[5].trim();
        String cardHolderName  = parts.length > 6 ? parts[6].trim() : "N/A";
        String expiryDate      = parts.length > 7 ? parts[7].trim() : "N/A";

        if (CardPayment.TYPE.equals(type)) {
            CardPayment cp = new CardPayment();
            cp.setPaymentId(paymentId);
            cp.setAmount(amount);
            cp.setPaymentDate(paymentDate);
            cp.setStatus(status);
            cp.setCardNumber(cardNumber);       // already masked — maskCard is idempotent
            cp.setCardHolderName(cardHolderName);
            cp.setExpiryDate(expiryDate);
            return cp;
        } else {
            return new CashPayment(paymentId, amount, paymentDate, status);
        }
    }

    // ── CREATE ────────────────────────────────────────────────────────────────
    public void savePayment(Payment payment) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(filePath, true), StandardCharsets.UTF_8))) {
            writer.write(serialise(payment));
            writer.newLine();
        }
    }

    // ── READ ALL ──────────────────────────────────────────────────────────────
    public List<Payment> getAllPayments() throws IOException {
        List<Payment> payments = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists() || file.length() == 0) return payments;

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(new FileInputStream(filePath), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                Payment p = deserialise(line);
                if (p != null) payments.add(p);
            }
        }
        return payments;
    }

    // ── READ ONE ──────────────────────────────────────────────────────────────
    public Payment getPaymentById(String paymentId) throws IOException {
        for (Payment p : getAllPayments()) {
            if (p.getPaymentId().equals(paymentId)) return p;
        }
        return null;
    }

    // ── UPDATE ────────────────────────────────────────────────────────────────
    public boolean updatePaymentStatus(String paymentId, String newStatus) throws IOException {
        List<Payment> all = getAllPayments();
        boolean updated = false;
        for (Payment p : all) {
            if (p.getPaymentId().equals(paymentId)) {
                p.setStatus(newStatus);
                updated = true;
                break;
            }
        }
        if (updated) rewriteFile(all);
        return updated;
    }

    // ── DELETE ────────────────────────────────────────────────────────────────
    public boolean deletePayment(String paymentId) throws IOException {
        List<Payment> all = getAllPayments();
        boolean removed = all.removeIf(p -> p.getPaymentId().equals(paymentId));
        if (removed) rewriteFile(all);
        return removed;
    }

    private void rewriteFile(List<Payment> payments) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(filePath, false), StandardCharsets.UTF_8))) {
            for (Payment p : payments) {
                writer.write(serialise(p));
                writer.newLine();
            }
        }
    }

    public static String generatePaymentId() {
        return "PAY-" + System.currentTimeMillis();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // SEED — Populate the file with realistic sample data if it is empty.
    // Called once on servlet startup so the app has data to display immediately.
    // ─────────────────────────────────────────────────────────────────────────
    public void seedIfEmpty() throws IOException {
        File f = new File(filePath);
        if (f.exists() && f.length() > 0) return;   // already has data — skip

        List<Payment> seeds = new java.util.ArrayList<>();

        // ── Card payments ──────────────────────────────────────────────────
        CardPayment c1 = new CardPayment(
                "PAY-1000000001", 12500.00, "2026-04-10", Payment.STATUS_COMPLETED,
                "4111111111111111", "AMAL PERERA", "08/28");
        seeds.add(c1);

        CardPayment c2 = new CardPayment(
                "PAY-1000000002", 8750.50, "2026-04-15", Payment.STATUS_COMPLETED,
                "5500005555555559", "NIMAL SILVA", "11/27");
        seeds.add(c2);

        CardPayment c3 = new CardPayment(
                "PAY-1000000003", 22000.00, "2026-04-22", Payment.STATUS_PENDING,
                "4012888888881881", "KASUN JAYAWARDENA", "03/29");
        seeds.add(c3);

        CardPayment c4 = new CardPayment(
                "PAY-1000000004", 5200.75, "2026-04-28", Payment.STATUS_FAILED,
                "4111111111111111", "DILANI FERNANDO", "06/26");
        seeds.add(c4);

        CardPayment c5 = new CardPayment(
                "PAY-1000000005", 31500.00, "2026-05-01", Payment.STATUS_PENDING,
                "5105105105105100", "RUWAN BANDARA", "09/28");
        seeds.add(c5);

        // ── Cash payments ──────────────────────────────────────────────────
        seeds.add(new CashPayment("PAY-1000000006", 6000.00,  "2026-04-05",  Payment.STATUS_COMPLETED));
        seeds.add(new CashPayment("PAY-1000000007", 14800.00, "2026-04-18",  Payment.STATUS_COMPLETED));
        seeds.add(new CashPayment("PAY-1000000008", 9250.00,  "2026-04-29",  Payment.STATUS_PENDING));

        rewriteFile(seeds);
    }
}
