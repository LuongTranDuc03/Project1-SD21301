# 🛒 Famicoats - Quản Lý Cửa Hàng Bán Quần Áo (Dự án 1 - SD21301)

Dự án này là hệ thống phần mềm quản lý cửa hàng bán lẻ (Point of Sale - POS) và quản lý sản phẩm, nhân sự, khách hàng, được xây dựng trên nền tảng Java Web (Servlet/JSP) và cơ sở dữ liệu Microsoft SQL Server.

## 🚀 Tính năng nổi bật

### 1. Quản lý Sản phẩm & Biến thể (Variants)
- Quản lý các thuộc tính sản phẩm: Thương hiệu, Danh mục, Chất liệu, Màu sắc, Kích thước, Kiểu dáng, Xuất xứ.
- Quản lý Sản phẩm cha và các Biến thể (Chi tiết sản phẩm).
- Tích hợp **Cloudinary** để upload và quản lý hình ảnh sản phẩm.

### 2. Bán hàng tại quầy (POS)
- Giao diện bán hàng nhanh chóng, tạo hóa đơn trực tiếp tại quầy.
- Quản lý nhiều hóa đơn chờ (Draft Invoices) cùng lúc.
- Thêm sản phẩm vào giỏ hàng, tùy chỉnh số lượng.
- Tính toán tổng tiền, áp dụng Phiếu giảm giá (Coupons).
- Xác nhận thanh toán và in/xuất hóa đơn.

### 3. Quản lý Hóa đơn & Lịch sử
- Theo dõi trạng thái hóa đơn (Chờ thanh toán, Đã thanh toán, Hủy...).
- Lưu vết lịch sử thay đổi trạng thái hóa đơn.
- Quản lý lịch sử thanh toán chi tiết.

### 4. Quản lý Nhân sự & Phân quyền
- Đăng nhập/Đăng xuất bảo mật. Hỗ trợ đăng nhập bằng tài khoản Google (OAuth 2.0).
- Phân quyền người dùng (Admin, Nhân viên).
- Quản lý thông tin nhân viên, đổi trạng thái làm việc.

### 5. Quản lý Khách hàng
- Lưu trữ thông tin khách hàng.
- Quản lý nhiều địa chỉ cho một khách hàng.
- Tích hợp API lấy dữ liệu Tỉnh/Thành phố, Quận/Huyện, Phường/Xã tự động.

### 6. Báo cáo & Thống kê (Dashboard)
- Thống kê doanh thu, số lượng đơn hàng.
- Dashboard tổng quan về lượng tồn kho.
- Tính năng xuất báo cáo ra file Excel (sử dụng Apache POI).

---

## 🗄 Sơ đồ cơ sở dữ liệu (Database Schema)

Hệ thống sử dụng cơ sở dữ liệu quan hệ với các bảng chính sau:

- **Quản lý người dùng & Phân quyền**: `vai_tro`, `nhan_vien`, `khach_hang`, `khach_hang_dia_chi`, `dia_chi`.
- **Thuộc tính sản phẩm**: `thuong_hieu`, `danh_muc`, `chat_lieu`, `mau_sac`, `kich_thuoc`, `kieu_dang`, `xuat_xu`.
- **Sản phẩm**: `san_pham`, `chi_tiet_san_pham`, `hinh_anh`.
- **Giao dịch & Thanh toán**: `hoa_don`, `chi_tiet_hoa_don`, `phieu_giam_gia`, `phuong_thuc_thanh_toan`.
- **Lịch sử**: `lich_su_hoa_don`, `lich_su_thanh_toan`.

*(Script tạo database có sẵn tại: `src/main/resources/famicoats_template.sql`)*

---

## 🛠 Công nghệ sử dụng
- **Backend**: Java 17, Jakarta Servlet 6, JSP, JSTL, Hibernate Core / JPA.
- **Database**: Microsoft SQL Server.
- **Build Tool**: Maven.
- **Thư viện khác**: Jackson (JSON), Apache POI (Excel), Cloudinary (Image Upload), Google API Client.

---

## 📖 Hướng dẫn cài đặt & chạy dự án

### Yêu cầu hệ thống:
- Java JDK 17
- Maven 3.x
- Microsoft SQL Server
- Apache Tomcat (phiên bản 10.1.x hỗ trợ Jakarta EE 10)

### Các bước thực hiện:

**Bước 1: Khởi tạo Database**
1. Mở SQL Server Management Studio (SSMS).
2. Chạy file script SQL `src/main/resources/famicoats_template.sql` để tạo schema và dữ liệu mẫu.

**Bước 2: Cấu hình kết nối CSDL & API**
- Kiểm tra và cập nhật thông tin chuỗi kết nối SQL Server (trong package `util/DatabaseConnection.java` hoặc file cấu hình Hibernate) cho phù hợp với tài khoản `sa` và `password` trên máy của bạn.
- Cập nhật các thông tin API keys của Cloudinary và Google Client ID nếu cần kiểm thử tính năng upload ảnh và đăng nhập Google.

**Bước 3: Build dự án**
Mở terminal hoặc command prompt tại thư mục gốc của dự án (nơi chứa file `pom.xml`) và chạy lệnh:
```bash
mvn clean install
```

**Bước 4: Deploy & Chạy dự án**
- **Sử dụng IDE (Khuyên dùng)**: Nếu dùng IntelliJ IDEA / Eclipse / VS Code, cấu hình **Smart Tomcat** hoặc cấu hình Application Server trỏ tới thư mục `target` hoặc thư mục dự án và chạy.
- **Sử dụng Tomcat độc lập**: Copy thư mục đã build hoặc file `.war` trong thư mục `target` vào thư mục `webapps` của Apache Tomcat và khởi động Tomcat (`bin/startup.bat`).

**Bước 5: Truy cập**
- Mở trình duyệt và truy cập vào đường dẫn dự án (Ví dụ: `http://localhost:8080/duan1_sd21301`).
- Sử dụng tài khoản quản trị có sẵn trong database để đăng nhập.
