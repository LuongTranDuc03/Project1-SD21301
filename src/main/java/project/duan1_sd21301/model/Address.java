package project.duan1_sd21301.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

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

    @Column(name = "dia_chi_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "tinh", length = 150, columnDefinition = "NVARCHAR(150)")
    String province;

    @Column(name = "huyen", length = 100, columnDefinition = "NVARCHAR(100)")
    String district;

    @Column(name = "xa", length = 150, columnDefinition = "NVARCHAR(150)")
    String ward;

    @Column(name = "dia_chi_chi_tiet", length = 500, columnDefinition = "NVARCHAR(500)")
    String detailedAddress;

    @Transient
    public String getFormattedAddress() {
        StringBuilder sb = new StringBuilder();
        if (detailedAddress != null && !detailedAddress.trim().isEmpty()) {
            sb.append(detailedAddress.trim());
        }
        if (ward != null && !ward.trim().isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(ward.trim());
        }
        if (district != null && !district.trim().isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(district.trim());
        }
        if (province != null && !province.trim().isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(province.trim());
        }
        return sb.toString();
    }
}
