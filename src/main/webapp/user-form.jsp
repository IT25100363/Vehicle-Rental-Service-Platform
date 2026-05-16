<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Form</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
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
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .form-container {
            background: var(--glass);
            backdrop-filter: blur(16px);
            padding: 3rem;
            border-radius: 24px;
            border: 1px solid var(--glass-border);
            width: 100%;
            max-width: 500px;
        }

        h2 { margin-bottom: 2rem; text-align: center; }

        .form-group { margin-bottom: 1.5rem; }

        label { display: block; margin-bottom: 0.5rem; font-size: 0.9rem; opacity: 0.8; }

        input, select {
            width: 100%;
            padding: 0.8rem;
            background: #ffffff;
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: white;
            outline: none;
            transition: 0.3s;
        }

        input:focus { border-color: var(--primary); background: rgba(255, 255, 255, 0.1); }

        .btn {
            width: 100%;
            padding: 1rem;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 1rem;
        }

        .btn:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(13, 148, 136, 0.25); }

        .back-link { display: block; text-align: center; margin-top: 1.5rem; color: var(--text); text-decoration: none; opacity: 0.6; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>
            <c:if test="${user != null}">Edit User</c:if>
            <c:if test="${user == null}">Add New User</c:if>
        </h2>

        <form action="users" method="post">
            <c:if test="${user != null}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${user.id}">
            </c:if>

            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" value="${user.name}" required>
            </div>

            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" value="${user.email}" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" value="${user.password}" required>
            </div>

            <div class="form-group">
                <label>Role</label>
                <select name="role">
                    <option value="User" <c:if test="${user.role == 'User'}">selected</c:if>>User</option>
                    <option value="Admin" <c:if test="${user.role == 'Admin'}">selected</c:if>>Admin</option>
                </select>
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phoneNumber" value="${user.phoneNumber}" required>
            </div>

            <button type="submit" class="btn">
                <c:if test="${user != null}">Update User</c:if>
                <c:if test="${user == null}">Create User</c:if>
            </button>
        </form>

        <a href="users" class="back-link">Cancel and go back</a>
    </div>
</body>
</html>
