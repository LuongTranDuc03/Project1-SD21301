package project.duan1_sd21301.model.luong;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "chi_tiet_san_pham")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ProductDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "product_id")
    String productId;

    @Column(name = "size", length = 50)
    String size;

    @Column(name = "color", length = 100)
    String color;

    @Column(name = "style", length = 100)
    String style;

    @Column(name = "import_price")
    double importPrice;

    @Column(name = "price")
    double price;

    @Column(name = "promo_price")
    double promoPrice;

    @Column(name = "stock")
    int stock;

    @Column(name = "weight")
    double weight;

    @Column(name = "length")
    double length;

    @Column(name = "width")
    double width;

    @Column(name = "thickness")
    double thickness;

    @Column(name = "status", length = 50)
    String status;

    /**
     * Danh sách hình ảnh — không map trực tiếp vào DB bởi entity này.
     * Dùng @Transient để Hibernate bỏ qua field này.
     */
    @Transient
    List<String> images;
}
