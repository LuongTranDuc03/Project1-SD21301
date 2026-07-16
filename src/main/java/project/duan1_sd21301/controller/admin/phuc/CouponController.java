package project.duan1_sd21301.controller.admin.phuc;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.phuc.Coupon;
import project.duan1_sd21301.service.phuc.CouponService;
import project.duan1_sd21301.service.phuc.impl.CouponServiceImpl;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CouponController", urlPatterns = {
        "/admin/coupons",
        "/admin/coupons/add",
        "/admin/coupons/edit",
        "/admin/coupons/save",
        "/admin/coupons/toggle-status"
})
public class CouponController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private static final Map<Integer, String> DISCOUNT_TYPE_LABELS;
    private static final Map<Integer, String> STATUS_LABELS;

    static {
        DISCOUNT_TYPE_LABELS = new LinkedHashMap<>();
        DISCOUNT_TYPE_LABELS.put(0, "Giảm phần trăm");
        DISCOUNT_TYPE_LABELS.put(1, "Giảm tiền");

        STATUS_LABELS = new LinkedHashMap<>();
        STATUS_LABELS.put(0, "Chưa kích hoạt");
        STATUS_LABELS.put(1, "Đang áp dụng");
        STATUS_LABELS.put(2, "Kết thúc");
        STATUS_LABELS.put(3, "Đã huỷ");
    }

    private final CouponService repo = new CouponServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.endsWith("/add")) {
            handleAddForm(request, response);
        } else if (uri.endsWith("/edit")) {
            handleEditForm(request, response);
        } else {
            handleList(request, response);
        }
    }

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

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("q");
        if (keyword != null && keyword.trim().isEmpty()) keyword = null;

        String fromDate = request.getParameter("fromDate");
        if (fromDate != null && fromDate.trim().isEmpty()) fromDate = null;

        String toDate = request.getParameter("toDate");
        if (toDate != null && toDate.trim().isEmpty()) toDate = null;

        Integer discountType = parseIntParam(request.getParameter("discountType"));
        Integer status       = parseIntParam(request.getParameter("status"));

        int page = 0;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try { page = Math.max(0, Integer.parseInt(pageParam)); }
            catch (NumberFormatException ignored) {}
        }

        long total     = repo.countAll(discountType, status, keyword, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;
        page = Math.min(page, totalPages - 1);

        List<Coupon> list = repo.findAll(discountType, status, keyword, fromDate, toDate, page, PAGE_SIZE);

        request.setAttribute("coupons",            list);
        request.setAttribute("discountTypeLabels", DISCOUNT_TYPE_LABELS);
        request.setAttribute("statusLabels",       STATUS_LABELS);
        request.setAttribute("total",              total);
        request.setAttribute("page",               page);
        request.setAttribute("size",               PAGE_SIZE);
        request.setAttribute("totalPages",         totalPages);
        request.setAttribute("currentDiscountType", discountType);
        request.setAttribute("currentStatus",      status);
        request.setAttribute("keyword",            keyword);
        request.setAttribute("fromDate",           fromDate);
        request.setAttribute("toDate",             toDate);
        request.setAttribute("pageTitle",          "Quản lý phiếu giảm giá");

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/coupon-list.jsp")
                .forward(request, response);
    }

    private void handleAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("coupon",             new Coupon());
        request.setAttribute("isEdit",             false);
        request.setAttribute("discountTypeLabels", DISCOUNT_TYPE_LABELS);
        request.setAttribute("pageTitle",          "Thêm phiếu giảm giá");

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/coupon-form.jsp")
                .forward(request, response);
    }

    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseIdParam(request);
        if (id < 0) { response.sendRedirect(request.getContextPath() + "/admin/coupons"); return; }

        Coupon c = repo.findById(id);
        if (c == null) { response.sendRedirect(request.getContextPath() + "/admin/coupons"); return; }

        request.setAttribute("coupon",             c);
        request.setAttribute("isEdit",             true);
        request.setAttribute("discountTypeLabels", DISCOUNT_TYPE_LABELS);
        request.setAttribute("pageTitle",          "Chỉnh sửa phiếu giảm giá");

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/coupon-form.jsp")
                .forward(request, response);
    }

    private void handleSave(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        boolean isEdit = idParam != null && !idParam.isEmpty() && !idParam.equals("0");
        int id = 0;
        if (isEdit) {
            try { id = Integer.parseInt(idParam); }
            catch (NumberFormatException e) { isEdit = false; }
        }

        String code          = trim(request.getParameter("code"));
        String name          = trim(request.getParameter("name"));
        Integer discountType = parseIntParam(request.getParameter("discountType"));
        Double discountValue = parseDoubleParam(request.getParameter("discountValue"));
        Double minOrderValue = parseDoubleParam(request.getParameter("minOrderValue"));
        Double maxDiscountAmount = parseDoubleParam(request.getParameter("maxDiscountAmount"));
        Integer quantity     = parseIntParam(request.getParameter("quantity"));
        Integer usedQuantity = parseIntParam(request.getParameter("usedQuantity"));
        LocalDate startDate  = parseDate(request.getParameter("startDate"));
        LocalDate endDate    = parseDate(request.getParameter("endDate"));
        String description   = trim(request.getParameter("description"));
        Integer status       = parseIntParam(request.getParameter("status"));

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
            if (c == null) { response.sendRedirect(request.getContextPath() + "/admin/coupons"); return; }

            c.setCode(code);
            c.setName(name);
            c.setDiscountType(discountType);
            c.setDiscountValue(discountValue);
            c.setMinOrderValue(minOrderValue);
            c.setMaxDiscountAmount(maxDiscountAmount);
            c.setQuantity(quantity);
            if (usedQuantity != null) c.setUsedQuantity(usedQuantity);
            c.setStartDate(startDate);
            c.setEndDate(endDate);
            c.setDescription(description);
            if (status != null) c.setStatus(status);

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
                    .startDate(startDate)
                    .endDate(endDate)
                    .description(description)
                    .status(status != null ? status : 1)
                    .createdAt(LocalDateTime.now())
                    .build();

            repo.save(c);
            response.sendRedirect(request.getContextPath() + "/admin/coupons?msg=created");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id     = parseIdParam(request);
        Integer st = parseIntParam(request.getParameter("status"));

        if (id >= 0 && st != null) {
            repo.toggleStatus(id, st);
        }
        String ref = request.getHeader("Referer");
        response.sendRedirect(ref != null ? ref : request.getContextPath() + "/admin/coupons");
    }

    private int parseIdParam(HttpServletRequest request) {
        String p = request.getParameter("id");
        if (p == null) return -1;
        try { return Integer.parseInt(p); }
        catch (NumberFormatException e) { return -1; }
    }

    private Integer parseIntParam(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try { return Integer.parseInt(val.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    private Double parseDoubleParam(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try { return Double.parseDouble(val.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    private LocalDate parseDate(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try { return LocalDate.parse(val.trim(), DATE_FMT); }
        catch (DateTimeParseException e) { return null; }
    }

    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
