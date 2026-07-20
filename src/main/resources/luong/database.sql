-- =====================================================================
-- KỊCH BẢN TẠO CƠ SỞ DỮ LIỆU VÀ CÁC BẢNG (CHUẨN HÓA)
-- Hệ cơ sở dữ liệu: SQL Server
-- Tên cơ sở dữ liệu: project1
-- Quy ước: id = khóa chính INT tự sinh (ẩn nội bộ DB)
--          code = mã hiển thị trên giao diện (do người dùng nhập)
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
IF OBJECT_ID('dbo.product_image', 'U') IS NOT NULL DROP TABLE dbo.product_image;
IF OBJECT_ID('dbo.product_detail', 'U') IS NOT NULL DROP TABLE dbo.product_detail;
IF OBJECT_ID('dbo.product', 'U') IS NOT NULL DROP TABLE dbo.product;
IF OBJECT_ID('dbo.style', 'U') IS NOT NULL DROP TABLE dbo.style;
IF OBJECT_ID('dbo.size', 'U') IS NOT NULL DROP TABLE dbo.size;
IF OBJECT_ID('dbo.color', 'U') IS NOT NULL DROP TABLE dbo.color;
IF OBJECT_ID('dbo.material', 'U') IS NOT NULL DROP TABLE dbo.material;
IF OBJECT_ID('dbo.category', 'U') IS NOT NULL DROP TABLE dbo.category;
IF OBJECT_ID('dbo.brand', 'U') IS NOT NULL DROP TABLE dbo.brand;
GO

-- =====================================================================
-- CÁC BẢNG DANH MỤC TỪ ĐIỂN (LOOKUP TABLES)
-- Mỗi bảng: id = PK tự sinh | code = mã hiển thị | name = tên đầy đủ
-- =====================================================================

