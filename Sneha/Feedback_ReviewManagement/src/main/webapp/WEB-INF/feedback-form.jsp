<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Feedback Form</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #0d9488; --bg: #f1f5f9; --glass: rgba(255, 255, 255, 0.94); --glass-border: rgba(15, 23, 42, 0.1); --text: #0f172a; }
        body { background: linear-gradient(165deg, #f0fdfa 0%, #e5f4ff 50%, #fafafa 100%); color: var(--text); font-family: 'Outfit', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .form-container { background: var(--glass); backdrop-filter: blur(16px); padding: 3rem; border-radius: 24px; border: 1px solid var(--glass-border); width: 100%; max-width: 500px; }
        h2 { margin-bottom: 2rem; text-align: center; }
        .form-group { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 0.5rem; font-size: 0.9rem; opacity: 0.8; }
        input, select, textarea { width: 100%; padding: 0.8rem; background: #ffffff; border: 1px solid var(--glass-border); border-radius: 12px; color: var(--text); outline: none; }
        .btn { width: 100%; padding: 1rem; background: var(--primary); color: white; border: none; border-radius: 12px; font-weight: 600; cursor: pointer; }
        .back-link { display: block; text-align: center; margin-top: 1.5rem; color: var(--text); text-decoration: none; opacity: 0.6; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>${feedback != null ? 'Edit Feedback' : 'Add Feedback'}</h2>
        <form action="feedbacks" method="post">
            <c:if test="${feedback != null}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${feedback.id}">
            </c:if>

            <div class="form-group"><label>User ID</label><input type="text" name="userId" value="${feedback.userId}" required></div>
            <div class="form-group"><label>Vehicle ID</label><input type="text" name="vehicleId" value="${feedback.vehicleId}" required></div>
            <div class="form-group">
                <label>Rating</label>
                <select name="rating">
                    <c:forEach var="i" begin="1" end="5">
                        <option value="${i}" ${feedback.rating == i ? 'selected' : ''}>${i} Stars</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group"><label>Comments</label><textarea name="comments" rows="3">${feedback.comments}</textarea></div>
            <div class="form-group"><label>Date</label><input type="date" name="date" value="${feedback.date}" required></div>

            <button type="submit" class="btn">${feedback != null ? 'Update Feedback' : 'Submit Feedback'}</button>
        </form>
        <a href="feedbacks" class="back-link">Cancel</a>
    </div>
</body>
</html>
