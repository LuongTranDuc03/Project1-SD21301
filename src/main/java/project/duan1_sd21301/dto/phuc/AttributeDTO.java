package project.duan1_sd21301.dto.phuc;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AttributeDTO {
    private int id;
    private String code;
    private String name;
    private Integer status;
    private Date createdAt;
}
