package com.shopsphere.swing.model;

public class ProductItem {
    private int id;
    private int categoryId;
    private String categoryName;
    private String name;
    private String brand;
    private double price;
    private double discount;
    private int stock;
    private String status;

    public ProductItem(int id, int categoryId, String categoryName, String name, String brand, double price, double discount, int stock, String status) {
        this.id = id;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.discount = discount;
        this.stock = stock;
        this.status = status;
    }

    public int getId() { return id; }
    public int getCategoryId() { return categoryId; }
    public String getCategoryName() { return categoryName; }
    public String getName() { return name; }
    public String getBrand() { return brand; }
    public double getPrice() { return price; }
    public double getDiscount() { return discount; }
    public int getStock() { return stock; }
    public String getStatus() { return status; }
}
