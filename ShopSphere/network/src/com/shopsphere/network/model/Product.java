package com.shopsphere.network.model;

import java.io.Serializable;

public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private int productId;
    private String name;
    private String brand;
    private double price;
    private int stock;
    private String category;

    public Product() {}

    public Product(int productId, String name, String brand, double price, int stock, String category) {
        this.productId = productId;
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.stock = stock;
        this.category = category;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    @Override
    public String toString() {
        return "Product #" + productId + ": " + name + " (" + brand + ") - ₹" + price + " [Stock: " + stock + "]";
    }
}
