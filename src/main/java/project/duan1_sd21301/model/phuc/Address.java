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

    // ===== Người nhận =====

    @Column(name = "nguoi_nhan", length = 150)
    String recipientName;

    @Column(name = "so_dien_thoai", length = 20)
    String phone;

    // ===== Địa chỉ =====

    @Column(name = "tinh", length = 150)
    String province;

    /**
     * @deprecated District không dùng nữa sau sáp nhập 07/2025, nhưng vẫn giữ cột trong DB (được set null)
     */
    @Column(name = "huyen", length = 100)
    @Deprecated
    String district;

    @Column(name = "xa", length = 150)
    String ward;

    @Column(name = "dia_chi_chi_tiet", columnDefinition = "NVARCHAR(500)")
    String addressDetail;

    // ===== Cài đặt =====

    @Column(name = "mac_dinh")
    Boolean isDefault;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String note;

    // ===== Quan hệ 1-N với HoaDon =====

    @OneToMany(mappedBy = "address", fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<Invoice> invoiceList;

    // ===== Helper =====

    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();
        if (addressDetail != null && !addressDetail.isBlank()) sb.append(addressDetail);
        if (ward          != null && !ward.isBlank())          sb.append(", ").append(ward);
        if (district      != null && !district.isBlank())      sb.append(", ").append(district);
        if (province      != null && !province.isBlank())      sb.append(", ").append(province);
        return sb.toString();
    }
}
