package project.duan1_sd21301.model.luong;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product {
    private String id;
    private String category;
    private String name;
    private double price;
    private int sold;

    private String brand;
    private String description;
    private String origin;

    private String careInstructions;
    private String status; // AVAILABLE (Còn hàng), OUT_OF_STOCK (Hết hàng)
    private List<ProductDetail> details; // Danh sách chi tiết sản phẩm (biến thể)

    // Tính tổng stock từ các biến thể
    public int getStock() {
        if (details == null || details.isEmpty()) return 0;
        int total = 0;
        for (ProductDetail d : details) total += d.getStock();
        return total;
    }

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

