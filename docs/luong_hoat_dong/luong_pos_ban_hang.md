# 🛍️ Luồng Hoạt Động: Module Bán Hàng Tại Quầy (POS - Point of Sale)

Tài liệu này mô tả chi tiết luồng bán hàng tốc độ cao tại quầy, quản lý đơn hàng chờ đa tab, áp dụng mã giảm giá, sinh mã VietQR chuyển khoản tự động, quy trình giao dịch SQL Transaction an toàn và in hóa đơn cho khách.

---

## 1. Thành Phần Code Đảm Nhận

- **View (JSP & JS):**
  - [pos.jsp](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/webapp/WEB-INF/views/admin/pos.jsp) - Màn hình thu ngân POS tích hợp modal tìm sản phẩm, chọn khách hàng, chọn coupon và quét VietQR.
  - [invoice-print.jsp](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/webapp/WEB-INF/views/admin/phuc/invoice-print.jsp) - Giao diện in hóa đơn bán hàng.
- **Controllers / Servlets:**
  - [PosController.java](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/java/project/duan1_sd21301/controller/admin/PosController.java) (`/admin/pos`) - Tải dữ liệu ban đầu (danh sách sản phẩm, biến thể, khách hàng, coupon kích hoạt).
  - [PosCheckoutController.java](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/java/project/duan1_sd21301/controller/admin/PosCheckoutController.java) (`/admin/pos/checkout`) - Xử lý thanh toán đơn hàng (AJAX POST JSON).
  - [PosDraftController.java](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/java/project/duan1_sd21301/controller/admin/PosDraftController.java) (`/admin/pos/draft/*`) - Quản lý và lưu trữ các đơn hàng chờ.
- **Services & Repositories:**
  - [PosCheckoutService.java](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/java/project/duan1_sd21301/service/pos/PosCheckoutService.java) - Chịu trách nhiệm thực thi **SQL Transaction** an toàn (tạo/cập nhật hóa đơn, thêm chi tiết hóa đơn, trừ tồn kho `so_luong` của biến thể, cập nhật `da_su_dung` mã giảm giá).
- **DTOs:**
  - `PosOrderRequestDTO.java`, `PosOrderItemDTO.java` - Đối tượng truyền nhận dữ liệu hóa đơn POS.

---

## 2. Sơ Đồ Luồng Hoạt Động (Mermaid Sequence Diagram)

```mermaid
sequenceDiagram
    autonumber
    actor Staff as 👩‍💼 Thu ngân (Staff/Manager)
    participant POS as 🖥️ UI POS (pos.jsp)
    participant CheckoutCtrl as ⚙️ PosCheckoutController
    participant Service as 🧩 PosCheckoutService
    participant DB as 🗄️ SQL Server Database

    rect rgb(240, 248, 255)
    note over Staff, DB: 1. Thao tác chuẩn bị đơn tại quầy
    Staff->>POS: Mở /admin/pos -> Hệ thống nạp danh sách Sản phẩm, Biến thể, Coupon, Khách hàng
    Staff->>POS: Thêm Tab hóa đơn mới (cho phép tối đa 10 hóa đơn chờ cùng lúc)
    Staff->>POS: Chọn sản phẩm + kích thước + màu sắc -> Thêm vào giỏ hàng
    Staff->>POS: Chọn Khách hàng (khách lẻ hoặc tìm theo SĐT) & Áp dụng Mã giảm giá (Coupon)
    POS->>POS: Tự động tính toán: Tạm tính, Tiền giảm, Phí giao hàng (nếu có) -> Tổng thanh toán
    end

    rect rgb(254, 243, 199)
    note over Staff, DB: 2. Thanh toán & Giao dịch DB (Transaction)
    Staff->>POS: Chọn Hình thức thanh toán (Tiền mặt hoặc VietQR) -> Chọn "Thanh toán & In hóa đơn"
    alt Thanh toán Chuyển khoản (VietQR)
        POS->>POS: Hiển thị Modal VietQR (Sinh QR tự động với Ngân hàng + STK + Số tiền chuẩn)
    end
    POS->>CheckoutCtrl: AJAX POST /admin/pos/checkout (JSON Order Payload)
    CheckoutCtrl->>Service: processCheckout(PosOrderRequestDTO, loggedInUser)
    
    Service->>DB: conn.setAutoCommit(false) -> Bắt đầu Transaction
    Service->>DB: 1. Validation tồn kho biến thể sản phẩm (so_luong >= quantity)
    Service->>DB: 2. Validation & Trừ số lượt dùng Coupon (da_su_dung += 1)
    Service->>DB: 3. INSERT INTO hoa_don (Mã HD, NV tạo, KH, Tổng tiền, Trạng thái=Completed)
    Service->>DB: 4. LOOP INSERT INTO hoa_don_chi_tiet (ID hóa đơn, ID biến thể, Số lượng, Đơn giá)
    Service->>DB: 5. UPDATE product_variants SET so_luong = so_luong - ? (Trừ tồn kho)
    
    alt Không có lỗi xảy ra
        Service->>DB: conn.commit() -> Hoàn tất giao dịch
        Service-->>CheckoutCtrl: Trả về invoiceCode thành công (VD: HD10028)
        CheckoutCtrl-->>POS: HTTP 200 { success: true, invoiceCode: "HD10028" }
        POS->>POS: Xóa tab hóa đơn đã thanh toán -> Mở cửa sổ In Hóa Đơn (`/admin/invoices/print?code=HD10028`)
    else Có lỗi xảy ra (Hết hàng trong kho / Coupon vượt hạn mức)
        Service->>DB: conn.rollback() -> Phục hồi nguyên trạng dữ liệu DB
        Service-->>CheckoutCtrl: Throw Exception message
        CheckoutCtrl-->>POS: HTTP 400/500 { success: false, message: "Lỗi chi tiết..." }
        POS->>POS: Hiển thị SweetAlert2 thông báo lỗi cho Thu ngân
    end
    end
```

