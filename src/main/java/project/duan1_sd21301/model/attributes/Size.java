package project.duan1_sd21301.model.attributes;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import java.util.Date;

@Entity
@Table(name = "kich_thuoc")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Size {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "kich_thuoc_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_kich_thuoc", length = 50, nullable = false)
    String name;

    @Column(name = "thu_tu")
    @Builder.Default
    Integer order = 0;

    @Column(name = "trang_thai")
    @Builder.Default
    Integer status = 1;

    @Column(name = "created_at", insertable = false, updatable = false)
    Date createdAt;
}

