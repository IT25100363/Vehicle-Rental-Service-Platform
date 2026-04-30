package service;

import model.User;

import java.io.*;
import java.util.*;

public class UserService {

    private final String FILE_PATH = "users.txt";

    private File getFile() {
        return new File(FILE_PATH);
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(getFile()))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                list.add(new User(
                        Integer.parseInt(data[0]),
                        data[1],
                        data[2]
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addUser(User user) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(getFile(), true))) {
            bw.write(user.toString());
            bw.newLine();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteUser(int id) {
        List<User> users = getAllUsers();
        users.removeIf(u -> u.getId() == id);
        saveAll(users);
    }

    public void updateUser(int id, String name, String email) {
        List<User> users = getAllUsers();

        for (User u : users) {
            if (u.getId() == id) {
                u.setName(name);
                u.setEmail(email);
            }
        }

        saveAll(users);
    }

    private void saveAll(List<User> users) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(getFile()))) {
            for (User u : users) {
                bw.write(u.toString());
                bw.newLine();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
