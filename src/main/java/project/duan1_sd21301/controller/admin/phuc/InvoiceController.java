package project.duan1_sd21301.controller.admin.phuc;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.phuc.Invoice;
import project.duan1_sd21301.model.phuc.InvoiceDetail;
import project.duan1_sd21301.model.phuc.InvoiceHistory;
import project.duan1_sd21301.repository.phuc.InvoiceRepository;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet quản lý hóa đơn.
 *  GET  /admin/invoices               → danh sách (phân trang, tìm kiếm, lọc trạng thái)
 *  GET  /admin/invoices/detail        → chi tiết hóa đơn (?id=...)
 *  GET  /admin/invoices/print         → trang in hóa đơn (?id=...)
 *  POST /admin/invoices/update-status → cập nhật trạng thái đơn hàng
 */
@WebServlet(name = "InvoiceController", urlPatterns = {
        "/admin/invoices",
        "/admin/invoices/detail",
        "/admin/invoices/print",
        "/admin/invoices/update-status"
})
public class InvoiceController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    /** Nhãn trạng thái đơn hàng */
    private static final Map<Integer, String> ORDER_STATUS_LABELS;
    static {
        ORDER_STATUS_LABELS = new LinkedHashMap<>();
        ORDER_STATUS_LABELS.put(0, "Chờ xác nhận");
        ORDER_STATUS_LABELS.put(1, "Đã xác nhận");
        ORDER_STATUS_LABELS.put(2, "Đang giao hàng");
        ORDER_STATUS_LABELS.put(3, "Hoàn thành");
        ORDER_STATUS_LABELS.put(4, "Đã huỷ");
    }

    private final InvoiceRepository invoiceRepo = new InvoiceRepository();

    // =====================================================================
    // GET
    // =====================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.endsWith("/detail")) {
            handleDetail(request, response);
        } else if (uri.endsWith("/print")) {
            handlePrint(request, response);
        } else {
            handleList(request, response);
        }
    }

    // =====================================================================
    // POST
    // =====================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/update-status")) {
            handleUpdateStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // =====================================================================
    // Handlers
    // =====================================================================

    /** Trang danh sách hóa đơn với phân trang, lọc và tìm kiếm */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");
        if (keyword != null && keyword.trim().isEmpty()) keyword = null;

        Integer orderStatus = null;
        String ttParam = request.getParameter("trangThai");
        if (ttParam != null && !ttParam.isEmpty()) {
            try { orderStatus = Integer.parseInt(ttParam); }
            catch (NumberFormatException ignored) { }
        }

        int page = 0;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try { page = Math.max(0, Integer.parseInt(pageParam)); }
            catch (NumberFormatException ignored) { }
        }

        long total      = invoiceRepo.countAll(orderStatus, keyword);
        int totalPages  = (int) Math.ceil((double) total / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;
        page = Math.min(page, totalPages - 1);

        List<Invoice> invoices = invoiceRepo.findAll(orderStatus, keyword, page, PAGE_SIZE);

        request.setAttribute("invoices",           invoices);
        request.setAttribute("orderStatusLabels",  ORDER_STATUS_LABELS);
        request.setAttribute("total",              total);
        request.setAttribute("page",               page);
        request.setAttribute("size",               PAGE_SIZE);
        request.setAttribute("totalPages",         totalPages);
        request.setAttribute("currentOrderStatus", orderStatus);
        request.setAttribute("keyword",            keyword);
        request.setAttribute("pageTitle",          "Quản lý hóa đơn");

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/invoice-list.jsp")
                .forward(request, response);
    }

    /** Trang chi tiết một hóa đơn */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseIdParam(request);
        if (id < 0) { response.sendRedirect(request.getContextPath() + "/admin/invoices"); return; }

        Invoice invoice = invoiceRepo.findById(id);
        if (invoice == null) { response.sendRedirect(request.getContextPath() + "/admin/invoices"); return; }

        List<InvoiceDetail>  detailList  = invoiceRepo.findDetailsByInvoiceId(id);
        List<InvoiceHistory> historyList = invoiceRepo.findHistoryByInvoiceId(id);

        request.setAttribute("invoice",           invoice);
        request.setAttribute("detailList",        detailList);
        request.setAttribute("historyList",       historyList);
        request.setAttribute("orderStatusLabels", ORDER_STATUS_LABELS);
        request.setAttribute("pageTitle",         "Chi tiết hóa đơn #HD-" + id);

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/invoice-detail.jsp")
                .forward(request, response);
    }

    /** Trang in hóa đơn */
    private void handlePrint(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseIdParam(request);
        if (id < 0) { response.sendRedirect(request.getContextPath() + "/admin/invoices"); return; }

        Invoice invoice = invoiceRepo.findById(id);
        if (invoice == null) { response.sendRedirect(request.getContextPath() + "/admin/invoices"); return; }

        List<InvoiceDetail> detailList = invoiceRepo.findDetailsByInvoiceId(id);

        request.setAttribute("invoice",           invoice);
        request.setAttribute("detailList",        detailList);
        request.setAttribute("orderStatusLabels", ORDER_STATUS_LABELS);

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/invoice-print.jsp")
                .forward(request, response);
    }

    /** Cập nhật trạng thái đơn hàng (POST) */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam         = request.getParameter("invoiceId");
        String newStatusParam  = request.getParameter("newStatus");
        String note            = request.getParameter("note");

        if (idParam == null || newStatusParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        int id, newStatus;
        try {
            id        = Integer.parseInt(idParam);
            newStatus = Integer.parseInt(newStatusParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        Invoice invoice = invoiceRepo.findById(id);
        if (invoice == null) { response.sendRedirect(request.getContextPath() + "/admin/invoices"); return; }

        int oldStatus = invoice.getOrderStatus();

        // Ghi lịch sử
        InvoiceHistory history = InvoiceHistory.builder()
                .invoice(invoice)
                .oldStatus(oldStatus)
                .newStatus(newStatus)
                .note(note != null ? note.trim() : "")
                .updatedAt(LocalDateTime.now())
                .status(1)
                .build();

        // Xác định xử lý kho:
        // Hủy đơn (→ 4): hoàn kho; khôi phục từ hủy (4 → khác): trừ kho
        boolean updateStock   = (newStatus == 4) || (oldStatus == 4 && newStatus != 4);
        boolean increaseStock = (newStatus == 4);

        List<InvoiceDetail> detailList = invoiceRepo.findDetailsByInvoiceId(id);
        invoice.setOrderStatus(newStatus);

        invoiceRepo.updateStatusAndSaveHistory(invoice, detailList, history, updateStock, increaseStock);

        String msg = (newStatus == 4) ? "cancelled" : "updated";
        response.sendRedirect(request.getContextPath()
                + "/admin/invoices/detail?id=" + id + "&msg=" + msg);
    }

    // =====================================================================
    // Helper
    // =====================================================================
    private int parseIdParam(HttpServletRequest request) {
        String idParam = request.getParameter("id");
        if (idParam == null) return -1;
        try { return Integer.parseInt(idParam); }
        catch (NumberFormatException e) { return -1; }
    }
}
