-- =====================================================================
-- KỊCH BẢN TẠO BẢNG VÀ THÊM DỮ LIỆU MẪU CHO DỰ ÁN FAMICOATS
-- Hệ cơ sở dữ liệu: SQL Server (FamiCoatsDB)
-- =====================================================================

-- XÓA BẢNG THEO THỨ TỰ (Nếu đã tồn tại) ĐỂ TRÁNH XUNG ĐỘT KHÓA NGOẠI
IF OBJECT_ID('dbo.hinh_anh_san_pham', 'U') IS NOT NULL DROP TABLE dbo.hinh_anh_san_pham;
IF OBJECT_ID('dbo.chi_tiet_san_pham', 'U') IS NOT NULL DROP TABLE dbo.chi_tiet_san_pham;
IF OBJECT_ID('dbo.san_pham', 'U') IS NOT NULL DROP TABLE dbo.san_pham;
IF OBJECT_ID('dbo.kieu_dang', 'U') IS NOT NULL DROP TABLE dbo.kieu_dang;
IF OBJECT_ID('dbo.mau_sac', 'U') IS NOT NULL DROP TABLE dbo.mau_sac;
IF OBJECT_ID('dbo.kich_thuoc', 'U') IS NOT NULL DROP TABLE dbo.kich_thuoc;
IF OBJECT_ID('dbo.danh_muc', 'U') IS NOT NULL DROP TABLE dbo.danh_muc;
IF OBJECT_ID('dbo.thuong_hieu', 'U') IS NOT NULL DROP TABLE dbo.thuong_hieu;
IF OBJECT_ID('dbo.chat_lieu', 'U') IS NOT NULL DROP TABLE dbo.chat_lieu;
GO

