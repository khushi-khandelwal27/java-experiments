package com.shopsphere.rmi.remote;

import java.io.Serializable;

public class ProductDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int productId;
    private String name;
    private String brand;
    private double price;
    private int stock;

    public ProductDTO() {}

    public ProductDTO(int productId, String name, String brand, double price, int stock) {
        this.productId = productId;
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.stock = stock;
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

    @Override
    public String toString() {
        return "ProductDTO [ID=" + productId + ", Name=" + name + ", Brand=" + brand 
                + ", Price=₹" + price + ", Stock=" + stock + "]";
    }
}
