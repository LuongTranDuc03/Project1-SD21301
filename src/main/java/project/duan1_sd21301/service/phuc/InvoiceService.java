package project.duan1_sd21301.service.phuc;

import project.duan1_sd21301.model.phuc.Invoice;
import project.duan1_sd21301.model.phuc.InvoiceDetail;
import project.duan1_sd21301.model.phuc.InvoiceHistory;

import java.util.List;

/**
 * InvoiceService – Interface định nghĩa các "hành động" liên quan đến hóa đơn.
 *
 * Controller sẽ gọi các phương thức trong interface này để thực hiện nghiệp vụ.
 * Lớp InvoiceServiceImpl sẽ cài đặt (implements) chi tiết từng phương thức.
 */
public interface InvoiceService {

    // =========================================================
    //  GHI DỮ LIỆU
    // =========================================================

    /** Thêm mới một hóa đơn vào database */
    Invoice save(Invoice invoice);

    /** Cập nhật thông tin hóa đơn */
    Invoice update(Invoice invoice);

    /** Xóa mềm hóa đơn: đặt status = 0, không xóa dữ liệu thật */
    void softDelete(int id);

    /**
     * Cập nhật trạng thái hóa đơn, xử lý tồn kho, và ghi lịch sử trong một lần.
     * Tất cả thực hiện trong một transaction để đảm bảo tính toàn vẹn dữ liệu.
     *
     * @param invoice       hóa đơn đã được set trạng thái mới
     * @param detailList    danh sách sản phẩm trong đơn (để tính số lượng tồn kho)
     * @param history       bản ghi lịch sử cần lưu
     * @param updateStock   true = có thay đổi tồn kho
     * @param increaseStock true = hoàn kho (hủy đơn); false = trừ kho (phục hồi đơn)
     */
    void updateStatusAndSaveHistory(Invoice invoice,
                                    List<InvoiceDetail> detailList,
                                    InvoiceHistory history,
                                    boolean updateStock,
                                    boolean increaseStock);

    // =========================================================
    //  ĐỌC DỮ LIỆU
    // =========================================================

    /** Tìm hóa đơn theo ID (kèm địa chỉ và phương thức thanh toán). Trả về null nếu không thấy. */
    Invoice findById(int id);

    /** Lấy danh sách sản phẩm chi tiết trong một hóa đơn */
    List<InvoiceDetail> findDetailsByInvoiceId(int invoiceId);

    /** Lấy lịch sử thay đổi trạng thái của một hóa đơn (mới nhất lên trước) */
    List<InvoiceHistory> findHistoryByInvoiceId(int invoiceId);

    /**
     * Lấy danh sách hóa đơn có lọc và phân trang.
     *
     * @param orderStatus null = tất cả; 0/1/2/3/4 = lọc theo trạng thái
     * @param keyword     tìm theo tên KH, SĐT, mã hóa đơn; null/rỗng = không lọc
     * @param page        số trang (bắt đầu từ 0)
     * @param size        số bản ghi mỗi trang
     */
    List<Invoice> findAll(Integer orderStatus, String keyword, int page, int size);

    /**
     * Đếm tổng số hóa đơn theo điều kiện lọc.
     * Dùng để tính tổng số trang cho phân trang.
     */
    long countAll(Integer orderStatus, String keyword);
}
