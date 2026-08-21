package project.duan1_sd21301.dto.pos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class PosOrderRequestDTO {
    private String id;
    private String customerCode; // "KH01" or ""
    private String customerName;
    private String customerPhone;
    
    @com.fasterxml.jackson.annotation.JsonProperty("isDelivery")
    private boolean isDelivery;
    private String recipientName;
    private String deliveryPhone;
    private String province;
    private String district;
    private String ward;
    private String deliveryAddress;
    
    private String note;
    
    private String paymentMethod; // "CASH" or "TRANSFER"
    private String discountCode;
    
    // Monetary values from client (for verification)
    private String shippingFee;
    private String customerPay;
    private String discountValue;
    
    private List<PosOrderItemDTO> items;
}
