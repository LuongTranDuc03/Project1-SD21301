# 🧥 FamiCoats - Hệ Thống Quản Lý & Bán Hàng Tại Quầy (POS)

**FamiCoats** là một hệ thống phần mềm chuyên nghiệp được thiết kế đặc biệt dành riêng cho các cửa hàng kinh doanh áo khoác thời trang. Hệ thống tập trung vào việc quản trị (Admin Dashboard) và vận hành tại quầy (POS), giúp tối ưu hóa quy trình bán hàng, quản lý hàng hóa, hóa đơn, khách hàng, nhân viên và các chương trình khuyến mãi.

Dự án được xây dựng dựa trên kiến trúc MVC với Java Servlet, JSP và Hibernate, mang lại độ ổn định, hiệu năng cao và bảo mật tốt.

---

## 👥 Đội Ngũ Phát Triển (Nhóm SD21301)

- **Trần Đức Lương (Leader)**: Phụ trách Core POS, Quản lý Sản phẩm (Product), Biến thể (Variants), Upload ảnh (Cloudinary API), Dashboard.
- **Hoàng Minh Phúc (Dev)**: Phụ trách Quản lý Hóa đơn (Invoice), Quản lý Khuyến mãi (Coupon).
- **Nguyễn Phạm Đăng Huy (Dev)**: Phụ trách Quản lý Nhân viên (Employee), Tài khoản, Phân quyền hệ thống.
- **Lê Việt Hà (Dev)**: Phụ trách Quản lý Khách hàng (Customer).

---

## 🚀 Các Chức Năng Nổi Bật (Features)

### 1. Hệ thống Bán Hàng Tại Quầy (POS - Point of Sale)
- **Treo hóa đơn (Draft Orders):** Hỗ trợ tạo và lưu tạm tối đa 10 hóa đơn cùng lúc, giúp nhân viên phục vụ nhiều khách hàng song song.
- **Quản lý giỏ hàng:** Thêm sản phẩm theo biến thể (màu sắc, kích cỡ), điều chỉnh số lượng, tự động tính toán tổng tiền.
- **Thanh toán linh hoạt:** Hỗ trợ thanh toán bằng Tiền mặt và Chuyển khoản (tích hợp tạo mã QR động chứa sẵn số tiền và nội dung chuyển khoản).
- **Áp dụng khuyến mãi (Coupon):** Tự động kiểm tra điều kiện (giá trị đơn hàng tối thiểu) và tính toán số tiền được giảm.

### 2. Quản Lý Hàng Hóa (Products & Variants)
- Quản lý sản phẩm cha và các biến thể chi tiết (Màu sắc, Kích thước, Giá bán, Số lượng tồn kho).
- **Tích hợp Cloudinary:** Tự động upload và lưu trữ hình ảnh sản phẩm lên nền tảng đám mây.
- Hỗ trợ Validate dữ liệu chặt chẽ và chuyển đổi trạng thái Bật/Tắt nhanh chóng.

### 3. Quản Lý Hóa Đơn & Đơn Hàng (Invoices)
- Theo dõi toàn bộ hóa đơn Tại quầy và Online.
- Tìm kiếm, lọc hóa đơn theo khoảng thời gian, trạng thái (Chờ xử lý, Đã xác nhận, Hoàn thành, Đã hủy).
- **Xuất báo cáo Excel (Export to Excel):** Hỗ trợ xuất danh sách hóa đơn ra file Excel bằng Apache POI phục vụ kế toán.

### 4. Quản Lý Khách Hàng & Khuyến Mãi (Customers & Coupons)
- Lưu trữ thông tin khách hàng, số điện thoại, địa chỉ (tích hợp API Tỉnh/Thành Việt Nam).
- Tạo các chương trình giảm giá (% hoặc số tiền cố định) với các điều kiện áp dụng chặt chẽ.

### 5. Quản Lý Phân Quyền & Nhân Sự (RBAC - Role Based Access Control)
- Phân chia vai trò rõ ràng: **Quản lý (Manager)** và **Nhân viên (Staff)**.
- **Quản lý:** Toàn quyền truy cập bảng điều khiển, thêm/sửa/xóa/xuất dữ liệu, quản lý nhân viên và cấu hình cửa hàng.
- **Nhân viên:** Chỉ có quyền thao tác bán hàng POS, xem dữ liệu (Read-only) hàng hóa, hóa đơn, khách hàng, không thể vào các module nhạy cảm hay xóa dữ liệu.
- Đăng nhập bảo mật thông thường hoặc **Đăng nhập qua Google (Google Login)**.

---

## 🔄 Luồng Hoạt Động (Project Flow)

