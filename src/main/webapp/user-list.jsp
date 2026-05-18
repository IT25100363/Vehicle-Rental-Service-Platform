<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #0d9488;
            --bg: #f1f5f9;
            --glass: rgba(255, 255, 255, 0.94);
            --glass-border: rgba(15, 23, 42, 0.1);
            --text: #0f172a;
        }

        body {
            background: linear-gradient(165deg, #f0fdfa 0%, #e5f4ff 50%, #fafafa 100%);
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            padding: 2rem;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 2.5rem;
            background: linear-gradient(135deg, rgba(13, 148, 136, 0.8), rgba(8, 145, 178, 0.7)), url('${pageContext.request.contextPath}/images/34.jpg') center/cover;
            border-radius: 20px;
            color: white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .header h1 { margin: 0; color: white; text-shadow: 0 2px 10px rgba(0,0,0,0.2); }
        .header .btn-back { background: rgba(255, 255, 255, 0.2); color: white; border: 1px solid rgba(255, 255, 255, 0.3); backdrop-filter: blur(5px); }
        .header .btn-back:hover { background: rgba(255, 255, 255, 0.3); }

        .btn {
            padding: 0.8rem 1.5rem;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
            cursor: pointer;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary { background: var(--primary); color: white; }
        .btn-danger { background: #ef4444; color: white; }
        .btn-back { background: var(--glass); color: var(--text); border: 1px solid var(--glass-border); }

        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--glass);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid var(--glass-border);
        }

        th, td {
            padding: 1.2rem;
            text-align: left;
            border-bottom: 1px solid var(--glass-border);
        }

        th { background: rgba(255, 255, 255, 0.1); font-weight: 600; }
        tr:hover { background: rgba(255, 255, 255, 0.03); }

        .actions { display: flex; gap: 1rem; }
        .actions a { color: var(--text); text-decoration: none; opacity: 0.7; transition: 0.3s; }
        .actions a:hover { opacity: 1; color: var(--primary); }
    </style>
</head>
<body>
    <div class="header">
        <h1><i class="fas fa-users"></i> User Management</h1>
        <div>
            <a href="index.jsp" class="btn btn-back"><i class="fas fa-arrow-left"></i> Dashboard</a>
            <a href="users?action=new" class="btn btn-primary"><i class="fas fa-plus"></i> Add User</a>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Phone</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${listUser}">
                <tr>
                    <td>${user.name}</td>
                    <td>${user.email}</td>
                    <td>${user.role}</td>
                    <td>${user.phoneNumber}</td>
                    <td class="actions">
                        <a href="users?action=edit&id=${user.id}"><i class="fas fa-edit"></i></a>
                        <a href="users?action=delete&id=${user.id}" onclick="return confirm('Delete this user?')"><i class="fas fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
