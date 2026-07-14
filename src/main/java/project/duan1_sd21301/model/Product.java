package project.duan1_sd21301.model;

<<<<<<< HEAD
import java.util.List;

=======
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
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
<<<<<<< HEAD
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
=======
    private String brand;
    private String description;
    private String origin;
    private String warranty;
    private String careInstructions;
    private String status; // AVAILABLE (Còn hàng), LOW_STOCK (Sắp hết), OUT_OF_STOCK (Hết hàng)
    private String bgColor;
    private List<String> colorCircles;
    private List<ProductDetail> details; // Danh sách chi tiết sản phẩm (biến thể)

    public String getPriceRangeFormatted() {
        if (details == null || details.isEmpty()) {
            return String.format("%,.0fđ", price).replace(",", ".");
        }
        double minPrice = Double.MAX_VALUE;
        double maxPrice = Double.MIN_VALUE;
        for (ProductDetail detail : details) {
            double p = detail.getPrice();
            if (p < minPrice) minPrice = p;
            if (p > maxPrice) maxPrice = p;
        }
        if (minPrice == Double.MAX_VALUE || maxPrice == Double.MIN_VALUE) {
            return String.format("%,.0fđ", price).replace(",", ".");
        }
        if (Double.compare(minPrice, maxPrice) == 0) {
            return String.format("%,.0fđ", minPrice).replace(",", ".");
        }
        return String.format("%,.0fđ - %,.0fđ", minPrice, maxPrice).replace(",", ".");
    }
}

>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
