package com.shopsphere.swing.model;

public class UserItem {
    private int userId;
    private String name;
    private String email;
    private String mobile;
    private String role;
    private String status;

    public UserItem(int userId, String name, String email, String mobile, String role, String status) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.mobile = mobile;
        this.role = role;
        this.status = status;
    }

    public int getUserId() { return userId; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getMobile() { return mobile; }
    public String getRole() { return role; }
    public String getStatus() { return status; }
}
