package com.vehiclerental.dao;

import com.vehiclerental.model.User;

import java.util.List;

public class UserDAO extends GenericDAO<User> {
    public UserDAO(String dbPath) {
        super(dbPath + "/users.txt", User::fromString);
    }
    public User getById(String id) { return super.getById(id, User::getId); }
    public void update(User user) { super.update(user, User::getId); }
    public void delete(String id) { super.delete(id, User::getId); }

    public User findByEmail(String email) {
        if (email == null) return null;
        String normalized = email.trim();
        List<User> all = getAll();
        return all.stream()
                .filter(u -> normalized.equalsIgnoreCase(u.getEmail()))
                .findFirst()
                .orElse(null);
    }
}
