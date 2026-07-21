-- =====================================================================
-- KỊCH BẢN TẠO CƠ SỞ DỮ LIỆU VÀ CÁC BẢNG (CHUẨN HÓA)
-- Hệ cơ sở dữ liệu: SQL Server
-- Tất cả các bảng đều có id (INT IDENTITY) và code (VARCHAR)
-- =====================================================================

IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'project1')
BEGIN
    CREATE DATABASE project1;
END
GO

USE project1;
GO

-- =====================================================================
-- XÓA BẢNG THEO THỨ TỰ (Nếu đã tồn tại) ĐỂ TRÁNH XUNG ĐỘT KHÓA NGOẠI
-- =====================================================================
IF OBJECT_ID('hinh_anh_san_pham', 'U') IS NOT NULL DROP TABLE hinh_anh_san_pham;
IF OBJECT_ID('chi_tiet_san_pham', 'U') IS NOT NULL DROP TABLE chi_tiet_san_pham;
IF OBJECT_ID('san_pham', 'U') IS NOT NULL DROP TABLE san_pham;
IF OBJECT_ID('kieu_dang', 'U') IS NOT NULL DROP TABLE kieu_dang;
IF OBJECT_ID('kich_thuoc', 'U') IS NOT NULL DROP TABLE kich_thuoc;
IF OBJECT_ID('mau_sac', 'U') IS NOT NULL DROP TABLE mau_sac;
IF OBJECT_ID('chat_lieu', 'U') IS NOT NULL DROP TABLE chat_lieu;
IF OBJECT_ID('danh_muc', 'U') IS NOT NULL DROP TABLE danh_muc;
IF OBJECT_ID('thuong_hieu', 'U') IS NOT NULL DROP TABLE thuong_hieu;

IF OBJECT_ID('dia_chi', 'U') IS NOT NULL DROP TABLE dia_chi;
IF OBJECT_ID('khach_hang', 'U') IS NOT NULL DROP TABLE khach_hang;

IF OBJECT_ID('nhan_vien', 'U') IS NOT NULL DROP TABLE nhan_vien;
IF OBJECT_ID('vai_tro', 'U') IS NOT NULL DROP TABLE vai_tro;
GO

-- =====================================================================
-- TẠO CÁC BẢNG (CHUẨN HÓA CÓ ID VÀ CODE)
-- =====================================================================

-- 1. VAI TRÒ
CREATE TABLE vai_tro (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    ten_vai_tro NVARCHAR(100) NOT NULL,
    mo_ta NVARCHAR(MAX),
    trang_thai INT DEFAULT 1
);
GO

-- 2. NHÂN VIÊN
CREATE TABLE nhan_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE, -- ma_nhan_vien
    id_vai_tro INT FOREIGN KEY REFERENCES vai_tro(id),
    ho_ten NVARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mat_khau VARCHAR(255) NOT NULL,
    so_dien_thoai VARCHAR(15),
    ngay_sinh DATE,
    gioi_tinh BIT, -- 1: Nam, 0: Nữ
    anh_dai_dien NVARCHAR(500),
    trang_thai INT DEFAULT 1,
    dia_chi NVARCHAR(MAX),
    cccd VARCHAR(20)
);
GO

-- 3. KHÁCH HÀNG
CREATE TABLE khach_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    ho_ten NVARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mat_khau VARCHAR(255),
    so_dien_thoai VARCHAR(15) NOT NULL,
    ngay_sinh DATE,
    gioi_tinh NVARCHAR(20),
    anh_dai_dien NVARCHAR(500),
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- 4. ĐỊA CHỈ (Khách hàng)
CREATE TABLE dia_chi (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    id_khach_hang INT NOT NULL FOREIGN KEY REFERENCES khach_hang(id) ON DELETE CASCADE,
    mac_dinh BIT DEFAULT 0,
    nguoi_nhan NVARCHAR(100),
    so_dien_thoai VARCHAR(15),
    tinh NVARCHAR(100) NOT NULL,
    huyen NVARCHAR(100) NOT NULL,
    xa NVARCHAR(100) NOT NULL,
    dia_chi_chi_tiet NVARCHAR(255) NOT NULL
);
GO

