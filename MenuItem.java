package com.cafeaura.model;

import java.math.BigDecimal;

public class MenuItem {
    private int id;
    private String name;
    private String category;
    private BigDecimal price;
    private int stock;
    private boolean available;
    private String imageUrl;

    public MenuItem() {
    }

    public MenuItem(int id, String name, String category, BigDecimal price, int stock, boolean available, String imageUrl) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.price = price;
        this.stock = stock;
        this.available = available;
        this.imageUrl = imageUrl;
    }

    public String getDetails() {
        return name + " - " + category + " - Rp " + price;
    }

    public void updateStock(int qty) {
        this.stock = Math.max(0, this.stock - qty);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
