# 🧾 Luồng Hoạt Động: Module Quản Lý Hóa Đơn & Đơn Hàng (Invoices & Orders)

Tài liệu này mô tả chi tiết quy trình tra cứu, quản lý danh sách hóa đơn bán tại quầy và online, luồng chuyển đổi trạng thái đơn hàng, hoàn trả hàng tồn kho khi hủy đơn và xuất báo cáo Excel trong hệ thống FamiCoats.

---

## 1. Thành Phần Code Đảm Nhận

- **Views (JSP):**
  - [invoice-list.jsp](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/webapp/WEB-INF/views/admin/phuc/invoice-list.jsp) - Danh sách hóa đơn kèm bộ lọc nâng cao.
  - [invoice-detail.jsp](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/webapp/WEB-INF/views/admin/phuc/invoice-detail.jsp) - Màn hình xem chi tiết đơn hàng, lịch sử thay đổi trạng thái và nút cập nhật.
  - [invoice-print.jsp](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/webapp/WEB-INF/views/admin/phuc/invoice-print.jsp) - Mẫu in hóa đơn bán lẻ.
- **Controllers / Servlets:**
  - [InvoiceController.java](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/java/project/duan1_sd21301/controller/admin/phuc/InvoiceController.java) - Tiếp nhận các request tra cứu, cập nhật trạng thái đơn hàng và xuất Excel.
