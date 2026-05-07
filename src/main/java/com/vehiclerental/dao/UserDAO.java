package com.vehiclerental.dao;

import com.vehiclerental.model.User;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private String filePath;

    public UserDAO(String contextPath) {
        if (contextPath != null) {
            this.filePath = contextPath + File.separator + "users.txt";
        } else {
            this.filePath = "users.txt";
        }
        File file = new File(this.filePath);
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return users;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                User user = User.fromString(line);
                if (user != null) {
                    users.add(user);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return users;
    }

    public void addUser(User user) {
        List<User> users = getAllUsers();
        int maxId = 0;
        for (User u : users) {
            if (u.getId() > maxId) maxId = u.getId();
        }
        user.setId(maxId + 1);
        users.add(user);
        saveAllUsers(users);
    }

    public User getUserById(int id) {
        List<User> users = getAllUsers();
        for (User u : users) {
            if (u.getId() == id) return u;
        }
        return null;
    }

    public void updateUser(User updatedUser) {
        List<User> users = getAllUsers();
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId() == updatedUser.getId()) {
                users.set(i, updatedUser);
                break;
            }
        }
        saveAllUsers(users);
    }

    public void deleteUser(int id) {
        List<User> users = getAllUsers();
        users.removeIf(u -> u.getId() == id);
        saveAllUsers(users);
    }

    private void saveAllUsers(List<User> users) {
        try (PrintWriter pw = new PrintWriter(new FileWriter(filePath))) {
            for (User u : users) {
                pw.println(u.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
