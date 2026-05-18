package com.vehiclerental.servlet;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import java.io.File;

public abstract class BaseServlet extends HttpServlet {
    protected String dbPath;

    @Override
    public void init() throws ServletException {
        super.init();
        dbPath = resolveDatabaseDirectory();
        File dbDir = new File(dbPath);
        if (!dbDir.exists()) {
            dbDir.mkdirs();
        }
        System.out.println("Vehicle rental DB path: " + dbPath);
    }

    /**
     * Resolves the flat-file DB directory. Priority:
     * <ol>
     *   <li>{@code VEHICLE_RENTAL_DB_PATH} (absolute path)</li>
     *   <li>System property {@code vehicle.rental.db.path}</li>
     *   <li>Context init-param {@code vehicle.rental.db.path} (relative to {@code user.dir} if not absolute)</li>
     *   <li>Local dev: {@code src/main/webapp/db} under current working directory if it exists</li>
     *   <li>{@code getRealPath("/db")} inside the deployed webapp (e.g. {@code target/.../WEB-INF/...})</li>
     *   <li>{@code ~/vehiclerental_db}</li>
     * </ol>
     */
    private String resolveDatabaseDirectory() {
        String env = trimToNull(System.getenv("VEHICLE_RENTAL_DB_PATH"));
        if (env != null) {
            return new File(env).getAbsolutePath();
        }

        String prop = trimToNull(System.getProperty("vehicle.rental.db.path"));
        if (prop != null) {
            return new File(prop).getAbsolutePath();
        }

        ServletContext ctx = getServletContext();
        if (ctx != null) {
            String param = trimToNull(ctx.getInitParameter("vehicle.rental.db.path"));
            if (param != null) {
                File f = new File(param);
                if (!f.isAbsolute()) {
                    f = new File(System.getProperty("user.dir"), param);
                }
                return f.getAbsolutePath();
            }
        }

        // IDE / mvn jetty:run / SmartTomcat — same folder as in the repo so Payment/Booking files stay visible
        File devDb = new File(System.getProperty("user.dir"), "src/main/webapp/db");
        if (devDb.isDirectory()) {
            return devDb.getAbsolutePath();
        }

        if (ctx != null) {
            String realPath = ctx.getRealPath("/db");
            if (realPath != null) {
                return realPath;
            }
        }

        return new File(System.getProperty("user.home"), "vehiclerental_db").getAbsolutePath();
    }

    private static String trimToNull(String s) {
        if (s == null) {
            return null;
        }
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}
