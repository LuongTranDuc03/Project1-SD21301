package project.duan1_sd21301.service;

import project.duan1_sd21301.model.ChiTietHoaDon;
import project.duan1_sd21301.model.HoaDon;
import project.duan1_sd21301.model.LichSuHoaDon;

import java.util.List;

public interface HoaDonService {

    // Lấy danh sách hóa đơn (có lọc trạng thái + tìm kiếm + phân trang)
    List<HoaDon> getHoaDons(Integer trangThai, String keyword, int page, int size);

    // Đếm tổng số hóa đơn (dùng để tính số trang)
    long countHoaDons(Integer trangThai, String keyword);

    // Lấy chi tiết một hóa đơn theo ID (trả về null nếu không tìm thấy)
    HoaDon getChiTiet(int id);

    // Lấy danh sách sản phẩm trong hóa đơn
    List<ChiTietHoaDon> getChiTietSanPhams(int hoaDonId);

    // Lấy lịch sử thay đổi trạng thái của hóa đơn
    List<LichSuHoaDon> getLichSuTrangThai(int hoaDonId);

    // Cập nhật trạng thái đơn hàng và tự động ghi lịch sử
    void capNhatTrangThai(int hoaDonId, int trangThaiMoi,
                          Integer nhanVienId, Integer khachHangId, String ghiChu);

    // Hủy hóa đơn (hoàn tồn kho + ghi lịch sử)
    void huyHoaDon(int hoaDonId, Integer nhanVienId, Integer khachHangId, String lyDoHuy);
}
