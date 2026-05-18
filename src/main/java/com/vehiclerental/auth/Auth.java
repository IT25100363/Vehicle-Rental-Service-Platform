package com.vehiclerental.auth;

import jakarta.servlet.http.HttpSession;

public final class Auth {
    public static final String SESSION_USER_ID = "userId";
    public static final String SESSION_USER_NAME = "userName";
    public static final String SESSION_USER_EMAIL = "userEmail";
    public static final String SESSION_USER_ROLE = "userRole";

    private Auth() {}

    public static boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute(SESSION_USER_ID) != null;
    }

    public static boolean isAdmin(HttpSession session) {
        return session != null && "Admin".equals(session.getAttribute(SESSION_USER_ROLE));
    }
}
