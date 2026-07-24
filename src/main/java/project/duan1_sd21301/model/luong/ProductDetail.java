package project.duan1_sd21301.model.luong;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;
import java.time.LocalDateTime;

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

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_san_pham", nullable = false)
    Product product;

    @Column(name = "ma_vach", length = 100)
    String barcode;

    @Column(name = "gia_goc")
    @Builder.Default
    double costPrice = 0.0;

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

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_kich_thuoc")
    Size size;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_mau_sac")
    Color color;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_kieu_dang")
    Style style;

    @Column(name = "created_at")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    @Builder.Default
    LocalDateTime updatedAt = LocalDateTime.now();

    @OneToMany(mappedBy = "productDetail", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<Image> images;
}
