package project.duan1_sd21301.model.ha;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import project.duan1_sd21301.model.Address;

@Entity
@Table(name = "khach_hang_dia_chi")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CustomerAddress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_khach_hang", nullable = false)
    Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_dia_chi", nullable = false)
    Address address;

    @Column(name = "nguoi_nhan", length = 150, columnDefinition = "NVARCHAR(150)")
    String recipientName;

    @Column(name = "so_dien_thoai", length = 20, columnDefinition = "NVARCHAR(20)")
    String phoneNumber;

    @Column(name = "mac_dinh")
    @Builder.Default
    boolean isDefault = false;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String note;

    @Transient
    public String getFormattedAddress() {
        return address != null ? address.getFormattedAddress() : "";
    }

    @Transient
    public String getProvince() { return address != null ? address.getProvince() : null; }
    @Transient
    public String getDistrict() { return address != null ? address.getDistrict() : null; }
    @Transient
    public String getWard() { return address != null ? address.getWard() : null; }
    @Transient
    public String getDetailedAddress() { return address != null ? address.getDetailedAddress() : null; }
    @Transient
    public String getCode() { return address != null ? address.getCode() : null; }
}
