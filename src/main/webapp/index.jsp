<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vehiclerental.auth.Auth" %>
<%
    Object role = session.getAttribute(Auth.SESSION_USER_ROLE);
    if (!"Admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/home.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Rental Service Platform | Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0d9488;
            --secondary: #0891b2;
            --bg: #f1f5f9;
            --glass: rgba(255, 255, 255, 0.94);
            --glass-border: rgba(15, 23, 42, 0.1);
            --text: #0f172a;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Outfit', sans-serif;
        }

        body {
            background: linear-gradient(165deg, #f0fdfa 0%, #e0f2fe 45%, #f8fafc 100%);
            color: var(--text);
            min-height: 100vh;
            overflow-x: hidden;
            padding-top: 2.5rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        header {
            position: relative;
            text-align: center;
            margin-bottom: 4rem;
            padding: 4rem 2rem;
            border-radius: 32px;
            overflow: hidden;
            background: url('${pageContext.request.contextPath}/images/34.jpg') center/cover no-repeat;
            color: white;
            animation: fadeInDown 1s ease-out;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
        }

        header::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(13, 148, 136, 0.85), rgba(8, 145, 178, 0.75));
            z-index: 1;
        }

        header h1 {
            position: relative;
            z-index: 2;
            font-size: 3rem;
            font-weight: 700;
            color: white;
            -webkit-text-fill-color: white;
            margin-bottom: 0.75rem;
            text-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        header p {
            position: relative;
            z-index: 2;
            color: rgba(255, 255, 255, 0.95);
            font-size: 1.1rem;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .card {
            background: var(--glass);
            backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 2rem;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            color: var(--text);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.05), transparent);
            transform: translateX(-100%);
            transition: 0.6s;
        }

        .card:hover::before {
            transform: translateX(100%);
        }

        .card:hover {
            transform: translateY(-10px) scale(1.02);
            background: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 16px 32px rgba(15, 23, 42, 0.12);
        }

        .card i {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            background: linear-gradient(to bottom right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .card h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .card p {
            font-size: 0.9rem;
            opacity: 0.7;
            line-height: 1.6;
        }

        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .nav-link {
            position: absolute;
            bottom: 2rem;
            right: 2rem;
            padding: 0.5rem 1.5rem;
            background: var(--primary);
            border-radius: 99px;
            font-size: 0.8rem;
            font-weight: 600;
            opacity: 0;
            transition: 0.3s;
        }

        .card:hover .nav-link {
            opacity: 1;
        }

        .admin-top-bar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
            padding: 0.65rem 1.25rem;
            font-size: 0.85rem;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--glass-border);
        }

        .admin-top-bar a {
            color: #0f766e;
            text-decoration: none;
            opacity: 0.95;
        }

        .admin-top-bar a:hover {
            opacity: 1;
            text-decoration: underline;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="admin-top-bar">
        <a href="${pageContext.request.contextPath}/home.jsp"><i class="fas fa-globe"></i> Public site</a>
        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-right-from-bracket"></i> Log out</a>
    </div>
    <div class="container">
        <header>
            <h1>Vehicle Rental Service Platform</h1>
            <p>Premium Management Service for Modern Fleets</p>
        </header>

        <div class="grid">
            <a href="users" class="card">
                <i class="fas fa-users"></i>
                <h3>User Management</h3>
                <p>Manage customers, admins, and roles. View, add, or update user credentials.</p>
                <span class="nav-link">Explore <i class="fas fa-arrow-right"></i></span>
            </a>

            <a href="vehicles" class="card">
                <i class="fas fa-car"></i>
                <h3>Vehicle Management</h3>
                <p>Control your fleet. Add new vehicles, track maintenance, and update status.</p>
                <span class="nav-link">Explore <i class="fas fa-arrow-right"></i></span>
            </a>

            <a href="bookings" class="card">
                <i class="fas fa-calendar-check"></i>
                <h3>Booking Management</h3>
                <p>Handle reservations and schedules. Confirm or cancel bookings efficiently.</p>
                <span class="nav-link">Explore <i class="fas fa-arrow-right"></i></span>
            </a>

            <a href="rentals" class="card">
                <i class="fas fa-key"></i>
                <h3>Rental & Return</h3>
                <p>Track active rentals, process returns, and record vehicle conditions.</p>
                <span class="nav-link">Explore <i class="fas fa-arrow-right"></i></span>
            </a>

            <a href="payments" class="card">
                <i class="fas fa-credit-card"></i>
                <h3>Payment Management</h3>
                <p>Monitor transactions, process invoices, and manage payment records.</p>
                <span class="nav-link">Explore <i class="fas fa-arrow-right"></i></span>
            </a>

            <a href="feedbacks" class="card">
                <i class="fas fa-star"></i>
                <h3>Feedback Management</h3>
                <p>Analyze customer reviews and ratings to improve your service quality.</p>
                <span class="nav-link">Explore <i class="fas fa-arrow-right"></i></span>
            </a>
        </div>
    </div>
</body>
</html>
