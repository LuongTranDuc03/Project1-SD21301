-- =======================================================
-- SCRIPT TẠO CƠ SỞ DỮ LIỆU FamiCoats
-- Bao gồm cấu trúc bảng và dữ liệu mẫu cho Hóa đơn
-- =======================================================

CREATE DATABASE FamiCoats;
GO
USE FamiCoats;
GO

-- 1. Bảng Nhân viên
CREATE TABLE nhan_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ho_ten NVARCHAR(100),
    sdt VARCHAR(20),
    email VARCHAR(100),
    mat_khau VARCHAR(100),
    chuc_vu INT,
    trang_thai INT
);

-- 2. Bảng Khách hàng
CREATE TABLE khach_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ho_ten NVARCHAR(100),
    sdt VARCHAR(20),
    email VARCHAR(100),
    mat_khau VARCHAR(100),
    gioi_tinh BIT,
    ngay_sinh DATE,
    trang_thai INT
);

-- 3. Bảng Địa chỉ
CREATE TABLE dia_chi (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_khach_hang INT FOREIGN KEY REFERENCES khach_hang(id),
    dia_chi_cu_the NVARCHAR(255),
    phuong_xa NVARCHAR(100),
    quan_huyen NVARCHAR(100),
    tinh_thanh NVARCHAR(100),
    trang_thai INT
);

-- 4. Bảng Phương thức thanh toán
CREATE TABLE phuong_thuc_thanh_toan (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_phuong_thuc NVARCHAR(100),
    kieu_thanh_toan INT, -- 1: Chuyển khoản, 2: Tiền mặt, v.v.
    trang_thai INT
);

-- 5. Bảng Phiếu giảm giá
CREATE TABLE phieu_giam_gia (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma_phieu VARCHAR(50),
    ten_phieu NVARCHAR(100),
    kieu_giam_gia INT, -- 1: % , 2: VNĐ
    gia_tri_giam DECIMAL(18,2),
    don_toi_thieu DECIMAL(18,2),
    giam_toi_da DECIMAL(18,2),
    so_luong INT,
    ngay_bat_dau DATETIME,
    ngay_ket_thuc DATETIME,
    trang_thai INT
);

-- 6. Bảng Chi tiết sản phẩm
CREATE TABLE chi_tiet_san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_san_pham INT,
    id_kich_thuoc INT,
    id_mau_sac INT,
    don_gia DECIMAL(18,2),
    so_luong INT,
    trang_thai INT
);

-- 7. Bảng Hóa đơn
CREATE TABLE hoa_don (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_nhan_vien INT FOREIGN KEY REFERENCES nhan_vien(id),
    id_khach_hang INT FOREIGN KEY REFERENCES khach_hang(id),
    id_dia_chi INT FOREIGN KEY REFERENCES dia_chi(id),
    id_phuong_thuc_thanh_toan INT FOREIGN KEY REFERENCES phuong_thuc_thanh_toan(id),
    id_ma_giam_gia INT FOREIGN KEY REFERENCES phieu_giam_gia(id),
    
    ngay_dat_hang DATETIME,
    ngay_xac_nhan DATETIME,
    
    ten_khach_hang NVARCHAR(150),
    sdt_khach_hang VARCHAR(20),
    email_khach_hang VARCHAR(200),
    dia_chi_khach_hang NVARCHAR(MAX),
    
    tong_so_luong INT,
    tam_tinh DECIMAL(18,2),
    tien_giam_hoa_don DECIMAL(18,2),
    tong_thanh_toan DECIMAL(18,2),
    da_thanh_toan DECIMAL(18,2),
    lien_hoan DECIMAL(18,2),
    
    ghi_chu NVARCHAR(MAX),
    trang_thai_thanh_toan INT, -- 0: Chưa TT, 1: Đã TT
    trang_thai_don_hang INT, -- 0: Chờ XN, 1: Đã XN, 2: Đang giao, 3: Thành công, 4: Huỷ
    trang_thai INT
);

-- 8. Bảng Chi tiết hóa đơn
CREATE TABLE chi_tiet_hoa_don (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don INT FOREIGN KEY REFERENCES hoa_don(id),
    id_chi_tiet_sp INT FOREIGN KEY REFERENCES chi_tiet_san_pham(id),
    so_luong INT,
    don_gia DECIMAL(18,2),
    gia_giam DECIMAL(18,2),
    thanh_tien DECIMAL(18,2),
    ghi_chu NVARCHAR(MAX)
);

