
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Feedback Management</title>
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
        .stars { color: #fbbf24; }
        .actions a { color: var(--text); opacity: 0.7; margin-right: 0.5rem; }
        .actions a:hover { opacity: 1; color: var(--primary); }
        .actions a.delete:hover { color: #ef4444; }
    </style>
</head>
<body>
    <div class="header">
        <h1><i class="fas fa-star"></i> Feedback Management</h1>
        <div>
            <a href="index.jsp" class="btn btn-back"><i class="fas fa-arrow-left"></i> Dashboard</a>
            <a href="feedbacks?action=new" class="btn btn-primary"><i class="fas fa-plus"></i> Add Feedback</a>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Customer</th>
                <th>Vehicle</th>
                <th>Rating</th>
                <th>Comments</th>
                <th>Date</th>
                <th style="text-align:right;">Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${listFeedback}">
                <tr>
                    <td>${userLabels[f.userId]}</td>
                    <td>${vehicleLabels[f.vehicleId]}</td>
                    <td>
                        <div class="stars">
                            <c:forEach begin="1" end="${f.rating}"><i class="fas fa-star"></i></c:forEach>
                            <c:forEach begin="${f.rating + 1}" end="5"><i class="far fa-star"></i></c:forEach>
                        </div>
                    </td>
                    <td>${f.comments}</td>
                    <td>${f.date}</td>
                    <td class="actions" style="text-align:right;">
                        <a href="feedbacks?action=edit&id=${f.id}" title="Edit"><i class="fas fa-edit"></i></a>
                        <a href="feedbacks?action=delete&id=${f.id}" class="delete" onclick="return confirm('Delete record?')" title="Delete"><i class="fas fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
