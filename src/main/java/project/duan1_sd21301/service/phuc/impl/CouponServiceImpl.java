package project.duan1_sd21301.service.phuc.impl;

import project.duan1_sd21301.model.phuc.Coupon;
import project.duan1_sd21301.repository.phuc.CouponRepository;
import project.duan1_sd21301.service.phuc.CouponService;

import java.util.List;

/**
 * CouponServiceImpl – Lớp cài đặt cụ thể của CouponService.
 *
 * "Impl" là viết tắt của "Implementation" (cài đặt / triển khai).
 *
 * Lớp này:
 *   - implements CouponService → phải cài đặt đầy đủ các phương thức trong interface
 *   - Sử dụng CouponRepository để thao tác với database
 *   - Đây là nơi bạn có thể thêm logic nghiệp vụ trong tương lai
 *     (ví dụ: validate thêm, gửi email thông báo, ghi log, ...)
 */
public class CouponServiceImpl implements CouponService {

    // Service "sở hữu" một Repository để giao tiếp với database
    // (Controller không biết gì về Repository, chỉ biết về Service)
    private final CouponRepository couponRepository = new CouponRepository();

    // =========================================================
    //  GHI DỮ LIỆU
    // =========================================================

    @Override
    public Coupon save(Coupon coupon) {
        // Hiện tại: chuyển thẳng xuống Repository
        // Tương lai: có thể thêm validate nghiệp vụ ở đây trước khi lưu
        return couponRepository.save(coupon);
    }

    @Override
    public Coupon update(Coupon coupon) {
        return couponRepository.update(coupon);
    }

    @Override
    public void toggleStatus(int id, int newStatus) {
        couponRepository.toggleStatus(id, newStatus);
    }

    // =========================================================
    //  ĐỌC DỮ LIỆU
    // =========================================================

    @Override
    public Coupon findById(int id) {
        return couponRepository.findById(id);
    }

    @Override
    public Coupon findByCode(String code) {
        return couponRepository.findByCode(code);
    }

    @Override
    public List<Coupon> findAll(Integer discountType, Integer status,
                                String keyword, String fromDate, String toDate, int page, int size) {
        return couponRepository.findAll(discountType, status, keyword, fromDate, toDate, page, size);
    }

    @Override
    public long countAll(Integer discountType, Integer status, String keyword, String fromDate, String toDate) {
        return couponRepository.countAll(discountType, status, keyword, fromDate, toDate);
    }

    @Override
    public List<Coupon> findActive() {
        return couponRepository.findActive();
    }

    @Override
    public boolean existsCode(String code, int excludeId) {
        return couponRepository.existsCode(code, excludeId);
    }
}
