<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} | Vehicle Rental Service Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme-light.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #0d9488;
            --secondary: #0891b2;
            --bg: #f1f5f9;
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
            position: sticky;
            top: 0;
            z-index: 10;
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
        .site-nav {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }
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
        .nav-user {
            font-size: 0.85rem;
            opacity: 0.75;
            padding: 0 0.35rem;
        }
        main {
            flex: 1;
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
            padding: 2rem 1.5rem 3rem;
        }
        .hero {
            position: relative;
            margin-bottom: 3rem;
            padding: 6rem 2rem;
            border-radius: 32px;
            overflow: hidden;
            background: url('${pageContext.request.contextPath}/images/34.jpg') center/cover no-repeat;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
        }
        .hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(13, 148, 136, 0.8), rgba(8, 145, 178, 0.65));
            backdrop-filter: blur(2px);
            z-index: 1;
        }
        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 750px;
        }
        .hero h1 {
            font-size: 3.25rem;
            font-weight: 800;
            margin-bottom: 1.25rem;
            color: white;
            -webkit-text-fill-color: white;
            text-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            letter-spacing: -0.02em;
        }
        .hero p {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.95);
            line-height: 1.7;
            margin: 0 auto;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .fleet-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2rem;
            margin-top: 1rem;
        }
        .fleet-card {
            background: var(--glass);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            border: 1px solid var(--glass-border);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
        }
        .fleet-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.1);
        }
        .fleet-card-img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-bottom: 1px solid var(--glass-border);
            background: #e2e8f0;
        }
        .fleet-card-content {
            padding: 1.5rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .fleet-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.5rem;
        }
        .fleet-card-title {
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--text);
        }
        .fleet-card-subtitle {
            font-size: 0.95rem;
            color: #64748b;
            margin-top: 0.2rem;
        }
        .fleet-card-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary);
            margin-top: 1rem;
            margin-bottom: 1.5rem;
        }
        .fleet-card-actions {
            margin-top: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .badge {
            display: inline-block;
            padding: 0.25rem 0.65rem;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 600;
            background: rgba(13, 148, 136, 0.18);
            border: 1px solid rgba(13, 148, 136, 0.3);
        }
        .site-footer {
            border-top: 1px solid var(--glass-border);
            padding: 1.25rem 1.5rem;
            background: #f1f5f9;
        }
        .site-footer-inner {
            max-width: 1100px;
            margin: 0 auto;
            text-align: center;
            font-size: 0.85rem;
            opacity: 0.65;
        }
        .empty-state {
            padding: 2rem;
            text-align: center;
            opacity: 0.7;
            border: 1px dashed var(--glass-border);
            border-radius: 16px;
        }
        .fleet-alert {
            padding: 0.85rem 1.1rem;
            margin-bottom: 1.25rem;
            border-radius: 14px;
            border: 1px solid rgba(251, 191, 36, 0.35);
            background: rgba(251, 191, 36, 0.12);
            color: #854d0e;
            font-size: 0.95rem;
        }
        .fleet-stat-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1.25rem;
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            border-radius: 14px;
            color: #065f46;
            font-weight: 600;
            margin-bottom: 2rem;
            backdrop-filter: blur(8px);
            animation: fadeInScale 0.6s ease-out;
        }
        .fleet-stat-badge i {
            color: #10b981;
            font-size: 1.1rem;
        }
        @keyframes fadeInScale {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        .btn-book {
            padding: 0.45rem 1rem;
            border-radius: 999px;
            border: none;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            font-family: inherit;
        }
        .btn-book:disabled {
            opacity: 0.35;
            cursor: not-allowed;
        }
        .btn-book-muted {
            font-size: 0.85rem;
            opacity: 0.45;
        }
        .modal {
            position: fixed;
            inset: 0;
            z-index: 200;
            display: grid;
            place-items: center;
            padding: 1rem;
        }
        .modal[hidden] {
            display: none;
        }
        .modal-backdrop {
            position: absolute;
            inset: 0;
            background: rgba(15, 23, 42, 0.35);
            backdrop-filter: blur(4px);
        }
        .modal-panel {
            position: relative;
            max-width: 400px;
            width: 100%;
            padding: 1.75rem;
            border-radius: 20px;
            border: 1px solid var(--glass-border);
            background: #ffffff;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.12);
        }
        .modal-panel h3 {
            margin-bottom: 0.5rem;
            font-size: 1.2rem;
        }
        .modal-panel p {
            opacity: 0.78;
            line-height: 1.55;
            margin-bottom: 1.25rem;
            font-size: 0.95rem;
        }
        .modal-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 0.6rem;
            justify-content: flex-end;
        }
        .modal-actions .btn-nav {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem 1rem;
            border-radius: 999px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.88rem;
            border: 1px solid transparent;
            cursor: pointer;
            font-family: inherit;
            background: transparent;
            color: var(--text);
        }
        .modal-actions .btn-nav-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
        }
        .modal-actions .btn-nav-outline {
            border-color: var(--glass-border);
            background: var(--glass);
        }
    </style>
