package project.duan1_sd21301.model.huy;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import project.duan1_sd21301.model.Address;

import java.util.Date;

@Entity
@Table(name = "nhan_vien")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "nhan_vien_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_nhan_vien", length = 150, nullable = false, columnDefinition = "NVARCHAR(150)")
    String fullName;

    @Column(name = "email", length = 200, nullable = false, unique = true, columnDefinition = "NVARCHAR(200)")
    String email;

    @Column(name = "mat_khau", length = 255)
    String password;

    @Column(name = "so_dien_thoai", length = 20, columnDefinition = "NVARCHAR(20)")
    String phoneNumber;

    @Column(name = "ngay_sinh")
    Date birthday;

    @Column(name = "gioi_tinh")
    Boolean gender;

    @Column(name = "anh_dai_dien", length = 500, columnDefinition = "NVARCHAR(500)")
    String avatar;

    @Column(name = "trang_thai")
    @Builder.Default
    Integer status = 1;

    @Column(name = "cccd", length = 20)
    String cccd;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_dia_chi")
    Address address;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_vai_tro")
    Role role;

    @Transient
    public void setAddress(String addressStr) {
        if (addressStr != null && !addressStr.trim().isEmpty()) {
            this.address = Address.builder().detailedAddress(addressStr.trim()).build();
        } else {
            this.address = null;
        }
    }

    @Transient
    public String getFullAddressString() {
        return (address != null) ? address.getFormattedAddress() : "";
    }

    @Transient
    public int getRoleId() {
        return (role != null) ? role.getId() : 0;
    }

    @Transient
    public String getRoleName() {
        return (role != null && role.getRoleName() != null) ? role.getRoleName() : "";
    }
}
