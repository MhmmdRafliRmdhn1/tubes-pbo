package com.cafeaura.model;

public class Admin extends User {
    private int accessLevel;

    public Admin() {
        setRole("ADMIN");
        this.accessLevel = 1;
    }

    public Admin(int id, String name, String email, String password, boolean active) {
        super(id, name, email, password, "ADMIN", active);
        this.accessLevel = 1;
    }

    @Override
    public String getDashboardName() {
        return "Admin Dashboard";
    }

    public int getAccessLevel() { return accessLevel; }
    public void setAccessLevel(int accessLevel) { this.accessLevel = accessLevel; }
}
