<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Vehicle" %>

<html>
<head>
    <title>Vehicle List</title>
</head>
<body>

<h2>Vehicle List</h2>

<a href="${pageContext.request.contextPath}/vehicles?action=new">Add New Vehicle</a>
<br><br>

<table border="1" cellpadding="10">
    <tr>
        <th>ID</th>
        <th>Brand</th>
        <th>Type</th>
        <th>Model</th>
        <th>Plate</th>
        <th>Fuel</th>
        <th>Actions</th>
    </tr>

<%
    List<Vehicle> list = (List<Vehicle>) request.getAttribute("vehicleList");

    if (list != null) {
        for (Vehicle v : list) {
%>
    <tr>
        <td><%= v.getId() %></td>
        <td><%= v.getBrand() %></td>
        <td><%= v.getVehicleType() %></td>
        <td><%= v.getModel() %></td>
        <td><%= v.getPlateNumber() %></td>
        <td><%= v.getFuelType() %></td>
        <td>
            <a href="${pageContext.request.contextPath}/vehicles?action=edit&id=<%= v.getId() %>">Edit</a> |
            <a href="${pageContext.request.contextPath}/vehicles?action=delete&id=<%= v.getId() %>"
               onclick="return confirm('Are you sure?')">Delete</a>
        </td>
    </tr>
<%
        }
    }
%>

</table>

</body>
</html>