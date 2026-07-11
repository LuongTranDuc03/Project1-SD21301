# HƯỚNG DẪN CẤU TRÚC DỰ ÁN JAKARTA EE (AI READABLE PROMPT)

Tài liệu này chứa toàn bộ cấu trúc cơ sở dữ liệu từ ERD và các yêu cầu thiết kế class cho dự án Jakarta EE sử dụng JPA (Hibernate), Repository Pattern, Service Layer và Servlet cho các chức năng liên quan đến Hóa đơn.
Đặc biệt đối với các class servlet phải tuân theo nguyên tắc của dự án Servlet/JSP.
---


## 1. DANH SÁCH CÁC THỰC THỂ (ENTITIES) TOÀN BỘ HỆ THỐNG

### Bảng 1: `nhan_vien` (Nhân viên)
- `id`: Long (PK)
- `ho_ten`: String
- `email`: String
- `mat_khau`: String
- `so_dien_thoai`: String
- `ngay_sinh`: Date
- `gioi_tinh`: Boolean
- `ccod`: String
- `luong`: Double
- `ngay_vao_lam`: Date
- `anh_dai_dien`: String
- `vai_tro`: String
- `trang_thai`: Integer

### Bảng 2: `khach_hang` (Khách hàng)
- `id`: Long (PK)
- `ho_ten`: String
- `email`: String
- `mat_khau`: String
- `so_dien_thoai`: String
- `ngay_sinh`: Date
- `gioi_tinh`: Boolean
- `diem_tich_luy`: Integer
- `hang_thanh_vien`: String
- `anh_dai_dien`: String
- `trang_thai`: Integer

### Bảng 3: `dia_chi` (Địa chỉ)
- `id`: Long (PK)
- `id_khach_hang`: Long (FK -> khach_hang.id)
- `nguoi_nhan`: String
- `so_dien_thoai`: String
- `tinh`: String
- `huyen`: String
- `xa`: String
- `dia_chi_chi_tiet`: String
- `mac_dinh`: Boolean
- `ghi_chu`: String

### Bảng 4: `danh_muc` (Danh mục)
- `id`: Long (PK)
- `ten_danh_muc`: String
- `mo_ta`: String
- `trang_thai`: Integer

### Bảng 5: `thuong_hieu` (Thương hiệu)
- `id`: Long (PK)
- `ten_thuong_hieu`: String
- `logo`: String
- `quoc_gia`: String
- `mo_ta`: String
- `trang_thai`: Integer

### Bảng 6: `chat_lieu` (Chất liệu)
- `id`: Long (PK)
- `ten_chat_lieu`: String
- `trang_thai`: Integer

### Bảng 7: `kich_thuoc` (Kích thước)
- `id`: Long (PK)
- `ten_kich_thuoc`: String
- `mo_ta`: String
- `trang_thai`: Integer

### Bảng 8: `mau_sac` (Màu sắc)
- `id`: Long (PK)
- `ten_mau`: String
- `ma_mau_hex`: String
- `trang_thai`: Integer

### Bảng 9: `kieu_dang` (Kiểu dáng)
- `id`: Long (PK)
- `ten_kieu_dang`: String
- `trang_thai`: Integer

### Bảng 10: `san_pham` (Sản phẩm)
- `id`: Long (PK)
- `id_danh_muc`: Long (FK -> danh_muc.id)
- `id_thuong_hieu`: Long (FK -> thuong_hieu.id)
- `id_chat_lieu`: Long (FK -> chat_lieu.id)
- `ten_san_pham`: String
- `mo_ta`: String
- `kieu_dang`: String
- `doi_tuong`: String
- `xuat_xu`: String
- `thuong_hieu_noi_bo`: Boolean
- `bao_hanh`: String
- `huong_dan_bao_quan`: String
- `trang_thai`: Integer

### Bảng 11: `chi_tiet_san_pham` (Chi tiết sản phẩm)
- `id`: Long (PK)
- `id_san_pham`: Long (FK -> san_pham.id)
- `id_kich_thuoc`: Long (FK -> kich_thuoc.id)
- `id_mau_sac`: Long (FK -> mau_sac.id)
- `id_kieu_dang`: Long (FK -> kieu_dang.id)
- `gia_nhap`: Double
- `gia_ban`: Double
- `gia_khuyen_mai`: Double
- `so_luong_ton`: Integer
- `trong_luong`: Double
- `chieu_dai`: Double
- `chieu_rong`: Double
- `do_day`: Double
- `trang_thai`: Integer

### Bảng 12: `hinh_anh_san_pham` (Hình ảnh sản phẩm)
- `id`: Long (PK)
- `id_chi_tiet_san_pham`: Long (FK -> chi_tiet_san_pham.id)
- `duong_dan`: String
- `anh_chinh`: Boolean
- `thu_tu`: Integer

### Bảng 13: `phieu_giam_gia` (Phiếu giảm giá / Voucher)
- `id`: Long (PK)
- `ten_chuong_trinh`: String
- `loai_giam`: String
- `gia_tri_giam`: Double
- `gia_tri_don_hang_toi_thieu`: Double
- `giam_toi_da`: Double
- `so_luong`: Integer
- `da_su_dung`: Integer
- `ngay_bat_dau`: Date
- `ngay_ket_thuc`: Date
- `mo_ta`: String
- `trang_thai`: Integer

