package project.duan1_sd21301.controller.admin.ha;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import project.duan1_sd21301.model.ha.Customer;
import project.duan1_sd21301.model.ha.Address;
import project.duan1_sd21301.validate.ha.CustomerValidator;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * Controller xử lý tất cả các nghiệp vụ CRUD và quản trị Khách hàng của hệ thống.
 * Hỗ trợ Upload File và quản lý bộ nhớ tạm thời ServletContext.
 */
@WebServlet(name = "CustomerController", value = "/admin/customers")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // Ngưỡng dung lượng file lưu tạm trong bộ nhớ (2MB)
        maxFileSize = 1024 * 1024 * 10,      // Dung lượng file tối đa được phép tải lên (10MB)
        maxRequestSize = 1024 * 1024 * 50    // Tổng dung lượng tối đa cho một Request (50MB)
)
public class CustomerController extends HttpServlet {

    // Định dạng ngày chuẩn dùng cho trường nhập Ngày sinh (yyyy-MM-dd)
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Phương thức khởi tạo Servlet.
     * Nạp sẵn các bản ghi khách hàng giả lập vào ServletContext để hiển thị ban đầu.
     */
    @Override
    public void init() throws ServletException {
        // Nếu ServletContext chưa có danh sách khách hàng thì tiến hành tạo mới
        if (getServletContext().getAttribute("customers") == null) {
            List<Customer> customers = new ArrayList<>();
            try {
                // Khách hàng mẫu thứ nhất
                customers.add(Customer.builder()
                        .id("KH001")
                        .fullName("Nguyễn Anh Tuấn")
                        .email("anhtuan.nguyen@gmail.com")
                        .password("tuannh123")
                        .phoneNumber("0987654321")
                        .dateOfBirth(dateFormat.parse("1995-05-12"))
                        .gender("Nam")
                        .avatar("https://i.pravatar.cc/150?img=11")
                        .status("Hoạt động")
                        .defaultAddress(new Address("Nguyễn Anh Tuấn", "0987654321", "123 Nguyễn Trãi, Quận 1, TP. Hồ Chí Minh"))
                        .otherAddresses(new ArrayList<>(Arrays.asList(
                                new Address("Nguyễn Anh Tuấn", "0987654321", "345 Điện Biên Phủ, Bình Thạnh, TP. Hồ Chí Minh")
                        )))
                        .build());

                // Khách hàng mẫu thứ hai
                customers.add(Customer.builder()
                        .id("KH002")
                        .fullName("Trần Thị Mai")
                        .email("maitran98@gmail.com")
                        .password("maipassword")
                        .phoneNumber("0912345678")
                        .dateOfBirth(dateFormat.parse("1998-09-20"))
                        .gender("Nữ")
                        .avatar("https://i.pravatar.cc/150?img=47")
                        .status("Hoạt động")
                        .defaultAddress(new Address("Trần Thị Mai", "0912345678", "456 Lê Lợi, Quận Hải Châu, Đà Nẵng"))
                        .otherAddresses(new ArrayList<>(Arrays.asList(
                                new Address("Trần Thị Mai", "0912345678", "12 Nguyễn Văn Linh, Thanh Khê, Đà Nẵng"),
                                new Address("Trần Thị Mai", "0912345678", "78 Trần Hưng Đạo, Sơn Trà, Đà Nẵng")
                        )))
                        .build());

                // Khách hàng mẫu thứ ba
                customers.add(Customer.builder()
                        .id("KH003")
                        .fullName("Lê Minh Hoàng")
                        .email("hoangleminh@yahoo.com")
                        .password("hoang1992")
                        .phoneNumber("0909090909")
                        .dateOfBirth(dateFormat.parse("1992-12-30"))
                        .gender("Nam")
                        .avatar("https://i.pravatar.cc/150?img=12")
                        .status("Khóa")
                        .defaultAddress(new Address("Lê Minh Hoàng", "0909090909", "789 Cầu Giấy, Quận Cầu Giấy, Hà Nội"))
                        .otherAddresses(new ArrayList<>())
                        .build());

                // Khách hàng mẫu thứ tư
                customers.add(Customer.builder()
                        .id("KH004")
                        .fullName("Phạm Khánh Vy")
                        .email("vypham.khanh@hotmail.com")
                        .password("vycute99")
                        .phoneNumber("0977777777")
                        .dateOfBirth(dateFormat.parse("1999-03-15"))
                        .gender("Nữ")
                        .avatar("https://i.pravatar.cc/150?img=49")
                        .status("Hoạt động")
                        .defaultAddress(new Address("Phạm Khánh Vy", "0977777777", "321 Trần Hưng Đạo, Quận Ninh Kiều, Cần Thơ"))
                        .otherAddresses(new ArrayList<>(Arrays.asList(
                                new Address("Phạm Khánh Vy", "0977777777", "56 Mậu Thân, Ninh Kiều, Cần Thơ")
                        )))
                        .build());

            } catch (ParseException e) {
                e.printStackTrace();
            }
            // Lưu trữ danh sách vừa tạo vào ServletContext (tồn tại suốt vòng đời ứng dụng)
            getServletContext().setAttribute("customers", customers);
        }
    }

