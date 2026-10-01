package com.cafeaura.model;

public class Staff extends User {
    private String shift;
    private String position;

    public Staff() {
        setRole("STAFF");
    }

    public Staff(int id, String name, String email, String password, boolean active) {
        super(id, name, email, password, "STAFF", active);
    }

    @Override
    public String getDashboardName() {
        return "Live Kitchen Queue";
    }

    public String getShift() { return shift; }
    public void setShift(String shift) { this.shift = shift; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}
