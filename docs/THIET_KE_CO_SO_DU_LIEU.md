# Tài Liệu Thiết Kế Chi Tiết Cơ Sở Dữ Liệu FamiCoats (Database Data Dictionary)

> **Hệ quản trị CSDL:** Microsoft SQL Server  
> **Database Name:** `FamiCoatsDatabase`  
> **Tổng số bảng:** 21 Bảng  

---

## 📋 Danh Sách Các Bảng Trong Hệ Thống

| STT | Tên bảng | Diễn giải nghiệp vụ | Phân loại |
| :---: | :--- | :--- | :--- |
| 1 | `phuong_thuc_thanh_toan` | Phương thức thanh toán | Bảng Danh mục (Lookup) |
| 2 | `vai_tro` | Vai trò / Chức vụ nhân viên | Bảng Phân quyền (Security) |
| 3 | `dia_chi` | Địa chỉ | Bảng Dữ liệu địa lý |
| 4 | `nhan_vien` | Nhân viên hệ thống | Bảng Người dùng (User) |
| 5 | `khach_hang` | Khách hàng | Bảng Người dùng (User) |
| 6 | `khach_hang_dia_chi` | Địa chỉ nhận hàng của khách hàng | Bảng Trung gian N-N |
| 7 | `thuong_hieu` | Thương hiệu sản phẩm | Bảng Thuộc tính sản phẩm |
| 8 | `danh_muc` | Danh mục sản phẩm | Bảng Thuộc tính sản phẩm |
| 9 | `chat_lieu` | Chất liệu sản phẩm | Bảng Thuộc tính sản phẩm |
| 10 | `mau_sac` | Màu sắc | Bảng Thuộc tính sản phẩm |
| 11 | `kich_thuoc` | Kích thước / Size | Bảng Thuộc tính sản phẩm |
| 12 | `kieu_dang` | Kiểu dáng sản phẩm | Bảng Thuộc tính sản phẩm |
| 13 | `xuat_xu` | Xuất xứ sản phẩm | Bảng Thuộc tính sản phẩm |
| 14 | `san_pham` | Sản phẩm chính | Bảng Sản phẩm (Product) |
| 15 | `chi_tiet_san_pham` | Biến thể sản phẩm (Variant) | Bảng Sản phẩm (Product Detail) |
| 16 | `hinh_anh` | Hình ảnh biến thể sản phẩm | Bảng Truyền thông (Media) |
| 17 | `phieu_giam_gia` | Phiếu/Mã giảm giá (Coupon) | Bảng Khuyến mãi (Promotion) |
| 18 | `hoa_don` | Hóa đơn bán hàng | Bảng Bán hàng (Sales / Order) |
| 19 | `chi_tiet_hoa_don` | Chi tiết mặt hàng trong hóa đơn | Bảng Bán hàng (Order Detail) |
| 20 | `lich_su_hoa_don` | Lịch sử thay đổi trạng thái hóa đơn | Bảng Nhật ký (Audit Logs) |
| 21 | `lich_su_thanh_toan` | Lịch sử giao dịch thanh toán | Bảng Thanh toán (Transaction) |

---

## 🗂️ Chi Tiết Cấu Trúc 21 Bảng Cơ Sở Dữ Liệu

