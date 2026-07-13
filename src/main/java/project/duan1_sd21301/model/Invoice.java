package project.duan1_sd21301.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {
    private String id;
    private String customerName;
    private String customerPhone;
    private String productName;
    private int quantity;
    private Date createdAt;
    private double totalAmount;
    private String paymentMethod;
    private String status; // SUCCESS, SHIPPING, PENDING, CANCELLED
}
