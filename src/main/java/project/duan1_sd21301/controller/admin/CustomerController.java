package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import project.duan1_sd21301.model.Customer;
import project.duan1_sd21301.model.Address;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@WebServlet(name = "CustomerController", value = "/admin/customers")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CustomerController extends HttpServlet {

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    public void init() throws ServletException {
        // Khởi tạo danh sách khách hàng mẫu nếu chưa tồn tại trong ServletContext
        if (getServletContext().getAttribute("customers") == null) {
            List<Customer> customers = new ArrayList<>();
            try {
                customers.add(Customer.builder()
                        .id("KH001")
                        .hoTen("Nguyễn Anh Tuấn")
                        .email("anhtuan.nguyen@gmail.com")
                        .matKhau("tuannh123")
                        .soDienThoai("0987654321")
                        .ngaySinh(dateFormat.parse("1995-05-12"))
                        .gioiTinh("Nam")
                        .diemTichLuy(120)
                        .hangThanhVien("Vàng")
                        .anhDaiDien("https://i.pravatar.cc/150?img=11")
                        .trangThai("Hoạt động")
                        .diaChiMacDinh(new Address("Nguyễn Anh Tuấn", "0987654321", "123 Nguyễn Trãi, Quận 1, TP. Hồ Chí Minh"))
                        .diaChiKhac(new ArrayList<>(Arrays.asList(
                            new Address("Nguyễn Anh Tuấn", "0987654321", "345 Điện Biên Phủ, Bình Thạnh, TP. Hồ Chí Minh")
                        )))
                        .build());

                customers.add(Customer.builder()
                        .id("KH002")
                        .hoTen("Trần Thị Mai")
                        .email("maitran98@gmail.com")
                        .matKhau("maipassword")
                        .soDienThoai("0912345678")
                        .ngaySinh(dateFormat.parse("1998-09-20"))
                        .gioiTinh("Nữ")
                        .diemTichLuy(450)
                        .hangThanhVien("Kim cương")
                        .anhDaiDien("https://i.pravatar.cc/150?img=47")
                        .trangThai("Hoạt động")
                        .diaChiMacDinh(new Address("Trần Thị Mai", "0912345678", "456 Lê Lợi, Quận Hải Châu, Đà Nẵng"))
                        .diaChiKhac(new ArrayList<>(Arrays.asList(
                            new Address("Trần Thị Mai", "0912345678", "12 Nguyễn Văn Linh, Thanh Khê, Đà Nẵng"),
                            new Address("Trần Thị Mai", "0912345678", "78 Trần Hưng Đạo, Sơn Trà, Đà Nẵng")
                        )))
                        .build());

                customers.add(Customer.builder()
                        .id("KH003")
                        .hoTen("Lê Minh Hoàng")
                        .email("hoangleminh@yahoo.com")
                        .matKhau("hoang1992")
                        .soDienThoai("0909090909")
                        .ngaySinh(dateFormat.parse("1992-12-30"))
                        .gioiTinh("Nam")
                        .diemTichLuy(50)
                        .hangThanhVien("Đồng")
                        .anhDaiDien("https://i.pravatar.cc/150?img=12")
                        .trangThai("Khóa")
                        .diaChiMacDinh(new Address("Lê Minh Hoàng", "0909090909", "789 Cầu Giấy, Quận Cầu Giấy, Hà Nội"))
                        .diaChiKhac(new ArrayList<>())
                        .build());

                customers.add(Customer.builder()
                        .id("KH004")
                        .hoTen("Phạm Khánh Vy")
                        .email("vypham.khanh@hotmail.com")
                        .matKhau("vycute99")
                        .soDienThoai("0977777777")
                        .ngaySinh(dateFormat.parse("1999-03-15"))
                        .gioiTinh("Nữ")
                        .diemTichLuy(280)
                        .hangThanhVien("Bạc")
                        .anhDaiDien("https://i.pravatar.cc/150?img=49")
                        .trangThai("Hoạt động")
                        .diaChiMacDinh(new Address("Phạm Khánh Vy", "0977777777", "321 Trần Hưng Đạo, Quận Ninh Kiều, Cần Thơ"))
                        .diaChiKhac(new ArrayList<>(Arrays.asList(
                            new Address("Phạm Khánh Vy", "0977777777", "56 Mậu Thân, Ninh Kiều, Cần Thơ")
                        )))
                        .build());

            } catch (ParseException e) {
                e.printStackTrace();
            }
            getServletContext().setAttribute("customers", customers);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Customer> allCustomers = (List<Customer>) getServletContext().getAttribute("customers");
        if (allCustomers == null) {
            allCustomers = new ArrayList<>();
        }

        String action = request.getParameter("action");

        // 1. Giao diện Thêm mới khách hàng (JSP độc lập)
        if ("add-form".equals(action)) {
            request.setAttribute("pageTitle", "Thêm khách hàng");
            request.getRequestDispatcher("/WEB-INF/views/admin/customer-form.jsp").forward(request, response);
            return;
        }

        // 2. Giao diện Cập nhật khách hàng (JSP độc lập)
        if ("edit-form".equals(action)) {
            String id = request.getParameter("id");
            Customer customer = null;
            for (Customer c : allCustomers) {
                if (c.getId().equals(id)) {
                    customer = c;
                    break;
                }
            }
            request.setAttribute("pageTitle", "Chỉnh sửa khách hàng");
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/views/admin/customer-form.jsp").forward(request, response);
            return;
        }

        // 3. Giao diện Xem chi tiết khách hàng (JSP độc lập)
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
            request.getRequestDispatcher("/WEB-INF/views/admin/customer-details.jsp").forward(request, response);
            return;
        }

        // 4. Thiết lập địa chỉ mặc định từ trang chi tiết
        if ("set-default-address".equals(action)) {
            String id = request.getParameter("id");
            String indexStr = request.getParameter("index");
            if (id != null && indexStr != null) {
                try {
                    int idx = Integer.parseInt(indexStr);
                    for (Customer cust : allCustomers) {
                        if (cust.getId().equals(id)) {
                            List<Address> other = cust.getDiaChiKhac();
                            if (idx >= 0 && idx < other.size()) {
                                Address oldDefault = cust.getDiaChiMacDinh();
                                cust.setDiaChiMacDinh(other.get(idx));
                                other.set(idx, oldDefault);
                            }
                            break;
                        }
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/admin/customers?action=details&id=" + id);
            return;
        }

        // 5. Giao diện Danh sách khách hàng (Mặc định)
        String search = request.getParameter("search");
        String filterRank = request.getParameter("filterRank");
        String filterStatus = request.getParameter("filterStatus");

        List<Customer> filteredCustomers = new ArrayList<>();
        
        for (Customer c : allCustomers) {
            boolean matches = true;

            // Lọc theo từ khóa tìm kiếm (Mã, Tên, SĐT, Email, Địa chỉ)
            if (search != null && !search.trim().isEmpty()) {
                String keyword = search.toLowerCase().trim();
                boolean addressMatch = false;
                if (c.getDiaChiMacDinh() != null) {
                    Address defaultAddr = c.getDiaChiMacDinh();
                    addressMatch = (defaultAddr.getChiTietDiaChi() != null && defaultAddr.getChiTietDiaChi().toLowerCase().contains(keyword))
                            || (defaultAddr.getTenNguoiNhan() != null && defaultAddr.getTenNguoiNhan().toLowerCase().contains(keyword))
                            || (defaultAddr.getSdtNguoiNhan() != null && defaultAddr.getSdtNguoiNhan().toLowerCase().contains(keyword));
                }
                if (!addressMatch && c.getDiaChiKhac() != null) {
                    for (Address otherAddr : c.getDiaChiKhac()) {
                        if (otherAddr != null) {
                            boolean singleMatch = (otherAddr.getChiTietDiaChi() != null && otherAddr.getChiTietDiaChi().toLowerCase().contains(keyword))
                                    || (otherAddr.getTenNguoiNhan() != null && otherAddr.getTenNguoiNhan().toLowerCase().contains(keyword))
                                    || (otherAddr.getSdtNguoiNhan() != null && otherAddr.getSdtNguoiNhan().toLowerCase().contains(keyword));
                            if (singleMatch) {
                                addressMatch = true;
                                break;
                            }
                        }
                    }
                }

                matches = c.getId().toLowerCase().contains(keyword)
                        || c.getHoTen().toLowerCase().contains(keyword)
                        || c.getSoDienThoai().contains(keyword)
                        || c.getEmail().toLowerCase().contains(keyword)
                        || addressMatch;
            }

            // Lọc theo Hạng thành viên
            if (matches && filterRank != null && !filterRank.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(filterRank)) {
                matches = filterRank.equalsIgnoreCase(c.getHangThanhVien());
            }

            // Lọc theo Trạng thái
            if (matches && filterStatus != null && !filterStatus.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(filterStatus)) {
                matches = filterStatus.equalsIgnoreCase(c.getTrangThai());
            }

            if (matches) {
                filteredCustomers.add(c);
            }
        }

        request.setAttribute("pageTitle", "Quản lý khách hàng");
        request.setAttribute("customers", filteredCustomers);
        request.setAttribute("searchVal", search != null ? search : "");
        request.setAttribute("filterRankVal", filterRank != null ? filterRank : "Tất cả");
        request.setAttribute("filterStatusVal", filterStatus != null ? filterStatus : "Tất cả");

        request.getRequestDispatcher("/WEB-INF/views/admin/customer-list.jsp").forward(request, response);
    }

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

        if ("add".equals(action) || "edit".equals(action)) {
            String id = request.getParameter("id");
            String hoTen = request.getParameter("hoTen");
            String email = request.getParameter("email");
            String matKhau = request.getParameter("matKhau");
            String soDienThoai = request.getParameter("soDienThoai");
            String ngaySinhStr = request.getParameter("ngaySinh");
            String gioiTinh = request.getParameter("gioiTinh");
            String diemStr = request.getParameter("diemTichLuy");
            String hangThanhVien = request.getParameter("hangThanhVien");
            String trangThai = request.getParameter("trangThai");
            String diaChiMacDinhTen = request.getParameter("diaChiMacDinhTen");
            String diaChiMacDinhSdt = request.getParameter("diaChiMacDinhSdt");
            String diaChiMacDinhDetail = request.getParameter("diaChiMacDinh");
            
            String[] diaChiKhacTenArr = request.getParameterValues("diaChiKhacTen");
            String[] diaChiKhacSdtArr = request.getParameterValues("diaChiKhacSdt");
            String[] diaChiKhacDetailArr = request.getParameterValues("diaChiKhac");
            String existingAnhDaiDien = request.getParameter("anhDaiDien"); // Giữ ảnh cũ khi edit

            // XỬ LÝ UPLOAD FILE ẢNH ĐẠI DIỆN
            String anhDaiDien = existingAnhDaiDien;
            try {
                Part filePart = request.getPart("anhDaiDienFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName();
                    // Sử dụng File API để tự động cấu trúc đường dẫn uploads an toàn hơn
                    File uploadDir = new File(getServletContext().getRealPath("/"), "uploads");
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    // Tạo tên file độc nhất tránh ghi đè
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    File fileToSave = new File(uploadDir, uniqueFileName);
                    filePart.write(fileToSave.getAbsolutePath());
                    
                    // Đường dẫn url tương đối để hiển thị ảnh
                    anhDaiDien = request.getContextPath() + "/uploads/" + uniqueFileName;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Nếu là thêm mới và hoàn toàn không upload ảnh, tự động nạp ảnh mẫu
            if ("add".equals(action) && (anhDaiDien == null || anhDaiDien.trim().isEmpty())) {
                anhDaiDien = "https://i.pravatar.cc/150?img=" + (int)(Math.random() * 70);
            }

            Date ngaySinh = null;
            try {
                if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
                    ngaySinh = dateFormat.parse(ngaySinhStr);
                }
            } catch (ParseException e) {
                ngaySinh = new Date();
            }

            int diemTichLuy = 0;
            try {
                if (diemStr != null && !diemStr.isEmpty()) {
                    diemTichLuy = Integer.parseInt(diemStr);
                }
            } catch (NumberFormatException ignored) {}

            Address defaultAddr = new Address(
                diaChiMacDinhTen != null ? diaChiMacDinhTen.trim() : "",
                diaChiMacDinhSdt != null ? diaChiMacDinhSdt.trim() : "",
                diaChiMacDinhDetail != null ? diaChiMacDinhDetail.trim() : ""
            );

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



            if ("add".equals(action)) {
                Customer newCustomer = Customer.builder()
                        .id(id)
                        .hoTen(hoTen)
                        .email(email)
                        .matKhau(matKhau)
                        .soDienThoai(soDienThoai)
                        .ngaySinh(ngaySinh)
                        .gioiTinh(gioiTinh)
                        .diemTichLuy(diemTichLuy)
                        .hangThanhVien(hangThanhVien)
                        .anhDaiDien(anhDaiDien)
                        .trangThai(trangThai)
                         .diaChiMacDinh(defaultAddr)
                        .diaChiKhac(listOtherAddr)
                        .build();
                customers.add(newCustomer);
            } else {
                for (Customer c : customers) {
                    if (c.getId().equals(id)) {
                        c.setHoTen(hoTen);
                        c.setEmail(email);
                        c.setMatKhau(matKhau);
                        c.setSoDienThoai(soDienThoai);
                        c.setNgaySinh(ngaySinh);
                        c.setGioiTinh(gioiTinh);
                        c.setDiemTichLuy(diemTichLuy);
                        c.setHangThanhVien(hangThanhVien);
                        c.setAnhDaiDien(anhDaiDien);
                        c.setTrangThai(trangThai);
                        c.setDiaChiMacDinh(defaultAddr);
                        c.setDiaChiKhac(listOtherAddr);
                        break;
                    }
                }
            }
        } else if ("delete-other-address".equals(action)) {
            String id = request.getParameter("id");
            String indexStr = request.getParameter("index");
            if (id != null && indexStr != null) {
                try {
                    int idx = Integer.parseInt(indexStr);
                    for (Customer cust : customers) {
                        if (cust.getId().equals(id)) {
                            if (idx >= 0 && idx < cust.getDiaChiKhac().size()) {
                                cust.getDiaChiKhac().remove(idx);
                            }
                            break;
                        }
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/admin/customers?action=details&id=" + id);
            return;
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            customers.removeIf(c -> c.getId().equals(id));
        }

        response.sendRedirect(request.getContextPath() + "/admin/customers");
    }
}
