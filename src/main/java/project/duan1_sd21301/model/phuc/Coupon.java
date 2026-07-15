package project.duan1_sd21301.model.phuc;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "phieu_giam_gia")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Coupon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "ma_phieu", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_chuong_trinh", length = 255, nullable = false, columnDefinition = "NVARCHAR(255)")
    String name;

    @Column(name = "loai_giam", nullable = false)
    Integer discountType;

    @Column(name = "gia_tri_giam", nullable = false)
    Double discountValue;

    @Column(name = "gia_tri_don_hang_toi_thieu")
    Double minOrderValue;

    @Column(name = "giam_toi_da")
    Double maxDiscountAmount;

    @Column(name = "so_luong")
    Integer quantity;

    @Column(name = "da_su_dung")
    @Builder.Default
    Integer usedQuantity = 0;

    @Column(name = "ngay_bat_dau")
    LocalDate startDate;

    @Column(name = "ngay_ket_thuc")
    LocalDate endDate;

    @Column(name = "mo_ta", columnDefinition = "NVARCHAR(MAX)")
    String description;

    @Column(name = "trang_thai")
    @Builder.Default
    Integer status = 1;

    @Column(name = "ngay_tao")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();

    @OneToMany(mappedBy = "coupon", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<Invoice> invoices;

    @Transient
    public int getRemainingQuantity() {
        int total = quantity != null ? quantity : 0;
        int used  = usedQuantity != null ? usedQuantity : 0;
        return Math.max(0, total - used);
    }
}