-- 1. BẢNG CHẤT LIỆU (chat_lieu)
CREATE TABLE dbo.chat_lieu (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_chat_lieu NVARCHAR(100) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 2. BẢNG THƯƠNG HIỆU (thuong_hieu)
CREATE TABLE dbo.thuong_hieu (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_thuong_hieu NVARCHAR(100) NOT NULL,
    logo NVARCHAR(255) NULL,
    quoc_gia NVARCHAR(100) NULL,
    mo_ta NVARCHAR(500) NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 3. BẢNG DANH MỤC (danh_muc)
-- LƯU Ý: Loại bỏ cột id_san_pham (FK) để sửa lỗi quan hệ vòng lặp (circular dependency).
CREATE TABLE dbo.danh_muc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_danh_muc NVARCHAR(100) NOT NULL,
    mo_ta NVARCHAR(500) NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 4. BẢNG KÍCH THƯỚC (kich_thuoc)
CREATE TABLE dbo.kich_thuoc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_kich_thuoc NVARCHAR(50) NOT NULL,
    mo_ta NVARCHAR(255) NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 5. BẢNG MÀU SẮC (mau_sac)
CREATE TABLE dbo.mau_sac (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_mau NVARCHAR(50) NOT NULL,
    ma_mau_hex VARCHAR(7) NULL, -- Ví dụ: #000000, #FFFFFF
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 6. BẢNG KIỂU DÁNG (kieu_dang)
CREATE TABLE dbo.kieu_dang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_kieu_dang NVARCHAR(100) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 7. BẢNG SẢN PHẨM (san_pham)
-- LƯU Ý: Cột `kieu_dang` (NVARCHAR) đã được gỡ bỏ khỏi bảng sản phẩm chính vì bạn đã tách 
-- thành bảng độc lập `kieu_dang` và liên kết thông qua khóa ngoại trong bảng `chi_tiet_san_pham`.
CREATE TABLE dbo.san_pham (
    id VARCHAR(50) PRIMARY KEY,
    id_danh_muc INT FOREIGN KEY REFERENCES dbo.danh_muc(id),
    id_thuong_hieu INT FOREIGN KEY REFERENCES dbo.thuong_hieu(id),
    id_chat_lieu INT FOREIGN KEY REFERENCES dbo.chat_lieu(id),
    ten_san_pham NVARCHAR(200) NOT NULL,
    mo_ta NVARCHAR(MAX) NULL,
    doi_tuong NVARCHAR(50) NULL,
    xuat_xu NVARCHAR(100) NULL,
    thuong_hieu_noi_bo BIT DEFAULT 0,
    bao_hanh NVARCHAR(100) NULL,
    huong_dan_bao_quan NVARCHAR(MAX) NULL,
    tinh_nang NVARCHAR(500) NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Kinh doanh'
);
GO

-- 8. BẢNG CHI TIẾT SẢN PHẨM (chi_tiet_san_pham)
CREATE TABLE dbo.chi_tiet_san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_san_pham VARCHAR(50) FOREIGN KEY REFERENCES dbo.san_pham(id) ON DELETE CASCADE,
    id_kich_thuoc INT FOREIGN KEY REFERENCES dbo.kich_thuoc(id),
    id_mau_sac INT FOREIGN KEY REFERENCES dbo.mau_sac(id),
    id_kieu_dang INT FOREIGN KEY REFERENCES dbo.kieu_dang(id),
    gia_nhap DECIMAL(18,2) NOT NULL,
    gia_ban DECIMAL(18,2) NOT NULL,
    gia_khuyen_mai DECIMAL(18,2) NULL,
    so_luong_ton INT NOT NULL DEFAULT 0,
    trong_luong DECIMAL(8,2) NULL,
    chieau_dai DECIMAL(8,2) NULL, -- Giữ nguyên chính tả 'chieau_dai' như trong ảnh thiết kế của bạn
    chieu_rong DECIMAL(8,2) NULL,
    do_day DECIMAL(8,2) NULL,
    chong_nuoc BIT DEFAULT 0,
    chong_gio BIT DEFAULT 0,
    giu_nhiet BIT DEFAULT 0,
    trang_thai NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- 9. BẢNG HÌNH ẢNH SẢN PHẨM (hinh_anh_san_pham)
CREATE TABLE dbo.hinh_anh_san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_chi_tiet_san_pham INT FOREIGN KEY REFERENCES dbo.chi_tiet_san_pham(id) ON DELETE CASCADE,
    duong_dan NVARCHAR(255) NOT NULL,
    la_anh_chinh BIT DEFAULT 0,
    thu_tu INT DEFAULT 1
);
GO


-- =====================================================================
-- THÊM DỮ LIỆU MẪU (MOCK DATA)
-- =====================================================================

-- 1. CHẤT LIỆU (chat_lieu)
INSERT INTO dbo.chat_lieu (ten_chat_lieu, trang_thai) VALUES
(N'Dạ (Wool)', N'Hoạt động'),
(N'Nỉ (Fleece)', N'Hoạt động'),
(N'Kaki (Khaki)', N'Hoạt động'),
(N'Polyester', N'Hoạt động'),
(N'Cotton Cao Cấp', N'Hoạt động');
GO

-- 2. THƯƠNG HIỆU (thuong_hieu)
INSERT INTO dbo.thuong_hieu (ten_thuong_hieu, logo, quoc_gia, mo_ta, trang_thai) VALUES
(N'FamiCoats', N'logo_famicoats.png', N'Việt Nam', N'Thương hiệu áo khoác cao cấp dành cho gia đình.', N'Hoạt động'),
(N'Zara', N'logo_zara.png', N'Tây Ban Nha', N'Thương hiệu thời trang nhanh quốc tế nổi tiếng.', N'Hoạt động'),
(N'Uniqlo', N'logo_uniqlo.png', N'Nhật Bản', N'Thời trang tối giản, tiện dụng công nghệ LifeWear.', N'Hoạt động'),
(N'H&M', N'logo_hm.png', N'Thụy Điển', N'Thời trang xu hướng, phong cách hiện đại trẻ trung.', N'Hoạt động');
GO

-- 3. DANH MỤC (danh_muc)
INSERT INTO dbo.danh_muc (ten_danh_muc, mo_ta, trang_thai) VALUES
(N'Áo Măng Tô (Trench Coat)', N'Áo khoác dáng dài thanh lịch giữ ấm tốt.', N'Hoạt động'),
(N'Áo Phao (Down Jacket)', N'Áo khoác phao dày dặn giữ nhiệt siêu tốt.', N'Hoạt động'),
(N'Áo Gió (Windbreaker)', N'Áo khoác mỏng nhẹ chống gió bụi và cản nước.', N'Hoạt động'),
(N'Áo Dạ (Wool Coat)', N'Áo khoác dạ ấm áp sang trọng lịch lãm.', N'Hoạt động'),
(N'Áo Blazer', N'Áo khoác phong cách Smart Casual thanh lịch.', N'Hoạt động');
GO

-- 4. KÍCH THƯỚC (kich_thuoc)
INSERT INTO dbo.kich_thuoc (ten_kich_thuoc, mo_ta, trang_thai) VALUES
(N'S', N'Kích cỡ nhỏ', N'Hoạt động'),
(N'M', N'Kích cỡ trung bình', N'Hoạt động'),
(N'L', N'Kích cỡ lớn', N'Hoạt động'),
(N'XL', N'Kích cỡ cực lớn', N'Hoạt động'),
(N'XXL', N'Kích cỡ ngoại cỡ', N'Hoạt động');
GO

-- 5. MÀU SẮC (mau_sac)
INSERT INTO dbo.mau_sac (ten_mau, ma_mau_hex, trang_thai) VALUES
(N'Đen', '#000000', N'Hoạt động'),
(N'Trắng', '#FFFFFF', N'Hoạt động'),
(N'Đỏ đô', '#800020', N'Hoạt động'),
(N'Xanh navy', '#000080', N'Hoạt động'),
(N'Be (Beige)', '#F5F5DC', N'Hoạt động');
GO

-- 6. KIỂU DÁNG (kieu_dang)
INSERT INTO dbo.kieu_dang (ten_kieu_dang, trang_thai) VALUES
(N'Slim-fit', N'Hoạt động'),
(N'Regular-fit', N'Hoạt động'),
(N'Oversize', N'Hoạt động'),
(N'Loose-fit', N'Hoạt động');
GO

-- 7. SẢN PHẨM (san_pham)
INSERT INTO dbo.san_pham (id, id_danh_muc, id_thuong_hieu, id_chat_lieu, ten_san_pham, mo_ta, doi_tuong, xuat_xu, thuong_hieu_noi_bo, bao_hanh, huong_dan_bao_quan, tinh_nang, trang_thai) VALUES
('SP001', 4, 1, 1, N'Áo Khoác Dạ Dáng Dài Fami Luxury', N'Áo khoác dạ dáng dài thiết kế sang trọng, chất liệu dạ cừu tự nhiên giữ ấm cực tốt.', N'Nữ', N'Việt Nam', 1, N'12 tháng', N'Giặt khô, không vắt máy, ủi hơi nước ở nhiệt độ thấp.', N'Giữ ấm tốt, chống nhăn, tôn dáng.', N'Kinh doanh'),
('SP002', 2, 1, 4, N'Áo Phao Béo Siêu Nhẹ Fami Warm', N'Áo phao lót bông siêu nhẹ, cản gió tốt, thích hợp cho thời tiết rét đậm rét hại.', N'Unisex', N'Việt Nam', 1, N'6 tháng', N'Giặt tay hoặc giặt máy chế độ nhẹ, không dùng chất tẩy mạnh.', N'Chống thấm nước nhẹ, cản gió, cực kỳ ấm áp.', N'Kinh doanh'),
('SP003', 1, 2, 3, N'Áo Trench Coat Zara Classic', N'Áo măng tô dáng dài phong cách cổ điển Tây Âu, tôn lên vẻ thanh lịch thời thượng.', N'Nam', N'Tây Ban Nha', 0, N'Không bảo hành', N'Giặt tay hoặc giặt khô, tránh ánh nắng trực tiếp khi phơi.', N'Thời trang, cản gió nhẹ.', N'Kinh doanh'),
('SP004', 3, 3, 4, N'Áo Gió Chống Nước Uniqlo Blocktech', N'Áo gió công nghệ Blocktech chống thấm nước tuyệt đối, cản gió tối ưu, thích hợp đi mưa nhẹ.', N'Unisex', N'Nhật Bản', 0, N'Không bảo hành', N'Giặt máy nước lạnh, không sấy nhiệt độ cao.', N'Chống nước tuyệt đối, chống tia UV, mỏng nhẹ.', N'Kinh doanh'),
('SP005', 5, 1, 5, N'Áo Blazer Cotton Fami Smart Casual', N'Áo khoác blazer mỏng nhẹ phong cách Hàn Quốc, thích hợp đi làm hoặc đi chơi.', N'Nam', N'Việt Nam', 1, N'3 tháng', N'Giặt tay nước lạnh, ủi ở nhiệt độ trung bình.', N'Thoáng khí, mềm mại, co giãn nhẹ.', N'Kinh doanh');
GO

-- 8. CHI TIẾT SẢN PHẨM (chi_tiet_san_pham)
INSERT INTO dbo.chi_tiet_san_pham (id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieau_dai, chieu_rong, do_day, chong_nuoc, chong_gio, giu_nhiet, trang_thai) VALUES
-- SP001 - Áo Dạ Fami Luxury (Size M - Đen, Size L - Be)
('SP001', 2, 1, 1, 500000.00, 950000.00, 850000.00, 50, 0.80, 95.0, 48.0, 2.5, 0, 1, 1, N'Hoạt động'), -- id: 1
('SP001', 3, 5, 1, 500000.00, 950000.00, 850000.00, 30, 0.85, 98.0, 50.0, 2.5, 0, 1, 1, N'Hoạt động'), -- id: 2

-- SP002 - Áo Phao Béo Fami Warm (Size L - Navy, Size XL - Đen)
('SP002', 3, 4, 3, 400000.00, 799000.00, 699000.00, 100, 1.10, 75.0, 60.0, 5.0, 1, 1, 1, N'Hoạt động'), -- id: 3
('SP002', 4, 1, 3, 400000.00, 799000.00, 749000.00, 40, 1.20, 78.0, 62.0, 5.0, 1, 1, 1, N'Hoạt động'), -- id: 4

-- SP003 - Áo Trench Coat Zara Classic (Size M - Đen, Size L - Navy)
('SP003', 2, 1, 2, 600000.00, 1200000.00, 1050000.00, 20, 0.90, 100.0, 52.0, 1.8, 0, 1, 0, N'Hoạt động'), -- id: 5
('SP003', 3, 4, 2, 600000.00, 1200000.00, NULL, 15, 0.95, 103.0, 54.0, 1.8, 0, 1, 0, N'Hoạt động'), -- id: 6

-- SP004 - Áo Gió Chống Nước Uniqlo Blocktech (Size S - Đỏ đô, Size M - Navy)
('SP004', 1, 3, 2, 250000.00, 499000.00, NULL, 60, 0.30, 65.0, 45.0, 0.8, 1, 1, 0, N'Hoạt động'), -- id: 7
('SP004', 2, 4, 2, 250000.00, 499000.00, 449000.00, 80, 0.32, 68.0, 47.0, 0.8, 1, 1, 0, N'Hoạt động'), -- id: 8

-- SP005 - Áo Blazer Cotton Fami Smart Casual (Size M - Đen, Size L - Be)
('SP005', 2, 1, 2, 300000.00, 599000.00, NULL, 35, 0.60, 72.0, 50.0, 1.2, 0, 0, 0, N'Hoạt động'), -- id: 9
('SP005', 3, 5, 2, 300000.00, 599000.00, 529000.00, 25, 0.63, 74.0, 52.0, 1.2, 0, 0, 0, N'Hoạt động'); -- id: 10
GO

-- 9. HÌNH ẢNH SẢN PHẨM (hinh_anh_san_pham)
INSERT INTO dbo.hinh_anh_san_pham (id_chi_tiet_san_pham, duong_dan, la_anh_chinh, thu_tu) VALUES
(1, 'anh1.png', 1, 1),
(1, 'anh2.png', 0, 2),
(2, 'anh3.png', 1, 1),
(3, 'anh4.png', 1, 1),
(4, 'anh5.png', 1, 1),
(5, 'anh6.png', 1, 1),
(6, 'anh7.png', 1, 1),
(7, 'anh8.png', 1, 1),
(8, 'anh9.png', 1, 1),
(9, 'anh10.png', 1, 1);
GO