-- 5. THƯƠNG HIỆU
CREATE TABLE thuong_hieu (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(100) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 6. DANH MỤC
CREATE TABLE danh_muc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(100) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 7. CHẤT LIỆU
CREATE TABLE chat_lieu (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(100) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 8. MÀU SẮC
CREATE TABLE mau_sac (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(50) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 9. KÍCH THƯỚC
CREATE TABLE kich_thuoc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(50) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 10. KIỂU DÁNG
CREATE TABLE kieu_dang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(100) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 11. SẢN PHẨM
CREATE TABLE san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    id_danh_muc INT FOREIGN KEY REFERENCES danh_muc(id),
    id_thuong_hieu INT FOREIGN KEY REFERENCES thuong_hieu(id),
    id_chat_lieu INT FOREIGN KEY REFERENCES chat_lieu(id),
    name NVARCHAR(255),
    gia_ban FLOAT,
    da_ban INT DEFAULT 0,
    mo_ta NVARCHAR(MAX),
    xuat_xu NVARCHAR(100),
    huong_dan_bao_quan NVARCHAR(MAX),
    status NVARCHAR(50)
);
GO

-- 12. CHI TIẾT SẢN PHẨM
CREATE TABLE chi_tiet_san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    id_san_pham INT NOT NULL FOREIGN KEY REFERENCES san_pham(id) ON DELETE CASCADE,
    id_kich_thuoc INT FOREIGN KEY REFERENCES kich_thuoc(id),
    id_mau_sac INT FOREIGN KEY REFERENCES mau_sac(id),
    id_kieu_dang INT FOREIGN KEY REFERENCES kieu_dang(id),
    gia_ban FLOAT,
    so_luong INT DEFAULT 0,
    trong_luong FLOAT,
    chieu_dai FLOAT,
    chieu_rong FLOAT,
    do_day FLOAT,
    status NVARCHAR(50)
);
GO

-- 13. HÌNH ẢNH SẢN PHẨM
CREATE TABLE hinh_anh_san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    id_chi_tiet_san_pham INT NOT NULL FOREIGN KEY REFERENCES chi_tiet_san_pham(id) ON DELETE CASCADE,
    duong_dan_anh NVARCHAR(500)
);
GO

-- =====================================================================
-- DỮ LIỆU MẪU (MOCK DATA) VỚI FAKE IMAGES
-- =====================================================================

-- VAI TRÒ
INSERT INTO vai_tro (code, ten_vai_tro, mo_ta, trang_thai) VALUES
('ROLE01', N'Admin', N'Quản trị viên hệ thống', 1),
('ROLE02', N'Quản lý', N'Quản lý cửa hàng', 1),
('ROLE03', N'Nhân viên', N'Nhân viên bán hàng', 1);

-- NHÂN VIÊN
INSERT INTO nhan_vien (code, id_vai_tro, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, anh_dai_dien, trang_thai, dia_chi, cccd) VALUES
('NV001', 1, N'Nguyễn Quản Trị', 'admin@example.com', '123456', '0901234567', '1990-01-01', 1, 'https://i.pravatar.cc/150?u=admin', 1, N'Hà Nội', '001090123456'),
('NV002', 2, N'Trần Thị Quản Lý', 'manager@example.com', '123456', '0912345678', '1992-05-15', 0, 'https://i.pravatar.cc/150?u=manager', 1, N'Hồ Chí Minh', '002092123456'),
('NV003', 3, N'Lê Nhân Viên', 'staff@example.com', '123456', '0923456789', '1995-10-20', 1, 'https://i.pravatar.cc/150?u=staff', 1, N'Đà Nẵng', '003095123456');

-- KHÁCH HÀNG
INSERT INTO khach_hang (code, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, anh_dai_dien, trang_thai) VALUES 
('KH001', N'Nguyễn Văn An', 'an.nguyen@example.com', '123456', '0987654321', '1995-05-20', N'Nam', 'https://i.pravatar.cc/150?img=11', N'Hoạt động'),
('KH002', N'Trần Thị Bích', 'bich.tran@example.com', '123456', '0912345678', '1998-10-15', N'Nữ', 'https://i.pravatar.cc/150?img=5', N'Hoạt động'),
('KH003', N'Lê Hoàng Nam', 'nam.le@example.com', '123456', '0909123456', '1990-01-01', N'Nam', 'https://i.pravatar.cc/150?img=13', N'Khóa'),
('KH004', N'Phạm Thu Hà', 'ha.pham@example.com', '123456', '0933456789', '2000-12-05', N'Nữ', 'https://i.pravatar.cc/150?img=9', N'Hoạt động');

