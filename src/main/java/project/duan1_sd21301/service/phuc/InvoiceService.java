package project.duan1_sd21301.service.phuc;

import project.duan1_sd21301.model.phuc.Invoice;
import project.duan1_sd21301.model.phuc.InvoiceDetail;
import project.duan1_sd21301.model.phuc.InvoiceHistory;
import project.duan1_sd21301.repository.phuc.InvoiceRepository;

import java.util.List;

/**
 * InvoiceService – Lớp service quản lý các nghiệp vụ liên quan đến hóa đơn.
 */
public class InvoiceService {

    private final InvoiceRepository invoiceRepository = new InvoiceRepository();

    public Invoice save(Invoice invoice) {
        return invoiceRepository.save(invoice);
    }

    public Invoice update(Invoice invoice) {
        return invoiceRepository.update(invoice);
    }

    public void softDelete(int id) {
        invoiceRepository.softDelete(id);
    }

    public void updateStatusAndSaveHistory(Invoice invoice,
                                           List<InvoiceDetail> detailList,
                                           InvoiceHistory history,
                                           boolean updateStock,
                                           boolean increaseStock) {
        invoiceRepository.updateStatusAndSaveHistory(invoice, detailList, history, updateStock, increaseStock);
    }

    public Invoice findById(int id) {
        return invoiceRepository.findById(id);
    }

    public List<InvoiceDetail> findDetailsByInvoiceId(int invoiceId) {
        return invoiceRepository.findDetailsByInvoiceId(invoiceId);
    }

    public List<InvoiceHistory> findHistoryByInvoiceId(int invoiceId) {
        return invoiceRepository.findHistoryByInvoiceId(invoiceId);
    }

    public List<Invoice> findAll(Integer orderStatus, String keyword, String fromDateStr, String toDateStr, int page, int size) {
        return invoiceRepository.findAll(orderStatus, keyword, fromDateStr, toDateStr, page, size);
    }

    public long countAll(Integer orderStatus, String keyword, String fromDateStr, String toDateStr) {
        return invoiceRepository.countAll(orderStatus, keyword, fromDateStr, toDateStr);
    }
}
