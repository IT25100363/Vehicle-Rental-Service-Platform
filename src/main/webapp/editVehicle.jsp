<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Vehicle" %>

<html>
<head>
    <title>Edit Vehicle</title>
</head>
<body>

<h2>Edit Vehicle</h2>

<%
    Vehicle v = (Vehicle) request.getAttribute("vehicle");
%>

<form action="${pageContext.request.contextPath}/vehicles" method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="<%= v.getId() %>">

    Brand: <input type="text" name="brand" value="<%= v.getBrand() %>" required><br><br>
    Type: <input type="text" name="vehicleType" value="<%= v.getVehicleType() %>" required><br><br>
    Model: <input type="text" name="model" value="<%= v.getModel() %>" required><br><br>
    Plate Number: <input type="text" name="plateNumber" value="<%= v.getPlateNumber() %>" required><br><br>
    Fuel Type: <input type="text" name="fuelType" value="<%= v.getFuelType() %>" required><br><br>

    <button type="submit">Update Vehicle</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/vehicles">Back to List</a>

</body>
</html>