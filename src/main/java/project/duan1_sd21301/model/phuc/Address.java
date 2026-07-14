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
    String recipientName;

    @Column(name = "so_dien_thoai", length = 20)
    String phone;

    @Column(name = "tinh", length = 100)
    String province;

    @Column(name = "huyen", length = 100)
    String district;

    @Column(name = "xa", length = 100)
    String ward;

    @Column(name = "dia_chi_chi_tiet", columnDefinition = "NVARCHAR(500)")
    String addressDetail;

    @Column(name = "mac_dinh")
    Boolean isDefault;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String note;

    // Quan hệ 1-N với HoaDon — mappedBy khớp với field "address" trong Invoice
    @OneToMany(mappedBy = "address", fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<Invoice> invoiceList;
}
