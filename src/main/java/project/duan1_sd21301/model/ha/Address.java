package project.duan1_sd21301.model.ha;

/**
 * Lớp đại diện cho địa chỉ giao hàng của khách hàng.
 * Chứa các thông tin người nhận, số điện thoại nhận và địa chỉ chi tiết.
 */
public class Address {
    // Tên của người sẽ nhận hàng tại địa chỉ này
    private String recipientName;
    
    // Số điện thoại liên hệ của người nhận hàng
    private String recipientPhone;
    
    // Chi tiết địa chỉ giao nhận (số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành)
    private String addressDetail;

    /**
     * Constructor mặc định không tham số.
     * Dùng cho việc khởi tạo đối tượng trống hoặc mapping dữ liệu tự động.
     */
    public Address() {}

    /**
     * Constructor đầy đủ tham số để khởi tạo nhanh địa chỉ mới.
     * 
     * @param recipientName   Tên người nhận hàng
     * @param recipientPhone  Số điện thoại liên hệ nhận hàng
     * @param addressDetail   Địa chỉ giao nhận chi tiết
     */
    public Address(String recipientName, String recipientPhone, String addressDetail) {
        this.recipientName = recipientName;
        this.recipientPhone = recipientPhone;
        this.addressDetail = addressDetail;
    }

    // --- GETTERS & SETTERS (Các phương thức đọc/ghi dữ liệu cho thuộc tính) ---
    
    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }
}
