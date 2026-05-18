<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.vehiclerental.dao.BookingDAO" %>
<%@ page import="com.vehiclerental.model.Booking" %>
<%@ page import="com.vehiclerental.dao.VehicleDAO" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.dao.UserDAO" %>
<%@ page import="com.vehiclerental.model.User" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    String dbPath = application.getRealPath("/db");

    Map<String, String> bookingVehicleNames = new HashMap<>();
    Map<String, String> bookingUserNames = new HashMap<>();

    BookingDAO bDao = new BookingDAO(dbPath);
    VehicleDAO vDao = new VehicleDAO(dbPath);
    UserDAO uDao = new UserDAO(dbPath);

    Map<String, Vehicle> vehicleMap = new HashMap<>();
    for(Vehicle v : vDao.getAll()) vehicleMap.put(v.getId().trim(), v);

    Map<String, User> userMap = new HashMap<>();
    for(User u : uDao.getAll()) userMap.put(u.getId().trim(), u);

    for(Booking b : bDao.getAll()) {
        String bId = b.getId().trim();
        Vehicle v = vehicleMap.get(b.getVehicleId().trim());
        if(v != null) {
            bookingVehicleNames.put(bId, "<strong>" + v.getModel() + "</strong><br><span style='font-size:0.8rem; opacity:0.75;'>" + v.getBrand() + "</span>");
        }
        User u = userMap.get(b.getUserId().trim());
        if(u != null) {
            bookingUserNames.put(bId, u.getName());
        }
    }
    request.setAttribute("bookingVehicleNames", bookingVehicleNames);
    request.setAttribute("bookingUserNames", bookingUserNames);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #0d9488; --bg: #f1f5f9; --glass: rgba(255, 255, 255, 0.94); --glass-border: rgba(15, 23, 42, 0.1); --text: #0f172a; }
        body { background: linear-gradient(165deg, #f0fdfa 0%, #e5f4ff 50%, #fafafa 100%); color: var(--text); font-family: 'Outfit', sans-serif; padding: 2rem; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .btn { padding: 0.8rem 1.5rem; border-radius: 12px; text-decoration: none; font-weight: 600; transition: 0.3s; cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 0.5rem; }
        .btn-primary { background: var(--primary); color: white; }
        .btn-back { background: var(--glass); color: var(--text); border: 1px solid var(--glass-border); }
        table { width: 100%; border-collapse: collapse; background: var(--glass); backdrop-filter: blur(10px); border-radius: 16px; overflow: hidden; border: 1px solid var(--glass-border); }
        th, td { padding: 1.2rem; text-align: left; border-bottom: 1px solid var(--glass-border); }
        th { background: rgba(255, 255, 255, 0.1); font-weight: 600; }
        .actions { display: flex; gap: 1rem; align-items: center; }
        .actions a { color: var(--text); text-decoration: none; opacity: 0.7; transition: 0.3s; }
        .actions a:hover { opacity: 1; }
    </style>
</head>
<body>
    <div class="header">
        <h1><i class="fas fa-credit-card"></i> Payment Management</h1>
        <div>
            <a href="index.jsp" class="btn btn-back"><i class="fas fa-arrow-left"></i> Dashboard</a>
            <a href="payments?action=new" class="btn btn-primary"><i class="fas fa-plus"></i> Add Payment</a>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Username</th>
                <th>Vehicle</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Method</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${listPayment}">
                <tr>
                    <td><code style="font-size:0.8rem;">${p.bookingId}</code></td>
                    <td>${bookingUserNames[p.bookingId]}</td>
                    <td>${bookingVehicleNames[p.bookingId]}</td>
                    <td>LKR ${p.amount}</td>
                    <td>${p.paymentDate}</td>
                    <td>${p.paymentMethod}</td>
                    <td>${p.status}</td>
                    <td class="actions">
                        <a href="payments?action=edit&id=${p.id}" title="Edit"><i class="fas fa-edit"></i></a>
                        <a href="payments?action=delete&id=${p.id}" title="Delete" onclick="return confirm('Delete record?')"><i class="fas fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
