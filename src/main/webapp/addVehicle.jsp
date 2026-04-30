<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Add Vehicle</title>
</head>
<body>

<h2>Add Vehicle</h2>

<form action="${pageContext.request.contextPath}/vehicles" method="post">
    <input type="hidden" name="action" value="insert">

    Brand: <input type="text" name="brand" required><br><br>
    Type: <input type="text" name="vehicleType" required><br><br>
    Model: <input type="text" name="model" required><br><br>
    Plate Number: <input type="text" name="plateNumber" required><br><br>
    Fuel Type: <input type="text" name="fuelType" required><br><br>

    <button type="submit">Add Vehicle</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/vehicles">Back to List</a>

</body>
</html>