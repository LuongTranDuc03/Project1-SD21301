package project.duan1_sd21301.model.luong;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "san_pham")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public  class Product {
     @Id
     @GeneratedValue(strategy = GenerationType.IDENTITY)
     int id;
     String code;
     String category;
     String name;
     String englishName;
     double price;
     double oldPrice;
     int discountPercent;
     int stock;
     int sold;
     double rating;
     String brand;
     String description;
     String origin;
     String warranty;
     String careInstructions;
     String status; // AVAILABLE (Còn hàng), LOW_STOCK (Sắp hết), OUT_OF_STOCK (Hết hàng)
     String bgColor;
     List<String> colorCircles;
     List<ProductDetail> details; // Danh sách chi tiết sản phẩm (biến thể)

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

