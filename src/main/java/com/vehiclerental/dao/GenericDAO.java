package com.vehiclerental.dao;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

public class GenericDAO<T> {
    private final String filePath;
    private final Function<String, T> fromString;

    public GenericDAO(String filePath, Function<String, T> fromString) {
        this.filePath = filePath;
        this.fromString = fromString;
        ensureFileExists();
    }

    private void ensureFileExists() {
        File file = new File(filePath);
        if (!file.exists()) {
            try {
                file.getParentFile().mkdirs();
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public List<T> getAll() {
        List<T> items = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    T item = fromString.apply(line);
                    if (item != null) items.add(item);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return items;
    }

    public void saveAll(List<T> items) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            for (T item : items) {
                bw.write(item.toString());
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void add(T item) {
        List<T> items = getAll();
        items.add(item);
        saveAll(items);
    }

    public void update(T item, Function<T, String> getId) {
        List<T> items = getAll();
        String idToUpdate = getId.apply(item);
        for (int i = 0; i < items.size(); i++) {
            if (getId.apply(items.get(i)).equals(idToUpdate)) {
                items.set(i, item);
                break;
            }
        }
        saveAll(items);
    }

    public void delete(String id, Function<T, String> getId) {
        List<T> items = getAll();
        items.removeIf(item -> getId.apply(item).equals(id));
        saveAll(items);
    }

    public T getById(String id, Function<T, String> getId) {
        return getAll().stream()
                .filter(item -> getId.apply(item).equals(id))
                .findFirst()
                .orElse(null);
    }
}
