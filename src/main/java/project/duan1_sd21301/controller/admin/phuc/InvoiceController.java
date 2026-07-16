package project.duan1_sd21301.controller.admin.phuc;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import project.duan1_sd21301.model.phuc.Invoice;
import project.duan1_sd21301.model.phuc.InvoiceDetail;
import project.duan1_sd21301.model.phuc.InvoiceHistory;
import project.duan1_sd21301.repository.phuc.InvoiceRepository;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
        "/admin/invoices/update-status",
        "/admin/invoices/export-excel"
})
public class InvoiceController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private static final Map<Integer, String> ORDER_STATUS_LABELS;
    static {
        ORDER_STATUS_LABELS = new LinkedHashMap<>();
        ORDER_STATUS_LABELS.put(0, "Chờ xác nhận");
        ORDER_STATUS_LABELS.put(1, "Đã xác nhận");
        ORDER_STATUS_LABELS.put(2, "Hoàn thành");
        ORDER_STATUS_LABELS.put(3, "Đã huỷ");
        ORDER_STATUS_LABELS.put(4, "Đã hoàn tiền");
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
        } else if (uri.endsWith("/export-excel")) {
            handleExportExcel(request, response);
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

        String fromDate = request.getParameter("fromDate");
        if (fromDate != null && fromDate.trim().isEmpty()) fromDate = null;

        String toDate = request.getParameter("toDate");
        if (toDate != null && toDate.trim().isEmpty()) toDate = null;

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

        long total      = invoiceRepo.countAll(orderStatus, keyword, fromDate, toDate);
        int totalPages  = (int) Math.ceil((double) total / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;
        page = Math.min(page, totalPages - 1);

        List<Invoice> invoices = invoiceRepo.findAll(orderStatus, keyword, fromDate, toDate, page, PAGE_SIZE);

        request.setAttribute("invoices",           invoices);
        request.setAttribute("orderStatusLabels",  ORDER_STATUS_LABELS);
        request.setAttribute("total",              total);
        request.setAttribute("page",               page);
        request.setAttribute("size",               PAGE_SIZE);
        request.setAttribute("totalPages",         totalPages);
        request.setAttribute("currentOrderStatus", orderStatus);
        request.setAttribute("keyword",            keyword);
        request.setAttribute("fromDate",           fromDate);
        request.setAttribute("toDate",             toDate);
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
        // Hủy đơn/Hoàn tiền (→ 3, 4): hoàn kho; khôi phục từ hủy/hoàn tiền (3, 4 → khác): trừ kho
        boolean isNewCancelOrRefund = (newStatus == 3 || newStatus == 4);
        boolean isOldCancelOrRefund = (oldStatus == 3 || oldStatus == 4);
        
        boolean updateStock   = isNewCancelOrRefund || (isOldCancelOrRefund && !isNewCancelOrRefund);
        boolean increaseStock = isNewCancelOrRefund;

        List<InvoiceDetail> detailList = invoiceRepo.findDetailsByInvoiceId(id);
        invoice.setOrderStatus(newStatus);

        invoiceRepo.updateStatusAndSaveHistory(invoice, detailList, history, updateStock, increaseStock);

        String msg = (newStatus == 3 || newStatus == 4) ? "cancelled" : "updated";
        response.sendRedirect(request.getContextPath()
                + "/admin/invoices/detail?id=" + id + "&msg=" + msg);
    }

    // =====================================================================
    // Export Excel
    // =====================================================================

    /** Xuất toàn bộ hóa đơn ra file Excel (.xlsx) theo filter hiện tại */
    private void handleExportExcel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String keyword = request.getParameter("q");
        if (keyword != null && keyword.trim().isEmpty()) keyword = null;

        String fromDate = request.getParameter("fromDate");
        if (fromDate != null && fromDate.trim().isEmpty()) fromDate = null;

        String toDate = request.getParameter("toDate");
        if (toDate != null && toDate.trim().isEmpty()) toDate = null;

        Integer orderStatus = null;
        String ttParam = request.getParameter("trangThai");
        if (ttParam != null && !ttParam.isEmpty()) {
            try { orderStatus = Integer.parseInt(ttParam); }
            catch (NumberFormatException ignored) { }
        }

        // Lấy TẤT CẢ hóa đơn (không phân trang) theo filter
        List<Invoice> all = invoiceRepo.findAll(orderStatus, keyword, fromDate, toDate, 0, Integer.MAX_VALUE);

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Hoa don");

            // ---- Styles ----
            CellStyle headerStyle = wb.createCellStyle();
            Font headerFont = wb.createFont();
            headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 11);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            CellStyle titleStyle = wb.createCellStyle();
            Font titleFont = wb.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            titleStyle.setAlignment(HorizontalAlignment.CENTER);
            titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            CellStyle dataStyle = wb.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            CellStyle numStyle = wb.createCellStyle();
            numStyle.cloneStyleFrom(dataStyle);
            DataFormat fmt = wb.createDataFormat();
            numStyle.setDataFormat(fmt.getFormat("#,##0"));
            numStyle.setAlignment(HorizontalAlignment.RIGHT);

            CellStyle centerStyle = wb.createCellStyle();
            centerStyle.cloneStyleFrom(dataStyle);
            centerStyle.setAlignment(HorizontalAlignment.CENTER);

            // ---- Tiêu đề file ----
            Row titleRow = sheet.createRow(0);
            titleRow.setHeightInPoints(28);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("DANH SACH HOA DON - FAMICOATS");
            titleCell.setCellStyle(titleStyle);
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 9));

            Row subRow = sheet.createRow(1);
            Cell subCell = subRow.createCell(0);
            subCell.setCellValue("Xuat ngay: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
            sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 9));

            // ---- Header row ----
            String[] headers = {"STT", "Ma HD", "Khach hang", "So dien thoai",
                    "Email", "Tong tien (VND)", "Da thanh toan (VND)",
                    "Phuong thuc TT", "Ngay dat hang", "Trang thai"};

            Row headerRow = sheet.createRow(3);
            headerRow.setHeightInPoints(20);
            for (int i = 0; i < headers.length; i++) {
                Cell c = headerRow.createCell(i);
                c.setCellValue(headers[i]);
                c.setCellStyle(headerStyle);
            }

            // ---- Data rows ----
            int rowIdx = 4;
            int stt    = 1;
            for (Invoice inv : all) {
                Row row = sheet.createRow(rowIdx++);
                row.setHeightInPoints(18);

                Cell c0 = row.createCell(0); c0.setCellValue(stt++);              c0.setCellStyle(centerStyle);
                Cell c1 = row.createCell(1); c1.setCellValue("HD" + inv.getId()); c1.setCellStyle(centerStyle);
                Cell c2 = row.createCell(2); c2.setCellValue(inv.getCustomerName()  != null ? inv.getCustomerName()  : ""); c2.setCellStyle(dataStyle);
                Cell c3 = row.createCell(3); c3.setCellValue(inv.getCustomerPhone() != null ? inv.getCustomerPhone() : ""); c3.setCellStyle(dataStyle);
                Cell c4 = row.createCell(4); c4.setCellValue(inv.getCustomerEmail() != null ? inv.getCustomerEmail() : ""); c4.setCellStyle(dataStyle);

                Cell c5 = row.createCell(5);
                if (inv.getTotalAmount() != null) { c5.setCellValue(inv.getTotalAmount()); c5.setCellStyle(numStyle); }
                else { c5.setCellValue("-"); c5.setCellStyle(dataStyle); }

                Cell c6 = row.createCell(6);
                if (inv.getPaidAmount() != null) { c6.setCellValue(inv.getPaidAmount()); c6.setCellStyle(numStyle); }
                else { c6.setCellValue("-"); c6.setCellStyle(dataStyle); }

                Cell c7 = row.createCell(7);
                c7.setCellValue(inv.getPaymentMethod() != null ? inv.getPaymentMethod().getName() : "-");
                c7.setCellStyle(dataStyle);

                Cell c8 = row.createCell(8);
                c8.setCellValue(inv.getOrderDate() != null ? inv.getOrderDate().format(dtf) : "-");
                c8.setCellStyle(centerStyle);

                Cell c9 = row.createCell(9);
                c9.setCellValue(ORDER_STATUS_LABELS.getOrDefault(inv.getOrderStatus(), "?"));
                c9.setCellStyle(centerStyle);
            }

            // ---- Auto-size columns ----
            int[] widths = {6, 10, 28, 16, 30, 18, 20, 18, 18, 16};
            for (int i = 0; i < widths.length; i++) {
                sheet.setColumnWidth(i, widths[i] * 256);
            }

            // ---- Response headers ----
            String filename = "HoaDon_FamiCoats_" +
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmm")) + ".xlsx";

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            wb.write(response.getOutputStream());
        }
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