### 1. Bảng `phuong_thuc_thanh_toan` (Phương thức thanh toán)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `phuong_thuc_thanh_toan_code` | VARCHAR(50) | Mã định danh phương thức thanh toán | NOT NULL, UNIQUE |
| 3 | `ten_phuong_thuc` | NVARCHAR(100) | Tên phương thức (Tiền mặt, VNPay, MoMo,...) | NOT NULL |
| 4 | `mo_ta` | NVARCHAR(MAX) | Mô tả chi tiết phương thức | NULL |
| 5 | `logo` | NVARCHAR(500) | Đường dẫn ảnh logo | NULL |
| 6 | `phi_thanh_toan` | DECIMAL(18,2) | Phụ phí thanh toán | NOT NULL, DEFAULT 0 |
| 7 | `trang_thai` | INT | Trạng thái hoạt động (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 8 | `created_at` | DATETIME | Thời điểm tạo bản ghi | NOT NULL, DEFAULT GETDATE() |

---

### 2. Bảng `vai_tro` (Vai trò / Phân quyền)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `code` | VARCHAR(50) | Mã định danh vai trò (ROLE01, ROLE02) | NOT NULL, UNIQUE |
| 3 | `ten_vai_tro` | NVARCHAR(100) | Tên vai trò (Quản lý, Nhân viên) | NOT NULL |
| 4 | `trang_thai` | INT | Trạng thái sử dụng (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 5 | `created_at` | DATETIME | Thời điểm tạo bản ghi | NOT NULL, DEFAULT GETDATE() |

---

### 3. Bảng `dia_chi` (Địa chỉ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `dia_chi_code` | VARCHAR(50) | Mã địa chỉ duy nhất | NOT NULL, UNIQUE |
| 3 | `tinh` | NVARCHAR(150) | Tỉnh / Thành phố | NULL |
| 4 | `huyen` | NVARCHAR(100) | Quận / Huyện | NULL |
| 5 | `xa` | NVARCHAR(150) | Phường / Xã | NULL |
| 6 | `dia_chi_chi_tiet` | NVARCHAR(500) | Số nhà, tên đường chi tiết | NULL |
| 7 | `created_at` | DATETIME | Thời điểm tạo bản ghi | NOT NULL, DEFAULT GETDATE() |

---

### 4. Bảng `nhan_vien` (Nhân viên)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `nhan_vien_code` | VARCHAR(50) | Mã nhân viên (NV001, NV002,...) | NOT NULL, UNIQUE |
| 3 | `id_vai_tro` | INT | Khóa ngoại vai trò | FK -> vai_tro(id), NULL |
| 4 | `id_dia_chi` | INT | Khóa ngoại địa chỉ | FK -> dia_chi(id), NULL |
| 5 | `ten_nhan_vien` | NVARCHAR(150) | Họ và tên nhân viên | NOT NULL |
| 6 | `cccd` | VARCHAR(20) | Số Căn cước công dân | NULL |
| 7 | `email` | NVARCHAR(200) | Địa chỉ Email đăng nhập | NOT NULL, UNIQUE |
| 8 | `mat_khau` | VARCHAR(255) | Mật khẩu tài khoản (BCrypt hash) | NOT NULL |
| 9 | `so_dien_thoai` | NVARCHAR(20) | Số điện thoại liên hệ | NULL |
| 10 | `ngay_sinh` | DATE | Ngày tháng năm sinh | NULL |
| 11 | `gioi_tinh` | BIT | Giới tính (1: Nam, 0: Nữ) | NULL |
| 12 | `anh_dai_dien` | NVARCHAR(500) | URL ảnh đại diện | NULL |
| 13 | `trang_thai` | INT | Trạng thái làm việc (1: Đang làm, 0: Nghỉ) | NOT NULL, DEFAULT 1 |
| 14 | `created_at` | DATETIME | Thời điểm tạo bản ghi | NOT NULL, DEFAULT GETDATE() |
| 15 | `updated_at` | DATETIME | Thời điểm cập nhật bản ghi | NOT NULL, DEFAULT GETDATE() |

---

### 5. Bảng `khach_hang` (Khách hàng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `khach_hang_code` | VARCHAR(50) | Mã khách hàng (KH001, KH002,...) | NOT NULL, UNIQUE |
| 3 | `ho_ten` | NVARCHAR(100) | Họ và tên khách hàng | NOT NULL |
| 4 | `email` | NVARCHAR(200) | Địa chỉ Email đăng ký | NOT NULL, UNIQUE |
| 5 | `mat_khau` | VARCHAR(255) | Mật khẩu (BCrypt hash) | NOT NULL |
| 6 | `so_dien_thoai` | NVARCHAR(20) | Số điện thoại liên hệ | NOT NULL |
| 7 | `ngay_sinh` | DATE | Ngày sinh | NULL |
| 8 | `gioi_tinh` | NVARCHAR(10) | Giới tính ('Nam', 'Nữ', 'Khác') | NULL |
| 9 | `anh_dai_dien` | NVARCHAR(500) | URL ảnh avatar | NULL |
| 10 | `trang_thai` | INT | Trạng thái tài khoản (1: Hoạt động, 0: Khóa) | NOT NULL, DEFAULT 1 |
| 11 | `created_at` | DATETIME | Thời điểm tạo bản ghi | NOT NULL, DEFAULT GETDATE() |
| 12 | `updated_at` | DATETIME | Thời điểm cập nhật | NOT NULL, DEFAULT GETDATE() |

---

### 6. Bảng `khach_hang_dia_chi` (Địa chỉ khách hàng - N-N)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `id_khach_hang` | INT | Khóa ngoại khách hàng | FK -> khach_hang(id), NOT NULL |
| 3 | `id_dia_chi` | INT | Khóa ngoại địa chỉ | FK -> dia_chi(id), NOT NULL |
| 4 | `nguoi_nhan` | NVARCHAR(150) | Tên người nhận hàng | NULL |
| 5 | `so_dien_thoai` | NVARCHAR(20) | Số điện thoại người nhận | NULL |
| 6 | `mac_dinh` | BIT | Địa chỉ mặc định (1: Mặc định, 0: Không) | NOT NULL, DEFAULT 0 |
| 7 | `ghi_chu` | NVARCHAR(MAX) | Ghi chú địa chỉ giao hàng | NULL |
| 8 | `created_at` | DATETIME | Thời điểm tạo bản ghi | NOT NULL, DEFAULT GETDATE() |

---

### 7. Bảng `thuong_hieu` (Thương hiệu)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `thuong_hieu_code` | VARCHAR(50) | Mã thương hiệu (BR001, BR002) | NOT NULL, UNIQUE |
| 3 | `ten_thuong_hieu` | NVARCHAR(100) | Tên thương hiệu (Zara, Uniqlo,...) | NOT NULL |
| 4 | `logo` | NVARCHAR(500) | Logo thương hiệu | NULL |
| 5 | `trang_thai` | INT | Trạng thái (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 6 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 8. Bảng `danh_muc` (Danh mục)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `danh_muc_code` | VARCHAR(50) | Mã danh mục (CAT001, CAT002) | NOT NULL, UNIQUE |
| 3 | `ten_danh_muc` | NVARCHAR(100) | Tên danh mục (Áo khoác da, Bomber,...) | NOT NULL |
| 4 | `trang_thai` | INT | Trạng thái (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 5 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 9. Bảng `chat_lieu` (Chất liệu)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `chat_lieu_code` | VARCHAR(50) | Mã chất liệu (MAT001, MAT002) | NOT NULL, UNIQUE |
| 3 | `ten_chat_lieu` | NVARCHAR(100) | Tên chất liệu (Da cừu, Vải gió, Denim,...) | NOT NULL |
| 4 | `trang_thai` | INT | Trạng thái (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 5 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 10. Bảng `mau_sac` (Màu sắc)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `mau_sac_code` | VARCHAR(50) | Mã màu sắc (MS001, MS002) | NOT NULL, UNIQUE |
| 3 | `ten_mau` | NVARCHAR(100) | Tên màu (Đen, Nâu, Xanh nhạt,...) | NOT NULL |
| 4 | `ma_hex` | VARCHAR(20) | Mã màu HEX (#000000, #FFFFFF) | NULL |
| 5 | `trang_thai` | INT | Trạng thái (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 6 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 11. Bảng `kich_thuoc` (Kích thước)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `kich_thuoc_code` | VARCHAR(50) | Mã kích thước (KT001, KT002) | NOT NULL, UNIQUE |
| 3 | `ten_kich_thuoc` | NVARCHAR(50) | Tên size (S, M, L, XL, XXL) | NOT NULL |
| 4 | `thu_tu` | INT | Thứ tự sắp xếp hiển thị | NOT NULL, DEFAULT 0 |
| 5 | `trang_thai` | INT | Trạng thái (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 6 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 12. Bảng `kieu_dang` (Kiểu dáng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `kieu_dang_code` | VARCHAR(50) | Mã kiểu dáng (KD001, KD002) | NOT NULL, UNIQUE |
| 3 | `ten_kieu_dang` | NVARCHAR(100) | Tên kiểu dáng (Regular, Oversize, Slim,...) | NOT NULL |
| 4 | `trang_thai` | INT | Trạng thái (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 5 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 13. Bảng `xuat_xu` (Xuất xứ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `xuat_xu_code` | VARCHAR(50) | Mã xuất xứ (XX001, XX002) | NOT NULL, UNIQUE |
| 3 | `ten_xuat_xu` | NVARCHAR(100) | Tên xuất xứ (Việt Nam, Nhật Bản,...) | NOT NULL |
| 4 | `trang_thai` | INT | Trạng thái (1: Hoạt động, 0: Ngừng) | NOT NULL, DEFAULT 1 |
| 5 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 14. Bảng `san_pham` (Sản phẩm)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `san_pham_code` | VARCHAR(50) | Mã sản phẩm (SP001, SP002) | NOT NULL, UNIQUE |
| 3 | `ten_san_pham` | NVARCHAR(255) | Tên sản phẩm | NOT NULL |
| 4 | `id_danh_muc` | INT | Khóa ngoại danh mục sản phẩm | FK -> danh_muc(id), NULL |
| 5 | `id_thuong_hieu` | INT | Khóa ngoại thương hiệu | FK -> thuong_hieu(id), NULL |
| 6 | `id_xuat_xu` | INT | Khóa ngoại xuất xứ | FK -> xuat_xu(id), NULL |
| 7 | `mo_ta` | NVARCHAR(MAX) | Mô tả sản phẩm | NULL |
| 8 | `doi_tuong` | NVARCHAR(50) | Đối tượng sử dụng ('Nam', 'Nữ', 'Unisex') | NULL |
| 9 | `huong_dan_bao_quan`| NVARCHAR(MAX) | Hướng dẫn sử dụng & bảo quản | NULL |
| 10 | `gia_goc` | DECIMAL(18,2) | Giá gốc sản phẩm | NOT NULL, DEFAULT 0 |
| 11 | `gia_ban` | DECIMAL(18,2) | Giá bán niêm yết | NOT NULL, DEFAULT 0 |
| 12 | `da_ban` | INT | Tổng số lượng đã bán | NOT NULL, DEFAULT 0 |
| 13 | `trang_thai` | INT | Trạng thái (1: Đang bán, 0: Ngừng bán) | NOT NULL, DEFAULT 1 |
| 14 | `created_at` | DATETIME | Thời điểm tạo bản ghi | NOT NULL, DEFAULT GETDATE() |
| 15 | `updated_at` | DATETIME | Thời điểm cập nhật | NOT NULL, DEFAULT GETDATE() |

---

### 15. Bảng `chi_tiet_san_pham` (Chi tiết sản phẩm / Biến thể Variant)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `chi_tiet_san_pham_code` | VARCHAR(50) | Mã biến thể (CTSP001, CTSP002) | NOT NULL, UNIQUE |
| 3 | `id_san_pham` | INT | Khóa ngoại sản phẩm | FK -> san_pham(id), NOT NULL |
| 4 | `id_kich_thuoc` | INT | Khóa ngoại kích thước | FK -> kich_thuoc(id), NULL |
| 5 | `id_mau_sac` | INT | Khóa ngoại màu sắc | FK -> mau_sac(id), NULL |
| 6 | `id_kieu_dang` | INT | Khóa ngoại kiểu dáng | FK -> kieu_dang(id), NULL |
| 7 | `ma_vach` | VARCHAR(100) | Mã vạch Barcode sản phẩm | NULL |
| 8 | `gia_nhap` | DECIMAL(18,2) | Giá nhập hàng biến thể | NOT NULL, DEFAULT 0 |
| 9 | `gia_ban` | DECIMAL(18,2) | Giá bán biến thể | NOT NULL, DEFAULT 0 |
| 10 | `so_luong` | INT | Số lượng tồn kho | NOT NULL, DEFAULT 0 |
| 11 | `trong_luong` | DECIMAL(8,3) | Trọng lượng (kg) | NOT NULL, DEFAULT 0 |
| 12 | `chieu_dai` | DECIMAL(8,2) | Kích thước chiều dài (cm) | NOT NULL, DEFAULT 0 |
| 13 | `chieu_rong` | DECIMAL(8,2) | Kích thước chiều rộng (cm) | NOT NULL, DEFAULT 0 |
| 14 | `do_day` | DECIMAL(8,2) | Độ dày sản phẩm (cm) | NOT NULL, DEFAULT 0 |
| 15 | `trang_thai` | INT | Trạng thái (1: Còn hàng, 0: Hết hàng) | NOT NULL, DEFAULT 1 |
| 16 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |
| 17 | `updated_at` | DATETIME | Thời điểm cập nhật | NOT NULL, DEFAULT GETDATE() |

---

### 16. Bảng `hinh_anh` (Hình ảnh sản phẩm)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `hinh_anh_code` | VARCHAR(50) | Mã ảnh (IMG001, IMG002) | NOT NULL, UNIQUE |
| 3 | `id_chi_tiet_san_pham` | INT | Khóa ngoại biến thể sản phẩm | FK -> chi_tiet_san_pham(id), NOT NULL |
| 4 | `duong_dan` | NVARCHAR(500) | URL ảnh (Cloudinary / local) | NULL |
| 5 | `anh_chinh` | BIT | Cờ đánh dấu ảnh chính (1: Có, 0: Phụ) | NOT NULL, DEFAULT 0 |
| 6 | `thu_tu` | INT | Thứ tự hiển thị ảnh | NOT NULL, DEFAULT 1 |
| 7 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 17. Bảng `phieu_giam_gia` (Phiếu giảm giá / Coupon)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `phieu_giam_gia_code` | VARCHAR(50) | Mã coupon (PGG001, PGG002) | NOT NULL, UNIQUE |
| 3 | `ten_chuong_trinh` | NVARCHAR(255) | Tên chương trình ưu đãi | NOT NULL |
| 4 | `loai_giam` | INT | Loại giảm giá (0: Giảm %, 1: Giảm VND) | NOT NULL |
| 5 | `gia_tri_giam` | DECIMAL(18,2) | Giá trị giảm (% hoặc số tiền VND) | NOT NULL |
| 6 | `gia_tri_don_hang_toi_thieu` | DECIMAL(18,2) | Điều kiện giá trị đơn tối thiểu | NULL |
| 7 | `giam_toi_da` | DECIMAL(18,2) | Số tiền giảm tối đa (với giảm %) | NULL |
| 8 | `so_luong` | INT | Tổng số lượng phát hành | NULL |
| 9 | `da_su_dung` | INT | Số lượt đã sử dụng | NOT NULL, DEFAULT 0 |
| 10 | `han_su_dung_moi_khach` | INT | Giới hạn dùng trên mỗi khách | NOT NULL, DEFAULT 1 |
| 11 | `ngay_bat_dau` | DATETIME | Ngày bắt đầu áp dụng | NULL |
| 12 | `ngay_ket_thuc` | DATETIME | Ngày hết hạn | NULL |
| 13 | `mo_ta` | NVARCHAR(MAX) | Mô tả chi tiết chương trình | NULL |
| 14 | `trang_thai` | INT | 0: Chưa kích hoạt, 1: Đang áp dụng, 2: Kết thúc, 3: Đã hủy | NOT NULL, DEFAULT 1 |
| 15 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |
| 16 | `updated_at` | DATETIME | Thời điểm cập nhật | NOT NULL, DEFAULT GETDATE() |

---

### 18. Bảng `hoa_don` (Hóa đơn)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `hoa_don_code` | VARCHAR(50) | Mã hóa đơn (HD001, HD002) | NOT NULL, UNIQUE |
| 3 | `id_khach_hang` | INT | Khóa ngoại khách hàng mua | FK -> khach_hang(id), NULL |
| 4 | `id_nhan_vien` | INT | Khóa ngoại nhân viên lập đơn | FK -> nhan_vien(id), NULL |
| 5 | `id_dia_chi` | INT | Khóa ngoại địa chỉ giao | FK -> dia_chi(id), NULL |
| 6 | `id_phuong_thuc_thanh_toan` | INT | Khóa ngoại phương thức TT | FK -> phuong_thuc_thanh_toan(id), NULL |
| 7 | `id_ma_giam_gia` | INT | Khóa ngoại mã giảm giá | FK -> phieu_giam_gia(id), NULL |
| 8 | `loai_hoa_don` | INT | Loại đơn hàng (0: Tại quầy POS, 1: Online) | NOT NULL, DEFAULT 1 |
| 9 | `ngay_dat_hang` | DATETIME | Thời điểm đặt hàng | NOT NULL, DEFAULT GETDATE() |
| 10 | `ngay_xac_nhan` | DATETIME | Thời điểm xác nhận | NULL |
| 11 | `ngay_giao_du_kien` | DATETIME | Ngày giao hàng dự kiến | NULL |
| 12 | `ngay_hoan_thanh` | DATETIME | Ngày hoàn thành đơn hàng | NULL |
| 13 | `ten_khach_nhan` | NVARCHAR(150) | Tên người nhận hàng | NULL |
| 14 | `sdt_khach_nhan` | NVARCHAR(20) | SĐT người nhận | NULL |
| 15 | `dia_chi_khach_nhan` | NVARCHAR(500) | Chuỗi địa chỉ giao nhận | NULL |
| 16 | `dia_chi_snapshot` | NVARCHAR(MAX) | Snapshot địa chỉ lưu thông tin tĩnh | NULL |
| 17 | `tong_so_luong` | INT | Tổng số lượng sản phẩm mua | NOT NULL, DEFAULT 0 |
| 18 | `tam_tinh` | DECIMAL(18,2) | Tiền tạm tính ban đầu | NOT NULL, DEFAULT 0 |
| 19 | `tien_giam_hoa_don` | DECIMAL(18,2) | Số tiền được giảm giá | NOT NULL, DEFAULT 0 |
| 20 | `tong_thanh_toan` | DECIMAL(18,2) | Tổng tiền phải thanh toán | NOT NULL, DEFAULT 0 |
| 21 | `da_thanh_toan` | DECIMAL(18,2) | Số tiền thực tế khách đã trả | NOT NULL, DEFAULT 0 |
| 22 | `lien_hoan` | DECIMAL(18,2) | Tiền thối/hoàn lại | NOT NULL, DEFAULT 0 |
| 23 | `phi_van_chuyen` | DECIMAL(18,2) | Phí vận chuyển giao hàng | NOT NULL, DEFAULT 0 |
| 24 | `ghi_chu` | NVARCHAR(MAX) | Ghi chú đơn hàng | NULL |
| 25 | `trang_thai_thanh_toan` | INT | Trạng thái TT (0: Chưa TT, 1: Đã TT) | NOT NULL, DEFAULT 0 |
| 26 | `trang_thai_don_hang` | INT | 0: Chờ xác nhận, 1: Đã xác nhận, 2: Đang giao, 3: Hoàn thành, 4: Đã hủy | NOT NULL, DEFAULT 0 |
| 27 | `trang_thai` | INT | Trạng thái hiển thị (1: Hiện, 0: Ẩn) | NOT NULL, DEFAULT 1 |
| 28 | `updated_at` | DATETIME | Thời điểm cập nhật gần nhất | NOT NULL, DEFAULT GETDATE() |

---

### 19. Bảng `chi_tiet_hoa_don` (Chi tiết hóa đơn)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `chi_tiet_hoa_don_code` | VARCHAR(50) | Mã CTHD (CTHD001, CTHD002) | NOT NULL, UNIQUE |
| 3 | `id_hoa_don` | INT | Khóa ngoại hóa đơn | FK -> hoa_don(id), NOT NULL |
| 4 | `id_chi_tiet_san_pham` | INT | Khóa ngoại biến thể sản phẩm | FK -> chi_tiet_san_pham(id), NULL |
| 5 | `ten_sp_tai_thoi_diem` | NVARCHAR(255) | Tên SP snapshot tại thời điểm mua | NULL |
| 6 | `mo_ta_variant` | NVARCHAR(255) | Mô tả màu/size/dáng tại thời điểm mua | NULL |
| 7 | `don_gia` | DECIMAL(18,2) | Đơn giá sản phẩm | NOT NULL, DEFAULT 0 |
| 8 | `gia_giam` | DECIMAL(18,2) | Giá giảm trên 1 đơn vị sản phẩm | NOT NULL, DEFAULT 0 |
| 9 | `so_luong` | INT | Số lượng sản phẩm mua | NOT NULL, DEFAULT 1 |
| 10 | `thanh_tien` | DECIMAL(18,2) | Thành tiền tổng mặt hàng | NOT NULL, DEFAULT 0 |
| 11 | `ghi_chu` | NVARCHAR(MAX) | Ghi chú sản phẩm | NULL |
| 12 | `created_at` | DATETIME | Thời điểm tạo | NOT NULL, DEFAULT GETDATE() |

---

### 20. Bảng `lich_su_hoa_don` (Lịch sử hóa đơn)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `lich_su_hoa_don_code` | VARCHAR(50) | Mã LSHD (LSHD001, LSHD002) | NOT NULL, UNIQUE |
| 3 | `id_hoa_don` | INT | Khóa ngoại hóa đơn | FK -> hoa_don(id), NOT NULL |
| 4 | `id_nguoi_thuc_hien` | INT | Nhân viên thực hiện thay đổi | FK -> nhan_vien(id), NULL |
| 5 | `id_khach_hang` | INT | Khách hàng thực hiện (nếu có) | FK -> khach_hang(id), NULL |
| 6 | `trang_thai_cu` | INT | Trạng thái đơn hàng cũ trước khi đổi | NOT NULL |
| 7 | `trang_thai_moi` | INT | Trạng thái đơn hàng mới sau khi đổi | NOT NULL |
| 8 | `ghi_chu` | NVARCHAR(MAX) | Lý do/ghi chú cập nhật trạng thái | NULL |
| 9 | `thoi_gian_cap_nhat` | DATETIME | Thời gian ghi nhận nhật ký | NOT NULL, DEFAULT GETDATE() |
| 10 | `trang_thai` | INT | Trạng thái log (1: Hoạt động) | NOT NULL, DEFAULT 1 |

---

### 21. Bảng `lich_su_thanh_toan` (Lịch sử thanh toán)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `id` | INT | Mã ID tự tăng | PRIMARY KEY, IDENTITY(1,1) |
| 2 | `lich_su_thanh_toan_code` | VARCHAR(50) | Mã LSTT (LSTT001, LSTT002) | NOT NULL, UNIQUE |
| 3 | `id_hoa_don` | INT | Khóa ngoại hóa đơn | FK -> hoa_don(id), NOT NULL |
| 4 | `ma_giao_dich_cong` | NVARCHAR(200) | Mã giao dịch cổng (VNPay/MoMo/Banking) | NULL |
| 5 | `so_tien` | DECIMAL(18,2) | Số tiền thực hiện giao dịch | NOT NULL, DEFAULT 0 |
| 6 | `noi_dung` | NVARCHAR(MAX) | Nội dung thanh toán | NULL |
| 7 | `trang_thai` | INT | Trạng thái giao dịch (1: Thành công, 0: Thất bại) | NOT NULL, DEFAULT 1 |
| 8 | `thoi_gian_giao_dich` | DATETIME | Thời gian diễn ra giao dịch | NOT NULL, DEFAULT GETDATE() |

---
