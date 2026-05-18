<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Vehicle Rental Service Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #0d9488;
            --secondary: #0891b2;
            --glass: rgba(255, 255, 255, 0.94);
            --glass-border: rgba(15, 23, 42, 0.1);
            --text: #0f172a;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Outfit', sans-serif; }
        body {
            background: linear-gradient(165deg, #f0fdfa 0%, #e0f2fe 45%, #f8fafc 100%);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .site-header {
            border-bottom: 1px solid var(--glass-border);
            background: linear-gradient(rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 0.9)), url('${pageContext.request.contextPath}/images/34.jpg') center/cover no-repeat;
            backdrop-filter: blur(12px);
        }
        .site-header-inner {
            max-width: 1100px;
            margin: 0 auto;
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .site-logo {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            font-weight: 700;
            font-size: 1.15rem;
            color: var(--text);
            text-decoration: none;
        }
        .site-logo i {
            background: linear-gradient(to bottom right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .site-nav { display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap; }
        .site-nav > a:not(.btn-nav) {
            color: var(--text);
            text-decoration: none;
            opacity: 0.85;
            padding: 0.35rem 0.5rem;
            font-weight: 500;
        }
        .site-nav > a:not(.btn-nav):hover { opacity: 1; color: #0d9488; }
        .btn-nav {
            padding: 0.45rem 1rem;
            border-radius: 999px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            border: 1px solid transparent;
        }
        .btn-nav-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }
        .btn-nav-outline {
            border-color: var(--glass-border);
            color: var(--text);
            background: var(--glass);
        }
        .nav-user { font-size: 0.85rem; opacity: 0.75; padding: 0 0.35rem; }
        main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .card {
            width: 100%;
            max-width: 440px;
            background: var(--glass);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 2rem;
        }
        .card h1 {
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
            background: linear-gradient(to right, #0d9488, #0891b2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .card p.sub { opacity: 0.7; margin-bottom: 1.5rem; font-size: 0.95rem; }
        .alert {
            padding: 0.75rem 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            font-size: 0.9rem;
            border: 1px solid var(--glass-border);
            background: rgba(239, 68, 68, 0.12);
            color: #fecaca;
        }
        label { display: block; margin-bottom: 0.35rem; font-size: 0.85rem; opacity: 0.85; }
        input {
            width: 100%;
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            border-radius: 12px;
            border: 1px solid var(--glass-border);
            background: #ffffff;
            color: var(--text);
            outline: none;
        }
        input:focus { border-color: rgba(129, 140, 248, 0.8); }
        button[type="submit"] {
            width: 100%;
            padding: 0.85rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            margin-top: 0.25rem;
        }
        .muted {
            text-align: center;
            margin-top: 1.25rem;
            font-size: 0.9rem;
            opacity: 0.75;
        }
        .muted a { color: #0d9488; }
        .site-footer {
            border-top: 1px solid var(--glass-border);
            padding: 1.25rem 1.5rem;
            background: #f1f5f9;
            font-size: 0.85rem;
            opacity: 0.65;
            text-align: center;
        }
    </style>
</head>
<body>
<%@ include file="/includes/site-header.jspf" %>
<main>
    <div class="card">
        <h1>Create your account</h1>
        <p class="sub">Browse the fleet as a guest, then book once you are signed in.</p>
        <c:if test="${param.error == 'missing'}">
            <div class="alert">Please fill in name, email, and password.</div>
        </c:if>
        <c:if test="${param.error == 'exists'}">
            <div class="alert">An account with this email already exists.</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/register" method="post">
            <c:if test="${not empty param.redirect}">
                <input type="hidden" name="redirect" value="${fn:escapeXml(param.redirect)}">
            </c:if>
            <label for="name">Full name</label>
            <input type="text" id="name" name="name" required autocomplete="name">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required autocomplete="email">
            <label for="phoneNumber">Phone</label>
            <input type="tel" id="phoneNumber" name="phoneNumber" autocomplete="tel">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required autocomplete="new-password">
            <button type="submit"><i class="fas fa-user-plus"></i> Register</button>
        </form>
        <c:choose>
            <c:when test="${not empty param.redirect}">
                <c:url var="loginLink" value="/login.jsp">
                    <c:param name="redirect" value="${param.redirect}" />
                </c:url>
                <p class="muted">Already registered? <a href="${loginLink}">Login</a></p>
            </c:when>
            <c:otherwise>
                <p class="muted">Already registered? <a href="${pageContext.request.contextPath}/login.jsp">Login</a></p>
            </c:otherwise>
        </c:choose>
    </div>
</main>
<%@ include file="/includes/site-footer.jspf" %>
</body>
</html>
