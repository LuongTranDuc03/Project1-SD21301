package project.duan1_sd21301.service.phuc.impl;

import project.duan1_sd21301.model.phuc.Invoice;
import project.duan1_sd21301.model.phuc.InvoiceDetail;
import project.duan1_sd21301.model.phuc.InvoiceHistory;
import project.duan1_sd21301.repository.phuc.InvoiceRepository;
import project.duan1_sd21301.service.phuc.InvoiceService;

import java.util.List;

/**
 * InvoiceServiceImpl – Lớp cài đặt cụ thể của InvoiceService.
 *
 * Lớp này:
 *   - implements InvoiceService → phải cài đặt đầy đủ các phương thức trong interface
 *   - Sử dụng InvoiceRepository để thao tác với database
 *   - Controller sẽ dùng InvoiceService (interface), không dùng trực tiếp lớp này
 */
public class InvoiceServiceImpl implements InvoiceService {

    // Service "sở hữu" một Repository để giao tiếp với database
    private final InvoiceRepository invoiceRepository = new InvoiceRepository();

    // =========================================================
    //  GHI DỮ LIỆU
    // =========================================================

    @Override
    public Invoice save(Invoice invoice) {
        return invoiceRepository.save(invoice);
    }

    @Override
    public Invoice update(Invoice invoice) {
        return invoiceRepository.update(invoice);
    }

    @Override
    public void softDelete(int id) {
        invoiceRepository.softDelete(id);
    }

    @Override
    public void updateStatusAndSaveHistory(Invoice invoice,
                                           List<InvoiceDetail> detailList,
                                           InvoiceHistory history,
                                           boolean updateStock,
                                           boolean increaseStock) {
        // Chuyển toàn bộ xuống Repository thực hiện trong một transaction
        invoiceRepository.updateStatusAndSaveHistory(invoice, detailList, history, updateStock, increaseStock);
    }

    // =========================================================
    //  ĐỌC DỮ LIỆU
    // =========================================================

    @Override
    public Invoice findById(int id) {
        return invoiceRepository.findById(id);
    }

    @Override
    public List<InvoiceDetail> findDetailsByInvoiceId(int invoiceId) {
        return invoiceRepository.findDetailsByInvoiceId(invoiceId);
    }

    @Override
    public List<InvoiceHistory> findHistoryByInvoiceId(int invoiceId) {
        return invoiceRepository.findHistoryByInvoiceId(invoiceId);
    }

    @Override
    public List<Invoice> findAll(Integer orderStatus, String keyword, String fromDateStr, String toDateStr, int page, int size) {
        return invoiceRepository.findAll(orderStatus, keyword, fromDateStr, toDateStr, page, size);
    }

    @Override
    public long countAll(Integer orderStatus, String keyword, String fromDateStr, String toDateStr) {
        return invoiceRepository.countAll(orderStatus, keyword, fromDateStr, toDateStr);
    }
}
