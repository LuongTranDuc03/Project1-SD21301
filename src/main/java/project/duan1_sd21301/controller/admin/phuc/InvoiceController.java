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
 *  GET  /admin/invoices           → danh sách (phân trang, tìm kiếm, lọc trạng thái)
 *  GET  /admin/invoices/detail    → chi tiết hóa đơn (?id=...)
 *  GET  /admin/invoices/print     → trang in hóa đơn (?id=...)
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
    private static final Map<Integer, String> TRANG_THAI_LABELS;
    static {
        TRANG_THAI_LABELS = new LinkedHashMap<>();
        TRANG_THAI_LABELS.put(0, "Chờ xác nhận");
        TRANG_THAI_LABELS.put(1, "Đã xác nhận");
        TRANG_THAI_LABELS.put(2, "Đang giao hàng");
        TRANG_THAI_LABELS.put(3, "Hoàn thành");
        TRANG_THAI_LABELS.put(4, "Đã huỷ");
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

        // --- Đọc params ---
        String keyword = request.getParameter("q");
        if (keyword != null && keyword.trim().isEmpty()) keyword = null;

        Integer trangThai = null;
        String ttParam = request.getParameter("trangThai");
        if (ttParam != null && !ttParam.isEmpty()) {
            try { trangThai = Integer.parseInt(ttParam); } catch (NumberFormatException ignored) { }
        }

        int page = 0;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try { page = Math.max(0, Integer.parseInt(pageParam)); } catch (NumberFormatException ignored) { }
        }

        // --- Truy vấn ---
        long total = invoiceRepo.countAll(trangThai, keyword);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;
        page = Math.min(page, totalPages - 1);

        List<Invoice> invoices = invoiceRepo.findAll(trangThai, keyword, page, PAGE_SIZE);

        // --- Set attributes ---
        request.setAttribute("hoaDons", invoices);
        request.setAttribute("trangThaiLabels", TRANG_THAI_LABELS);
        request.setAttribute("total", total);
        request.setAttribute("page", page);
        request.setAttribute("size", PAGE_SIZE);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentTrangThai", trangThai);
        request.setAttribute("keyword", keyword);
        request.setAttribute("pageTitle", "Quản lý hóa đơn");

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/invoice-list.jsp")
                .forward(request, response);
    }

    /** Trang chi tiết một hóa đơn */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        int id;
        try { id = Integer.parseInt(idParam); }
        catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        Invoice hd = invoiceRepo.findById(id);
        if (hd == null) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        List<InvoiceDetail> chiTietList   = invoiceRepo.findDetailsByInvoiceId(id);
        List<InvoiceHistory> lichSuList   = invoiceRepo.findHistoryByInvoiceId(id);

        request.setAttribute("hoaDon", hd);
        request.setAttribute("chiTietList", chiTietList);
        request.setAttribute("lichSuList", lichSuList);
        request.setAttribute("trangThaiLabels", TRANG_THAI_LABELS);
        request.setAttribute("pageTitle", "Chi tiết hóa đơn #HD-" + id);

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/invoice-detail.jsp")
                .forward(request, response);
    }

    /** Trang in hóa đơn */
    private void handlePrint(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        int id;
        try { id = Integer.parseInt(idParam); }
        catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        Invoice hd = invoiceRepo.findById(id);
        if (hd == null) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        List<InvoiceDetail> chiTietList = invoiceRepo.findDetailsByInvoiceId(id);

        request.setAttribute("hoaDon", hd);
        request.setAttribute("chiTietList", chiTietList);
        request.setAttribute("trangThaiLabels", TRANG_THAI_LABELS);

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/invoice-print.jsp")
                .forward(request, response);
    }

    /** Cập nhật trạng thái đơn hàng (POST) */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam      = request.getParameter("hoaDonId");
        String ttMoiParam   = request.getParameter("trangThaiMoi");
        String ghiChu       = request.getParameter("ghiChu");

        if (idParam == null || ttMoiParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        int id, trangThaiMoi;
        try {
            id           = Integer.parseInt(idParam);
            trangThaiMoi = Integer.parseInt(ttMoiParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        Invoice hd = invoiceRepo.findById(id);
        if (hd == null) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices");
            return;
        }

        int trangThaiCu = hd.getTrangThaiDonHang() != null ? hd.getTrangThaiDonHang() : 0;

        // Ghi lịch sử
        InvoiceHistory lichSu = InvoiceHistory.builder()
                .invoice(hd)
                .trangThaiCu(trangThaiCu)
                .trangThaiMoi(trangThaiMoi)
                .ghiChu(ghiChu != null ? ghiChu.trim() : "")
                .thoiGianCapNhat(LocalDateTime.now())
                .trangThai(1)
                .build();

        // Xác định có cần xử lý kho không
        // Khi huỷ đơn (→ 4): hoàn kho; Khi khôi phục từ huỷ (4 → khác): trừ kho
        boolean xuLyKho  = (trangThaiMoi == 4) || (trangThaiCu == 4 && trangThaiMoi != 4);
        boolean tangKho  = (trangThaiMoi == 4);

        List<InvoiceDetail> chiTietList = invoiceRepo.findDetailsByInvoiceId(id);
        hd.setTrangThaiDonHang(trangThaiMoi);

        invoiceRepo.capNhatTrangThaiVaGhiLichSu(hd, chiTietList, lichSu, xuLyKho, tangKho);

        String msg = (trangThaiMoi == 4) ? "cancelled" : "updated";
        response.sendRedirect(request.getContextPath()
                + "/admin/invoices/detail?id=" + id + "&msg=" + msg);
    }
}
