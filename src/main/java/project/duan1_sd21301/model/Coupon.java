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
public class Coupon {
    private String id;
    private String tenChuongTrinh;
    private String loaiGiam; // PERCENT, CASH
    private double giaTriGiam;
    private double giaTriDonHangToiThieu;
    private double giamToiDa;
    private int soLuong;
    private int daSuDung;
    private Date ngayBatDau;
    private Date ngayKetThuc;
    private String moTa;
    private String trangThai; // ACTIVE, UPCOMING, EXPIRED, INACTIVE
}