-- ĐỊA CHỈ
INSERT INTO dia_chi (code, id_khach_hang, mac_dinh, nguoi_nhan, so_dien_thoai, tinh, huyen, xa, dia_chi_chi_tiet) VALUES 
('DC001', 1, 1, NULL, NULL, N'Thành phố Hà Nội', N'Quận Đống Đa', N'Phường Láng Hạ', N'Số 12 Ngõ 34'),
('DC002', 1, 0, N'Nguyễn Văn Bình (Em trai)', '0988111222', N'Thành phố Hồ Chí Minh', N'Quận Tân Bình', N'Phường 2', N'Số 8A'),
('DC003', 2, 1, NULL, NULL, N'Thành phố Đà Nẵng', N'Quận Hải Châu', N'Phường Hải Châu 1', N'123 Đường Trần Phú'),
('DC004', 3, 1, NULL, NULL, N'Thành phố Hải Phòng', N'Huyện Thủy Nguyên', N'Xã Hòa Bình', N'Thôn 4'),
('DC005', 4, 1, NULL, NULL, N'Thành phố Hồ Chí Minh', N'Quận Bình Thạnh', N'Phường 22', N'Tòa nhà Landmark 81');

-- THƯƠNG HIỆU
INSERT INTO thuong_hieu (code, ten) VALUES
('BR001', N'FamiCoats'),
('BR002', N'Zara'),
('BR003', N'Levi''s'),
('BR004', N'Uniqlo'),
('BR005', N'The North Face');

-- DANH MỤC
INSERT INTO danh_muc (code, ten) VALUES
('CAT001', N'Áo khoác da'),
('CAT002', N'Áo bomber'),
('CAT003', N'Áo denim'),
('CAT004', N'Áo phao');

-- CHẤT LIỆU
INSERT INTO chat_lieu (code, ten) VALUES
('MAT001', N'Da cừu'),
('MAT002', N'Vải gió'),
('MAT003', N'Denim'),
('MAT004', N'Lông vũ');

-- MÀU SẮC
INSERT INTO mau_sac (code, ten) VALUES
('COL001', N'Đen'),
('COL002', N'Be'),
('COL003', N'Navy'),
('COL004', N'Đỏ đô');

-- KÍCH THƯỚC
INSERT INTO kich_thuoc (code, ten) VALUES
('SZ001', N'S'),
('SZ002', N'M'),
('SZ003', N'L'),
('SZ004', N'XL');

-- KIỂU DÁNG
INSERT INTO kieu_dang (code, ten) VALUES
('STY001', N'Slim-fit'),
('STY002', N'Oversize'),
('STY003', N'Classic'),
('STY004', N'Vintage');

-- SẢN PHẨM
INSERT INTO san_pham (code, id_danh_muc, id_thuong_hieu, id_chat_lieu, name, gia_ban, da_ban, mo_ta, xuat_xu, huong_dan_bao_quan, status) VALUES
('SP001', 1, 1, 1, N'Áo khoác da nam Premium', 1850000, 324, N'Áo khoác da cao cấp, chống nước tốt.', N'Việt Nam', N'Chỉ giặt khô', 'AVAILABLE'),
('SP002', 2, 2, 2, N'Bomber jacket oversize', 1290000, 287, N'Áo bomber form rộng thoải mái, phong cách trẻ trung.', N'Nhập khẩu', N'Giặt máy nhẹ', 'AVAILABLE'),
('SP003', 3, 3, 3, N'Áo denim wash nữ vintage', 890000, 241, N'Áo denim vintage mang đậm phong cách đường phố.', N'Việt Nam', N'Giặt riêng', 'AVAILABLE');

-- CHI TIẾT SẢN PHẨM
INSERT INTO chi_tiet_san_pham (code, id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang, gia_ban, so_luong, trong_luong, chieu_dai, chieu_rong, do_day, status) VALUES
('CT001', 1, 2, 1, 1, 1850000, 20, 0.8, 95.0, 48.0, 2.5, N'AVAILABLE'),
('CT002', 1, 3, 2, 2, 1850000, 28, 0.85, 98.0, 50.0, 2.5, N'AVAILABLE'),
('CT003', 2, 3, 3, 3, 1290000, 18, 1.1, 75.0, 60.0, 5.0, N'AVAILABLE'),
('CT004', 3, 2, 1, 4, 890000, 10, 0.9, 100.0, 52.0, 1.8, N'AVAILABLE');

-- HÌNH ẢNH SẢN PHẨM
INSERT INTO hinh_anh_san_pham (code, id_chi_tiet_san_pham, duong_dan_anh) VALUES
('IMG001', 1, N'https://picsum.photos/400?random=1'),
('IMG002', 1, N'https://picsum.photos/400?random=2'),
('IMG003', 2, N'https://picsum.photos/400?random=3'),
('IMG004', 3, N'https://picsum.photos/400?random=4'),
('IMG005', 4, N'https://picsum.photos/400?random=5');
GO
