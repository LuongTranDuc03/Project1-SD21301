package project.duan1_sd21301.service.impl;

import project.duan1_sd21301.model.*;
import project.duan1_sd21301.repository.*;
import project.duan1_sd21301.service.HoaDonService;

import java.time.LocalDateTime;
import java.util.List;

public class HoaDonServiceImpl implements HoaDonService {

    // Khai báo các repository cần dùng
    private HoaDonRepository       hoaDonRepo  = new HoaDonRepository();
    private ChiTietHoaDonRepository chiTietRepo = new ChiTietHoaDonRepository();
    private LichSuHoaDonRepository  lichSuRepo  = new LichSuHoaDonRepository();

    // =====================================================
    //  QUERY
    // =====================================================

    @Override
    public List<HoaDon> getHoaDons(Integer trangThai, String keyword, int page, int size) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return hoaDonRepo.search(keyword, page, size);
        }
        return hoaDonRepo.findAll(trangThai, page, size);
    }

    @Override
    public long countHoaDons(Integer trangThai, String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return hoaDonRepo.countSearch(keyword);
        }
        return hoaDonRepo.countAll(trangThai);
    }

    @Override
    public HoaDon getChiTiet(int id) {
        return hoaDonRepo.findById(id);
    }

    @Override
    public List<ChiTietHoaDon> getChiTietSanPhams(int hoaDonId) {
        return chiTietRepo.findByHoaDonId(hoaDonId);
    }

    @Override
    public List<LichSuHoaDon> getLichSuTrangThai(int hoaDonId) {
        return lichSuRepo.findByHoaDonId(hoaDonId);
    }

    // =====================================================
    //  COMMAND — CẬP NHẬT TRẠNG THÁI
    // =====================================================

    @Override
    public void capNhatTrangThai(int hoaDonId, int trangThaiMoi,
                                 Integer nhanVienId, Integer khachHangId, String ghiChu) {

        // 1. Lấy hóa đơn
        HoaDon hoaDon = hoaDonRepo.findById(hoaDonId);
        if (hoaDon == null) {
            throw new IllegalArgumentException("Không tìm thấy hóa đơn ID: " + hoaDonId);
        }

        int trangThaiCu = hoaDon.getTrangThaiDonHang();

        // 2. Cập nhật trạng thái mới
        hoaDon.setTrangThaiDonHang(trangThaiMoi);
        if (trangThaiMoi == 1) {
            hoaDon.setNgayXacNhan(LocalDateTime.now()); // Đã xác nhận → ghi ngày xác nhận
        }

        // 3. Xác định có cần xử lý tồn kho không
        boolean xuLyKho   = false;
        boolean tangTonKho = false;

        if (trangThaiMoi == 4 && trangThaiCu != 4) {
            // Chuyển sang Hủy → hoàn lại tồn kho
            xuLyKho    = true;
            tangTonKho = true;
        } else if (trangThaiCu == 4 && trangThaiMoi != 4) {
            // Phục hồi từ Hủy → trừ lại tồn kho
            xuLyKho    = true;
            tangTonKho = false;
        }

        List<ChiTietHoaDon> chiTietList = null;
        if (xuLyKho) {
            chiTietList = chiTietRepo.findByHoaDonId(hoaDonId);
        }

        // 4. Tạo bản ghi lịch sử
        LichSuHoaDon lichSu = taoLichSu(hoaDon, nhanVienId, khachHangId,
                                          trangThaiCu, trangThaiMoi, ghiChu);

        // 5. Giao cho Repository lưu vào DB (1 transaction)
        hoaDonRepo.capNhatTrangThaiVaGhiLichSu(hoaDon, chiTietList, lichSu, xuLyKho, tangTonKho);
    }

    // =====================================================
    //  COMMAND — HỦY HÓA ĐƠN
    // =====================================================

    @Override
    public void huyHoaDon(int hoaDonId, Integer nhanVienId, Integer khachHangId, String lyDoHuy) {

        // 1. Lấy hóa đơn
        HoaDon hoaDon = hoaDonRepo.findById(hoaDonId);
        if (hoaDon == null) {
            throw new IllegalArgumentException("Không tìm thấy hóa đơn ID: " + hoaDonId);
        }

        // 2. Chỉ hủy được khi chưa giao hàng (trạng thái < 2)
        if (hoaDon.getTrangThaiDonHang() >= 2) {
            throw new IllegalStateException(
                "Không thể hủy đơn đang ở trạng thái: " + hoaDon.getTrangThaiDonHang()
            );
        }

        int trangThaiCu = hoaDon.getTrangThaiDonHang();

        // 3. Đặt trạng thái → 4 (Đã huỷ)
        hoaDon.setTrangThaiDonHang(4);

        // 4. Lấy chi tiết sản phẩm để hoàn kho
        List<ChiTietHoaDon> chiTietList = chiTietRepo.findByHoaDonId(hoaDonId);

        // 5. Tạo bản ghi lịch sử hủy
        String ghiChu = "[HỦY ĐƠN] " + (lyDoHuy != null ? lyDoHuy : "Không có lý do");
        LichSuHoaDon lichSu = taoLichSu(hoaDon, nhanVienId, khachHangId,
                                          trangThaiCu, 4, ghiChu);

        // 6. Lưu vào DB (hoàn kho + ghi lịch sử trong 1 transaction)
        hoaDonRepo.capNhatTrangThaiVaGhiLichSu(hoaDon, chiTietList, lichSu,
                                                true, true);
    }

    // =====================================================
    //  HELPER
    // =====================================================

    // Tạo một bản ghi lịch sử hóa đơn
    private LichSuHoaDon taoLichSu(HoaDon hoaDon, Integer nhanVienId, Integer khachHangId,
                                    int trangThaiCu, int trangThaiMoi, String ghiChu) {
        LichSuHoaDon lichSu = new LichSuHoaDon();
        lichSu.setHoaDon(hoaDon);
        lichSu.setTrangThaiCu(trangThaiCu);
        lichSu.setTrangThaiMoi(trangThaiMoi);
        lichSu.setGhiChu(ghiChu);
        lichSu.setThoiGianCapNhat(LocalDateTime.now());
        lichSu.setTrangThai(1);

        // Gán nhân viên nếu có
        if (nhanVienId != null) {
            NhanVien nv = new NhanVien();
            nv.setId(nhanVienId);
            lichSu.setNguoiThucHien(nv);
        }

        // Gán khách hàng nếu có
        if (khachHangId != null) {
            KhachHang kh = new KhachHang();
            kh.setId(khachHangId);
            lichSu.setKhachHang(kh);
        }

        return lichSu;
    }
}
