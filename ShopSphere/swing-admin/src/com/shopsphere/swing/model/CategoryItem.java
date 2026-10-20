package com.shopsphere.swing.model;

public class CategoryItem {
    private int id;
    private String name;
    private String description;
    private String status;

    public CategoryItem(int id, String name, String description, String status) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.status = status;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public String getStatus() { return status; }

    @Override
    public String toString() {
        return name;
    }
}
