package com.vehiclerental.dao;

import com.vehiclerental.model.Feedback;

public class FeedbackDAO extends GenericDAO<Feedback> {
    public FeedbackDAO(String dbPath) {
        super(dbPath + "/feedbacks.txt", Feedback::fromString);
    }
    public Feedback getById(String id) { return super.getById(id, Feedback::getId); }
    public void update(Feedback feedback) { super.update(feedback, Feedback::getId); }
    public void delete(String id) { super.delete(id, Feedback::getId); }
    public java.util.List<Feedback> findByUserId(String userId) {
        if (userId == null) return java.util.List.of();
        return getAll().stream()
                .filter(f -> userId.equals(f.getUserId()))
                .collect(java.util.stream.Collectors.toList());
    }
}

