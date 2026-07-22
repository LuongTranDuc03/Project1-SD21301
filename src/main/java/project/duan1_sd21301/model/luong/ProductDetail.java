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

    @Column(name = "chi_tiet_san_pham_code", length = 50, nullable = false, unique = true)
    String code;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_san_pham", nullable = false)
    Product product;

    @Column(name = "gia_ban")
    @Builder.Default
    double price = 0.0;

    @Column(name = "so_luong")
    @Builder.Default
    int stock = 0;

    @Column(name = "trong_luong")
    @Builder.Default
    double weight = 0.0;

    @Column(name = "chieu_dai")
    @Builder.Default
    double length = 0.0;

    @Column(name = "chieu_rong")
    @Builder.Default
    double width = 0.0;

    @Column(name = "do_day")
    @Builder.Default
    double thickness = 0.0;

    @Column(name = "trang_thai", length = 50)
    @Builder.Default
    String status = "AVAILABLE";

    @Transient
    String size;

    @Transient
    String color;

    @Transient
    String style;

    @Transient
    List<String> images;
}