### Luồng 1: Xác Thực & Phân Quyền (Authentication & RBAC)
1. Người dùng truy cập trang Đăng nhập (Login).
2. Lựa chọn Đăng nhập tài khoản/mật khẩu hoặc Sign-in with Google.
3. Hệ thống kiểm tra vai trò (`Role ID`).
   - Nếu là **Staff**, hệ thống ẩn các chức năng nhạy cảm trên giao diện (Dashboard, Tài khoản) và chuyển hướng tới trang POS. 
   - Đồng thời, Filter ở phía Server (`AuthFilter`) sẽ chặn mọi request truy cập trái phép.
   - Nếu là **Manager**, hiển thị đầy đủ giao diện Admin Dashboard và toàn quyền chức năng.

### Luồng 2: Quy Trình Bán Hàng (POS Workflow)
1. Thu ngân vào trang **Bán Hàng (POS)**.
2. Tạo Hóa Đơn Chờ mới (Hỗ trợ nhiều tab hóa đơn).
3. Tìm kiếm sản phẩm hoặc quét sản phẩm -> Chọn biến thể (Màu, Size) -> Thêm vào giỏ hàng.
4. Cập nhật số lượng, hệ thống kiểm tra tồn kho realtime.
5. (Tùy chọn) Chọn khách hàng (hoặc thêm mới), áp dụng Mã giảm giá (Coupon).
6. Bấm **Thanh toán**, chọn phương thức:
   - *Tiền mặt:* Thu ngân nhập tiền khách đưa, hệ thống tính tiền thừa.
   - *Chuyển khoản:* Hệ thống hiển thị QR Code động, khách hàng quét để thanh toán.
7. Bấm Xác nhận hoàn tất -> Hệ thống trừ tồn kho, cập nhật doanh thu và in hóa đơn (nếu có).

### Luồng 3: Quản Lý Sản Phẩm (Product Workflow)
1. Quản lý vào trang Hàng Hóa -> Thêm Sản phẩm mới.
2. Nhập thông tin chung (Tên, Mô tả, Danh mục).
3. Thêm các Biến thể (Thêm kích cỡ, màu sắc, giá, số lượng).
4. Tải ảnh sản phẩm lên -> Hệ thống gọi API qua `CloudinaryUploadServlet` trả về link ảnh.
5. Bấm Lưu -> Dữ liệu lưu vào DB thông qua Hibernate.

### Luồng 4: Thống Kê & Báo Cáo (Dashboard Workflow)
1. Quản lý vào trang Dashboard (hoặc Inventory Dashboard).
2. Hệ thống tổng hợp dữ liệu doanh thu, đơn hàng, sản phẩm bán chạy, khách hàng mua nhiều.
3. Vẽ biểu đồ trực quan giúp Quản lý nắm bắt tình hình kinh doanh ngay lập tức.

---

## 🛠 Kiến Trúc & Công Nghệ (Tech Stack)

- **Backend:** Java 17, Jakarta Servlet API, JSP (JavaServer Pages), JSTL.
- **ORM / Database:** Hibernate Core (6.x), SQL Server. (Sử dụng JDBC cho các query đặc thù cần tối ưu).
- **Frontend:** HTML5, CSS3, Vanilla JavaScript, JSP (Server-side rendering).
- **Thư viện UI/UX:** SweetAlert2, QRCode.js.
- **Tích hợp API (Third-party APIs):** 
  - Cloudinary (Quản lý hình ảnh)
  - Google API Client (Xác thực Google Sign-In)
  - Jackson (Parse JSON cho API Tỉnh/Thành phố)
  - Apache POI (Xuất file Excel)
- **Công cụ phát triển:** IntelliJ IDEA, SQL Server Management Studio (SSMS), Maven.

---

## ⚙️ Hướng Dẫn Cài Đặt (Getting Started)

1. **Clone dự án:** Tải mã nguồn từ repository.
2. **Database:** Mở SSMS, tạo database mới và chạy script (nếu có) hoặc để Hibernate tự động tạo bảng (tùy cấu hình `hibernate.hbm2ddl.auto`).
3. **Cấu hình kết nối:** Mở file cấu hình Hibernate / JDBC cập nhật chuỗi kết nối SQL Server, user, password.
4. **Cloudinary & Google API:** Thay đổi API Key, API Secret trong code nếu cần thiết.
5. **Run dự án:** Chạy thông qua Maven (Tomcat plugin) hoặc configure Local Tomcat Server trên IntelliJ. 

> *FamiCoats - Tối ưu hóa vận hành, Nâng tầm cửa hàng của bạn!*