-- Thương hiệu
CREATE TABLE dbo.brand (
    id   INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,   -- VD: BR001
    name NVARCHAR(100) NOT NULL,
    status NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- Danh mục sản phẩm
CREATE TABLE dbo.category (
    id   INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,   -- VD: CAT001
    name NVARCHAR(100) NOT NULL,
    status NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- Chất liệu
CREATE TABLE dbo.material (
    id   INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,   -- VD: MAT001
    name NVARCHAR(100) NOT NULL,
    status NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- Màu sắc
CREATE TABLE dbo.color (
    id   INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,   -- VD: COL001
    name NVARCHAR(50) NOT NULL,
    status NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- Kích thước
CREATE TABLE dbo.size (
    id   INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,   -- VD: SZ001
    name NVARCHAR(50) NOT NULL,         -- VD: S, M, L, XL
    status NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- Kiểu dáng
CREATE TABLE dbo.style (
    id   INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,   -- VD: STY001
    name NVARCHAR(100) NOT NULL,
    status NVARCHAR(50) DEFAULT N'Hoạt động'
);
GO

-- =====================================================================
-- BẢNG SẢN PHẨM CHÍNH
-- id = PK tự sinh | code = mã sản phẩm hiển thị (VD: SP001)
-- =====================================================================
CREATE TABLE dbo.product (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    code        VARCHAR(50) NOT NULL UNIQUE,   -- Mã sản phẩm hiển thị: SP001
    category_id INT FOREIGN KEY REFERENCES dbo.category(id),
    brand_id    INT FOREIGN KEY REFERENCES dbo.brand(id),
    material_id INT FOREIGN KEY REFERENCES dbo.material(id),
    name        NVARCHAR(255),
    price       FLOAT,
    sold        INT DEFAULT 0,
    description NVARCHAR(MAX),
    origin      NVARCHAR(100),
    care_instructions NVARCHAR(MAX),
    status      NVARCHAR(50)  -- AVAILABLE, OUT_OF_STOCK
);
GO

-- =====================================================================
-- BẢNG BIẾN THỂ SẢN PHẨM
-- id = PK tự sinh | liên kết với product qua product_id (INT)
-- =====================================================================
CREATE TABLE dbo.product_detail (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL FOREIGN KEY REFERENCES dbo.product(id) ON DELETE CASCADE,
    size_id    INT FOREIGN KEY REFERENCES dbo.size(id),
    color_id   INT FOREIGN KEY REFERENCES dbo.color(id),
    style_id   INT FOREIGN KEY REFERENCES dbo.style(id),
    price      FLOAT,
    stock      INT DEFAULT 0,
    weight     FLOAT,
    length     FLOAT,
    width      FLOAT,
    thickness  FLOAT,
    status     NVARCHAR(50)
);
GO

-- =====================================================================
-- BẢNG HÌNH ẢNH BIẾN THỂ
-- id = PK tự sinh | liên kết với product_detail qua product_detail_id (INT)
-- =====================================================================
CREATE TABLE dbo.product_image (
    id                INT IDENTITY(1,1) PRIMARY KEY,
    product_detail_id INT NOT NULL FOREIGN KEY REFERENCES dbo.product_detail(id) ON DELETE CASCADE,
    image_url         NVARCHAR(255)
);
GO

-- =====================================================================
-- DỮ LIỆU MẪU - BẢNG TỪ ĐIỂN
-- =====================================================================

-- Thương hiệu
INSERT INTO dbo.brand (code, name) VALUES
('BR001', N'FamiCoats'),
('BR002', N'Zara'),
('BR003', N'Levi''s'),
('BR004', N'Uniqlo'),
('BR005', N'The North Face'),
('BR006', N'H&M'),
('BR007', N'Cardina');

-- Danh mục
INSERT INTO dbo.category (code, name) VALUES
('CAT001', N'Áo khoác da'),
('CAT002', N'Áo bomber'),
('CAT003', N'Áo denim'),
('CAT004', N'Áo phao'),
('CAT005', N'Áo gió'),
('CAT006', N'Áo len');

-- Chất liệu
INSERT INTO dbo.material (code, name) VALUES
('MAT001', N'Da cừu'),
('MAT002', N'Vải gió'),
('MAT003', N'Denim'),
('MAT004', N'Lông vũ'),
('MAT005', N'Len');

-- Màu sắc
INSERT INTO dbo.color (code, name) VALUES
('COL001', N'Đen'),
('COL002', N'Be'),
('COL003', N'Navy'),
('COL004', N'Đỏ đô'),
('COL005', N'Cam');

-- Kích thước
INSERT INTO dbo.size (code, name) VALUES
('SZ001', N'S'),
('SZ002', N'M'),
('SZ003', N'L'),
('SZ004', N'XL');

-- Kiểu dáng
INSERT INTO dbo.style (code, name) VALUES
('STY001', N'Slim-fit'),
('STY002', N'Oversize'),
('STY003', N'Classic'),
('STY004', N'Vintage'),
('STY005', N'Blocktech'),
('STY006', N'Casual'),
('STY007', N'Biker'),
('STY008', N'Thu đông');
GO

-- =====================================================================
-- DỮ LIỆU MẪU - BẢNG PRODUCT (code = mã giao diện, id tự sinh)
-- brand_id: 1=FamiCoats, 2=Zara, 3=Levi's, 4=Uniqlo, 5=The North Face, 6=H&M, 7=Cardina
-- category_id: 1=Áo khoác da, 2=Áo bomber, 3=Áo denim, 4=Áo phao, 5=Áo gió, 6=Áo len
-- material_id: 1=Da cừu, 2=Vải gió, 3=Denim, 4=Lông vũ, 5=Len
-- =====================================================================
INSERT INTO dbo.product (code, category_id, brand_id, material_id, name, price, sold, description, origin, care_instructions, status) VALUES
('SP001', 1, 1, 1, N'Áo khoác da nam Premium',       1850000, 324, N'Áo khoác da nam chất liệu da cừu tự nhiên cao cấp, bề mặt da mềm mịn. Thiết kế slim-fit hiện đại, tôn dáng người mặc.',         N'Việt Nam',  N'Chỉ giặt khô, không giặt máy. Tránh ánh nắng trực tiếp, bảo quản nơi khô ráo, thoáng mát.',                    'AVAILABLE'),
('SP002', 2, 2, 2, N'Bomber jacket oversize unisex',  1290000, 287, N'Áo bomber form rộng thời trang unisex. Lớp lót gió dày dặn, bo chun cổ tay và gấu áo chắc chắn.',                                N'Nhập khẩu', N'Giặt máy chế độ nhẹ với nước ấm, dùng túi giặt. Không tẩy trắng, phơi nơi râm mát.',                           'AVAILABLE'),
('SP003', 3, 3, 3, N'Áo denim wash nữ vintage',        890000, 241, N'Áo khoác bò denim dáng lửng phong cách retro vintage cho nữ. Chất bò dày dặn, wash màu tự nhiên cá tính.',                      N'Việt Nam',  N'Giặt riêng bằng tay hoặc máy chế độ thường, lộn trái khi giặt và phơi để giữ màu wash.',                      'AVAILABLE'),
('SP004', 4, 4, 4, N'Áo phao siêu nhẹ unisex',        2100000, 198, N'Áo phao lông vũ siêu nhẹ, cản gió cản nước nhẹ vượt trội. Thiết kế gấp gọn tiện lợi mang đi du lịch.',                          N'Nhật Bản',  N'Giặt tay nhẹ nhàng bằng nước lạnh với dầu gội đầu. Tránh giặt khô hoặc vắt xoắn mạnh.',                        'AVAILABLE'),
('SP005', 5, 5, 2, N'Khoác gió windbreaker nam',       1150000, 156, N'Áo gió thể thao nam chống nước nhẹ, cản gió 100%. Lớp lót lưới thoáng khí hạn chế bí mồ hôi.',                                 N'Việt Nam',  N'Giặt máy bằng nước lạnh với bột giặt nhẹ. Không ủi ở nhiệt độ cao.',                                          'AVAILABLE'),
('SP006', 1, 1, 1, N'Áo khoác da nữ Premium',         1750000, 412, N'Phiên bản áo da cừu cao cấp dành riêng cho nữ, kiểu dáng biker cá tính, khóa kéo kim loại không gỉ sang trọng.',               N'Việt Nam',  N'Chỉ giặt khô chuyên nghiệp. Dùng khăn mềm ẩm để lau các vết bẩn nhẹ trên bề mặt da.',                          'OUT_OF_STOCK'),
('SP007', 2, 6, 2, N'Bomber jacket slim fit nam',      1190000, 203, N'Áo khoác bomber dáng ôm nam tính lịch lãm, dễ dàng phối cùng áo phông và quần jeans đơn giản.',                                 N'Việt Nam',  N'Giặt máy ở nhiệt độ bình thường, lộn trái áo khi phơi để giữ độ bền cho bo chun cổ tay.',                      'AVAILABLE'),
('SP008', 6, 7, 5, N'Áo khoác len nữ thu đông',         990000, 167, N'Chất liệu len dệt sợi cao cấp mềm mại, co giãn tốt, không xù lông. Giữ ấm cơ thể hiệu quả trong thời tiết se lạnh.',           N'Việt Nam',  N'Giặt tay nhẹ nhàng bằng dầu gội hoặc nước giặt chuyên dụng cho đồ len. Phơi nằm ngang.',                        'AVAILABLE');
GO

-- =====================================================================
-- DỮ LIỆU MẪU - BẢNG PRODUCT DETAIL
-- product_id tham chiếu đến cột id (INT) trong bảng product
-- Dùng subquery để lấy id từ code, tránh hardcode số
-- size_id: 1=S, 2=M, 3=L, 4=XL
-- color_id: 1=Đen, 2=Be, 3=Navy, 4=Đỏ đô, 5=Cam
-- style_id: 1=Slim-fit, 2=Oversize, 3=Classic, 4=Vintage, 5=Blocktech, 6=Casual, 7=Biker, 8=Thu đông
-- =====================================================================
INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 2, 1, 1, 950000, 20, 0.80, 95.0, 48.0, 2.5, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP001';  -- M | Đen | Slim-fit

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 3, 2, 2, 950000, 28, 0.85, 98.0, 50.0, 2.5, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP001';  -- L | Be | Oversize

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 3, 3, 3, 799000, 18, 1.10, 75.0, 60.0, 5.0, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP002';  -- L | Navy | Classic

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 4, 1, 3, 799000, 14, 1.20, 78.0, 62.0, 5.0, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP002';  -- XL | Đen | Classic

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 2, 1, 4, 1200000, 10, 0.90, 100.0, 52.0, 1.8, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP003'; -- M | Đen | Vintage

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 3, 3, 4, 1200000,  5, 0.95, 103.0, 54.0, 1.8, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP003'; -- L | Navy | Vintage

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 1, 4, 5, 499000, 30, 0.30, 65.0, 45.0, 0.8, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP004';  -- S | Đỏ đô | Blocktech

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 2, 3, 5, 499000, 31, 0.32, 68.0, 47.0, 0.8, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP004';  -- M | Navy | Blocktech

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 2, 1, 6, 599000,  3, 0.60, 72.0, 50.0, 1.2, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP005';  -- M | Đen | Casual

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 3, 2, 6, 599000,  5, 0.63, 74.0, 52.0, 1.2, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP005';  -- L | Be | Casual

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 2, 1, 7, 1750000, 0, 1.00, 60.0, 45.0, 3.0, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP006'; -- M | Đen | Biker

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 3, 1, 1, 1190000, 45, 0.80, 70.0, 50.0, 2.0, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP007'; -- L | Đen | Slim-fit

INSERT INTO dbo.product_detail (product_id, size_id, color_id, style_id, price, stock, weight, length, width, thickness, status)
SELECT p.id, 1, 5, 8, 990000, 28, 0.50, 65.0, 45.0, 1.5, N'Hoạt động' FROM dbo.product p WHERE p.code = 'SP008';  -- S | Cam | Thu đông
GO

-- =====================================================================
-- DỮ LIỆU MẪU - BẢNG PRODUCT IMAGE
-- product_detail_id tham chiếu đến cột id (INT) tự sinh trong product_detail
-- Dùng ROW_NUMBER để lấy đúng id biến thể theo thứ tự insert
-- =====================================================================
DECLARE @detailIds TABLE (rn INT, detail_id INT);
INSERT INTO @detailIds
SELECT ROW_NUMBER() OVER (ORDER BY id), id FROM dbo.product_detail ORDER BY id;

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh1.png' FROM @detailIds WHERE rn = 1;   -- SP001 - M Đen Slim-fit
INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh2.png' FROM @detailIds WHERE rn = 1;

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh3.png' FROM @detailIds WHERE rn = 2;   -- SP001 - L Be Oversize

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh4.png' FROM @detailIds WHERE rn = 3;   -- SP002 - L Navy Classic

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh5.png' FROM @detailIds WHERE rn = 4;   -- SP002 - XL Đen Classic

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh6.png' FROM @detailIds WHERE rn = 5;   -- SP003 - M Đen Vintage

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh7.png' FROM @detailIds WHERE rn = 6;   -- SP003 - L Navy Vintage

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh8.png' FROM @detailIds WHERE rn = 7;   -- SP004 - S Đỏ đô Blocktech

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh9.png' FROM @detailIds WHERE rn = 8;   -- SP004 - M Navy Blocktech

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh10.png' FROM @detailIds WHERE rn = 9;  -- SP005 - M Đen Casual

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh10.png' FROM @detailIds WHERE rn = 10; -- SP005 - L Be Casual

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh11.png' FROM @detailIds WHERE rn = 11; -- SP006 - M Đen Biker

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh12.png' FROM @detailIds WHERE rn = 12; -- SP007 - L Đen Slim-fit

INSERT INTO dbo.product_image (product_detail_id, image_url)
SELECT detail_id, N'anh13.png' FROM @detailIds WHERE rn = 13; -- SP008 - S Cam Thu đông
GO