-- 9. Bảng Lịch sử hóa đơn
CREATE TABLE lich_su_hoa_don (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don INT FOREIGN KEY REFERENCES hoa_don(id),
    id_nhan_vien INT FOREIGN KEY REFERENCES nhan_vien(id),
    id_khach_hang INT FOREIGN KEY REFERENCES khach_hang(id),
    trang_thai_cu INT,
    trang_thai_moi INT,
    thoi_gian_cap_nhat DATETIME,
    ghi_chu NVARCHAR(MAX)
);

-- 10. Bảng Lịch sử thanh toán
CREATE TABLE lich_su_thanh_toan (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don INT FOREIGN KEY REFERENCES hoa_don(id),
    id_phuong_thuc_thanh_toan INT FOREIGN KEY REFERENCES phuong_thuc_thanh_toan(id),
    so_tien DECIMAL(18,2),
    thoi_gian_thanh_toan DATETIME,
    trang_thai INT
);

GO

-- ==============================================
-- -- THÊM DỮ LIỆU MẪU
-- -- ================================================================

-- Nhân viên
INSERT INTO nhan_vien (ho_ten, sdt, email, mat_khau, chuc_vu, trang_thai) VALUES 
(N'Admin JacketZone', '0987654321', 'admin@jacketzone.vn', '123456', 1, 1);

-- Khách hàng
INSERT INTO khach_hang (ho_ten, sdt, email, mat_khau, gioi_tinh, ngay_sinh, trang_thai) VALUES 
(N'Nguyễn Văn An', '0912345678', 'nguyen.van.an@gmail.com', '123', 1, '1995-05-12', 1),
(N'Trần Thị Bình', '0987654321', 'binh.tran@gmail.com', '123', 0, '1998-10-20', 1),
(N'Lê Minh Châu', '0905111222', 'chau.le@gmail.com', '123', 1, '2000-01-01', 1),
(N'Phạm Thị Lan', '0933777888', 'lan.pham@gmail.com', '123', 0, '1990-12-12', 1),
(N'Hoàng Văn Dũng', '0976543210', 'dung.hoang@gmail.com', '123', 1, '1985-08-08', 1);

-- Phương thức thanh toán
INSERT INTO phuong_thuc_thanh_toan (ten_phuong_thuc, kieu_thanh_toan, trang_thai) VALUES 
(N'Chuyển khoản ngân hàng', 1, 1),
(N'Thanh toán khi nhận hàng (COD)', 2, 1),
(N'Ví điện tử MoMo', 3, 1);

-- Chi tiết sản phẩm (Mock data)
INSERT INTO chi_tiet_san_pham (id_san_pham, id_kich_thuoc, id_mau_sac, don_gia, so_luong, trang_thai) VALUES 
(1, 1, 1, 1850000, 50, 1), -- Áo khoác da nam Premium
(2, 2, 2, 1290000, 30, 1), -- Bomber jacket oversize
(3, 3, 1, 890000, 100, 1), -- Áo denim wash nữ
(4, 1, 3, 2100000, 20, 1), -- Áo phao siêu nhẹ
(5, 4, 4, 1150000, 45, 1); -- Khoác gió windbreaker

-- Hóa đơn (5 bản ghi mẫu)
-- HD1: Hoàn thành (Trạng thái đơn: 3)
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES 
(1, 1, 1, '2026-06-30 08:30:00', '2026-06-30 08:35:00', N'Nguyễn Văn An', '0912345678', 'nguyen.van.an@gmail.com', N'123 Nguyễn Huệ, Q.1, TP.HCM', 1, 1850000, 10000, 1840000, 1, 3, 1, N'Khách hàng yêu cầu giao vào buổi chiều. Gọi trước 30 phút.');

-- HD2: Đang giao (Trạng thái đơn: 2)
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES 
(1, 2, 2, '2026-06-30 10:15:00', '2026-06-30 10:30:00', N'Trần Thị Bình', '0987654321', 'binh.tran@gmail.com', N'45 Lê Lợi, Q.1, TP.HCM', 2, 2580000, 0, 2580000, 0, 2, 1, N'');

