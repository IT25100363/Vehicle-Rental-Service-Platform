<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.vehiclerental.dao.VehicleDAO" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // Fallback: Populate vehicleNames map if the Java Servlet hasn't been recompiled yet
    if (request.getAttribute("vehicleNames") == null) {
        String dbPath = application.getRealPath("/db");
        VehicleDAO vDao = new VehicleDAO(dbPath);
        Map<String, String> names = new HashMap<>();
        for(Vehicle v : vDao.getAll()) {
            names.put(v.getId().trim(), "<strong>" + v.getModel() + "</strong><br><span style='font-size:0.8rem; opacity:0.75;'>" + v.getBrand() + "</span>");
        }
        request.setAttribute("vehicleNames", names);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Management</title>
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
        .actions { display: flex; gap: 1rem; }
        .actions a { color: var(--text); text-decoration: none; opacity: 0.7; transition: 0.3s; }
        .actions img { width: 26px; height: 26px; object-fit: contain; }
    </style>
</head>
<body>
    <div class="header">
        <h1><i class="fas fa-calendar-check"></i> Booking Management</h1>
        <div>
            <a href="index.jsp" class="btn btn-back"><i class="fas fa-arrow-left"></i> Dashboard</a>
            <a href="bookings?action=new" class="btn btn-primary"><i class="fas fa-plus"></i> New Booking</a>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>User ID</th>
                <th>Vehicle Name</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="b" items="${listBooking}">
                <tr>
                    <td><code style="font-size:0.8rem;">${b.id}</code></td>
                    <td>${b.userId}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty vehicleNames[b.vehicleId]}">
                                ${vehicleNames[b.vehicleId]}
                            </c:when>
                            <c:otherwise>
                                <strong><c:out value="${b.vehicleId}" /></strong>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${b.startDate}</td>
                    <td>${b.endDate}</td>
                    <td>${b.status}</td>
                    <td class="actions">
                        <a href="payments?action=new&bookingId=${b.id}" title="Customer Payment">
                            <img src="images/money.png" alt="Payment">
                        </a>
                        <c:if test="${b.status == 'Confirmed'}">
                            <a href="rentals?action=new&bookingId=${b.id}" title="Record pickup / rental"><i class="fas fa-key"></i></a>
                        </c:if>
                        <a href="bookings?action=edit&id=${b.id}"><i class="fas fa-edit"></i></a>
                        <a href="bookings?action=delete&id=${b.id}" onclick="return confirm('Delete booking?')"><i class="fas fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>