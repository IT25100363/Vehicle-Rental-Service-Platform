<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Form</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #0d9488; --bg: #f1f5f9; --glass: rgba(255, 255, 255, 0.94); --glass-border: rgba(15, 23, 42, 0.1); --text: #0f172a; }
        body { background: linear-gradient(165deg, #f0fdfa 0%, #e5f4ff 50%, #fafafa 100%); color: var(--text); font-family: 'Outfit', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .form-container { background: var(--glass); backdrop-filter: blur(16px); padding: 3rem; border-radius: 24px; border: 1px solid var(--glass-border); width: 100%; max-width: 500px; }
        h2 { margin-bottom: 2rem; text-align: center; }
        .form-group { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 0.5rem; font-size: 0.9rem; opacity: 0.8; }
        input, select { width: 100%; padding: 0.8rem; background: #ffffff; border: 1px solid var(--glass-border); border-radius: 12px; color: var(--text); outline: none; }
        .btn { width: 100%; padding: 1rem; background: var(--primary); color: white; border: none; border-radius: 12px; font-weight: 600; cursor: pointer; }
        .back-link { display: block; text-align: center; margin-top: 1.5rem; color: var(--text); text-decoration: none; opacity: 0.6; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>${payment != null ? 'Edit Payment' : 'Add Payment'}</h2>
        <form action="payments" method="post">
            <c:if test="${payment != null}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${payment.id}">
            </c:if>

            <div class="form-group"><label>Booking ID</label><input type="text" name="bookingId" value="${payment.bookingId}" required></div>
            <div class="form-group"><label>Amount</label><input type="number" step="0.01" name="amount" value="${payment.amount}" required></div>
            <div class="form-group"><label>Date</label><input type="date" name="paymentDate" value="${payment.paymentDate}" required></div>
            <div class="form-group">
                <label>Method</label>
                <select name="paymentMethod">
                    <option value="Cash" ${payment.paymentMethod == 'Cash' ? 'selected' : ''}>Cash</option>
                    <option value="Card" ${payment.paymentMethod == 'Card' ? 'selected' : ''}>Card</option>
                    <option value="Online" ${payment.paymentMethod == 'Online' ? 'selected' : ''}>Online</option>
                </select>
            </div>
            <div class="form-group">
                <label>Status</label>
                <select name="status">
                    <option value="Pending" ${payment.status == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Paid" ${payment.status == 'Paid' ? 'selected' : ''}>Paid</option>
                </select>
            </div>
            <button type="submit" class="btn">${payment != null ? 'Update Payment' : 'Save Payment'}</button>
        </form>
        <a href="payments" class="back-link">Cancel</a>
    </div>
</body>
</html>
