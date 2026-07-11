package project.duan1_sd21301.service;

import project.duan1_sd21301.model.ChiTietHoaDon;
import project.duan1_sd21301.model.HoaDon;
import project.duan1_sd21301.model.LichSuHoaDon;

import java.util.List;
import java.util.Optional;

/**
 * Interface định nghĩa các nghiệp vụ liên quan đến Hóa đơn.
 */
public interface HoaDonService {

    // ===== QUERY =====

    /**
     * Lấy danh sách hóa đơn có phân trang và lọc.
     *
     * @param trangThaiDonHang null = tất cả; 0=Chờ xác nhận, 1=Đã xác nhận, 2=Đang giao, 3=Thành công, 4=Huỷ
     * @param keyword          từ khóa tìm kiếm (tên KH, SĐT, email), null hoặc rỗng = bỏ qua
     * @param page             số trang (bắt đầu từ 0)
     * @param size             số phần tử mỗi trang
     */
    List<HoaDon> getHoaDons(Integer trangThaiDonHang, String keyword, int page, int size);

    /**
     * Đếm tổng số hóa đơn khớp điều kiện lọc (dùng cho phân trang).
     */
    long countHoaDons(Integer trangThaiDonHang, String keyword);

    /**
     * Xem chi tiết một hóa đơn.
     */
    Optional<HoaDon> getChiTiet(Integer id);

    /**
     * Lấy danh sách chi tiết sản phẩm của một hóa đơn.
     */
    List<ChiTietHoaDon> getChiTietSanPhams(Integer hoaDonId);

    /**
     * Lấy lịch sử trạng thái của một hóa đơn.
     */
    List<LichSuHoaDon> getLichSuTrangThai(Integer hoaDonId);

    // ===== COMMAND =====

    /**
     * Cập nhật trạng thái đơn hàng và ghi lịch sử.
     *
     * @param hoaDonId       ID hóa đơn
     * @param trangThaiMoi   trạng thái mới (0=Chờ, 1=Xác nhận, 2=Đang giao, 3=Thành công, 4=Huỷ)
     * @param nhanVienId     ID nhân viên thực hiện (null nếu khách hàng tự huỷ)
     * @param khachHangId    ID khách hàng (null nếu nhân viên thực hiện)
     * @param ghiChu         ghi chú kèm theo
     */
    void capNhatTrangThai(Integer hoaDonId, Integer trangThaiMoi,
                          Integer nhanVienId, Integer khachHangId, String ghiChu);

    /**
     * Hủy hóa đơn — hoàn lại số lượng tồn kho cho từng sản phẩm trong đơn.
     *
     * @param hoaDonId    ID hóa đơn cần hủy
     * @param nhanVienId  người thực hiện (null nếu khách hàng tự huỷ)
     * @param khachHangId người thực hiện (null nếu nhân viên huỷ)
     * @param lyDoHuy     lý do hủy đơn
     */
    void huyHoaDon(Integer hoaDonId, Integer nhanVienId, Integer khachHangId, String lyDoHuy);
}
