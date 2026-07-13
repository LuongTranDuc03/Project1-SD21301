package project.duan1_sd21301.model;

import java.util.List;

public class Product {
    private String id;
    private String category;
    private String name;
    private String englishName;
    private double price;
    private double oldPrice;
    private int discountPercent;
    private int stock;
    private int sold;
    private double rating;
    private String status; // AVAILABLE (Còn hàng), LOW_STOCK (Sắp hết), OUT_OF_STOCK (Hết hàng)
    private String bgColor;
    private List<String> colorCircles;

    public Product() {}

    public Product(String id, String category, String name, String englishName, double price, double oldPrice,
                   int discountPercent, int stock, int sold, double rating, String status, String bgColor, List<String> colorCircles) {
        this.id = id;
        this.category = category;
        this.name = name;
        this.englishName = englishName;
        this.price = price;
        this.oldPrice = oldPrice;
        this.discountPercent = discountPercent;
        this.stock = stock;
        this.sold = sold;
        this.rating = rating;
        this.status = status;
        this.bgColor = bgColor;
        this.colorCircles = colorCircles;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEnglishName() {
        return englishName;
    }

    public void setEnglishName(String englishName) {
        this.englishName = englishName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getOldPrice() {
        return oldPrice;
    }

    public void setOldPrice(double oldPrice) {
        this.oldPrice = oldPrice;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getSold() {
        return sold;
    }

    public void setSold(int sold) {
        this.sold = sold;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getBgColor() {
        return bgColor;
    }

    public void setBgColor(String bgColor) {
        this.bgColor = bgColor;
    }

    public List<String> getColorCircles() {
        return colorCircles;
    }

    public void setColorCircles(List<String> colorCircles) {
        this.colorCircles = colorCircles;
    }
}