</head>
<body data-ctx="${pageContext.request.contextPath}" data-logged-in="${not empty sessionScope.userId}">
<%@ include file="/includes/site-header.jspf" %>
<main>
    <section class="hero">
        <div class="hero-content">
            <h1>Explore Our premium vehicle collection</h1>
            <p>Vehicles maintained through Vehicle Management appear here for guests and customers. Sign in to manage your bookings and profile.</p>
        </div>
    </section>

    <div class="fleet-stat-badge">
        <i class="fas fa-car-side"></i>
        <span>Total Vehicles in Our Fleet: <strong>${not empty listVehicle ? listVehicle.size() : 0}</strong></span>
    </div>
    <c:if test="${param.bookingError == 'unavailable'}">
        <div class="fleet-alert">
            That vehicle is not available to book right now. Choose another from the list.
        </div>
    </c:if>
    <c:choose>
        <c:when test="${empty listVehicle}">
            <div class="empty-state">
                <p>No vehicles listed yet. Admins can add vehicles from the dashboard.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="fleet-grid">
                <c:forEach var="v" items="${listVehicle}">
                    <div class="fleet-card">
                        <img src="${v.imageUrl}" alt="${v.brand} ${v.model}" class="fleet-card-img" onerror="this.src='https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=600&q=80'">
                        <div class="fleet-card-content">
                            <div class="fleet-card-header">
                                <div>
                                    <h3 class="fleet-card-title">${v.brand} ${v.model}</h3>
                                    <div class="fleet-card-subtitle">Plate: ${v.plateNumber}</div>
                                </div>
                                <span class="badge">${v.status}</span>
                            </div>
                            <div class="fleet-card-price">
                                LKR ${v.rentalPricePerDay} <span style="font-size: 0.85rem; font-weight: 400; color: #64748b;">/ day</span>
                            </div>
                            <div class="fleet-card-actions">
                                <c:choose>
                                    <c:when test="${v.status == 'Available'}">
                                        <button type="button" class="btn-book" style="width: 100%; padding: 0.75rem;" data-book-id="${v.id}">Book Now</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn-book btn-book-muted" style="width: 100%; padding: 0.75rem; background: #e2e8f0; color: #64748b;" disabled>Unavailable</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<div id="book-modal" class="modal" role="dialog" aria-modal="true" aria-labelledby="book-modal-title" hidden>
    <div class="modal-backdrop" onclick="window.closeBookModal && window.closeBookModal()"></div>
    <div class="modal-panel">
        <h3 id="book-modal-title">Continue to book</h3>
        <p>Sign in or create a free account to save your booking. Your vehicle selection will carry through.</p>
        <div class="modal-actions">
            <button type="button" class="btn-nav btn-nav-outline" onclick="window.closeBookModal && window.closeBookModal()">Cancel</button>
            <a id="modal-register-link" class="btn-nav btn-nav-outline" href="#">Sign up</a>
            <a id="modal-login-link" class="btn-nav btn-nav-primary" href="#">Log in</a>
        </div>
    </div>
</div>

<%@ include file="/includes/site-footer.jspf" %>
<script>
(function () {
    var body = document.body;
    var ctx = body.getAttribute('data-ctx') || '';
    var loggedIn = body.getAttribute('data-logged-in') === 'true';
    var modal = document.getElementById('book-modal');

    window.closeBookModal = function () {
        if (modal) modal.hidden = true;
    };

    function openGuestModal(vehicleId) {
        var path = '/account?vehicleId=' + encodeURIComponent(vehicleId) + '&focus=book';
        var enc = encodeURIComponent(path);
        document.getElementById('modal-login-link').href = ctx + '/login.jsp?reason=book&redirect=' + enc;
        document.getElementById('modal-register-link').href = ctx + '/register.jsp?redirect=' + enc;
        modal.hidden = false;
    }

    document.querySelectorAll('[data-book-id]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var id = btn.getAttribute('data-book-id');
            if (loggedIn) {
                window.location.href = ctx + '/book-vehicle?id=' + encodeURIComponent(id);
            } else {
                openGuestModal(id);
            }
        });
    });
})();
</script>
</body>
</html>