- **Repositories:**
  - [InvoiceRepository.java](file:///d:/DuAn1-ChayThu/Project1-SD21301/src/main/java/project/duan1_sd21301/repository/phuc/InvoiceRepository.java) - Thực hiện các truy vấn SQL nâng cao (tìm kiếm dynamic, phân trang, thống kê tổng tiền, update trạng thái kèm khôi phục kho).

---

## 2. Sơ Đồ Luồng Hoạt Động (Mermaid Sequence Diagram)

```mermaid
sequenceDiagram
    autonumber
    actor User as 👤 Người dùng (Manager / Staff)
    participant ListUI as 🖥️ invoice-list.jsp
    participant DetailUI as 🖥️ invoice-detail.jsp
    participant InvCtrl as ⚙️ InvoiceController
    participant Repo as 💾 InvoiceRepository
    participant DB as 🗄️ SQL Server Database

    rect rgb(240, 248, 255)
    note over User, DB: 1. Luồng Lọc & Tra Cứu Hóa Đơn
    User->>ListUI: Nhập từ khóa (Mã HD/SĐT) + Chọn khoảng ngày + Trạng thái
    ListUI->>InvCtrl: GET /admin/invoices/list?search=...&fromDate=...&toDate=...&status=...
    InvCtrl->>Repo: findAll(search, type, status, paymentStatus, fromDate, toDate, page, pageSize)
    Repo->>DB: SELECT * FROM hoa_don WHERE [Dynamic Conditions] ORDER BY ngay_tao DESC
    DB-->>Repo: ResultSet Hóa đơn + Phân trang
    Repo-->>InvCtrl: List<HoaDon> & TotalPages
    InvCtrl-->>ListUI: Render bảng danh sách hóa đơn
    end

    rect rgb(255, 245, 245)
    note over User, DB: 2. Luồng Cập Nhật Trạng Thái & Hoàn Kho Khi Hủy
    User->>DetailUI: Chọn Trạng thái mới (Ví dụ: "Hủy đơn" - Status 4)
    DetailUI->>InvCtrl: POST /admin/invoices/update-status (id, newStatus, note)
    InvCtrl->>Repo: updateStatus(id, newStatus, note)
    
    alt Trường hợp Hủy đơn hàng (Status = 4)
        Repo->>DB: conn.setAutoCommit(false) -> Bắt đầu Transaction
        Repo->>DB: UPDATE hoa_don SET trang_thai_don_hang = 4, ngay_huy = GETDATE()
        Repo->>DB: SELECT * FROM hoa_don_chi_tiet WHERE id_hoa_don = ?
        Repo->>DB: LOOP UPDATE product_variants SET so_luong = so_luong + ? (Hoàn trả kho)
        Repo->>DB: conn.commit()
    else Chuyển sang Trạng thái khác (Đang giao / Hoàn thành)
        Repo->>DB: UPDATE hoa_don SET trang_thai_don_hang = ?
    end
    
    Repo-->>InvCtrl: Trả về thành công
    InvCtrl-->>DetailUI: Redirect /admin/invoices/detail kèm Toast Success
    end
```

---

## 3. Các Bước Xử Lý Nghiệp Vụ Chi Tiết

### 3.1. Bộ Lọc Tìm Kiếm Đa Chỉ Tiêu
Hệ thống hỗ trợ tìm kiếm linh hoạt thông qua `InvoiceRepository.findAll()` với các tham số:
- **Từ khóa search:** Tìm theo Mã hóa đơn (`HD...`), Tên khách hàng, Số điện thoại nhận.
- **Loại đơn hàng:** Tại quầy (POS) hoặc Đơn Online giao hàng.
- **Trạng thái đơn hàng:** 
  - `0`: Chờ xử lý
  - `1`: Đã xác nhận
  - `2`: Đang giao hàng
  - `3`: Hoàn thành
  - `4`: Đã hủy
- **Khoảng thời gian:** Từ ngày -> Đến ngày (`fromDate`, `toDate`).
- **Phân trang:** Hỗ trợ phân trang chuẩn SQL với `OFFSET` và `FETCH NEXT`.

### 3.2. Vòng Đời Trạng Thái Đơn Hàng (Order Lifecycle)

```mermaid
stateDiagram-v2
    [*] --> ChoXuly: 0. Đơn mới tạo
    ChoXuly --> DaXacNhan: 1. Xác nhận đơn
    DaXacNhan --> DangGiao: 2. Giao cho shipper
    DangGiao --> HoanThanh: 3. Khách đã nhận & thanh toán
    ChoXuly --> DaHuy: 4. Hủy đơn
    DaXacNhan --> DaHuy: 4. Hủy đơn (Cần hoàn kho)
    DangGiao --> DaHuy: 4. Hủy đơn (Cần hoàn kho)
    HoanThanh --> [*]
    DaHuy --> [*]
```

### 3.3. Cơ Chế Hoàn Trả Tồn Kho Khi Hủy Đơn
Một điểm kỹ thuật quan trọng trong xử lý hóa đơn:
- Khi một đơn hàng đã chốt (đã trừ kho ở bước trước) bị **Hủy (`Status = 4`)**, hệ thống bắt buộc chạy **SQL Transaction** để cộng trả lại số lượng sản phẩm vào kho:
  $$\text{Số lượng tồn kho mới} = \text{Số lượng hiện tại} + \text{Số lượng trong đơn bị hủy}$$
- Nếu mã giảm giá (Coupon) được sử dụng trong đơn đó, lượt sử dụng của Coupon cũng sẽ được giảm đi 1 (`da_su_dung - 1`) để đảm bảo quyền lợi cho cửa hàng.

### 3.4. Xuất Báo Cáo Excel (Apache POI)
- Khi ấn nút **"Xuất Excel"** tại `invoice-list.jsp`, request gửi tới `/admin/invoices/export-excel`.
- `InvoiceController` sử dụng thư viện **Apache POI** để tạo file `.xlsx` động chứa toàn bộ danh sách hóa đơn theo bộ lọc hiện tại, bao gồm: Mã HD, Ngày tạo, Khách hàng, Thu ngân, Phương thức thanh toán, Tổng tiền và Trạng thái.
- File Excel được ghi trực tiếp vào `HttpServletResponse` dưới dạng Attachment Stream để trình duyệt tự động tải xuống.

---

## 4. Phân Quyền Thao Tác

- **Quản lý (Manager):** Có quyền thay đổi mọi trạng thái hóa đơn, duyệt hủy đơn, hoàn tiền và xuất file Excel báo cáo.
- **Nhân viên (Staff):** Xem được danh sách và chi tiết hóa đơn. 
  - Không có quyền bấm nút **Hủy hóa đơn** đã hoàn thành hoặc **Xuất báo cáo Excel** (các nút này bị ẩn trên UI theo quy định an ninh).
