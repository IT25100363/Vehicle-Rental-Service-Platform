package servlet;

import model.User;
import service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class UserServlet extends HttpServlet {

    private UserService service = new UserService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("users", service.getAllUsers());
        RequestDispatcher rd = req.getRequestDispatcher("users.jsp");
        rd.forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String email = req.getParameter("email");

            service.addUser(new User(id, name, email));
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.deleteUser(id);
        }

        if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String email = req.getParameter("email");

            service.updateUser(id, name, email);
        }

        resp.sendRedirect("users");
    }
}