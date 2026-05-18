package com.vehiclerental.servlet;

import com.vehiclerental.dao.FeedbackDAO;
import com.vehiclerental.dao.UserDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Feedback;
import com.vehiclerental.model.User;
import com.vehiclerental.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/feedbacks")
public class FeedbackServlet extends BaseServlet {
    private FeedbackDAO feedbackDAO;
    private UserDAO userDAO;
    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        feedbackDAO = new FeedbackDAO(dbPath);
        userDAO = new UserDAO(dbPath);
        vehicleDAO = new VehicleDAO(dbPath);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteFeedback(request, response);
                break;
            default:
                listFeedbacks(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            updateFeedback(request, response);
        } else {
            insertFeedback(request, response);
        }
    }

    private void listFeedbacks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Feedback> listFeedback = feedbackDAO.getAll();
        request.setAttribute("listFeedback", listFeedback);

        var users = userDAO.getAll();
        var vehicles = vehicleDAO.getAll();
        java.util.Map<String, String> userLabels = new java.util.HashMap<>();
        java.util.Map<String, String> vehicleLabels = new java.util.HashMap<>();
        for (User u : users) userLabels.put(u.getId(), u.getName());
        for (Vehicle v : vehicles) vehicleLabels.put(v.getId(), v.getBrand() + " " + v.getModel());

        request.setAttribute("userLabels", userLabels);
        request.setAttribute("vehicleLabels", vehicleLabels);

        request.getRequestDispatcher("feedback-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("feedback-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        Feedback existingFeedback = feedbackDAO.getById(id);
        request.setAttribute("feedback", existingFeedback);
        request.getRequestDispatcher("feedback-form.jsp").forward(request, response);
    }

    private void insertFeedback(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("userId");
        String vehicleId = request.getParameter("vehicleId");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comments = request.getParameter("comments");
        String date = request.getParameter("date");

        Feedback newFeedback = new Feedback(UUID.randomUUID().toString(), userId, vehicleId, rating, comments, date);
        feedbackDAO.add(newFeedback);
        response.sendRedirect("feedbacks");
    }

    private void updateFeedback(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String userId = request.getParameter("userId");
        String vehicleId = request.getParameter("vehicleId");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comments = request.getParameter("comments");
        String date = request.getParameter("date");

        Feedback feedback = new Feedback(id, userId, vehicleId, rating, comments, date);
        feedbackDAO.update(feedback);
        response.sendRedirect("feedbacks");
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        feedbackDAO.delete(id);
        response.sendRedirect("feedbacks");
    }
}
