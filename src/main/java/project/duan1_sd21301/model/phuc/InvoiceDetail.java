package project.duan1_sd21301.model.phuc;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import lombok.experimental.FieldDefaults;
import java.time.LocalDateTime;
import project.duan1_sd21301.model.luong.ProductDetail;

@Entity
@Table(name = "chi_tiet_hoa_don")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class InvoiceDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "chi_tiet_hoa_don_code", length = 50, nullable = false, unique = true)
    String code;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_hoa_don", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    Invoice invoice;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_chi_tiet_san_pham")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    ProductDetail productDetail;

    @Column(name = "ten_sp_tai_thoi_diem", columnDefinition = "NVARCHAR(255)")
    String productNameSnapshot;

    @Column(name = "mo_ta_variant", columnDefinition = "NVARCHAR(255)")
    String variantDescriptionSnapshot;

    @Column(name = "mau_sac_snapshot", columnDefinition = "NVARCHAR(100)")
    String colorSnapshot;

    @Column(name = "kich_thuoc_snapshot", columnDefinition = "NVARCHAR(20)")
    String sizeSnapshot;

    @Column(name = "kieu_dang_snapshot", columnDefinition = "NVARCHAR(100)")
    String styleSnapshot;

    @Column(name = "don_gia")
    Double unitPrice;

    @Column(name = "gia_giam")
    Double discountPrice;

    @Column(name = "so_luong")
    int quantity;

    @Column(name = "thanh_tien")
    Double totalPrice;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String note;

    @Column(name = "created_at")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();
}