-- HD3: Chờ xử lý (Trạng thái đơn: 0)
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES 
(1, 3, 3, '2026-06-29 14:20:00', N'Lê Minh Châu', '0905111222', 'chau.le@gmail.com', N'78 Nguyễn Trãi, Q.5, TP.HCM', 1, 890000, 0, 890000, 1, 0, 1, N'Giao hàng giờ hành chính.');

-- HD4: Đã xác nhận (Trạng thái đơn: 1)
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES 
(1, 4, 1, '2026-06-29 09:00:00', '2026-06-29 09:15:00', N'Phạm Thị Lan', '0933777888', 'lan.pham@gmail.com', N'12 Võ Văn Tần, Q.3, TP.HCM', 1, 2100000, 50000, 2050000, 1, 1, 1, N'Đóng gói cẩn thận làm quà tặng.');

-- HD5: Đã huỷ (Trạng thái đơn: 4)
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES 
(1, 5, 2, '2026-06-28 16:45:00', '2026-06-28 17:00:00', N'Hoàng Văn Dũng', '0976543210', 'dung.hoang@gmail.com', N'99 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM', 3, 3450000, 0, 3450000, 0, 4, 1, N'Khách đổi ý không mua nữa.');

-- Chi tiết hóa đơn
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_sp, so_luong, don_gia, gia_giam, thanh_tien, ghi_chu) VALUES 
(1, 1, 1, 1850000, 10000, 1840000, N''),
(2, 2, 2, 1290000, 0, 2580000, N''),
(3, 3, 1, 890000, 0, 890000, N''),
(4, 4, 1, 2100000, 50000, 2050000, N''),
(5, 5, 3, 1150000, 0, 3450000, N'');

-- Lịch sử hóa đơn cho HD1 (Hoàn thành)
INSERT INTO lich_su_hoa_don (id_hoa_don, id_nhan_vien, trang_thai_cu, trang_thai_moi, thoi_gian_cap_nhat, ghi_chu) VALUES 
(1, 1, NULL, 0, '2026-06-30 08:30:00', N'Đơn hàng được đặt thành công'),
(1, 1, 0, 1, '2026-06-30 08:35:00', N'Đã xác nhận đơn hàng'),
(1, 1, 1, 2, '2026-06-30 10:15:00', N'Đã giao cho đơn vị vận chuyển'),
(1, 1, 2, 3, '2026-06-30 14:22:00', N'Giao hàng thành công');

-- Lịch sử hóa đơn cho HD5 (Đã hủy)
INSERT INTO lich_su_hoa_don (id_hoa_don, id_nhan_vien, trang_thai_cu, trang_thai_moi, thoi_gian_cap_nhat, ghi_chu) VALUES 
(5, 1, NULL, 0, '2026-06-28 16:45:00', N'Đơn hàng được đặt thành công'),
(5, 1, 0, 1, '2026-06-28 17:00:00', N'Đã xác nhận đơn hàng'),
(5, 1, 1, 4, '2026-06-28 18:00:00', N'Huỷ đơn: Khách đổi ý không mua nữa.');

-- =======================================================
-- THÊM 15 BẢN GHI HOÁ ĐƠN MỚI
-- =======================================================

INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES 
(1, 1, 1, '2026-07-01 10:00:00', N'Nguyễn Văn An', '0912345678', 'nguyen.van.an@gmail.com', N'123 Nguyễn Huệ, Q.1, TP.HCM', 1, 1850000, 0, 1850000, 1, 3, 1, N''),
(1, 2, 2, '2026-07-02 11:00:00', N'Trần Thị Bình', '0987654321', 'binh.tran@gmail.com', N'45 Lê Lợi, Q.1, TP.HCM', 2, 2580000, 0, 2580000, 0, 2, 1, N''),
(1, 3, 3, '2026-07-03 12:00:00', N'Lê Minh Châu', '0905111222', 'chau.le@gmail.com', N'78 Nguyễn Trãi, Q.5, TP.HCM', 1, 890000, 0, 890000, 1, 3, 1, N''),
(1, 4, 1, '2026-07-04 13:00:00', N'Phạm Thị Lan', '0933777888', 'lan.pham@gmail.com', N'12 Võ Văn Tần, Q.3, TP.HCM', 1, 2100000, 0, 2100000, 1, 3, 1, N''),
(1, 5, 2, '2026-07-05 14:00:00', N'Hoàng Văn Dũng', '0976543210', 'dung.hoang@gmail.com', N'99 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM', 1, 1150000, 0, 1150000, 0, 0, 1, N''),
(1, 1, 3, '2026-07-06 15:00:00', N'Nguyễn Văn An', '0912345678', 'nguyen.van.an@gmail.com', N'123 Nguyễn Huệ, Q.1, TP.HCM', 1, 1850000, 0, 1850000, 1, 3, 1, N''),
(1, 2, 1, '2026-07-07 16:00:00', N'Trần Thị Bình', '0987654321', 'binh.tran@gmail.com', N'45 Lê Lợi, Q.1, TP.HCM', 2, 2580000, 0, 2580000, 1, 3, 1, N''),
(1, 3, 2, '2026-07-08 17:00:00', N'Lê Minh Châu', '0905111222', 'chau.le@gmail.com', N'78 Nguyễn Trãi, Q.5, TP.HCM', 1, 890000, 0, 890000, 0, 1, 1, N''),
(1, 4, 3, '2026-07-09 18:00:00', N'Phạm Thị Lan', '0933777888', 'lan.pham@gmail.com', N'12 Võ Văn Tần, Q.3, TP.HCM', 1, 2100000, 0, 2100000, 1, 3, 1, N''),
(1, 5, 1, '2026-07-10 19:00:00', N'Hoàng Văn Dũng', '0976543210', 'dung.hoang@gmail.com', N'99 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM', 1, 1150000, 0, 1150000, 1, 3, 1, N''),
(1, 1, 2, '2026-07-11 20:00:00', N'Nguyễn Văn An', '0912345678', 'nguyen.van.an@gmail.com', N'123 Nguyễn Huệ, Q.1, TP.HCM', 1, 1850000, 0, 1850000, 0, 2, 1, N''),
(1, 2, 3, '2026-07-12 21:00:00', N'Trần Thị Bình', '0987654321', 'binh.tran@gmail.com', N'45 Lê Lợi, Q.1, TP.HCM', 2, 2580000, 0, 2580000, 1, 3, 1, N''),
(1, 3, 1, '2026-07-13 09:00:00', N'Lê Minh Châu', '0905111222', 'chau.le@gmail.com', N'78 Nguyễn Trãi, Q.5, TP.HCM', 1, 890000, 0, 890000, 1, 3, 1, N''),
(1, 4, 2, '2026-07-14 10:00:00', N'Phạm Thị Lan', '0933777888', 'lan.pham@gmail.com', N'12 Võ Văn Tần, Q.3, TP.HCM', 1, 2100000, 0, 2100000, 0, 0, 1, N''),
(1, 5, 3, '2026-07-14 11:00:00', N'Hoàng Văn Dũng', '0976543210', 'dung.hoang@gmail.com', N'99 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM', 1, 1150000, 0, 1150000, 1, 3, 1, N'');

INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_sp, so_luong, don_gia, gia_giam, thanh_tien, ghi_chu) VALUES 
(6, 1, 1, 1850000, 0, 1850000, N''),
(7, 2, 2, 1290000, 0, 2580000, N''),
(8, 3, 1, 890000, 0, 890000, N''),
(9, 4, 1, 2100000, 0, 2100000, N''),
(10, 5, 1, 1150000, 0, 1150000, N''),
(11, 1, 1, 1850000, 0, 1850000, N''),
(12, 2, 2, 1290000, 0, 2580000, N''),
(13, 3, 1, 890000, 0, 890000, N''),
(14, 4, 1, 2100000, 0, 2100000, N''),
(15, 5, 1, 1150000, 0, 1150000, N''),
(16, 1, 1, 1850000, 0, 1850000, N''),
(17, 2, 2, 1290000, 0, 2580000, N''),
(18, 3, 1, 890000, 0, 890000, N''),
(19, 4, 1, 2100000, 0, 2100000, N''),
(20, 5, 1, 1150000, 0, 1150000, N'');