---

## 3. Các Bước Xử Lý Nghiệp Vụ Chi Tiết

### 3.1. Quản lý Đa Đơn Hàng Chờ (Multi-tab Orders)
- Màn hình POS cho phép thu ngân phục vụ song song nhiều khách hàng cùng lúc.
- Mỗi đơn hàng được lưu dưới dạng một **Tab tạm (Draft Order)** trong LocalStorage / Memory.
- Hỗ trợ tới 10 hóa đơn chờ. Thu ngân có thể chuyển đổi linh hoạt giữa các tab mà không làm mất dữ liệu sản phẩm đã chọn của từng khách.

### 3.2. Chọn Sản Phẩm & Áp Dụng Khuyến Mãi
1. **Tìm kiếm sản phẩm:** Hỗ trợ tìm kiếm theo tên, mã sản phẩm hoặc lọc theo Danh mục, Màu sắc, Kích cỡ.
2. **Kiểm tra tồn kho tức thì (UI Level):** Khi chọn biến thể, hệ thống hiển thị chính xác số lượng tồn kho còn lại (`so_luong`). Không cho phép chọn quá số lượng hiện có.
3. **Áp dụng Coupon:**
   - Hệ thống tự động lọc danh sách mã giảm giá hợp lệ đang có hiệu lực (`findActive`).
   - Kiểm tra điều kiện **Giá trị đơn hàng tối thiểu (`gia_tri_toi_thieu`)**. Nếu giỏ hàng không đạt điều kiện, hệ thống cảnh báo và không áp dụng.

### 3.3. Xử Lý Thanh Toán & SQL Transaction (Cốt Lõi)
Khi ấn **Thanh Toán**, request JSON được truyền về `PosCheckoutService.processCheckout`:
1. **Khởi tạo Transaction:** `conn.setAutoCommit(false)`.
2. **Sinh mã Hóa đơn:** Tự động tạo mã dạng `HDxxxxx` không trùng lặp.
3. **Kiểm tra điều kiện Coupon (Server-side Validation):**
   - Kiểm tra `da_su_dung < so_luong` toàn hệ thống.
   - Kiểm tra số lần sử dụng của khách hàng hiện tại (`han_su_dung_moi_khach`).
4. **Ghi nhận Hóa đơn (`hoa_don`):**
   - Lưu ID Nhân viên thu ngân (`loggedInUser.getId()`).
   - Ghi nhận trạng thái: `3` (Hoàn thành) đối với mua trực tiếp tại quầy, hoặc `1` (Đã xác nhận) nếu chọn Giao hàng.
5. **Ghi nhận Chi tiết & Trừ Tồn Kho:**
   - Với mỗi sản phẩm trong giỏ hàng, hệ thống ghi một bản ghi vào `hoa_don_chi_tiet`.
   - Thực thi câu lệnh SQL trực tiếp: `UPDATE product_variants SET so_luong = so_luong - ? WHERE id = ?`. Nếu tồn kho < số lượng mua, lập tức ném ngoại lệ để Rollback.
6. **Commit & Phản Hồi:** Nếu mọi câu lệnh đều thành công, gọi `conn.commit()`.

---

## 4. In Hóa Đơn & Xử Lý Sự Cố

- **In Hóa Đơn:** Ngay sau khi nhận kết quả thanh toán thành công (`invoiceCode`), màn hình tự động bật cửa sổ in hóa đơn `/admin/invoices/print?code=HDxxxxx` được định dạng chuẩn máy in nhiệt 80mm.
- **Rollback An Toàn:** Nếu hai thu ngân cùng bán biến thể sản phẩm cuối cùng trong kho tại một thời điểm, chỉ một giao dịch được phép `commit`, giao dịch còn lại sẽ bị `rollback` và báo lỗi *"Sản phẩm đã hết hàng trong kho!"* giúp tránh tranh chấp dữ liệu (Concurrency handling).
