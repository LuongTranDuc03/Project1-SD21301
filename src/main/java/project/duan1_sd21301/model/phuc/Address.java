package project.duan1_sd21301.model.phuc;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "dia_chi")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "id_khach_hang")
//    @ToString.Exclude
//    @EqualsAndHashCode.Exclude
//    KhachHang khachHang;

    @Column(name = "nguoi_nhan", length = 150)
    String nguoiNhan;

    @Column(name = "so_dien_thoai", length = 20)
    String soDienThoai;

    @Column(name = "tinh", length = 100)
    String tinh;

    @Column(name = "huyen", length = 100)
    String huyen;

    @Column(name = "xa", length = 100)
    String xa;

    @Column(name = "dia_chi_chi_tiet", columnDefinition = "NVARCHAR(500)")
    String diaChiChiTiet;

    @Column(name = "mac_dinh")
    Boolean macDinh;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String ghiChu;

    // Quan hệ 1-N với HoaDon
    @OneToMany(mappedBy = "diaChi", fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private List<Invoice> invoiceList;
}
