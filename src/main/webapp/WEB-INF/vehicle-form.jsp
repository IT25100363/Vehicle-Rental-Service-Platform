<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Vehicle Form</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #0d9488; --bg: #f1f5f9; --glass: rgba(255, 255, 255, 0.94); --glass-border: rgba(15, 23, 42, 0.1); --text: #0f172a; }
        body { background: linear-gradient(165deg, #f0fdfa 0%, #e5f4ff 50%, #fafafa 100%); color: var(--text); font-family: 'Outfit', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .form-container { background: var(--glass); backdrop-filter: blur(16px); padding: 3rem; border-radius: 24px; border: 1px solid var(--glass-border); width: 100%; max-width: 500px; }
        h2 { margin-bottom: 2rem; text-align: center; }
        .form-group { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 0.5rem; font-size: 0.9rem; opacity: 0.8; }
        input, select { width: 100%; padding: 0.8rem; background: #ffffff; border: 1px solid var(--glass-border); border-radius: 12px; color: var(--text); outline: none; transition: 0.3s; }
        .btn { width: 100%; padding: 1rem; background: var(--primary); color: white; border: none; border-radius: 12px; font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 1rem; }
        .back-link { display: block; text-align: center; margin-top: 1.5rem; color: var(--text); text-decoration: none; opacity: 0.6; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>${vehicle != null ? 'Edit Vehicle' : 'Add New Vehicle'}</h2>
        <form action="vehicles" method="post">
            <c:if test="${vehicle != null}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${vehicle.id}">
            </c:if>

            <div class="form-group"><label>Brand</label><input type="text" name="brand" value="${vehicle.brand}" required></div>
            <div class="form-group"><label>Model</label><input type="text" name="model" value="${vehicle.model}" required></div>
            <div class="form-group"><label>Plate Number</label><input type="text" name="plateNumber" value="${vehicle.plateNumber}" required></div>
            <div class="form-group"><label>Rental Price / Day</label><input type="number" step="0.01" name="rentalPricePerDay" value="${vehicle.rentalPricePerDay}" required></div>
            <div class="form-group">
                <label>Status</label>
                <select name="status">
                    <option value="Available" ${vehicle.status == 'Available' ? 'selected' : ''}>Available</option>
                    <option value="Rented" ${vehicle.status == 'Rented' ? 'selected' : ''}>Rented</option>
                    <option value="Maintenance" ${vehicle.status == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                </select>
            </div>
            <div class="form-group"><label>Image URL (Optional)</label><input type="text" name="imageUrl" value="${vehicle.imageUrl}" placeholder="Leave blank for default"></div>
            <button type="submit" class="btn">${vehicle != null ? 'Update Vehicle' : 'Create Vehicle'}</button>
        </form>
        <a href="vehicles" class="back-link">Cancel</a>
    </div>
</body>
</html>
