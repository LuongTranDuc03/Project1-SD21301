package project.duan1_sd21301.model.ha;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "khach_hang")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "khach_hang_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ho_ten", length = 100, nullable = false, columnDefinition = "NVARCHAR(100)")
    String fullName;

    @Column(name = "email", length = 200, nullable = false, unique = true, columnDefinition = "NVARCHAR(200)")
    String email;

    @Column(name = "mat_khau", length = 255)
    String password;

    @Column(name = "so_dien_thoai", length = 20, nullable = false, columnDefinition = "NVARCHAR(20)")
    String phoneNumber;

    @Column(name = "ngay_sinh")
    Date dateOfBirth;

    @Column(name = "gioi_tinh", length = 10, columnDefinition = "NVARCHAR(10)")
    String gender;

    @Column(name = "anh_dai_dien", length = 500, columnDefinition = "NVARCHAR(500)")
    String avatar;

    @Column(name = "trang_thai", length = 50, columnDefinition = "NVARCHAR(50)")
    @Builder.Default
    String status = "Hoạt động";

    @Transient
    @Builder.Default
    List<CustomerAddress> addresses = new ArrayList<>();

    @Transient
    public CustomerAddress getDefaultAddress() {
        if (addresses == null) return null;
        for (CustomerAddress a : addresses) {
            if (a.isDefault()) return a;
        }
        return addresses.isEmpty() ? null : addresses.get(0);
    }

    @Transient
    public List<CustomerAddress> getOtherAddresses() {
        List<CustomerAddress> others = new ArrayList<>();
        if (addresses == null) return others;
        CustomerAddress def = getDefaultAddress();
        for (CustomerAddress a : addresses) {
            if (a != def) others.add(a);
        }
        return others;
    }
}
