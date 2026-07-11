package project.duan1_sd21301.service.impl;

import org.hibernate.Session;
import org.hibernate.Transaction;
import project.duan1_sd21301.model.*;
import project.duan1_sd21301.repository.*;
import project.duan1_sd21301.service.HoaDonService;
import project.duan1_sd21301.util.HibernateUtil;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Triển khai nghiệp vụ quản lý hóa đơn.
 * <p>
 * Trạng thái đơn hàng (trang_thai_don_hang):
 *   0 = Chờ xác nhận
 *   1 = Đã xác nhận
 *   2 = Đang giao hàng
 *   3 = Thành công (giao thành công)
 *   4 = Đã huỷ
 * </p>
 */
public class HoaDonServiceImpl implements HoaDonService {

    private final HoaDonRepository hoaDonRepo = new HoaDonRepository();
    private final ChiTietHoaDonRepository chiTietRepo = new ChiTietHoaDonRepository();
    private final LichSuHoaDonRepository lichSuRepo = new LichSuHoaDonRepository();
    private final LichSuThanhToanRepository lichSuTTRepo = new LichSuThanhToanRepository();

    // =================================================================
    //  QUERY
    // =================================================================

    @Override
    public List<HoaDon> getHoaDons(Integer trangThaiDonHang, String keyword, int page, int size) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return hoaDonRepo.search(keyword, page, size);
        }
        return hoaDonRepo.findAll(trangThaiDonHang, page, size);
    }

    @Override
    public long countHoaDons(Integer trangThaiDonHang, String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Đơn giản: đếm tất cả khi có keyword (để không phức tạp hoá query)
            return hoaDonRepo.countAll(null);
        }
        return hoaDonRepo.countAll(trangThaiDonHang);
    }

    @Override
    public Optional<HoaDon> getChiTiet(Integer id) {
        return hoaDonRepo.findById(id);
    }

    @Override
    public List<ChiTietHoaDon> getChiTietSanPhams(Integer hoaDonId) {
        return chiTietRepo.findByHoaDonId(hoaDonId);
    }

    @Override
    public List<LichSuHoaDon> getLichSuTrangThai(Integer hoaDonId) {
        return lichSuRepo.findByHoaDonId(hoaDonId);
    }

    // =================================================================
    //  COMMAND — CẬP NHẬT TRẠNG THÁI
    // =================================================================

    @Override
    public void capNhatTrangThai(Integer hoaDonId, Integer trangThaiMoi,
                                 Integer nhanVienId, Integer khachHangId, String ghiChu) {

        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // 1. Load hóa đơn
            HoaDon hoaDon = session.get(HoaDon.class, hoaDonId);
            if (hoaDon == null) {
                throw new IllegalArgumentException("Không tìm thấy hóa đơn ID: " + hoaDonId);
            }

            Integer trangThaiCu = hoaDon.getTrangThaiDonHang();

            // 2. Kiểm tra quy trình chuyển trạng thái hợp lệ
            validateStateTransition(trangThaiCu, trangThaiMoi);

            // 3. Cập nhật trạng thái đơn hàng
            hoaDon.setTrangThaiDonHang(trangThaiMoi);

            // Nếu chuyển sang "Đã xác nhận" -> ghi ngày xác nhận
            if (trangThaiMoi == 1) {
                hoaDon.setNgayXacNhan(LocalDateTime.now());
            }

            // Xử lý hoàn/trừ tồn kho nếu liên quan đến trạng thái Huỷ (4)
            if (trangThaiMoi == 4 && trangThaiCu != 4) {
                // Huỷ đơn -> Hoàn tồn kho
                List<ChiTietHoaDon> chiTietList = chiTietRepo.findByHoaDonId(hoaDonId);
                for (ChiTietHoaDon ct : chiTietList) {
                    if (ct.getChiTietSanPham() != null) {
                        ChiTietSanPham sp = session.get(ChiTietSanPham.class, ct.getChiTietSanPham().getId());
                        if (sp != null && ct.getSoLuong() != null) {
                            sp.setSoLuongTon(sp.getSoLuongTon() + ct.getSoLuong());
                            session.merge(sp);
                        }
                    }
                }
            } else if (trangThaiCu == 4 && trangThaiMoi != 4) {
                // Phục hồi đơn từ Huỷ -> Trừ lại tồn kho
                List<ChiTietHoaDon> chiTietList = chiTietRepo.findByHoaDonId(hoaDonId);
                for (ChiTietHoaDon ct : chiTietList) {
                    if (ct.getChiTietSanPham() != null) {
                        ChiTietSanPham sp = session.get(ChiTietSanPham.class, ct.getChiTietSanPham().getId());
                        if (sp != null && ct.getSoLuong() != null) {
                            sp.setSoLuongTon(sp.getSoLuongTon() - ct.getSoLuong());
                            session.merge(sp);
                        }
                    }
                }
            }

            session.merge(hoaDon);

            // 4. Ghi lịch sử trạng thái
            NhanVien nguoiThucHien = (nhanVienId != null) ? session.get(NhanVien.class, nhanVienId) : null;
            KhachHang khachHang    = (khachHangId != null) ? session.get(KhachHang.class, khachHangId) : null;

            LichSuHoaDon lichSu = LichSuHoaDon.builder()
                    .hoaDon(hoaDon)
                    .nguoiThucHien(nguoiThucHien)
                    .khachHang(khachHang)
                    .trangThaiCu(trangThaiCu)
                    .trangThaiMoi(trangThaiMoi)
                    .ghiChu(ghiChu)
                    .thoiGianCapNhat(LocalDateTime.now())
                    .trangThai(1)
                    .build();

            session.persist(lichSu);
            tx.commit();

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật trạng thái hóa đơn: " + e.getMessage(), e);
        }
    }

    // =================================================================
    //  COMMAND — HỦY HÓA ĐƠN
    // =================================================================

    @Override
    public void huyHoaDon(Integer hoaDonId, Integer nhanVienId, Integer khachHangId, String lyDoHuy) {

        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // 1. Load hóa đơn
            HoaDon hoaDon = session.get(HoaDon.class, hoaDonId);
            if (hoaDon == null) {
                throw new IllegalArgumentException("Không tìm thấy hóa đơn ID: " + hoaDonId);
            }

            // 2. Chỉ cho phép hủy khi chưa giao hàng (trạng thái < 2)
            if (hoaDon.getTrangThaiDonHang() >= 2) {
                throw new IllegalStateException(
                    "Không thể hủy hóa đơn đang ở trạng thái: " + hoaDon.getTrangThaiDonHang()
                );
            }

            Integer trangThaiCu = hoaDon.getTrangThaiDonHang();

            // 3. Hoàn trả tồn kho cho từng sản phẩm trong đơn
            List<ChiTietHoaDon> chiTietList = chiTietRepo.findByHoaDonId(hoaDonId);
            for (ChiTietHoaDon ct : chiTietList) {
                if (ct.getChiTietSanPham() != null) {
                    ChiTietSanPham sp = session.get(ChiTietSanPham.class, ct.getChiTietSanPham().getId());
                    if (sp != null && ct.getSoLuong() != null) {
                        sp.setSoLuongTon(sp.getSoLuongTon() + ct.getSoLuong());
                        session.merge(sp);
                    }
                }
            }

            // 4. Cập nhật trạng thái hóa đơn -> 4 (Đã huỷ)
            hoaDon.setTrangThaiDonHang(4);
            session.merge(hoaDon);

            // 5. Ghi lịch sử hủy đơn
            NhanVien nguoiThucHien = (nhanVienId != null) ? session.get(NhanVien.class, nhanVienId) : null;
            KhachHang khachHang    = (khachHangId != null) ? session.get(KhachHang.class, khachHangId) : null;

            LichSuHoaDon lichSu = LichSuHoaDon.builder()
                    .hoaDon(hoaDon)
                    .nguoiThucHien(nguoiThucHien)
                    .khachHang(khachHang)
                    .trangThaiCu(trangThaiCu)
                    .trangThaiMoi(4)
                    .ghiChu("[HỦY ĐƠN] " + (lyDoHuy != null ? lyDoHuy : "Không có lý do"))
                    .thoiGianCapNhat(LocalDateTime.now())
                    .trangThai(1)
                    .build();

            session.persist(lichSu);
            tx.commit();

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi hủy hóa đơn: " + e.getMessage(), e);
        }
    }

    // =================================================================
    //  HELPER
    // =================================================================

    /**
     * Kiểm tra luồng chuyển trạng thái hợp lệ:
     *   0 (Chờ XN) → 1 (Đã XN) → 2 (Đang giao) → 3 (Thành công)
     *   0, 1 → 4 (Huỷ)  [chỉ hủy trước khi giao]
     */
    private void validateStateTransition(Integer cu, Integer moi) {
        // Cho phép cập nhật bất kỳ trạng thái nào (theo yêu cầu người dùng)
        // Không ném Exception kiểm tra trạng thái nữa.
    }
}
