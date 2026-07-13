package project.duan1_sd21301.model;

import java.util.Date;

public class Invoice {
    private String id;
    private String customerName;
    private String customerPhone;
    private String productName;
    private int quantity;
    private Date createdAt;
    private double totalAmount;
    private String paymentMethod;
    private String status; // SUCCESS, SHIPPING, PENDING, CANCELLED

    public Invoice() {
    }

    public Invoice(String id, String customerName, String customerPhone, String productName, int quantity,
            Date createdAt, double totalAmount, String paymentMethod, String status) {
        this.id = id;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.productName = productName;
        this.quantity = quantity;
        this.createdAt = createdAt;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.status = status;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
