package project.duan1_sd21301.service.phuc;

import project.duan1_sd21301.model.phuc.Coupon;

import java.util.List;

/**
 * CouponService – Interface định nghĩa các "hành động" liên quan đến phiếu giảm giá.
 *
 * Interface là một "hợp đồng": bất kỳ class nào implements interface này
 * đều phải cài đặt đầy đủ các phương thức được khai báo ở đây.
 *
 * Lợi ích:
 *   - Controller chỉ cần biết "có thể làm gì" (interface), không cần biết "làm như thế nào"
 *   - Dễ thay thế cách cài đặt mà không sửa Controller
 */
public interface CouponService {

    // =========================================================
    //  GHI DỮ LIỆU
    // =========================================================

    /** Thêm mới một phiếu giảm giá */
    Coupon save(Coupon coupon);

    /** Cập nhật thông tin phiếu giảm giá */
    Coupon update(Coupon coupon);

    /**
     * Bật hoặc tắt trạng thái của phiếu giảm giá.
     *
     * @param id        id của phiếu giảm giá cần đổi trạng thái
     * @param newStatus trạng thái mới (ví dụ: 0 = tắt, 1 = bật)
     */
    void toggleStatus(int id, int newStatus);

    // =========================================================
    //  ĐỌC DỮ LIỆU
    // =========================================================

    /** Tìm phiếu giảm giá theo ID. Trả về null nếu không tìm thấy. */
    Coupon findById(int id);

    /** Tìm phiếu giảm giá theo mã code. Trả về null nếu không tìm thấy. */
    Coupon findByCode(String code);

    /**
     * Lấy danh sách phiếu giảm giá có lọc và phân trang.
     *
     * @param discountType null = tất cả; 0 = giảm %, 1 = giảm tiền
     * @param status       null = tất cả; 0/1/2/3 = lọc theo trạng thái
     * @param keyword      từ khóa tìm theo mã hoặc tên; null/rỗng = không lọc
     * @param page         số trang (bắt đầu từ 0)
     * @param size         số bản ghi mỗi trang
     */
    List<Coupon> findAll(Integer discountType, Integer status,
                         String keyword, String fromDate, String toDate, int page, int size);

    /**
     * Đếm tổng số phiếu giảm giá theo điều kiện lọc.
     * Dùng để tính tổng số trang cho phân trang.
     */
    long countAll(Integer discountType, Integer status, String keyword, String fromDate, String toDate);

    /**
     * Lấy danh sách phiếu giảm giá đang còn hiệu lực:
     * trạng thái bật, còn lượt dùng, và trong thời hạn.
     */
    List<Coupon> findActive();

    /**
     * Kiểm tra mã coupon đã tồn tại chưa.
     *
     * @param code      mã cần kiểm tra
     * @param excludeId khi thêm mới truyền 0; khi chỉnh sửa truyền id của chính nó
     * @return true nếu mã đã tồn tại (bị trùng)
     */
    boolean existsCode(String code, int excludeId);
}
