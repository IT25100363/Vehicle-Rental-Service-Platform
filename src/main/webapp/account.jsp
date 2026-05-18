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
            background: rgba(255, 255, 255, 0.96);
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
        .site-nav > a:not(.btn-nav):hover { opacity: 1; color: var(--primary); }
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
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
        }
        .account-announcements {
            display: grid;
            gap: 0.75rem;
            width: 100%;
        }
        .account-primary-layout {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
            align-items: start;
            width: 100%;
        }
        @media (min-width: 900px) {
            .account-primary-layout {
                grid-template-columns: 1fr 1.1fr;
                align-items: start;
            }
        }
        .panel {
            background: var(--glass);
            backdrop-filter: blur(14px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 1.75rem;
        }
        .panel h2 {
            font-size: 1.2rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .alert {
            padding: 0.75rem 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            font-size: 0.9rem;
            border: 1px solid var(--glass-border);
        }
        .alert.ok {
            background: rgba(34, 197, 94, 0.12);
            color: #166534;
        }
        .alert.err {
            background: rgba(239, 68, 68, 0.1);
            color: #b91c1c;
        }
        label { display: block; margin-bottom: 0.35rem; font-size: 0.85rem; opacity: 0.85; }
        input, select {
            width: 100%;
            padding: 0.65rem 0.85rem;
            margin-bottom: 1rem;
            border-radius: 12px;
            border: 1px solid var(--glass-border);
            background: #ffffff;
            color: var(--text);
            outline: none;
        }
        .hint { font-size: 0.8rem; opacity: 0.65; margin: -0.5rem 0 1rem; }
        button.primary {
            padding: 0.75rem 1.25rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 0.5rem;
            font-size: 0.95rem;
        }
        th, td {
            padding: 0.65rem 0.5rem;
            text-align: left;
            border-bottom: 1px solid var(--glass-border);
        }
        th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #64748b;
        }
        .badge {
            display: inline-block;
            padding: 0.2rem 0.55rem;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 600;
            background: rgba(13, 148, 136, 0.18);
            border: 1px solid rgba(13, 148, 136, 0.3);
        }
        .empty { opacity: 0.7; font-size: 0.95rem; padding: 0.5rem 0; }
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
        .two-col {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
        }
        @media (max-width: 520px) {
            .two-col { grid-template-columns: 1fr; }
        }
        .stars { color: #fbbf24; font-size: 0.85rem; }
        .feedback-item {
            border-bottom: 1px solid var(--glass-border);
            padding: 1rem 0;
        }
        .feedback-item:last-child { border-bottom: none; }
        .feedback-meta { font-size: 0.8rem; opacity: 0.6; display: flex; justify-content: space-between; margin-bottom: 0.25rem; }
        .feedback-comment { font-size: 0.9rem; margin-top: 0.4rem; line-height: 1.4; }
        .feedback-delete { color: #ef4444; opacity: 0.5; transition: 0.3s; font-size: 0.8rem; text-decoration: none; }
        .feedback-delete:hover { opacity: 1; }
        .btn-cancel-booking {
            padding: 0.35rem 0.65rem;
            font-size: 0.8rem;
            border-radius: 8px;
            border: 1px solid rgba(239, 68, 68, 0.45);
            background: rgba(239, 68, 68, 0.12);
            color: #fecaca;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-cancel-booking:hover { background: rgba(239, 68, 68, 0.22); }
        .booking-column {
            display: flex;
            flex-direction: column;
            align-items: stretch;
            gap: 1.5rem;
            min-width: 0;
        }
        .booking-alerts { display: grid; gap: 0.75rem; }
        .booking-block-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        textarea {
            width: 100%;
            padding: 0.65rem 0.85rem;
            margin-bottom: 1rem;
            border-radius: 12px;
            border: 1px solid var(--glass-border);
            background: #ffffff;
            color: var(--text);
            outline: none;
            resize: vertical;
            min-height: 80px;
        }
    </style>
</head>
<body>
<%@ include file="/includes/site-header.jspf" %>
<main>
    <c:if test="${param.booked == '1' or param.cancelled == '1' or param.error == 'cancelPolicy' or param.error == 'cancelAuth' or param.error == 'cancel' or param.error == 'booking'}">
    <div class="account-announcements booking-alerts">
        <c:if test="${param.booked == '1'}">
            <div class="alert ok">Booking request submitted (status: Pending).</div>
        </c:if>
        <c:if test="${param.cancelled == '1'}">
            <div class="alert ok">Your booking was cancelled.</div>
        </c:if>
        <c:if test="${param.error == 'cancelPolicy'}">
            <div class="alert err">This booking cannot be cancelled (already active, completed, or outside the allowed window).</div>
        </c:if>
        <c:if test="${param.error == 'cancelAuth'}">
            <div class="alert err">You cannot cancel that booking.</div>
        </c:if>
        <c:if test="${param.error == 'cancel'}">
            <div class="alert err">Unable to cancel. Try again.</div>
        </c:if>
        <c:if test="${param.error == 'booking'}">
            <div class="alert err">Please choose a vehicle and valid dates.</div>
        </c:if>
    </div>
    </c:if>

    <div class="account-primary-layout">
    <section class="panel">
        <h2><i class="fas fa-id-card"></i> Profile</h2>
        <c:if test="${param.saved == '1'}">
            <div class="alert ok">Your profile was updated.</div>
        </c:if>
        <c:if test="${param.error == 'email'}">
            <div class="alert err">That email is already used by another account.</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/account" method="post">
            <input type="hidden" name="formAction" value="updateProfile">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" value="${user.name}" required>
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="${user.email}" required>
            <label for="phoneNumber">Phone</label>
            <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
            <label for="password">New password</label>
            <input type="password" id="password" name="password" autocomplete="new-password" placeholder="Leave blank to keep current">
            <p class="hint">Role: <strong>${user.role}</strong> (managed by administrators)</p>
            <button type="submit" class="primary"><i class="fas fa-floppy-disk"></i> Save changes</button>
        </form>
    </section>
    <div id="booking-section" class="booking-column">
        <section class="panel">
            <h2 class="booking-block-title"><i class="fas fa-calendar-plus"></i> Request a booking</h2>
            <form action="${pageContext.request.contextPath}/account" method="post">
                <input type="hidden" name="formAction" value="createBooking">
                <label for="vehicleId">Vehicle</label>
                <select id="vehicleId" name="vehicleId" required>
                    <option value="" disabled="disabled"<c:if test="${empty prefillVehicleId}"> selected="selected"</c:if>>Select a vehicle</option>
                    <c:forEach var="v" items="${vehicles}">
                        <c:if test="${v.status == 'Available'}">
                            <c:choose>
                                <c:when test="${prefillVehicleId eq v.id}">
                                    <option value="${v.id}" selected="selected">${v.brand} ${v.model} — ${v.plateNumber}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${v.id}">${v.brand} ${v.model} — ${v.plateNumber}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>
                </select>
                <div class="two-col">
                    <div>
                        <label for="startDate">Start</label>
                        <input type="date" id="startDate" name="startDate" required>
                    </div>
                    <div>
                        <label for="endDate">End</label>
                        <input type="date" id="endDate" name="endDate" required>
                    </div>
                </div>
                <button type="submit" class="primary"><i class="fas fa-plus"></i> Submit booking</button>
            </form>
        </section>

        <section class="panel">
            <h2 class="booking-block-title"><i class="fas fa-calendar-check"></i> Your bookings</h2>
            <c:choose>
                <c:when test="${empty myBookings}">
                    <p class="empty">No bookings yet.</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Vehicle</th>
                                <th>Start</th>
                                <th>End</th>
                                <th>Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${myBookings}">
                                <tr>
                                    <td>${vehicleLabels[b.vehicleId]}</td>
                                    <td>${b.startDate}</td>
                                    <td>${b.endDate}</td>
                                    <td><span class="badge">${b.status}</span></td>
                                    <td style="text-align:right;white-space:nowrap;">
                                        <c:if test="${cancelEligibility[b.id]}">
                                            <form action="${pageContext.request.contextPath}/account" method="post" style="display:inline;" onsubmit="return confirm('Cancel this booking?');">
                                                <input type="hidden" name="formAction" value="cancelBooking">
                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                <button type="submit" class="btn-cancel-booking">Cancel</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
    </div>

    <section class="panel account-feedback-panel">
        <h2><i class="fas fa-star"></i> Feedback & Reviews</h2>
        <c:if test="${param.feedbackSaved == '1'}">
            <div class="alert ok">Thank you! Your review has been posted.</div>
        </c:if>
        <c:if test="${param.feedbackDeleted == '1'}">
            <div class="alert ok">Review removed successfully.</div>
        </c:if>
        <c:if test="${param.error == 'feedback'}">
            <div class="alert err">Please provide a rating and select a vehicle.</div>
        </c:if>

        <h3 style="font-size:1rem;margin-bottom:0.75rem;opacity:0.9;">Leave a review</h3>
        <form action="${pageContext.request.contextPath}/account" method="post">
            <input type="hidden" name="formAction" value="submitFeedback">
            <label for="f-vehicleId">Vehicle</label>
            <select id="f-vehicleId" name="vehicleId" required>
                <option value="" disabled="disabled" selected="selected">Select vehicle to review</option>
                <c:forEach var="v" items="${vehicles}">
                    <option value="${v.id}">${v.brand} ${v.model}</option>
                </c:forEach>
            </select>
            <label for="rating">Rating</label>
            <select id="rating" name="rating" required>
                <option value="5">5 Stars - Excellent</option>
                <option value="4">4 Stars - Very Good</option>
                <option value="3">3 Stars - Good</option>
                <option value="2">2 Stars - Fair</option>
                <option value="1">1 Star - Poor</option>
            </select>
            <label for="comments">Your comments</label>
            <textarea id="comments" name="comments" placeholder="How was your experience?"></textarea>
            <button type="submit" class="primary"><i class="fas fa-paper-plane"></i> Post Review</button>
        </form>

        <h3 style="font-size:1rem;margin:1.5rem 0 0.75rem;opacity:0.9;">Your history</h3>
        <c:choose>
            <c:when test="${empty myFeedbacks}">
                <p class="empty">You haven't left any reviews yet.</p>
            </c:when>
            <c:otherwise>
                <div class="feedback-list">
                    <c:forEach var="f" items="${myFeedbacks}">
                        <div class="feedback-item">
                            <div class="feedback-meta">
                                <span><strong>${vehicleLabels[f.vehicleId]}</strong></span>
                                <div>
                                    <span style="margin-right: 0.75rem;">${f.date}</span>
                                    <form action="${pageContext.request.contextPath}/account" method="post" style="display:inline;" onsubmit="return confirm('Delete this review?')">
                                        <input type="hidden" name="formAction" value="deleteFeedback">
                                        <input type="hidden" name="feedbackId" value="${f.id}">
                                        <button type="submit" class="feedback-delete" style="background:none;border:none;cursor:pointer;padding:0;">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                            <div class="stars">
                                <c:forEach begin="1" end="${f.rating}">
                                    <i class="fas fa-star"></i>
                                </c:forEach>
                                <c:forEach begin="${f.rating + 1}" end="5">
                                    <i class="far fa-star"></i>
                                </c:forEach>
                            </div>
                            <c:if test="${not empty f.comments}">
                                <p class="feedback-comment">${f.comments}</p>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
<%@ include file="/includes/site-footer.jspf" %>
<c:if test="${focusBookingSection}">
<script>
document.getElementById('booking-section').scrollIntoView({ behavior: 'smooth', block: 'start' });
</script>
</c:if>
</body>
</html>
