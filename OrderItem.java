package com.cafeaura.model;

import java.math.BigDecimal;

public class OrderItem {
    private int id;
    private int orderId;
    private int menuId;
    private String menuName;
    private int quantity;
    private BigDecimal priceEach;
    private BigDecimal subtotal;

    public OrderItem() {
    }

    public OrderItem(int menuId, String menuName, int quantity, BigDecimal priceEach) {
        this.menuId = menuId;
        this.menuName = menuName;
        this.quantity = quantity;
        this.priceEach = priceEach;
        this.subtotal = getSubtotal();
    }

    public BigDecimal getSubtotal() {
        if (priceEach == null) {
            return BigDecimal.ZERO;
        }
        return priceEach.multiply(BigDecimal.valueOf(quantity));
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }

    public String getMenuName() { return menuName; }
    public void setMenuName(String menuName) { this.menuName = menuName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPriceEach() { return priceEach; }
    public void setPriceEach(BigDecimal priceEach) { this.priceEach = priceEach; }

    public BigDecimal getSubtotalValue() { return subtotal; }
    public void setSubtotalValue(BigDecimal subtotal) { this.subtotal = subtotal; }
}