    /**
     * Xử lý các yêu cầu lấy thông tin hoặc điều hướng giao diện (HTTP GET).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Chuyển toast message từ session sang request (nếu có)
        jakarta.servlet.http.HttpSession session = request.getSession();
        String toastMsg = (String) session.getAttribute("toastMessage");
        String toastType = (String) session.getAttribute("toastType");
        if (toastMsg != null) {
            request.setAttribute("toastMessage", toastMsg);
            request.setAttribute("toastType", toastType != null ? toastType : "success");
            session.removeAttribute("toastMessage");
            session.removeAttribute("toastType");
        }

        // Lấy danh sách khách hàng hiện thời từ ServletContext
        List<Customer> allCustomers = (List<Customer>) getServletContext().getAttribute("customers");
        if (allCustomers == null) {
            allCustomers = new ArrayList<>();
        }

        String action = request.getParameter("action");

        // 1. Giao diện Thêm mới khách hàng
        if ("add-form".equals(action)) {
            // Tự sinh mã khách hàng gợi ý để hiển thị gợi ý trên placeholder
            String nextId = generateNextCustomerId(allCustomers);
            request.setAttribute("nextId", nextId);
            request.setAttribute("isEdit", false);
            request.setAttribute("pageTitle", "Thêm khách hàng");
            request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-form.jsp").forward(request, response);
            return;
        }

        // 2. Giao diện Cập nhật thông tin khách hàng
        if ("edit-form".equals(action)) {
            String id = request.getParameter("id");
            Customer customer = null;
            // Tìm khách hàng có ID tương ứng trong danh sách dữ liệu
            for (Customer c : allCustomers) {
                if (c.getId().equals(id)) {
                    customer = c;
                    break;
                }
            }
            request.setAttribute("pageTitle", "Chỉnh sửa khách hàng");
            request.setAttribute("customer", customer);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-form.jsp").forward(request, response);
            return;
        }

        // 3. Giao diện Xem hồ sơ chi tiết khách hàng
        if ("details".equals(action)) {
            String id = request.getParameter("id");
            Customer customer = null;
            for (Customer c : allCustomers) {
                if (c.getId().equals(id)) {
                    customer = c;
                    break;
                }
            }
            request.setAttribute("pageTitle", "Chi tiết hồ sơ khách hàng");
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-details.jsp").forward(request, response);
            return;
        }

        // 4. Thiết lập một địa chỉ phụ lên làm địa chỉ mặc định chính thức
        if ("set-default-address".equals(action)) {
            String id = request.getParameter("id");
            String indexStr = request.getParameter("index");
            if (id != null && indexStr != null) {
                try {
                    int idx = Integer.parseInt(indexStr);
                    for (Customer cust : allCustomers) {
                        if (cust.getId().equals(id)) {
                            List<Address> other = cust.getOtherAddresses();
                            if (idx >= 0 && idx < other.size()) {
                                // Thực hiện đổi chỗ giữa địa chỉ mặc định cũ và địa chỉ phụ mới được chọn
                                Address oldDefault = cust.getDefaultAddress();
                                cust.setDefaultAddress(other.get(idx));
                                other.set(idx, oldDefault);
                                session.setAttribute("toastMessage", "Thiết lập địa chỉ mặc định thành công!");
                                session.setAttribute("toastType", "success");
                            }
                            break;
                        }
                    }
                } catch (NumberFormatException ignored) {
                }
            }
            // Quay trở lại trang xem chi tiết khách hàng
            response.sendRedirect(request.getContextPath() + "/admin/customers?action=details&id=" + id);
            return;
        }

        // 5. Giao diện Danh sách khách hàng (Có tìm kiếm và bộ lọc)
        String search = request.getParameter("search");

        String filterStatus = request.getParameter("filterStatus");
        String filterGender = request.getParameter("filterGender");
        String filterAddress = request.getParameter("filterAddress");

        List<Customer> filteredCustomers = new ArrayList<>();

        // Lọc tuần tự qua danh sách toàn bộ khách hàng
        for (Customer c : allCustomers) {
            boolean matches = true;

            // Tìm kiếm nhanh: so sánh từ khóa với Mã, Tên, SĐT, Email
            if (search != null && !search.trim().isEmpty()) {
                String keyword = search.toLowerCase().trim();
                matches = c.getId().toLowerCase().contains(keyword)
                        || c.getFullName().toLowerCase().contains(keyword)
                        || c.getPhoneNumber().contains(keyword)
                        || c.getEmail().toLowerCase().contains(keyword);
            }

            // Lọc theo Giới tính (Tất cả, Nam, Nữ, Khác)
            if (matches && filterGender != null && !filterGender.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(filterGender)) {
                matches = filterGender.equalsIgnoreCase(c.getGender());
            }

            // Lọc theo Địa chỉ (kiểm tra trong defaultAddress và otherAddresses)
            if (matches && filterAddress != null && !filterAddress.trim().isEmpty()) {
                String addrKeyword = filterAddress.toLowerCase().trim();
                boolean addressMatch = false;
                
                if (c.getDefaultAddress() != null && c.getDefaultAddress().getAddressDetail() != null) {
                    if (c.getDefaultAddress().getAddressDetail().toLowerCase().contains(addrKeyword)) {
                        addressMatch = true;
                    }
                }
                
                if (!addressMatch && c.getOtherAddresses() != null) {
                    for (Address otherAddr : c.getOtherAddresses()) {
                        if (otherAddr != null && otherAddr.getAddressDetail() != null) {
                            if (otherAddr.getAddressDetail().toLowerCase().contains(addrKeyword)) {
                                addressMatch = true;
                                break;
                            }
                        }
                    }
                }
                matches = addressMatch;
            }



            // Lọc theo Trạng thái hoạt động (Hoạt động, Khóa)
            if (matches && filterStatus != null && !filterStatus.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(filterStatus)) {
                matches = filterStatus.equalsIgnoreCase(c.getStatus());
            }

            // Nếu thoả mãn toàn bộ bộ lọc thì thêm vào danh sách hiển thị
            if (matches) {
                filteredCustomers.add(c);
            }
        }

        // Xuất danh sách khách hàng (đã được lọc) ra file CSV (Excel)
        if ("exportExcel".equals(action)) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"danh_sach_khach_hang.csv\"");
            try (java.io.PrintWriter writer = response.getWriter()) {
                // Ghi ký tự BOM để Excel hiểu file là UTF-8
                writer.write('\ufeff');
                writer.println("STT,Mã khách hàng,Tên khách hàng,Số điện thoại,Email,Giới tính,Trạng thái");
                int stt = 1;
                // Sử dụng filteredCustomers thay vì allCustomers
                for (Customer cust : filteredCustomers) {
                    String name = cust.getFullName() != null ? cust.getFullName().replace("\"", "\"\"") : "";
                    String phone = cust.getPhoneNumber() != null ? cust.getPhoneNumber() : "";
                    String email = cust.getEmail() != null ? cust.getEmail() : "";
                    String gender = cust.getGender() != null ? cust.getGender() : "";
                    String statusLabel = cust.getStatus() != null ? (cust.getStatus().equals("ACTIVE") ? "Hoạt động" : "Ngừng hoạt động") : "";

                    writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"\n",
                            stt++, cust.getId(), name, phone, email, gender, statusLabel);
                }
            }
            return;
        }

        // Đẩy dữ liệu ra view
        request.setAttribute("pageTitle", "Quản lý khách hàng");
        request.setAttribute("customers", filteredCustomers);
        request.setAttribute("searchVal", search != null ? search : "");

        request.setAttribute("filterStatusVal", filterStatus != null ? filterStatus : "Tất cả");
        request.setAttribute("filterGenderVal", filterGender != null ? filterGender : "Tất cả");
        request.setAttribute("filterAddressVal", filterAddress != null ? filterAddress : "");

        request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-list.jsp").forward(request, response);
    }

    /**
     * Xử lý gửi các biểu mẫu thêm, cập nhật hoặc xóa dữ liệu (HTTP POST).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        List<Customer> customers = (List<Customer>) getServletContext().getAttribute("customers");

        if (customers == null) {
            customers = new ArrayList<>();
            getServletContext().setAttribute("customers", customers);
        }

        // Trường hợp thêm mới hoặc chỉnh sửa thông tin khách hàng
        if ("add".equals(action) || "edit".equals(action)) {
            String id = request.getParameter("id");
            
            // Xử lý cơ chế mã tự sinh: Nếu bỏ trống khi thêm mới, sinh mã tự động.
            if ("add".equals(action) && (id == null || id.trim().isEmpty())) {
                id = generateNextCustomerId(customers);
            } else if (id != null) {
                id = id.trim();
            }
            
            String hoTen = request.getParameter("hoTen");
            String email = request.getParameter("email");
            String soDienThoai = request.getParameter("soDienThoai");
            String ngaySinhStr = request.getParameter("ngaySinh");
            String gioiTinh = request.getParameter("gioiTinh");

            String trangThai = request.getParameter("trangThai");
            String diaChiMacDinhTen = request.getParameter("diaChiMacDinhTen");
            String diaChiMacDinhSdt = request.getParameter("diaChiMacDinhSdt");
            String diaChiMacDinhDetail = request.getParameter("diaChiMacDinh");

            String[] diaChiKhacTenArr = request.getParameterValues("diaChiKhacTen");
            String[] diaChiKhacSdtArr = request.getParameterValues("diaChiKhacSdt");
            String[] diaChiKhacDetailArr = request.getParameterValues("diaChiKhac");
            String existingAnhDaiDien = request.getParameter("anhDaiDien"); // Nhận link ảnh cũ để phòng trường hợp không đổi ảnh

            // XỬ LÝ UPLOAD TỆP TIN ẢNH ĐẠI DIỆN
            String anhDaiDien = existingAnhDaiDien;
            try {
                Part filePart = request.getPart("anhDaiDienFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName();
                    // Lưu file vào thư mục /uploads bên trong webapp
                    File uploadDir = new File(getServletContext().getRealPath("/"), "uploads");
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    // Đặt tên tệp tin độc nhất bằng timestamp để không bị ghi đè
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    File fileToSave = new File(uploadDir, uniqueFileName);
                    filePart.write(fileToSave.getAbsolutePath());

                    // Tạo URL tương đối truy cập ảnh từ client
                    anhDaiDien = request.getContextPath() + "/uploads/" + uniqueFileName;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Nếu thêm mới và hoàn toàn không chọn tải ảnh nào lên, tự chọn ngẫu nhiên một avatar có sẵn
            if ("add".equals(action) && (anhDaiDien == null || anhDaiDien.trim().isEmpty())) {
                anhDaiDien = "https://i.pravatar.cc/150?img=" + (int) (Math.random() * 70);
            }

            // Chuyển đổi định dạng Ngày sinh
            Date ngaySinh = null;
            try {
                if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
                    ngaySinh = dateFormat.parse(ngaySinhStr);
                }
            } catch (ParseException e) {
                ngaySinh = new Date();
            }



            // Khởi tạo đối tượng địa chỉ mặc định
            Address defaultAddr = new Address(
                    diaChiMacDinhTen != null ? diaChiMacDinhTen.trim() : "",
                    diaChiMacDinhSdt != null ? diaChiMacDinhSdt.trim() : "",
                    diaChiMacDinhDetail != null ? diaChiMacDinhDetail.trim() : ""
            );

            // Thu thập toàn bộ các địa chỉ phụ khác người dùng nhập
            List<Address> listOtherAddr = new ArrayList<>();
            if (diaChiKhacDetailArr != null) {
                for (int i = 0; i < diaChiKhacDetailArr.length; i++) {
                    String detail = diaChiKhacDetailArr[i];
                    if (detail != null && !detail.trim().isEmpty()) {
                        String ten = (diaChiKhacTenArr != null && diaChiKhacTenArr.length > i && diaChiKhacTenArr[i] != null) ? diaChiKhacTenArr[i].trim() : "";
                        String sdt = (diaChiKhacSdtArr != null && diaChiKhacSdtArr.length > i && diaChiKhacSdtArr[i] != null) ? diaChiKhacSdtArr[i].trim() : "";
                        listOtherAddr.add(new Address(ten, sdt, detail.trim()));
                    }
                }
            }

            // GỌI BỘ XÁC THỰC DỮ LIỆU (VALIDATE)
            boolean isEdit = "edit".equals(action);
            List<String> errors = CustomerValidator.validate(
                    id, hoTen, email, soDienThoai, ngaySinh, gioiTinh,
                    trangThai, diaChiMacDinhDetail, customers, isEdit
            );

            // Nếu phát hiện lỗi nghiệp vụ: Dừng xử lý và trả về form kèm thông tin cũ
            if(!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("isEdit", isEdit);
                request.setAttribute("customer", Customer.builder()
                        .id(id)
                        .fullName(hoTen)
                        .email(email)
                        .phoneNumber(soDienThoai)
                        .dateOfBirth(ngaySinh)
                        .gender(gioiTinh)
                        .status(trangThai)
                        .avatar(anhDaiDien)
                        .defaultAddress(defaultAddr)
                        .otherAddresses(listOtherAddr)
                        .build());
                request.getRequestDispatcher("/WEB-INF/views/admin/ha/customer-form.jsp")
                        .forward(request, response);
                return;
            }

            // Trường hợp dữ liệu hợp lệ: thực hiện Lưu hoặc Cập nhật
            jakarta.servlet.http.HttpSession session = request.getSession();
            if ("add".equals(action)) {
                // Tạo mới Khách hàng và chèn vào đầu danh sách
                Customer newCustomer = Customer.builder()
                        .id(id)
                        .fullName(hoTen)
                        .email(email)
                        .phoneNumber(soDienThoai)
                        .dateOfBirth(ngaySinh)
                        .gender(gioiTinh)
                        .avatar(anhDaiDien)
                        .status(trangThai)
                        .defaultAddress(defaultAddr)
                        .otherAddresses(listOtherAddr)
                        .build();
                customers.add(0, newCustomer);
                session.setAttribute("toastMessage", "Thêm mới khách hàng thành công!");
                session.setAttribute("toastType", "success");
            } else {
                // Tìm kiếm khách hàng cũ và cập nhật đè các thuộc tính mới
                for (Customer c : customers) {
                    if (c.getId().equals(id)) {
                        c.setFullName(hoTen);
                        c.setEmail(email);
                        c.setPhoneNumber(soDienThoai);
                        c.setDateOfBirth(ngaySinh);
                        c.setGender(gioiTinh);
                        c.setAvatar(anhDaiDien);
                        c.setStatus(trangThai);
                        c.setDefaultAddress(defaultAddr);
                        c.setOtherAddresses(listOtherAddr);
                        break;
                    }
                }
                session.setAttribute("toastMessage", "Cập nhật khách hàng thành công!");
                session.setAttribute("toastType", "success");
            }
        } 
        // Thao tác xóa một địa chỉ phụ khỏi hồ sơ khách hàng
        else if ("delete-other-address".equals(action)) {
            jakarta.servlet.http.HttpSession session = request.getSession();
            String id = request.getParameter("id");
            String indexStr = request.getParameter("index");
            if (id != null && indexStr != null) {
                try {
                    int idx = Integer.parseInt(indexStr);
                    for (Customer cust : customers) {
                        if (cust.getId().equals(id)) {
                            if (idx >= 0 && idx < cust.getOtherAddresses().size()) {
                                cust.getOtherAddresses().remove(idx);
                                session.setAttribute("toastMessage", "Xóa địa chỉ phụ thành công!");
                                session.setAttribute("toastType", "success");
                            }
                            break;
                        }
                    }
                } catch (NumberFormatException ignored) {
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/customers?action=details&id=" + id);
            return;
        } 
        // Thao tác đổi trạng thái (gạt switch) khách hàng
        else if ("toggle-status".equals(action)) {
            jakarta.servlet.http.HttpSession session = request.getSession();
            String id = request.getParameter("id");
            if (id != null) {
                for (Customer c : customers) {
                    if (c.getId().equals(id)) {
                        if ("Hoạt động".equalsIgnoreCase(c.getStatus())) {
                            c.setStatus("Khóa");
                        } else {
                            c.setStatus("Hoạt động");
                        }
                        session.setAttribute("toastMessage", "Cập nhật trạng thái thành công!");
                        session.setAttribute("toastType", "success");
                        break;
                    }
                }
            }
        }
        // Thao tác xóa hẳn một khách hàng khỏi hệ thống
        else if ("delete".equals(action)) {
            jakarta.servlet.http.HttpSession session = request.getSession();
            String id = request.getParameter("id");
            customers.removeIf(c -> c.getId().equals(id));
            session.setAttribute("toastMessage", "Xóa khách hàng thành công!");
            session.setAttribute("toastType", "success");
        }

        // Quay lại trang danh sách khách hàng
        response.sendRedirect(request.getContextPath() + "/admin/customers");
    }

    /**
     * Hàm phụ trợ quét danh sách khách hàng để sinh mã kế tiếp có số lớn nhất + 1.
     * Ví dụ quét thấy KH004 thì sinh mã mới gợi ý là KH005.
     */
    private String generateNextCustomerId(List<Customer> customers) {
        int maxNum = 0;
        if (customers != null) {
            for (Customer c : customers) {
                String id = c.getId();
                if (id != null && id.startsWith("KH")) {
                    try {
                        int num = Integer.parseInt(id.substring(2));
                        if (num > maxNum) {
                            maxNum = num;
                        }
                    } catch (NumberFormatException ignored) {
                    }
                }
            }
        }
        return String.format("KH%03d", maxNum + 1);
    }
}