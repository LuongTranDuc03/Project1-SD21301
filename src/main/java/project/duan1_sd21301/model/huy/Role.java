package project.duan1_sd21301.model.huy;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "vai_tro")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_vai_tro", length = 100, nullable = false, columnDefinition = "NVARCHAR(100)")
    String roleName;

    @Column(name = "trang_thai")
    @Builder.Default
    Integer status = 1;

    public Role(int id, String roleName, int status) {
        this.id = id;
        this.roleName = roleName;
        this.status = status;
    }
}
