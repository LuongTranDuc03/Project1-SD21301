package project.duan1_sd21301.service.phuc;

import project.duan1_sd21301.model.phuc.Coupon;
import project.duan1_sd21301.repository.phuc.CouponRepository;

import java.util.List;

/**
 * CouponService – Lớp service quản lý các nghiệp vụ liên quan đến phiếu giảm giá.
 */
public class CouponService {

    private final CouponRepository couponRepository = new CouponRepository();

    public Coupon save(Coupon coupon) {
        return couponRepository.save(coupon);
    }

    public Coupon update(Coupon coupon) {
        return couponRepository.update(coupon);
    }

    public void toggleStatus(int id, int newStatus) {
        couponRepository.toggleStatus(id, newStatus);
    }

    public void updateExpiredCoupons() {
        couponRepository.updateExpiredCoupons();
    }

    public Coupon findById(int id) {
        return couponRepository.findById(id);
    }

    public Coupon findByCode(String code) {
        return couponRepository.findByCode(code);
    }

    public List<Coupon> findAll(Integer discountType, Integer status,
                                String keyword, String fromDate, String toDate, int page, int size) {
        return couponRepository.findAll(discountType, status, keyword, fromDate, toDate, page, size);
    }

    public long countAll(Integer discountType, Integer status, String keyword, String fromDate, String toDate) {
        return couponRepository.countAll(discountType, status, keyword, fromDate, toDate);
    }

    public List<Coupon> findActive() {
        return couponRepository.findActive();
    }

    public boolean existsCode(String code, int excludeId) {
        return couponRepository.existsCode(code, excludeId);
    }
}
