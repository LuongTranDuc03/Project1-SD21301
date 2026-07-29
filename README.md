# Hệ thống Quản lý & Bán hàng tại quầy (POS) FamiCoats

**Các thành viên nhóm phát triển:**
- Trần Đức Lương (Leader)
- Hoàng Minh Phúc (Dev)
- Nguyễn Phạm Đăng Huy (Dev)
- Lê Việt Hà (Dev)

---

## GIỚI THIỆU DỰ ÁN

Chào mừng bạn đến với dự án **FamiCoats** - Hệ thống phần mềm chuyên nghiệp dành riêng cho việc quản lý cửa hàng kinh doanh áo khoác thời trang. 

Khác với một website thương mại điện tử đơn thuần, dự án của chúng tôi tập trung sức mạnh vào **Hệ thống quản trị (Admin Dashboard)** và **Nền tảng Bán hàng tại quầy (POS - Point of Sale)**. Hệ thống được xây dựng nhằm giải quyết bài toán quản lý vận hành thực tế tại các cửa hàng vật lý: từ việc xử lý đơn hàng tốc độ cao tại quầy, quản lý chính xác từng biến thể sản phẩm (màu sắc, kích cỡ, tồn kho), cho đến việc theo dõi doanh thu và chăm sóc khách hàng.

### 1. Các tính năng nổi bật của FamiCoats

Dự án được thiết kế xoay quanh các quy trình nghiệp vụ cốt lõi của một cửa hàng thời trang:

#### 🛍️ Hệ thống Bán hàng tại quầy (POS)
- **Xử lý đa luồng:** Cho phép nhân viên tạo và treo nhiều hóa đơn cùng lúc (tối đa 10 hóa đơn), giúp phục vụ nhiều khách hàng song song mà không bị gián đoạn.
- **Thanh toán linh hoạt:** Hỗ trợ thanh toán bằng Tiền mặt hoặc Chuyển khoản. Đặc biệt, hệ thống tự động sinh **Mã QR chuyển khoản** với số tiền chính xác cho từng hóa đơn.
- **Tích hợp phần cứng:** Hỗ trợ tính năng in hóa đơn trực tiếp cho khách hàng.
- **Xử lý Khuyến mãi thông minh:** Tự động tính toán áp dụng hoặc gỡ bỏ mã giảm giá dựa trên giá trị tối thiểu của đơn hàng ngay trong lúc bán.

#### 📦 Quản lý Sản phẩm & Biến thể (Variants)
- Quản lý cấu trúc sản phẩm phức tạp với nhiều biến thể (Màu sắc, Kích cỡ, Giá nhập, Giá bán, Số lượng tồn kho).
- Tích hợp **Cloudinary API** để lưu trữ và quản lý hình ảnh sản phẩm/biến thể trực tiếp trên nền tảng đám mây.
- Bật/tắt trạng thái (Còn hàng/Hết hàng) nhanh chóng bằng công tắc (Toggle Switch) ngay trên bảng dữ liệu.

#### 🧾 Quản lý Hóa đơn & Đơn hàng
- Phân loại rõ ràng đơn hàng **Tại quầy** và **Online**.
- Bộ lọc nâng cao: Tìm kiếm theo mã hóa đơn, khoảng thời gian (Từ ngày - Đến ngày), trạng thái đơn hàng (Chờ xử lý, Đã xác nhận, Hoàn thành, Đã hủy...).
- Theo dõi chi tiết lịch sử cập nhật trạng thái của từng đơn hàng.
- **Xuất báo cáo Excel** danh sách hóa đơn phục vụ công tác kế toán.

#### 🎁 Quản lý Khuyến mãi & Khách hàng
- Tạo lập các chiến dịch giảm giá, mã Coupon với các điều kiện áp dụng chặt chẽ (giảm theo % hoặc số tiền cố định, giá trị đơn hàng tối thiểu).
- Lưu trữ thông tin khách hàng, lịch sử mua hàng để hỗ trợ các chiến dịch chăm sóc khách hàng.

### 2. Kiến trúc & Công nghệ sử dụng

FamiCoats được phát triển dựa trên mô hình MVC truyền thống, đảm bảo sự ổn định, bảo mật và dễ dàng mở rộng.

- **Backend:** Java 17, Jakarta Servlet API, JSP (JavaServer Pages).
- **ORM / Database Access:** Hibernate Core kết hợp JDBC thuần túy cho các tác vụ cần tối ưu hiệu năng cao (như xử lý giao dịch tại POS).
- **Cơ sở dữ liệu:** Microsoft SQL Server.
- **Frontend:** HTML5, CSS3, Vanilla JavaScript, kết hợp các thư viện UI/UX (SweetAlert2, QRCode.js).
- **Tích hợp (Third-party APIs):** 
  - Cloudinary (Quản lý hình ảnh)
  - API Tỉnh/Thành Việt Nam (Quản lý địa chỉ giao hàng)
- **Công cụ phát triển & Quản lý mã nguồn:** IntelliJ IDEA, SQL Server Management Studio (SSMS), Postman, Git & GitHub.

---

> *"Dự án FamiCoats là tâm huyết của toàn bộ nhóm. Qua quá trình phát triển, chúng tôi không chỉ nắm vững cách vận hành của một hệ thống quản lý bán hàng thực tế mà còn giải quyết được nhiều bài toán kỹ thuật phức tạp như: đồng bộ trạng thái đơn hàng realtime trên UI, xử lý giao dịch (Transaction) an toàn khi thanh toán, và tối ưu hóa trải nghiệm của nhân viên thu ngân tại quầy."* - **Đại diện nhóm phát triển.**