### Bảng 14: `phuong_thuc_thanh_toan` (Phương thức thanh toán)
- `id`: Long (PK)
- `ten_phuong_thuc`: String
- `mo_ta`: String
- `logo`: String
- `phi_thanh_toan`: Double
- `trang_thai`: Integer

### Bảng 15: `hoa_don` (Hóa đơn)
- `id`: Long (PK)
- `id_khach_hang`: Long (FK -> khach_hang.id, có thể null nếu là khách vãng lai)
- `id_nhan_vien`: Long (FK -> nhan_vien.id)
- `id_dia_chi`: Long (FK -> dia_chi.id)
- `id_phuong_thuc_thanh_toan`: Long (FK -> phuong_thuc_thanh_toan.id)
- `id_ma_giam_gia`: Long (FK -> phieu_giam_gia.id)
- `ma_hoa_don`: String (Tự động tạo hoặc duy nhất)
- `ngay_dat_hang`: Date
- `ngay_xac_nhan`: Date
- `ten_khach_hang`: String
- `sdt_khach_hang`: String
- `email_khach_hang`: String
- `dia_chi_khach_hang`: String
- `tong_so_luong`: Integer
- `tam_tinh`: Double
- `tien_giam_hoa_don`: Double
- `tong_thanh_toan`: Double
- `tien_hoan`: Double
- `ghi_chu`: String
- `trang_thai_thanh_toan`: Integer
- `trang_thai_don_hang`: Integer
- `trang_thai`: Integer

### Bảng 16: `chi_tiet_hoa_don` (Chi tiết hóa đơn)
- `id`: Long (PK)
- `id_chi_tiet_san_pham`: Long (FK -> chi_tiet_san_pham.id)
- `id_hoa_don`: Long (FK -> hoa_don.id)
- `don_gia`: Double
- `gia_giam`: Double
- `so_luong`: Integer
- `thanh_tien`: Double
- `ghi_chu`: String

### Bảng 17: `lich_su_hoa_don` (Lịch sử trạng thái hóa đơn)
- `id`: Long (PK)
- `hoa_don_id`: Long (FK -> hoa_don.id)
- `id_nguoi_thuc_hien`: Long (FK -> nhan_vien.id hoặc khach_hang.id)
- `id_khach_hang`: Long
- `trang_thai_cu`: Integer
- `trang_thai_moi`: Integer
- `ghi_chu`: String
- `thoi_gian_cap_nhat`: Date
- `trang_thai`: Integer

### Bảng 18: `lich_su_thanh_toan` (Lịch sử cổng thanh toán)
- `id`: Long (PK)
- `id_hoa_don`: Long (FK -> hoa_don.id)
- `ma_giao_dich_cong`: String
- `so_tien`: Double
- `noi_dung`: String
- `trang_thai`: Integer
- `thoi_gian_giao_dich`: Date

---

## 2. YÊU CẦU THIẾT KẾ REPOSITORY & SERVICE LAYER (CHỈ HÓA ĐƠN)

AI cần tạo các Repository lớp cơ sở (`CrudRepository` hoặc dùng trực tiếp `EntityManager`) cho các bảng liên quan đến hóa đơn bao gồm:
1. `HoaDonRepository`: CRUD, tìm kiếm hóa đơn theo mã, theo khách hàng, theo trạng thái đơn hàng.
2. `ChiTietHoaDonRepository`: Tìm danh sách chi tiết sản phẩm theo mã hóa đơn, tính tổng tiền.
3. `LichSuHoaDonRepository`: Ghi vết mỗi khi hóa đơn đổi trạng thái.
4. `LichSuThanhToanRepository`: Ghi nhận giao dịch thanh toán thành công/thất bại.

### Nghiệp vụ cụ thể trong `HoaDonService`:
- **Tạo hóa đơn mới (Đặt hàng):** Kiểm tra số lượng tồn kho (`so_luong_ton` trong `chi_tiet_san_pham`), áp dụng voucher (`phieu_giam_gia`), tạo `hoa_don` và các `chi_tiet_hoa_don` tương ứng trong một Transaction.
- **Cập nhật trạng thái đơn hàng:** Đổi `trang_thai_don_hang` (Chờ xác nhận -> Đã xác nhận -> Đang giao -> Thành công / Hủy) kèm theo tạo bản ghi mới trong `lich_su_hoa_don`.
- **Hủy hóa đơn:** Hoàn lại số lượng sản phẩm vào kho tồn nếu đơn hàng bị hủy trước khi giao.

---

## 3. CẤU TRÚC SERVLET API / CONTROLLER (CHỨC NĂNG HÓA ĐƠN)

AI triển khai các endpoint sau bằng `HttpServlet`:

- `GET /orders`: Lấy danh sách toàn bộ hóa đơn (hỗ trợ phân trang, lọc theo trạng thái).
- `GET /orders/detail?id=...`: Xem chi tiết 1 hóa đơn cùng danh sách sản phẩm trong hóa đơn đó.
- `POST /orders/create`: Tạo đơn hàng mới từ giỏ hàng.
- `POST /orders/update-status`: Cập nhật trạng thái hóa đơn (Xác nhận, giao hàng, hoàn thành, hủy đơn).
