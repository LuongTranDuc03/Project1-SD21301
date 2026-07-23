package project.duan1_sd21301.controller.admin.ha;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import project.duan1_sd21301.model.Address;
import project.duan1_sd21301.model.ha.Customer;
import project.duan1_sd21301.model.ha.CustomerAddress;
import project.duan1_sd21301.service.ha.CustomerService;
import project.duan1_sd21301.service.ha.CustomerServiceImpl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "CustomerController", value = "/admin/customers")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class CustomerController extends HttpServlet {

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private final CustomerService customerService = new CustomerServiceImpl();

    @Override
    public void init() throws ServletException {
        // Mock data setup removed - data is fetched directly from database via customerService
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String toastMsg = (String) session.getAttribute("toastMessage");
        String toastType = (String) session.getAttribute("toastType");
        if (toastMsg != null) {
            request.setAttribute("toastMessage", toastMsg);
            request.setAttribute("toastType", toastType != null ? toastType : "success");
            session.removeAttribute("toastMessage");
            session.removeAttribute("toastType");
        }

        List<Customer> allCustomers = customerService.getAllCustomers();
        if (allCustomers == null) allCustomers = new ArrayList<>();

        String action = request.getParameter("action");

        // 1. Thêm mới
        if ("add-form".equals(action)) {
            String nextCode = generateNextCustomerCode(allCustomers);
            request.setAttribute("nextCode", nextCode);
            request.setAttribute("isEdit", false);
            request.setAttribute("pageTitle", "Thêm khách hàng");
            request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-form.jsp").forward(request, response);
            return;
        }

        // 2. Form sửa — tìm theo id hoặc code
        if ("edit-form".equals(action)) {
            Customer customer = findCustomer(request, allCustomers);
            request.setAttribute("pageTitle", "Chỉnh sửa khách hàng");
            request.setAttribute("customer", customer);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-form.jsp").forward(request, response);
            return;
        }

        // 3. Chi tiết — tìm theo id hoặc code
        if ("details".equals(action)) {
            Customer customer = findCustomer(request, allCustomers);
            request.setAttribute("pageTitle", "Chi tiết hồ sơ khách hàng");
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-details.jsp").forward(request, response);
            return;
        }

        // 4. Đặt địa chỉ mặc định theo addressCode
        if ("set-default-address".equals(action)) {
            String addressCode = request.getParameter("addressCode");
            Customer cust = findCustomer(request, allCustomers);
            if (cust != null && addressCode != null) {
                if (cust.getAddresses() != null) {
                    for (CustomerAddress a : cust.getAddresses()) {
                        a.setDefault(a.getCode().equals(addressCode));
                    }
                    session.setAttribute("toastMessage", "Thiết lập địa chỉ mặc định thành công!");
                    session.setAttribute("toastType", "success");
                }
            }
            String redirectParam = (cust != null && cust.getCode() != null) ? "code=" + cust.getCode() : "id=" + request.getParameter("id");
            response.sendRedirect(request.getContextPath() + "/admin/customers?action=details&" + redirectParam);
            return;
        }

        // 5. Danh sách + tìm kiếm / lọc
        String search = request.getParameter("search");
        String filterStatus = request.getParameter("filterStatus");
        String filterGender = request.getParameter("filterGender");
        String filterAddress = request.getParameter("filterAddress");

        List<Customer> filteredCustomers = new ArrayList<>();
        for (Customer c : allCustomers) {
            boolean matches = true;

            if (search != null && !search.trim().isEmpty()) {
                String kw = search.toLowerCase().trim();
                matches = c.getCode().toLowerCase().contains(kw)
                        || c.getFullName().toLowerCase().contains(kw)
                        || c.getPhoneNumber().contains(kw)
                        || c.getEmail().toLowerCase().contains(kw);
            }

            if (matches && filterGender != null && !filterGender.trim().isEmpty()
                    && !"Tất cả".equalsIgnoreCase(filterGender)) {
                matches = filterGender.equalsIgnoreCase(c.getGender());
            }

            if (matches && filterAddress != null && !filterAddress.trim().isEmpty()) {
                String addrKw = filterAddress.toLowerCase().trim();
                boolean found = false;
                if (c.getAddresses() != null) {
                    for (CustomerAddress a : c.getAddresses()) {
                        String full = buildFullAddress(a).toLowerCase();
                        if (full.contains(addrKw)) { found = true; break; }
                    }
                }
                matches = found;
            }

            if (matches && filterStatus != null && !filterStatus.trim().isEmpty()
                    && !"Tất cả".equalsIgnoreCase(filterStatus)) {
                matches = filterStatus.equalsIgnoreCase(c.getStatus());
            }

            if (matches) filteredCustomers.add(c);
        }

        // Export CSV
        if ("exportExcel".equals(action)) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"danh_sach_khach_hang.csv\"");
            try (java.io.PrintWriter writer = response.getWriter()) {
                writer.write('\ufeff');
                writer.println("STT,Mã khách hàng,Tên khách hàng,Số điện thoại,Email,Giới tính,Trạng thái");
                int stt = 1;
                for (Customer cust : filteredCustomers) {
                    String name = cust.getFullName() != null ? cust.getFullName().replace("\"", "\"\"") : "";
                    writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"\n",
                            stt++, cust.getCode(), name,
                            cust.getPhoneNumber() != null ? cust.getPhoneNumber() : "",
                            cust.getEmail() != null ? cust.getEmail() : "",
                            cust.getGender() != null ? cust.getGender() : "",
                            cust.getStatus() != null ? cust.getStatus() : "");
                }
            }
            return;
        }

        request.setAttribute("pageTitle", "Quản lý khách hàng");
        request.setAttribute("customers", filteredCustomers);
        request.setAttribute("searchVal", search != null ? search : "");
        request.setAttribute("filterStatusVal", filterStatus != null ? filterStatus : "Tất cả");
        request.setAttribute("filterGenderVal", filterGender != null ? filterGender : "Tất cả");
        request.setAttribute("filterAddressVal", filterAddress != null ? filterAddress : "");
        request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        List<Customer> customers = customerService.getAllCustomers();
        if (customers == null) { customers = new ArrayList<>(); }
        HttpSession session = request.getSession();

        if ("add".equals(action) || "edit".equals(action)) {
            String code = request.getParameter("code");
            if ("add".equals(action) && (code == null || code.trim().isEmpty())) {
                code = generateNextCustomerCode(customers);
            } else if (code != null) {
                code = code.trim();
            }

            String hoTen = request.getParameter("hoTen");
            String email = request.getParameter("email");
            String soDienThoai = request.getParameter("soDienThoai");
            String ngaySinhStr = request.getParameter("ngaySinh");
            String gioiTinh = request.getParameter("gioiTinh");
            String trangThai = request.getParameter("trangThai");
            String existingAvatar = request.getParameter("anhDaiDien");

            // Upload ảnh
            String anhDaiDien = existingAvatar;
            try {
                Part filePart = request.getPart("anhDaiDienFile");
                if (filePart != null && filePart.getSize() > 0) {
                    File uploadDir = new File(getServletContext().getRealPath("/"), "uploads");
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    String uniqueFileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    filePart.write(new File(uploadDir, uniqueFileName).getAbsolutePath());
                    anhDaiDien = request.getContextPath() + "/uploads/" + uniqueFileName;
                }
            } catch (Exception e) { e.printStackTrace(); }

            if ("add".equals(action) && (anhDaiDien == null || anhDaiDien.trim().isEmpty())) {
                anhDaiDien = "https://i.pravatar.cc/150?img=" + (int)(Math.random() * 70);
            }

            Date ngaySinh = null;
            try {
                if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) ngaySinh = dateFormat.parse(ngaySinhStr);
            } catch (ParseException e) { ngaySinh = new Date(); }

            // Xây dựng danh sách địa chỉ từ form
            // Địa chỉ mặc định
            String defaultRecipient = request.getParameter("defaultRecipientName");
            String defaultPhone     = request.getParameter("defaultPhoneNumber");
            String defaultProvince  = request.getParameter("defaultProvince");
            String defaultDistrict  = request.getParameter("defaultDistrict");
            String defaultWard      = request.getParameter("defaultWard");
            String defaultDetail    = request.getParameter("defaultDetailedAddress");
            String defaultNote      = request.getParameter("defaultNote");
            String defaultAddrCode  = request.getParameter("defaultAddressCode");

            // Các địa chỉ phụ
            String[] otherCodes      = request.getParameterValues("otherAddressCode");
            String[] otherRecipients = request.getParameterValues("otherRecipientName");
            String[] otherPhones     = request.getParameterValues("otherPhoneNumber");
            String[] otherProvinces  = request.getParameterValues("otherProvince");
            String[] otherDistricts  = request.getParameterValues("otherDistrict");
            String[] otherWards      = request.getParameterValues("otherWard");
            String[] otherDetails    = request.getParameterValues("otherDetailedAddress");
            String[] otherNotes      = request.getParameterValues("otherNote");

            List<CustomerAddress> addresses = new ArrayList<>();

            // Địa chỉ mặc định
            int nextAddrId = getNextAddressId(customers);
            String resolvedDefaultCode = (defaultAddrCode != null && !defaultAddrCode.trim().isEmpty())
                    ? defaultAddrCode.trim() : generateNextAddressCode(customers, 0);
            CustomerAddress defaultAddr = CustomerAddress.builder()
                    .id(nextAddrId++)
                    .recipientName(defaultRecipient != null ? defaultRecipient.trim() : "")
                    .phoneNumber(defaultPhone != null ? defaultPhone.trim() : "")
                    .isDefault(true)
                    .note(defaultNote != null ? defaultNote.trim() : "")
                    .address(Address.builder().code(resolvedDefaultCode).province(defaultProvince != null ? defaultProvince.trim() : "").district(defaultDistrict != null ? defaultDistrict.trim() : "").ward(defaultWard != null ? defaultWard.trim() : "").detailedAddress(defaultDetail != null ? defaultDetail.trim() : "").build())
                    .build();
            addresses.add(defaultAddr);

            // Các địa chỉ phụ
            if (otherDetails != null) {
                for (int i = 0; i < otherDetails.length; i++) {
                    String detail = otherDetails[i];
                    if (detail == null || detail.trim().isEmpty()) continue;
                    String oCode = (otherCodes != null && otherCodes.length > i && otherCodes[i] != null && !otherCodes[i].trim().isEmpty())
                            ? otherCodes[i].trim() : generateNextAddressCode(customers, addresses.size());
                    CustomerAddress otherAddr = CustomerAddress.builder()
                            .id(nextAddrId++)
                            .recipientName(safe(otherRecipients, i))
                            .phoneNumber(safe(otherPhones, i))
                            .isDefault(false)
                            .note(safe(otherNotes, i))
                            .address(Address.builder().code(oCode).province(safe(otherProvinces, i)).district(safe(otherDistricts, i)).ward(safe(otherWards, i)).detailedAddress(detail.trim()).build())
                            .build();
                    addresses.add(otherAddr);
                }
            }

            // Validate
            boolean isEdit = "edit".equals(action);
            String defaultFullAddr = buildFullAddress(defaultAddr);
            List<String> errors = CustomerValidator.validate(code, hoTen, email, soDienThoai, ngaySinh, gioiTinh, trangThai, defaultFullAddr, customers, isEdit);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("isEdit", isEdit);
                Customer preview = Customer.builder()
                        .code(code).fullName(hoTen).email(email).phoneNumber(soDienThoai)
                        .dateOfBirth(ngaySinh).gender(gioiTinh).status(trangThai).avatar(anhDaiDien)
                        .addresses(addresses).build();
                for (CustomerAddress a : preview.getAddresses()) a.setCustomer(preview);
                request.setAttribute("customer", preview);
                request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-form.jsp").forward(request, response);
                return;
            }

            if ("add".equals(action)) {
                int nextId = 1;
                for (Customer c : customers) { if (c.getId() >= nextId) nextId = c.getId() + 1; }
                Customer newC = Customer.builder()
                        .id(nextId).code(code).fullName(hoTen).email(email).phoneNumber(soDienThoai)
                        .dateOfBirth(ngaySinh).gender(gioiTinh).avatar(anhDaiDien).status(trangThai)
                        .addresses(addresses).build();
                for (CustomerAddress a : newC.getAddresses()) a.setCustomer(newC);
                
                if (customerService.addCustomer(newC)) {
                    session.setAttribute("toastMessage", "Thêm mới khách hàng thành công!");
                    session.setAttribute("toastType", "success");
                } else {
                    session.setAttribute("toastMessage", "Thêm thất bại (Email trùng hoặc lỗi DB)!");
                    session.setAttribute("toastType", "error");
                }
            } else {
                Customer found = findCustomer(request, customers);
                if (found != null) {
                    found.setFullName(hoTen); found.setEmail(email); found.setPhoneNumber(soDienThoai);
                    found.setDateOfBirth(ngaySinh); found.setGender(gioiTinh);
                    found.setAvatar(anhDaiDien); found.setStatus(trangThai);
                    found.setAddresses(addresses);
                    for (CustomerAddress a : found.getAddresses()) a.setCustomer(found);
                    
                    if (customerService.updateCustomer(found)) {
                        session.setAttribute("toastMessage", "Cập nhật khách hàng thành công!");
                        session.setAttribute("toastType", "success");
                    } else {
                        session.setAttribute("toastMessage", "Cập nhật thất bại (Lỗi DB)!");
                        session.setAttribute("toastType", "error");
                    }
                }
            }

        } else if ("delete-address".equals(action)) {
            String addressCode  = request.getParameter("addressCode");
            Customer cust = findCustomer(request, customers);
            if (cust != null && addressCode != null && cust.getAddresses() != null) {
                for (CustomerAddress ca : cust.getAddresses()) {
                    if (addressCode.equals(ca.getCode()) && ca.getId() > 0) {
                        customerService.deleteCustomerAddress(ca.getId());
                    }
                }
                session.setAttribute("toastMessage", "Xóa địa chỉ thành công!");
                session.setAttribute("toastType", "success");
            }
            String redirectParam = (cust != null && cust.getCode() != null) ? "code=" + cust.getCode() : "id=" + request.getParameter("id");
            response.sendRedirect(request.getContextPath() + "/admin/customers?action=details&" + redirectParam);
            return;

        } else if ("toggle-status".equals(action)) {
            Customer found = findCustomer(request, customers);
            if (found != null) {
                found.setStatus("Hoạt động".equalsIgnoreCase(found.getStatus()) ? "Khóa" : "Hoạt động");
                if (customerService.updateCustomer(found)) {
                    session.setAttribute("toastMessage", "Cập nhật trạng thái thành công!");
                    session.setAttribute("toastType", "success");
                }
            }

        } else if ("delete".equals(action)) {
            Customer found = findCustomer(request, customers);
            if (found != null) {
                if (customerService.deleteCustomer(found.getId())) {
                    session.setAttribute("toastMessage", "Xóa khách hàng thành công!");
                    session.setAttribute("toastType", "success");
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/customers");
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private Customer findByCode(List<Customer> list, String code) {
        if (code == null) return null;
        Customer fromDb = customerService.getCustomerByCode(code);
        if (fromDb != null) return fromDb;
        if (list != null) {
            for (Customer c : list) { if (code.equals(c.getCode())) return c; }
        }
        return null;
    }

    private Customer findCustomer(HttpServletRequest request, List<Customer> list) {
        if (request == null) return null;
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                Customer fromDb = customerService.getCustomerById(id);
                if (fromDb != null) return fromDb;
                if (list != null) {
                    for (Customer c : list) { if (c.getId() == id) return c; }
                }
            } catch (NumberFormatException ignored) {}
        }
        String code = request.getParameter("code");
        if (code != null && !code.trim().isEmpty()) {
            Customer fromDb = customerService.getCustomerByCode(code.trim());
            if (fromDb != null) return fromDb;
            if (list != null) {
                for (Customer c : list) { if (code.trim().equals(c.getCode())) return c; }
            }
        }
        return null;
    }

    private String buildFullAddress(CustomerAddress a) {
        if (a == null) return "";
        List<String> parts = new ArrayList<>();
        if (a.getDetailedAddress() != null && !a.getDetailedAddress().isEmpty()) parts.add(a.getDetailedAddress());
        if (a.getWard() != null && !a.getWard().isEmpty()) parts.add(a.getWard());
        if (a.getDistrict() != null && !a.getDistrict().isEmpty()) parts.add(a.getDistrict());
        if (a.getProvince() != null && !a.getProvince().isEmpty()) parts.add(a.getProvince());
        return String.join(", ", parts);
    }

    private String safe(String[] arr, int i) {
        return (arr != null && arr.length > i && arr[i] != null) ? arr[i].trim() : "";
    }

    private String generateNextCustomerCode(List<Customer> customers) {
        int max = 0;
        if (customers != null) {
            for (Customer c : customers) {
                String code = c.getCode();
                if (code != null && code.startsWith("KH")) {
                    try { int n = Integer.parseInt(code.substring(2)); if (n > max) max = n; }
                    catch (NumberFormatException ignored) {}
                }
            }
        }
        return String.format("KH%03d", max + 1);
    }

    private String generateNextAddressCode(List<Customer> customers, int offset) {
        return null; // Trả về null để Repository tự động sinh mã DC016, DC017... theo chuẩn
    }

    private int getNextAddressId(List<Customer> customers) {
        int max = 0;
        if (customers != null) {
            for (Customer c : customers) {
                if (c.getAddresses() == null) continue;
                for (CustomerAddress a : c.getAddresses()) { if (a.getId() > max) max = a.getId(); }
            }
        }
        return max + 1;
    }
}