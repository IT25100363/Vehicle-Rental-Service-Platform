<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rental Form</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #0d9488; --bg: #f1f5f9; --glass: rgba(255, 255, 255, 0.94); --glass-border: rgba(15, 23, 42, 0.1); --text: #0f172a; }
        body { background: linear-gradient(165deg, #f0fdfa 0%, #e5f4ff 50%, #fafafa 100%); color: var(--text); font-family: 'Outfit', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .form-container { background: var(--glass); backdrop-filter: blur(16px); padding: 3rem; border-radius: 24px; border: 1px solid var(--glass-border); width: 100%; max-width: 520px; }
        h2 { margin-bottom: 2rem; text-align: center; }
        .form-group { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 0.5rem; font-size: 0.9rem; opacity: 0.8; }
        input, select, textarea { width: 100%; padding: 0.8rem; background: #ffffff; border: 1px solid var(--glass-border); border-radius: 12px; color: var(--text); outline: none; }
        .btn { width: 100%; padding: 1rem; background: var(--primary); color: white; border: none; border-radius: 12px; font-weight: 600; cursor: pointer; }
        .back-link { display: block; text-align: center; margin-top: 1.5rem; color: var(--text); text-decoration: none; opacity: 0.6; }
        .hint { font-size: 0.8rem; opacity: 0.65; margin: -0.4rem 0 0.75rem; line-height: 1.35; }
        .info-box { font-size: 0.85rem; line-height: 1.45; padding: 0.9rem 1rem; border-radius: 12px; border: 1px solid var(--glass-border); background: rgba(13, 148, 136, 0.12); margin-bottom: 1rem; }
        .err { background: rgba(239, 68, 68, 0.15); border-color: rgba(239, 68, 68, 0.35); color: #fecaca; padding: 0.75rem 1rem; border-radius: 12px; margin-bottom: 1rem; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Process Rental/Return</h2>

        <c:if test="${not empty formError}">
            <c:choose>
                <c:when test="${formError == 'duplicate'}">
                    <div class="err">A rental/return record already exists for that booking.</div>
                </c:when>
                <c:when test="${formError == 'notconfirmed'}">
                    <div class="err">Booking must be <strong>Confirmed</strong> before pickup can be recorded.</div>
                </c:when>
                <c:when test="${formError == 'booking'}">
                    <div class="err">Booking ID is invalid or missing.</div>
                </c:when>
                <c:when test="${formError == 'vehicle'}">
                    <div class="err">Vehicle for this booking could not be loaded.</div>
                </c:when>
                <c:when test="${formError == 'rentaldate'}">
                    <div class="err">Rental (pickup) date is required.</div>
                </c:when>
                <c:otherwise>
                    <div class="err">Could not save. Please check the form.</div>
                </c:otherwise>
            </c:choose>
        </c:if>

        <c:if test="${not empty prefillBooking}">
            <div class="info-box">
                <strong>Booking</strong> ${prefillBooking.id}<br/>
                Scheduled: <strong>${prefillBooking.startDate}</strong> → <strong>${prefillBooking.endDate}</strong><br/>
                Status: <strong>${prefillBooking.status}</strong>
                <c:if test="${not empty vehicleForLate}">
                    <br/>Daily rate: <strong>LKR ${vehicleForLate.rentalPricePerDay}</strong>/day
                </c:if>
            </div>
        </c:if>

        <c:if test="${rental != null && not empty computedLateFee}">
            <p class="hint">With the current return date, late fee included in total ≈ <strong>LKR ${computedLateFee}</strong> (days after scheduled end × daily rate) plus other charges below.</p>
        </c:if>

        <form action="rentals" method="post">
            <c:if test="${rental != null}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${rental.id}">
            </c:if>

            <div class="form-group"><label>Booking ID</label><input type="text" name="bookingId" value="${not empty rental ? rental.bookingId : prefillBooking.id}" required></div>
            <div class="form-group">
                <label>Rental date (pickup)</label>
                <input type="date" name="rentalDate" value="${rental.rentalDate}" required>
            </div>
            <div class="form-group">
                <label>Return date (actual)</label>
                <input type="date" name="returnDate" value="${rental.returnDate}">
                <p class="hint">Leave empty until the vehicle is returned. Late fees are computed from the scheduled end date when this is set.</p>
            </div>
            <div class="form-group"><label>Vehicle condition</label><input type="text" name="conditionOnReturn" value="${rental.conditionOnReturn}" placeholder="e.g. Good, minor scratch"></div>
            <div class="form-group">
                <label>Other charges (LKR)</label>
                <c:choose>
                    <c:when test="${rental == null}">
                        <input type="number" step="0.01" min="0" name="manualCharges" value="" placeholder="0.00">
                    </c:when>
                    <c:otherwise>
                        <input type="number" step="0.01" min="0" name="manualCharges" value="${manualChargesPrefill}" placeholder="0.00">
                    </c:otherwise>
                </c:choose>
                <p class="hint">Damage, fuel, cleaning, etc. Late return fees are added automatically from the booking end date and vehicle daily rate.</p>
            </div>

            <button type="submit" class="btn">${rental != null ? 'Update Record' : 'Save Record'}</button>
        </form>
        <a href="rentals" class="back-link">Cancel</a>
    </div>
</body>
</html>
