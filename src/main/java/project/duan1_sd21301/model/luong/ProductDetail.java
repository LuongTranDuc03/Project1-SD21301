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
     String productId;
     String size;
     String color;
     String style;
     double importPrice;
     double price;
     double promoPrice;
     int stock;
     double weight;
     double length;
     double width;
     double thickness;
     String status;
     List<String> images; // Danh sách hình ảnh nối với chi tiết sản phẩm này
}
