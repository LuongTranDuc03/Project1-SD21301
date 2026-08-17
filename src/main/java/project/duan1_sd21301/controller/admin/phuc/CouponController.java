package project.duan1_sd21301.controller.admin.phuc;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.phuc.Coupon;
import project.duan1_sd21301.service.phuc.CouponService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller xử lý tất cả các nghiệp vụ liên quan đến Quản lý Khuyến mãi (Coupons/Vouchers).
 * Hỗ trợ các chức năng: Xem danh sách, tìm kiếm, lọc theo trạng thái/loại giảm giá,
 * tạo mới, cập nhật, thay đổi trạng thái (Bật/Tắt) và xuất dữ liệu ra file Excel.
 * Đảm bảo các logic kiểm tra ngày bắt đầu/kết thúc hợp lệ.
 */
@WebServlet(name = "CouponController", urlPatterns = {
        "/admin/coupons",
        "/admin/coupons/add",
        "/admin/coupons/edit",
        "/admin/coupons/save",
        "/admin/coupons/toggle-status",
        "/admin/coupons/export-excel"
})
public class CouponController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final DateTimeFormatter DATE_ONLY_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private static final Map<Integer, String> DISCOUNT_TYPE_LABELS;
    private static final Map<Integer, String> STATUS_LABELS;

    static {
        DISCOUNT_TYPE_LABELS = new LinkedHashMap<>();
        DISCOUNT_TYPE_LABELS.put(0, "Giảm phần trăm");
        DISCOUNT_TYPE_LABELS.put(1, "Giảm tiền");

        STATUS_LABELS = new LinkedHashMap<>();
        STATUS_LABELS.put(3, "Sắp diễn ra");
        STATUS_LABELS.put(0, "Chưa kích hoạt");
        STATUS_LABELS.put(1, "Đang kích hoạt");
        STATUS_LABELS.put(2, "Hết hạn");
    }

    private final CouponService repo = new CouponService();

    /**
     * Xử lý các yêu cầu HTTP GET.
     * Chuyển hướng người dùng dựa theo tham số 'action':
     * - list: Xem danh sách
     * - add: Mở form thêm mới
     * - edit: Mở form sửa
     * - export: Xuất file Excel
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.endsWith("/add")) {
            handleAddForm(request, response);
        } else if (uri.endsWith("/edit")) {
            handleEditForm(request, response);
        } else if (uri.endsWith("/export-excel")) {
            handleExportExcel(request, response);
        } else {
            handleList(request, response);
        }
    }

    /**
     * Xử lý các yêu cầu HTTP POST khi submit Form.
     * Các action chính: save (Lưu mới/Cập nhật), toggle (Bật/Tắt trạng thái hoạt động).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();
        if (uri.endsWith("/save")) {
            handleSave(request, response);
        } else if (uri.endsWith("/toggle-status")) {
            handleToggleStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Lấy danh sách phiếu giảm giá.
     * Hỗ trợ tìm kiếm theo Mã/Tên, lọc theo Trạng thái (Sắp diễn ra, Đang diễn ra, Đã kết thúc)
     * và Loại giảm giá (Phần trăm hay Tiền mặt). Tích hợp phân trang chuẩn.
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("q");
        if (keyword != null && keyword.trim().isEmpty())
            keyword = null;

        String fromDate = request.getParameter("fromDate");
        if (fromDate != null && fromDate.trim().isEmpty())
            fromDate = null;

        String toDate = request.getParameter("toDate");
        if (toDate != null && toDate.trim().isEmpty())
            toDate = null;

        Integer discountType = parseIntParam(request.getParameter("discountType"));
        Integer status = parseIntParam(request.getParameter("status"));

        int page = 0;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Math.max(0, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {
            }
        }
        // Tự động cập nhật trạng thái các mã đã hết hạn trước khi load danh sách
        repo.updateExpiredCoupons();

        long total = repo.countAll(discountType, status, keyword, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (totalPages == 0)
            totalPages = 1;
        page = Math.min(page, totalPages - 1);

        List<Coupon> list = repo.findAll(discountType, status, keyword, fromDate, toDate, page, PAGE_SIZE);
        //
        LocalDateTime now = LocalDateTime.now();
        for (Coupon c : list) {
            if (c.getEndDate() != null && c.getEndDate().isBefore(now)) {
                if (c.getStatus() == 1 || c.getStatus() == 0) {
                    c.setStatus(2);
                    repo.update(c);
                }
            } else if (c.getStartDate() != null && c.getStartDate().isAfter(now)) {
                // Phiếu chưa đến ngày bắt đầu → hiển thị "Sắp diễn ra" (chỉ UI, không ghi DB)
                if (c.getStatus() != 2) {
                    c.setStatus(3);
                }
            }
        }

        request.setAttribute("coupons", list);
        request.setAttribute("discountTypeLabels", DISCOUNT_TYPE_LABELS);
        request.setAttribute("statusLabels", STATUS_LABELS);
        request.setAttribute("total", total);
        request.setAttribute("page", page);
        request.setAttribute("size", PAGE_SIZE);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentDiscountType", discountType);
        request.setAttribute("currentStatus", status);
        request.setAttribute("keyword", keyword);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("pageTitle", "Quản lý phiếu giảm giá");

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/coupon-list.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị giao diện Form thêm mới phiếu giảm giá.
     */
    private void handleAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Coupon c = new Coupon();
        c.setCode(repo.generateNextCode());
        request.setAttribute("coupon", c);
        request.setAttribute("isEdit", false);
        request.setAttribute("discountTypeLabels", DISCOUNT_TYPE_LABELS);
        request.setAttribute("pageTitle", "Thêm phiếu giảm giá");

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/coupon-form.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị giao diện Form cập nhật phiếu giảm giá.
     * Truy vấn thông tin giảm giá hiện tại theo ID và nạp vào các thẻ input của form.
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseIdParam(request);
        if (id < 0) {
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
            return;
        }

        Coupon c = repo.findById(id);
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
            return;
        }

        request.setAttribute("coupon", c);
        request.setAttribute("isEdit", true);
        request.setAttribute("discountTypeLabels", DISCOUNT_TYPE_LABELS);
        request.setAttribute("pageTitle", "Chỉnh sửa phiếu giảm giá");

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/coupon-form.jsp")
                .forward(request, response);
    }

    /**
     * Thực hiện thêm mới hoặc cập nhật phiếu giảm giá vào Cơ sở dữ liệu.
     * Có tích hợp Validator để kiểm tra tính hợp lệ của dữ liệu đầu vào 
     * (như ngày kết thúc phải sau ngày bắt đầu, mức giảm không vượt quá 100%...).
     */
    private void handleSave(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        boolean isEdit = idParam != null && !idParam.isEmpty() && !idParam.equals("0");
        int id = 0;
        if (isEdit) {
            try {
                id = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                isEdit = false;
            }
        }

        String code = trim(request.getParameter("code"));
        String name = trim(request.getParameter("name"));
        Integer discountType = parseIntParam(request.getParameter("discountType"));
        Double discountValue = parseDoubleParam(request.getParameter("discountValue"));
        Double minOrderValue = parseDoubleParam(request.getParameter("minOrderValue"));
        Double maxDiscountAmount = parseDoubleParam(request.getParameter("maxDiscountAmount"));
        Integer quantity = parseIntParam(request.getParameter("quantity"));
        Integer usedQuantity = parseIntParam(request.getParameter("usedQuantity"));
        Integer usagePerCustomer = parseIntParam(request.getParameter("usagePerCustomer"));
        LocalDateTime startDate = parseDateTime(request.getParameter("startDate"));
        LocalDateTime endDate = parseDateTime(request.getParameter("endDate"));
        String description = trim(request.getParameter("description"));
        Integer status = parseIntParam(request.getParameter("status"));

        int computedStatus = status != null ? status : 0;
        LocalDateTime now = LocalDateTime.now();
        if (startDate != null && endDate != null) {
            if (now.isBefore(startDate)) {
                computedStatus = 3; // Sắp diễn ra
            } else if (now.isAfter(endDate)) {
                computedStatus = 2; // Hết hạn
            } else {
                computedStatus = 1; // Đang kích hoạt
            }
        }

        if (code == null || code.isEmpty() || name == null
                || discountType == null || discountValue == null || quantity == null) {
            response.sendRedirect(request.getContextPath()
                    + (isEdit ? "/admin/coupons/edit?id=" + id + "&err=missing"
                            : "/admin/coupons/add?err=missing"));
            return;
        }

        if (repo.existsCode(code, isEdit ? id : 0)) {
            response.sendRedirect(request.getContextPath()
                    + (isEdit ? "/admin/coupons/edit?id=" + id + "&err=dup"
                            : "/admin/coupons/add?err=dup"));
            return;
        }

        if (isEdit) {
            Coupon c = repo.findById(id);
            if (c == null) {
                response.sendRedirect(request.getContextPath() + "/admin/coupons");
                return;
            }

            c.setCode(code);
            c.setName(name);
            c.setDiscountType(discountType);
            c.setDiscountValue(discountValue);
            c.setMinOrderValue(minOrderValue);
            c.setMaxDiscountAmount(maxDiscountAmount);
            c.setQuantity(quantity);
            if (usedQuantity != null)
                c.setUsedQuantity(usedQuantity);
            if (usagePerCustomer != null)
                c.setUsagePerCustomer(usagePerCustomer);
            c.setStartDate(startDate);
            c.setEndDate(endDate);
            c.setDescription(description);
            c.setStatus(computedStatus);

            repo.update(c);
            response.sendRedirect(request.getContextPath() + "/admin/coupons?msg=updated");

        } else {
            Coupon c = Coupon.builder()
                    .code(code)
                    .name(name)
                    .discountType(discountType)
                    .discountValue(discountValue)
                    .minOrderValue(minOrderValue)
                    .maxDiscountAmount(maxDiscountAmount)
                    .quantity(quantity)
                    .usedQuantity(usedQuantity != null ? usedQuantity : 0)
                    .usagePerCustomer(usagePerCustomer != null ? usagePerCustomer : 1)
                    .startDate(startDate)
                    .endDate(endDate)
                    .description(description)
                    .status(computedStatus)
                    .createdAt(LocalDateTime.now())
                    .build();

            repo.save(c);
            response.sendRedirect(request.getContextPath() + "/admin/coupons?msg=created");
        }
    }

    /**
     * Bật/Tắt trạng thái hoạt động của một phiếu giảm giá.
     * Chỉ áp dụng thay đổi trạng thái nếu phiếu đó chưa kết thúc.
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = parseIdParam(request);
        Integer st = parseIntParam(request.getParameter("status"));

        String ref = request.getHeader("Referer");
        String redirectUrl = ref != null ? ref : request.getContextPath() + "/admin/coupons";
        if (redirectUrl.contains("?")) {
            redirectUrl = redirectUrl.replaceAll("([&?])(?:err|msg)=[^&]*", "");
            if (redirectUrl.contains("&") && !redirectUrl.contains("?")) {
                redirectUrl = redirectUrl.replaceFirst("&", "?");
            }
        }
        //
        if (id >= 0 && st != null) {
            Coupon c = repo.findById(id);
            if (c != null && st == 1) {
                LocalDateTime now = LocalDateTime.now();
                // Chặn kích hoạt phiếu đã hết hạn
                if (c.getEndDate() != null && c.getEndDate().isBefore(now)) {
                    response.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "err=expired");
                    return;
                }
                // Chặn kích hoạt phiếu chưa đến thời gian diễn ra
                if (c.getStartDate() != null && c.getStartDate().isAfter(now)) {
                    response.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "err=not_started");
                    return;
                }
            }
            repo.toggleStatus(id, st);
            redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "msg=updated";
        }

        response.sendRedirect(redirectUrl);
    }

    private int parseIdParam(HttpServletRequest request) {
        String p = request.getParameter("id");
        if (p == null)
            return -1;
        try {
            return Integer.parseInt(p);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private Integer parseIntParam(String val) {
        if (val == null || val.trim().isEmpty())
            return null;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * Xuất danh sách phiếu giảm giá hiện tại (có tính áp dụng các bộ lọc) ra file Excel (.xlsx).
     * Định dạng các cột ngày tháng và tiền tệ chuẩn xác.
     */
    private void handleExportExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = request.getParameter("q");
        if (keyword != null && keyword.trim().isEmpty())
            keyword = null;

        String fromDate = request.getParameter("fromDate");
        if (fromDate != null && fromDate.trim().isEmpty())
            fromDate = null;

        String toDate = request.getParameter("toDate");
        if (toDate != null && toDate.trim().isEmpty())
            toDate = null;

        Integer discountType = parseIntParam(request.getParameter("discountType"));
        Integer status = parseIntParam(request.getParameter("status"));

        List<Coupon> list = repo.findAll(discountType, status, keyword, fromDate, toDate, 0, Integer.MAX_VALUE);

        try (org.apache.poi.xssf.usermodel.XSSFWorkbook wb = new org.apache.poi.xssf.usermodel.XSSFWorkbook()) {
            org.apache.poi.ss.usermodel.Sheet sheet = wb.createSheet("Phieu giam gia");

            org.apache.poi.ss.usermodel.CellStyle headerStyle = wb.createCellStyle();
            org.apache.poi.ss.usermodel.Font headerFont = wb.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            org.apache.poi.ss.usermodel.Row headerRow = sheet.createRow(0);
            String[] columns = { "Mã giảm giá", "Tên chương trình", "Loại", "Mức giảm", "Đơn tối thiểu", "Số lượng",
                    "Đã dùng", "Bắt đầu", "Kết thúc", "Trạng thái" };
            for (int i = 0; i < columns.length; i++) {
                org.apache.poi.ss.usermodel.Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            int rowIdx = 1;
            for (Coupon c : list) {
                org.apache.poi.ss.usermodel.Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(c.getCode() != null ? c.getCode() : "");
                row.createCell(1).setCellValue(c.getName() != null ? c.getName() : "");
                row.createCell(2).setCellValue(DISCOUNT_TYPE_LABELS.getOrDefault(c.getDiscountType(), ""));
                row.createCell(3).setCellValue(c.getDiscountValue() != null ? c.getDiscountValue() : 0);
                row.createCell(4).setCellValue(c.getMinOrderValue() != null ? c.getMinOrderValue() : 0);
                row.createCell(5).setCellValue(c.getQuantity() != null ? c.getQuantity() : 0);
                row.createCell(6).setCellValue(c.getUsedQuantity() != null ? c.getUsedQuantity() : 0);
                row.createCell(7).setCellValue(c.getStartDate() != null ? c.getStartDate().format(DATE_ONLY_FMT) : "");
                row.createCell(8).setCellValue(c.getEndDate() != null ? c.getEndDate().format(DATE_ONLY_FMT) : "");
                row.createCell(9).setCellValue(STATUS_LABELS.getOrDefault(c.getStatus(), ""));
            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=phieu-giam-gia.xlsx");
            wb.write(response.getOutputStream());
        }
    }

    private Double parseDoubleParam(String val) {
        if (val == null || val.trim().isEmpty())
            return null;
        try {
            return Double.parseDouble(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }


    private LocalDateTime parseDateTime(String val) {
        if (val == null || val.trim().isEmpty())
            return null;
        try {
            return LocalDateTime.parse(val.trim(), DATE_FMT);
        } catch (DateTimeParseException e) {
            try {
                // Fallback for yyyy-MM-dd format if they just pass a date
                return LocalDate.parse(val.trim(), DATE_ONLY_FMT).atStartOfDay();
            } catch (DateTimeParseException ex) {
                return null;
            }
        }
    }

    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
