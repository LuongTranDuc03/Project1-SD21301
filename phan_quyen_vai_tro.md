# Tài Liệu Phân Quyền Vai Trò (Role-Based Access Control)

Tài liệu này mô tả chi tiết các quyền hạn tương ứng với từng vai trò trong hệ thống FamiCoats. Hiện tại, hệ thống được phân chia thành 2 vai trò chính: **Quản lý (Manager - ID: 1)** và **Nhân viên (Staff - ID: 2)**.

---

## 1. Vai trò Quản lý (ID Vai trò = 1)
**Định nghĩa:** Quản lý là người có quyền hạn cao nhất trong hệ thống phần mềm.

**Quyền truy cập:**
- **Toàn quyền truy cập tất cả các tính năng & module:**
  - **Bảng điều khiển (Thống kê):** Xem toàn bộ báo cáo doanh thu, sản phẩm bán chạy, khách hàng.
  - **Tài khoản / Nhân sự:** Có quyền quản lý nhân viên, thêm, sửa, xóa, phân quyền tài khoản cho hệ thống.
  - **Cài đặt:** Quản lý và thay đổi cấu hình, thông tin cửa hàng.
  - **Hàng hóa (Sản phẩm & Thuộc tính), Bán hàng, Đơn hàng (Hóa đơn), Khách hàng, Mã giảm giá:** Truy cập toàn bộ danh sách và chi tiết.

**Quyền thao tác (Hành động):**
- Thêm mới (Thêm sản phẩm, thêm khách hàng, thêm mã giảm giá, ...).
- Chỉnh sửa (Cập nhật thông tin hàng hóa, hóa đơn, người dùng, ...).
- Xóa / Xóa mềm (Vô hiệu hóa sản phẩm, khóa tài khoản, ...).
- Các thao tác đặc biệt: Hoàn trả hóa đơn, Hủy hóa đơn, Xuất Excel/CSV danh sách.

---

## 2. Vai trò Nhân viên (ID Vai trò = 2)
**Định nghĩa:** Nhân viên là người sử dụng hệ thống để thực hiện các thao tác bán hàng và chăm sóc khách hàng cơ bản, không có quyền can thiệp vào dữ liệu thống kê hay hệ thống.

**Quyền truy cập Module (Pages):**
- **Bị chặn truy cập (Không thể vào):**
  - 🚫 **Bảng điều khiển (Thống kê):** Không được xem doanh thu, lợi nhuận của cửa hàng.
  - 🚫 **Tài khoản / Quản lý nhân viên:** Không được xem hoặc chỉnh sửa thông tin của nhân viên khác.
  - 🚫 **Cài đặt:** Không có quyền truy cập vào phần cấu hình hệ thống.
- **Được phép truy cập (Xem danh sách):**
  - ✅ **Bán hàng (POS) & Hóa đơn:** Xem danh sách hóa đơn, lịch sử giao dịch.
  - ✅ **Sản phẩm & Thuộc tính:** Xem danh sách hàng hóa và các biến thể để tư vấn cho khách hàng.
  - ✅ **Khách hàng:** Xem danh sách khách hàng của hệ thống.
  - ✅ **Khuyến mãi / Mã giảm giá:** Xem danh sách các voucher hiện có.

**Quyền thao tác (Hành động):**
- Nhân viên chủ yếu có quyền **Xem dữ liệu (Read-only)**.
- **Bị ẩn/chặn các nút chức năng sau (Không thể thao tác):**
  - 🚫 Thêm mới (Nút Thêm sản phẩm, Thêm khách hàng, ...).
  - 🚫 Chỉnh sửa / Cập nhật (Nút sửa thông tin).
  - 🚫 Xóa dữ liệu (Nút xóa, vô hiệu hóa).
  - 🚫 Xuất Excel / Export (Chặn chức năng tải xuống dữ liệu).
  - 🚫 Hoàn trả hóa đơn, Hủy hóa đơn.

---

## 3. Cơ chế hoạt động (Dành cho nhà phát triển)
Cơ chế phân quyền được thực thi qua 2 lớp bảo vệ:
1. **Bảo mật giao diện (UI Level):**
   - Ẩn các menu chức năng như Thống kê, Tài khoản, Cài đặt trên thanh Sidebar đối với người dùng là Nhân viên.
   - Ẩn các nút "Thêm mới", "Sửa", "Xóa", "Xuất file" tại các trang danh sách nếu không phải là Quản lý.
2. **Bảo mật máy chủ (Server-side Filter Level):**
   - Sử dụng `AuthFilter` để chặn truy cập ở cấp độ request. 
   - Nếu Nhân viên cố tình nhập URL truy cập trực tiếp vào các trang bị cấm (như `/admin/accounts`, `/admin/settings`, hoặc dashboard), hệ thống sẽ chặn và chuyển hướng về trang báo lỗi 403 (Không có quyền truy cập) hoặc trang chủ mặc định được phép.
