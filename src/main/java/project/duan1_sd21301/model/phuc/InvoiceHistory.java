package project.duan1_sd21301.model.phuc;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Entity
@Table(name = "lich_su_hoa_don")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class InvoiceHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_hoa_don", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    Invoice invoice;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "id_nguoi_thuc_hien")
//    @ToString.Exclude
//    @EqualsAndHashCode.Exclude
//    NhanVien nguoiThucHien;
//
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "id_khach_hang")
//    @ToString.Exclude
//    @EqualsAndHashCode.Exclude
//    KhachHang khachHang;

    @Column(name = "trang_thai_cu")
    int oldStatus;

    @Column(name = "trang_thai_moi")
    int newStatus;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String note;

    @Column(name = "thoi_gian_cap_nhat")
    LocalDateTime updatedAt;

    @Column(name = "trang_thai")
    int status; // 1: Active, 0: Inactive
}
