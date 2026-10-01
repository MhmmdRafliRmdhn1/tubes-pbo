package com.cafeaura.model;

public class Customer extends User {
    private String address;
    private String phone;

    public Customer() {
        setRole("CUSTOMER");
    }

    public Customer(int id, String name, String email, String password, boolean active) {
        super(id, name, email, password, "CUSTOMER", active);
    }

    @Override
    public String getDashboardName() {
        return "2F Menu";
    }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}
