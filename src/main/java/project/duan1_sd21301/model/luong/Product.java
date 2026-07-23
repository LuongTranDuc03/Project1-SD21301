package project.duan1_sd21301.model.luong;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "san_pham")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "san_pham_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_san_pham", length = 255, nullable = false, columnDefinition = "NVARCHAR(255)")
    String name;

    @Column(name = "mo_ta", columnDefinition = "NVARCHAR(MAX)")
    String description;

    @Column(name = "doi_tuong", length = 50, columnDefinition = "NVARCHAR(50)")
    String targetGender;

    @Column(name = "xuat_xu", length = 100, columnDefinition = "NVARCHAR(100)")
    String origin;

    @Column(name = "huong_dan_bao_quan", columnDefinition = "NVARCHAR(MAX)")
    String careInstructions;

    @Column(name = "gia_ban")
    @Builder.Default
    double price = 0.0;

    @Column(name = "da_ban")
    @Builder.Default
    int sold = 0;

    @Column(name = "trang_thai", length = 50)
    @Builder.Default
    String status = "AVAILABLE";

    @Transient
    String category;

    @Transient
    String brand;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<ProductDetail> details;

    @Transient
    public int getStock() {
        if (details == null || details.isEmpty())
            return 0;
        int total = 0;
        for (ProductDetail d : details)
            total += d.getStock();
        return total;
    }

    @Transient
    public String getEffectiveStatus() {
        if (getStock() <= 0) {
            return "OUT_OF_STOCK";
        }
        return (status != null && !status.trim().isEmpty()) ? status : "AVAILABLE";
    }

    @Transient
    public String getPriceRangeFormatted() {
        if (details == null || details.isEmpty()) {
            return String.format("%,.0fđ", price).replace(",", ".");
        }
        double minPrice = Double.MAX_VALUE;
        double maxPrice = Double.MIN_VALUE;
        for (ProductDetail detail : details) {
            double p = detail.getPrice();
            if (p < minPrice)
                minPrice = p;
            if (p > maxPrice)
                maxPrice = p;
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
