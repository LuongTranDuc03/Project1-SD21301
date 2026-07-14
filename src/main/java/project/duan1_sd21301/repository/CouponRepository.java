package project.duan1_sd21301.repository;

import project.duan1_sd21301.model.Coupon;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class CouponRepository implements BaseRepository<Coupon, String> {

    private static final List<Coupon> coupons = new CopyOnWriteArrayList<>();

    static {
        // Khởi tạo một số dữ liệu ảo ban đầu
        coupons.add(new Coupon("PGG-SUMMER26", "Chào Hè Rực Rỡ 2026", "PERCENT", 15.0, 500000.0, 100000.0, 100, 45, parseDate("2026-06-01 00:00"), parseDate("2026-08-31 23:59"), "Giảm giá 15% cho tất cả đơn hàng từ 500k trở lên trong mùa hè 2026.", "ACTIVE"));
        coupons.add(new Coupon("PGG-FAMI50K", "Tri Ân Khách Hàng Thân Thiết", "CASH", 50000.0, 300000.0, 50000.0, 200, 120, parseDate("2026-07-01 00:00"), parseDate("2026-07-31 23:59"), "Giảm ngay 50.000đ cho khách hàng thân thiết của FamiCoats.", "ACTIVE"));
        coupons.add(new Coupon("PGG-FALL26", "Bộ Sưu Tập Mùa Thu 2026", "PERCENT", 20.0, 1000000.0, 300000.0, 50, 0, parseDate("2026-09-01 00:00"), parseDate("2026-10-31 23:59"), "Giảm giá ra mắt sản phẩm mới mùa thu 2026.", "UPCOMING"));
        coupons.add(new Coupon("PGG-NEWYEAR26", "Mừng Năm Mới 2026", "CASH", 100000.0, 800000.0, 100000.0, 80, 80, parseDate("2026-01-01 00:00"), parseDate("2026-01-15 23:59"), "Khuyến mãi chào mừng xuân Bính Ngọ 2026.", "EXPIRED"));
        coupons.add(new Coupon("PGG-OFFLINE", "Khuyến mãi Offline tại cửa hàng", "PERCENT", 10.0, 200000.0, 50000.0, 150, 22, parseDate("2026-05-01 00:00"), parseDate("2026-12-31 23:59"), "Chương trình giảm giá tạm dừng để nâng cấp hệ thống.", "INACTIVE"));
    }

    private static Date parseDate(String dateStr) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(dateStr);
        } catch (Exception e) {
            return new Date();
        }
    }

    @Override
    public List<Coupon> findAll() {
        // Trả về danh sách được sắp xếp hoặc bản sao để an toàn luồng
        List<Coupon> list = new ArrayList<>(coupons);
        // Sắp xếp mã mới nhất lên trước (hoặc theo ý muốn)
        return list;
    }

    @Override
    public Coupon findById(String id) {
        if (id == null) return null;
        for (Coupon c : coupons) {
            if (c.getId().equalsIgnoreCase(id)) {
                return c;
            }
        }
        return null;
    }

    @Override
    public boolean insert(Coupon entity) {
        if (entity == null || entity.getId() == null) return false;
        if (findById(entity.getId()) != null) return false; // Trùng mã
        return coupons.add(entity);
    }

    @Override
    public boolean update(Coupon entity) {
        if (entity == null || entity.getId() == null) return false;
        for (int i = 0; i < coupons.size(); i++) {
            if (coupons.get(i).getId().equalsIgnoreCase(entity.getId())) {
                coupons.set(i, entity);
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean delete(String id) {
        if (id == null) return false;
        for (Coupon c : coupons) {
            if (c.getId().equalsIgnoreCase(id)) {
                return coupons.remove(c);
            }
        }
        return false;
    }
}
