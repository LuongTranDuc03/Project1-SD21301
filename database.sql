-- =======================================================
-- SCRIPT TẠO CƠ SỞ DỮ LIỆU FamiCoats - PHIÊN BẢN ĐẦY ĐỦ
-- Đồng bộ với tất cả Hibernate Entity classes
-- =======================================================

USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FamiCoats')
BEGIN
    ALTER DATABASE FamiCoats SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FamiCoats;
END
GO
CREATE DATABASE FamiCoats;
GO
USE FamiCoats;
GO

-- =======================================================
-- PHẦN 1: TẠO CẤU TRÚC BẢNG
-- =======================================================

-- 1. Bảng Nhân viên (Entity: NhanVien)
CREATE TABLE nhan_vien (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    ho_ten          NVARCHAR(200) NOT NULL,
    email           VARCHAR(200) UNIQUE,
    mat_khau        VARCHAR(500),
    so_dien_thoai   VARCHAR(20),
    ngay_sinh       DATE,
    gioi_tinh       BIT,           -- 1: Nam, 0: Nữ
    ccod            VARCHAR(20),   -- CCCD
    luong           DECIMAL(18,2),
    ngay_vao_lam    DATE,
    anh_dai_dien    VARCHAR(500),
    vai_tro         NVARCHAR(50),  -- ADMIN, NHAN_VIEN, QUAN_LY
    trang_thai      INT            -- 1: Hoạt động, 0: Nghỉ việc
);

-- 2. Bảng Khách hàng (Entity: KhachHang)
CREATE TABLE khach_hang (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    ho_ten          NVARCHAR(200) NOT NULL,
    email           VARCHAR(200) UNIQUE,
    mat_khau        VARCHAR(500),
    so_dien_thoai   VARCHAR(20),
    ngay_sinh       DATE,
    gioi_tinh       BIT,           -- 1: Nam, 0: Nữ
    diem_tich_luy   INT DEFAULT 0,
    hang_thanh_vien NVARCHAR(50),  -- DONG, BAC, VANG, BACH_KIM
    anh_dai_dien    VARCHAR(500),
    trang_thai      INT            -- 1: Hoạt động, 0: Bị khóa
);

-- 3. Bảng Địa chỉ (Entity: DiaChi)
CREATE TABLE dia_chi (
    id                  INT IDENTITY(1,1) PRIMARY KEY,
    id_khach_hang       INT FOREIGN KEY REFERENCES khach_hang(id),
    nguoi_nhan          NVARCHAR(150),
    so_dien_thoai       VARCHAR(20),
    tinh                NVARCHAR(100),
    huyen               NVARCHAR(100),
    xa                  NVARCHAR(100),
    dia_chi_chi_tiet    NVARCHAR(500),
    mac_dinh            BIT DEFAULT 0,
    ghi_chu             NVARCHAR(MAX)
);

-- 4. Bảng Phương thức thanh toán (Entity: PhuongThucThanhToan)
CREATE TABLE phuong_thuc_thanh_toan (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    ten_phuong_thuc NVARCHAR(100) NOT NULL,
    mo_ta           NVARCHAR(MAX),
    logo            VARCHAR(500),
    phi_thanh_toan  DECIMAL(18,2) DEFAULT 0,
    trang_thai      INT            -- 1: Hoạt động, 0: Không hoạt động
);

-- 5. Bảng Phiếu giảm giá (Entity: PhieuGiamGia)
CREATE TABLE phieu_giam_gia (
    id                          INT IDENTITY(1,1) PRIMARY KEY,
    ten_chuong_trinh            NVARCHAR(200) NOT NULL,
    loai_giam                   VARCHAR(50),       -- PHAN_TRAM, SO_TIEN_CO_DINH
    gia_tri_giam                DECIMAL(18,2),
    gia_tri_don_hang_toi_thieu  DECIMAL(18,2),
    giam_toi_da                 DECIMAL(18,2),
    so_luong                    INT,
    da_su_dung                  INT DEFAULT 0,
    ngay_bat_dau                DATETIME,
    ngay_ket_thuc               DATETIME,
    mo_ta                       NVARCHAR(MAX),
    trang_thai                  INT                -- 1: Còn hiệu lực, 0: Hết hạn
);

-- 6. Bảng Sản phẩm (Entity: SanPham) - MỚI
CREATE TABLE san_pham (
    id                  INT IDENTITY(1,1) PRIMARY KEY,
    ma_san_pham         VARCHAR(50) UNIQUE,
    ten_san_pham        NVARCHAR(300) NOT NULL,
    ten_tieng_anh       VARCHAR(300),
    danh_muc            NVARCHAR(100),
    thuong_hieu         NVARCHAR(100),
    xuat_xu             NVARCHAR(100),
    bao_hanh            NVARCHAR(50),
    mo_ta               NVARCHAR(MAX),
    huong_dan_bao_quan  NVARCHAR(MAX),
    anh_dai_dien        VARCHAR(500),
    trang_thai          INT            -- 1: Đang bán, 0: Ngừng bán
);

-- 7. Bảng Chi tiết sản phẩm / Biến thể (Entity: ChiTietSanPham)
CREATE TABLE chi_tiet_san_pham (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    id_san_pham     INT FOREIGN KEY REFERENCES san_pham(id),
    mau_sac         NVARCHAR(100),
    kich_thuoc      VARCHAR(20),       -- S, M, L, XL, XXL
    kieu_dang       NVARCHAR(100),     -- Slim-fit, Oversize, ...
    gia_nhap        DECIMAL(18,2),
    gia_ban         DECIMAL(18,2),
    gia_khuyen_mai  DECIMAL(18,2),
    so_luong_ton    INT DEFAULT 0,
    trong_luong     DECIMAL(10,2),
    chieu_dai       DECIMAL(10,2),
    chieu_rong      DECIMAL(10,2),
    do_day          DECIMAL(10,2),
    trang_thai      INT                -- 1: Đang bán, 0: Ngừng bán
);

-- 8. Bảng Hóa đơn (Entity: HoaDon)
CREATE TABLE hoa_don (
    id                          INT IDENTITY(1,1) PRIMARY KEY,
    id_nhan_vien                INT FOREIGN KEY REFERENCES nhan_vien(id),
    id_khach_hang               INT FOREIGN KEY REFERENCES khach_hang(id),
    id_dia_chi                  INT FOREIGN KEY REFERENCES dia_chi(id),
    id_phuong_thuc_thanh_toan   INT FOREIGN KEY REFERENCES phuong_thuc_thanh_toan(id),
    id_ma_giam_gia              INT FOREIGN KEY REFERENCES phieu_giam_gia(id),

    ngay_dat_hang               DATETIME,
    ngay_xac_nhan               DATETIME,

    -- Snapshot thông tin khách tại thời điểm đặt
    ten_khach_hang              NVARCHAR(150),
    sdt_khach_hang              VARCHAR(20),
    email_khach_hang            VARCHAR(200),
    dia_chi_khach_hang          NVARCHAR(500),

    -- Thông tin tài chính
    tong_so_luong               INT,
    tam_tinh                    DECIMAL(18,2),
    tien_giam_hoa_don           DECIMAL(18,2) DEFAULT 0,
    tong_thanh_toan             DECIMAL(18,2),
    da_thanh_toan               DECIMAL(18,2) DEFAULT 0,
    lien_hoan                   DECIMAL(18,2) DEFAULT 0,

    ghi_chu                     NVARCHAR(MAX),
    trang_thai_thanh_toan       INT,  -- 0: Chưa TT, 1: Đã TT
    trang_thai_don_hang         INT,  -- 0: Chờ XN, 1: Đã XN, 2: Đang giao, 3: Thành công, 4: Huỷ
    trang_thai                  INT   -- 1: Active, 0: Inactive
);

-- 9. Bảng Chi tiết hóa đơn (Entity: ChiTietHoaDon)
CREATE TABLE chi_tiet_hoa_don (
    id                  INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don          INT FOREIGN KEY REFERENCES hoa_don(id),
    id_chi_tiet_san_pham INT FOREIGN KEY REFERENCES chi_tiet_san_pham(id),
    don_gia             DECIMAL(18,2),
    gia_giam            DECIMAL(18,2) DEFAULT 0,
    so_luong            INT,
    thanh_tien          DECIMAL(18,2),
    ghi_chu             NVARCHAR(MAX)
);

-- 10. Bảng Lịch sử hóa đơn (Entity: LichSuHoaDon)
CREATE TABLE lich_su_hoa_don (
    id                  INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don          INT NOT NULL FOREIGN KEY REFERENCES hoa_don(id),
    id_nguoi_thuc_hien  INT FOREIGN KEY REFERENCES nhan_vien(id),
    id_khach_hang       INT FOREIGN KEY REFERENCES khach_hang(id),
    trang_thai_cu       INT,
    trang_thai_moi      INT,
    ghi_chu             NVARCHAR(MAX),
    thoi_gian_cap_nhat  DATETIME,
    trang_thai          INT DEFAULT 1
);

-- 11. Bảng Lịch sử thanh toán (Entity: LichSuThanhToan)
CREATE TABLE lich_su_thanh_toan (
    id                      INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don              INT NOT NULL FOREIGN KEY REFERENCES hoa_don(id),
    ma_giao_dich_cong       VARCHAR(200),
    so_tien                 DECIMAL(18,2),
    noi_dung                NVARCHAR(MAX),
    trang_thai              INT,  -- 0: Thất bại, 1: Thành công
    thoi_gian_giao_dich     DATETIME
);

GO

-- =======================================================
-- PHẦN 2: DỮ LIỆU MẪU
-- =======================================================

-- ----- NHÂN VIÊN -----
INSERT INTO nhan_vien (ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, ccod, luong, ngay_vao_lam, vai_tro, trang_thai) VALUES
(N'Admin FamiCoats',        'admin@famicoats.vn',   '123456', '0987000001', '1990-01-15', 1, '001090000001', 15000000, '2022-01-01', N'ADMIN',     1),
(N'Nguyễn Thị Hoa',         'hoa.nv@famicoats.vn',  '123456', '0987000002', '1995-03-20', 0, '079095000002', 10000000, '2022-06-01', N'NHAN_VIEN', 1),
(N'Trần Văn Minh',           'minh.nv@famicoats.vn', '123456', '0987000003', '1993-07-10', 1, '036093000003',  9000000, '2023-01-15', N'NHAN_VIEN', 1);

-- ----- KHÁCH HÀNG -----
INSERT INTO khach_hang (ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, diem_tich_luy, hang_thanh_vien, trang_thai) VALUES
(N'Nguyễn Văn An',       'an.nguyen@gmail.com',       '123', '0912111001', '1995-05-12', 1, 1200, N'BAC',      1),
(N'Trần Thị Bình',       'binh.tran@gmail.com',       '123', '0912111002', '1998-10-20', 0,  800, N'DONG',     1),
(N'Lê Minh Châu',         'chau.le@gmail.com',         '123', '0912111003', '2000-01-01', 1,  450, N'DONG',     1),
(N'Phạm Thị Lan',         'lan.pham@gmail.com',        '123', '0912111004', '1990-12-12', 0, 3500, N'VANG',     1),
(N'Hoàng Văn Dũng',       'dung.hoang@gmail.com',      '123', '0912111005', '1985-08-08', 1,  200, N'DONG',     1),
(N'Nguyễn Thị Mai',       'mai.nguyen@gmail.com',      '123', '0912111006', '1992-04-25', 0, 5000, N'BACH_KIM', 1),
(N'Vũ Đức Long',           'long.vu@gmail.com',         '123', '0912111007', '1988-11-30', 1, 1800, N'BAC',      1),
(N'Đỗ Thị Hương',          'huong.do@gmail.com',        '123', '0912111008', '1997-06-14', 0,  600, N'DONG',     1),
(N'Bùi Văn Tùng',          'tung.bui@gmail.com',        '123', '0912111009', '1991-02-28', 1, 2200, N'VANG',     1),
(N'Lý Thị Thanh',          'thanh.ly@gmail.com',        '123', '0912111010', '1996-09-09', 0,  100, N'DONG',     1);

-- ----- PHƯƠNG THỨC THANH TOÁN -----
INSERT INTO phuong_thuc_thanh_toan (ten_phuong_thuc, mo_ta, phi_thanh_toan, trang_thai) VALUES
(N'Chuyển khoản ngân hàng', N'Chuyển khoản qua tài khoản ngân hàng, QR Code', 0,     1),
(N'Thanh toán khi nhận hàng (COD)', N'Trả tiền mặt khi nhận hàng', 15000, 1),
(N'Ví điện tử MoMo',        N'Thanh toán qua ứng dụng MoMo', 0,     1);

-- ----- PHIẾU GIẢM GIÁ -----
INSERT INTO phieu_giam_gia (ten_chuong_trinh, loai_giam, gia_tri_giam, gia_tri_don_hang_toi_thieu, giam_toi_da, so_luong, da_su_dung, ngay_bat_dau, ngay_ket_thuc, mo_ta, trang_thai) VALUES
(N'Khuyến mãi hè 2026',       'PHAN_TRAM',       10, 500000,  200000, 100, 23, '2026-06-01 00:00:00', '2026-08-31 23:59:59', N'Giảm 10% cho đơn từ 500k', 1),
(N'Flash Sale 7/7',            'SO_TIEN_CO_DINH', 50000, 300000, 50000, 50,  15, '2026-07-07 00:00:00', '2026-07-07 23:59:59', N'Giảm 50k cho đơn từ 300k', 0),
(N'Ưu đãi thành viên Vàng',    'PHAN_TRAM',       15, 1000000, 300000, 200, 8,  '2026-01-01 00:00:00', '2026-12-31 23:59:59', N'Giảm 15% cho thành viên Vàng', 1);

-- ----- SẢN PHẨM (20 sản phẩm) -----
INSERT INTO san_pham (ma_san_pham, ten_san_pham, ten_tieng_anh, danh_muc, thuong_hieu, xuat_xu, bao_hanh, mo_ta, huong_dan_bao_quan, trang_thai) VALUES
('SP001', N'Áo khoác da nam Premium',          'Leather Jacket Premium',       N'Áo khoác da',  N'FamiCoats',      N'Việt Nam',  N'12 tháng', N'Áo khoác da nam chất liệu da cừu tự nhiên cao cấp, bề mặt da mềm mịn, chắn gió và giữ ấm tốt. Thiết kế slim-fit hiện đại.', N'Chỉ giặt khô, không giặt máy. Tránh ánh nắng trực tiếp.', 1),
('SP002', N'Bomber jacket oversize unisex',     'Bomber Jacket Oversize',       N'Áo bomber',    N'Zara',           N'Nhập khẩu', N'6 tháng',  N'Áo bomber form rộng thời trang unisex. Lớp lót gió dày dặn, bo chun cổ tay và gấu áo chắc chắn, chống gió hiệu quả.', N'Giặt máy chế độ nhẹ với nước ấm. Không tẩy trắng.', 1),
('SP003', N'Áo denim wash nữ vintage',          'Denim Jacket Vintage',         N'Áo denim',     N'Levi''s',         N'Việt Nam',  N'3 tháng',  N'Áo khoác bò denim dáng lửng phong cách retro vintage cho nữ. Chất bò dày dặn, wash màu tự nhiên cá tính.', N'Giặt riêng bằng tay, lộn trái khi giặt để giữ màu.', 1),
('SP004', N'Áo phao siêu nhẹ unisex',           'Ultra Light Puffer Jacket',    N'Áo phao',      N'Uniqlo',         N'Nhật Bản',  N'6 tháng',  N'Áo phao lông vũ siêu nhẹ, cản gió cản nước. Thiết kế gấp gọn tiện lợi.', N'Giặt tay nhẹ bằng nước lạnh với dầu gội. Tránh vắt xoắn mạnh.', 1),
('SP005', N'Khoác gió windbreaker nam',          'Windbreaker Jacket',          N'Áo gió',       N'The North Face', N'Việt Nam',  N'12 tháng', N'Áo gió thể thao nam chống nước nhẹ, cản gió 100%. Lớp lót lưới thoáng khí.', N'Giặt máy nước lạnh với bột giặt nhẹ. Không ủi cao.', 1),
('SP006', N'Áo khoác da nữ biker style',         'Women Biker Leather Jacket',   N'Áo khoác da',  N'FamiCoats',      N'Việt Nam',  N'12 tháng', N'Phiên bản áo da cừu cao cấp dành riêng cho nữ, kiểu dáng biker cá tính, khóa kéo kim loại không gỉ.', N'Chỉ giặt khô chuyên nghiệp. Lau vết bẩn nhẹ bằng khăn mềm ẩm.', 1),
('SP007', N'Bomber jacket slim fit nam',          'Slim Fit Bomber',             N'Áo bomber',    N'H&M',            N'Việt Nam',  N'6 tháng',  N'Áo khoác bomber dáng ôm nam tính lịch lãm. Dễ phối với áo phông và quần jeans.', N'Giặt máy ở nhiệt độ bình thường. Lộn trái áo khi phơi.', 1),
('SP008', N'Áo khoác len nữ thu đông',            'Wool Coat Women',             N'Áo len',       N'Cardina',        N'Việt Nam',  N'3 tháng',  N'Chất liệu len dệt sợi cao cấp mềm mại, co giãn tốt, không xù lông. Giữ ấm hiệu quả trong thời tiết se lạnh.', N'Giặt tay nhẹ bằng dầu gội hoặc nước giặt chuyên dụng cho đồ len. Phơi nằm ngang.', 1),
('SP009', N'Áo khoác kaki unisex 2 lớp',         'Double Layer Khaki Jacket',   N'Áo kaki',      N'FamiCoats',      N'Việt Nam',  N'6 tháng',  N'Áo khoác kaki 2 lớp dày dặn, thiết kế unisex hiện đại, phù hợp cả nam và nữ. Màu kaki cổ điển dễ phối đồ.', N'Giặt máy chế độ thường. Phơi nơi thoáng mát tránh ánh nắng gắt.', 1),
('SP010', N'Áo phao vest không tay nữ',           'Sleeveless Vest Puffer',      N'Áo phao',      N'Nike',           N'Nhập khẩu', N'6 tháng',  N'Áo gile phao không tay giữ ấm, chất liệu nhẹ thoáng. Phong cách thể thao năng động phù hợp mùa đông.', N'Giặt máy ở nhiệt độ thấp. Sấy khô ở nhiệt độ thấp.', 1),
('SP011', N'Áo khoác dạ nữ oversize sang trọng', 'Oversized Wool Blend Coat',   N'Áo dạ',        N'ELLE',           N'Nhập khẩu', N'6 tháng',  N'Áo khoác dạ dáng dài oversize sang trọng. Chất liệu hỗn hợp len và polyester cao cấp, giữ form tốt.', N'Chỉ giặt khô hoặc giặt tay cẩn thận. Ủi ở nhiệt độ vừa.', 1),
('SP012', N'Áo hoodie khoác ngoài nam',           'Men''s Hoodie Jacket',         N'Áo hoodie',    N'Adidas',         N'Nhập khẩu', N'6 tháng',  N'Áo hoodie khoác ngoài chất liệu cotton fleece dày dặn. Có mũ trùm đầu tiện lợi, túi kangaroo rộng rãi.', N'Giặt máy lộn trái. Không dùng máy sấy.', 1),
('SP013', N'Áo khoác thể thao nữ 3 lớp',         'Women 3-in-1 Jacket',         N'Áo thể thao',  N'Columbia',       N'Nhập khẩu', N'12 tháng', N'Áo khoác 3 lớp đa năng: lớp ngoài chống nước, lớp trong fleece giữ ấm, có thể tháo rời sử dụng độc lập.', N'Giặt máy chế độ nhẹ. Tháo lớp fleece trước khi giặt.', 1),
('SP014', N'Áo khoác jean đen skinny nam',        'Men Black Skinny Denim Jacket',N'Áo denim',     N'Levis',          N'Việt Nam',  N'3 tháng',  N'Áo khoác jean đen phong cách skinny hiện đại dành cho nam. Chất denim cứng cáp, phai màu tự nhiên theo thời gian.', N'Giặt lộn trái bằng nước lạnh. Không tẩy.', 1),
('SP015', N'Áo gió thể thao nữ nhẹ',             'Women Lightweight Windbreaker',N'Áo gió',       N'Adidas',         N'Nhập khẩu', N'6 tháng',  N'Áo gió nhẹ siêu mỏng dành cho nữ, có thể gấp gọn vào túi đựng riêng. Chống nước và cản gió hiệu quả.', N'Giặt máy nhiệt độ thấp. Không sấy khô.', 1),
('SP016', N'Áo khoác dù lót nỉ unisex',          'Fleece-lined Parka',          N'Áo khoác dù',  N'FamiCoats',      N'Việt Nam',  N'6 tháng',  N'Áo khoác dù lót nỉ 2 lớp ấm áp, chống gió tốt. Thiết kế unisex phù hợp mọi lứa tuổi.', N'Giặt máy chế độ nhẹ. Phơi nơi thoáng mát.', 1),
('SP017', N'Áo blazer khoác ngoài nữ',           'Women Blazer Jacket',         N'Áo blazer',    N'MANGO',          N'Nhập khẩu', N'3 tháng',  N'Áo blazer phối khoác ngoài phong cách công sở kết hợp casual thời thượng. Chất liệu tweed cao cấp.', N'Chỉ giặt khô. Ủi mặt trái ở nhiệt độ vừa.', 1),
('SP018', N'Áo khoác thể thao track jacket nam',  'Men Track Jacket',            N'Áo thể thao',  N'Nike',           N'Nhập khẩu', N'6 tháng',  N'Áo track jacket thể thao cổ điển phong cách retro. Chất liệu polyester nhẹ thoáng, khô nhanh.', N'Giặt máy nhiệt độ thấp. Phơi nơi thoáng mát.', 1),
('SP019', N'Áo khoác lông cừu sherpa nữ',         'Women Sherpa Fleece Jacket',  N'Áo sherpa',    N'Patagonia',      N'Nhập khẩu', N'12 tháng', N'Áo khoác lông cừu sherpa mềm mại, siêu ấm, phong cách Boho chic độc đáo. Chất liệu thân thiện môi trường.', N'Giặt tay nhẹ hoặc máy chế độ đặc biệt. Không sấy.', 1),
('SP020', N'Áo khoác da lộn (suede) unisex',      'Suede Leather Jacket',        N'Áo khoác da',  N'FamiCoats',      N'Việt Nam',  N'12 tháng', N'Áo khoác da lộn (suede) thiết kế unisex thanh lịch. Bề mặt da nhung mịn đặc trưng, tạo điểm nhấn phong cách.', N'Chỉ vệ sinh bằng bàn chải chuyên dụng cho suede. Không để ướt.', 1);

-- ----- CHI TIẾT SẢN PHẨM (Biến thể) -----
-- SP001 - Áo khoác da nam Premium
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(1, N'Đen',  'M',  N'Slim-fit', 800000, 1850000, 1650000, 25, 0.80, 95.0, 48.0, 2.5, 1),
(1, N'Nâu',  'L',  N'Slim-fit', 800000, 1850000, 0,       18, 0.85, 98.0, 50.0, 2.5, 1),
(1, N'Đen',  'XL', N'Slim-fit', 800000, 1850000, 1700000, 12, 0.90, 100.0,52.0, 2.5, 1);

-- SP002 - Bomber jacket oversize
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(2, N'Navy',  'L',  N'Oversize', 500000, 1290000, 1090000, 20, 1.10, 75.0, 60.0, 5.0, 1),
(2, N'Đen',   'XL', N'Oversize', 500000, 1290000, 1190000, 15, 1.20, 78.0, 62.0, 5.0, 1),
(2, N'Olive', 'M',  N'Oversize', 500000, 1290000, 0,       10, 1.05, 72.0, 58.0, 5.0, 1);

-- SP003 - Áo denim wash nữ
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(3, N'Xanh nhạt', 'S', N'Vintage', 350000, 890000, 790000, 12, 0.90, 60.0, 44.0, 1.8, 1),
(3, N'Xanh đậm',  'M', N'Vintage', 350000, 890000, 0,      8,  0.92, 62.0, 46.0, 1.8, 1),
(3, N'Đen wash',  'L', N'Vintage', 350000, 890000, 750000, 5,  0.95, 64.0, 48.0, 1.8, 1);

-- SP004 - Áo phao siêu nhẹ
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(4, N'Đen',  'S',  N'Regular', 900000, 2100000, 0,       30, 0.30, 65.0, 45.0, 0.8, 1),
(4, N'Navy', 'M',  N'Regular', 900000, 2100000, 1850000, 25, 0.32, 68.0, 47.0, 0.8, 1),
(4, N'Xanh', 'L',  N'Regular', 900000, 2100000, 1900000, 20, 0.35, 70.0, 49.0, 0.8, 1);

-- SP005 - Khoác gió windbreaker
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(5, N'Đen',   'M', N'Casual', 450000, 1150000, 990000, 8,  0.60, 72.0, 50.0, 1.2, 1),
(5, N'Cam',   'L', N'Casual', 450000, 1150000, 0,      6,  0.62, 74.0, 52.0, 1.2, 1),
(5, N'Xanh lá', 'XL', N'Casual', 450000, 1150000, 950000, 4, 0.65, 76.0, 54.0, 1.2, 1);

-- SP006 - Áo khoác da nữ biker
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(6, N'Đen',     'S', N'Biker', 750000, 1750000, 1550000, 10, 0.75, 58.0, 42.0, 2.5, 1),
(6, N'Nâu đỏ', 'M', N'Biker', 750000, 1750000, 0,       8,  0.78, 60.0, 44.0, 2.5, 1);

-- SP007 - Bomber slim fit nam
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(7, N'Đen',  'M', N'Slim-fit', 480000, 1190000, 0,       22, 1.0, 70.0, 48.0, 4.0, 1),
(7, N'Xanh rêu', 'L', N'Slim-fit', 480000, 1190000, 1050000, 18, 1.05, 73.0, 50.0, 4.0, 1),
(7, N'Đỏ đô', 'XL', N'Slim-fit', 480000, 1190000, 0,    12, 1.10, 75.0, 52.0, 4.0, 1);

-- SP008 - Áo khoác len nữ
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(8, N'Kem',    'S', N'Regular', 400000, 990000, 890000, 15, 0.70, 85.0, 44.0, 3.0, 1),
(8, N'Xám',    'M', N'Regular', 400000, 990000, 850000, 12, 0.72, 87.0, 46.0, 3.0, 1),
(8, N'Hồng',   'L', N'Regular', 400000, 990000, 0,      8,  0.75, 89.0, 48.0, 3.0, 1);

-- SP009 - Áo khoác kaki
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(9, N'Kaki', 'M', N'Regular', 380000, 950000, 0,       20, 0.85, 75.0, 50.0, 2.0, 1),
(9, N'Kaki', 'L', N'Regular', 380000, 950000, 850000, 15, 0.88, 77.0, 52.0, 2.0, 1),
(9, N'Xanh', 'XL', N'Regular', 380000, 950000, 880000, 10, 0.90, 79.0, 54.0, 2.0, 1);

-- SP010 - Áo phao vest không tay
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(10, N'Đen',  'S', N'Vest', 350000, 850000, 750000, 18, 0.25, 58.0, 42.0, 2.0, 1),
(10, N'Xanh', 'M', N'Vest', 350000, 850000, 0,       14, 0.27, 60.0, 44.0, 2.0, 1),
(10, N'Đỏ',  'L', N'Vest', 350000, 850000, 780000, 10, 0.29, 62.0, 46.0, 2.0, 1);

-- SP011 - Áo khoác dạ nữ
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(11, N'Camel', 'S', N'Oversize', 900000, 2200000, 1990000, 8,  1.20, 100.0, 44.0, 4.0, 1),
(11, N'Đen',   'M', N'Oversize', 900000, 2200000, 2000000, 6,  1.25, 103.0, 46.0, 4.0, 1),
(11, N'Trắng kem', 'L', N'Oversize', 900000, 2200000, 0, 4, 1.30, 105.0, 48.0, 4.0, 1);

-- SP012 - Áo hoodie khoác ngoài
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(12, N'Xám',   'M',  N'Regular', 300000, 750000, 0,      25, 0.65, 68.0, 50.0, 3.5, 1),
(12, N'Đen',   'L',  N'Regular', 300000, 750000, 690000, 20, 0.67, 70.0, 52.0, 3.5, 1),
(12, N'Trắng', 'XL', N'Regular', 300000, 750000, 0,      15, 0.70, 72.0, 54.0, 3.5, 1);

-- SP013 - Áo khoác thể thao 3 lớp
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(13, N'Xanh dương', 'M', N'3-in-1', 1000000, 2500000, 2200000, 10, 1.10, 72.0, 50.0, 5.0, 1),
(13, N'Đen',        'L', N'3-in-1', 1000000, 2500000, 2300000, 8,  1.15, 74.0, 52.0, 5.0, 1);

-- SP014 - Áo khoác jean đen
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(14, N'Đen', 'M',  N'Skinny', 320000, 790000, 0,      18, 0.88, 65.0, 47.0, 1.8, 1),
(14, N'Đen', 'L',  N'Skinny', 320000, 790000, 720000, 14, 0.90, 67.0, 49.0, 1.8, 1),
(14, N'Đen', 'XL', N'Skinny', 320000, 790000, 0,      10, 0.92, 69.0, 51.0, 1.8, 1);

-- SP015 - Áo gió nữ nhẹ
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(15, N'Hồng',  'S', N'Slim', 280000, 690000, 590000, 15, 0.20, 62.0, 43.0, 0.5, 1),
(15, N'Tím',   'M', N'Slim', 280000, 690000, 0,       12, 0.21, 64.0, 45.0, 0.5, 1),
(15, N'Xanh mint', 'L', N'Slim', 280000, 690000, 620000, 8, 0.22, 66.0, 47.0, 0.5, 1);

-- SP016 - Áo khoác dù lót nỉ
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(16, N'Đen', 'M',  N'Casual', 420000, 990000, 890000, 22, 0.90, 70.0, 50.0, 4.0, 1),
(16, N'Xanh','L',  N'Casual', 420000, 990000, 0,       18, 0.92, 72.0, 52.0, 4.0, 1),
(16, N'Xám', 'XL', N'Casual', 420000, 990000, 920000, 12, 0.95, 74.0, 54.0, 4.0, 1);

-- SP017 - Áo blazer khoác ngoài
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(17, N'Trắng ngà', 'S', N'Fitted',  700000, 1590000, 1390000, 8,  0.70, 75.0, 42.0, 2.0, 1),
(17, N'Đen',       'M', N'Fitted',  700000, 1590000, 1450000, 6,  0.72, 77.0, 44.0, 2.0, 1),
(17, N'Xanh navy', 'L', N'Fitted',  700000, 1590000, 0,       5,  0.74, 79.0, 46.0, 2.0, 1);

-- SP018 - Track jacket thể thao
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(18, N'Đen trắng', 'M',  N'Retro', 380000, 950000, 0,      20, 0.45, 68.0, 50.0, 1.5, 1),
(18, N'Đỏ trắng',  'L',  N'Retro', 380000, 950000, 850000, 15, 0.47, 70.0, 52.0, 1.5, 1),
(18, N'Xanh',       'XL', N'Retro', 380000, 950000, 0,      10, 0.49, 72.0, 54.0, 1.5, 1);

-- SP019 - Áo khoác lông cừu sherpa
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(19, N'Trắng kem', 'S', N'Regular', 1100000, 2800000, 2500000, 8,  1.30, 66.0, 44.0, 5.0, 1),
(19, N'Nâu đất',   'M', N'Regular', 1100000, 2800000, 2600000, 6,  1.32, 68.0, 46.0, 5.0, 1),
(19, N'Xám trắng', 'L', N'Regular', 1100000, 2800000, 0,       4,  1.35, 70.0, 48.0, 5.0, 1);

-- SP020 - Áo khoác da lộn suede
INSERT INTO chi_tiet_san_pham (id_san_pham, mau_sac, kich_thuoc, kieu_dang, gia_nhap, gia_ban, gia_khuyen_mai, so_luong_ton, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
(20, N'Nâu cát',   'M', N'Slim-fit', 850000, 2000000, 1790000, 10, 0.85, 72.0, 50.0, 2.5, 1),
(20, N'Nâu đậm',   'L', N'Slim-fit', 850000, 2000000, 0,        8,  0.88, 74.0, 52.0, 2.5, 1),
(20, N'Đen suede', 'M', N'Slim-fit', 850000, 2000000, 1850000,  6,  0.86, 72.0, 50.0, 2.5, 1);

-- ----- 15 HÓA ĐƠN -----
-- HD1: Nguyễn Văn An - Hoàn thành - Chuyển khoản
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 1, 1, '2026-06-10 08:30:00', '2026-06-10 09:00:00', N'Nguyễn Văn An', '0912111001', 'an.nguyen@gmail.com', N'123 Nguyễn Huệ, Q.1, TP.HCM', 1, 1850000, 185000, 1695000, 1695000, 1, 3, 1, N'Giao giờ hành chính');

-- HD2: Trần Thị Bình - Đang giao - COD
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(2, 2, 2, '2026-06-15 10:15:00', '2026-06-15 11:00:00', N'Trần Thị Bình', '0912111002', 'binh.tran@gmail.com', N'45 Lê Lợi, Q.1, TP.HCM', 2, 2580000, 0, 2595000, 0, 0, 2, 1, N'');

-- HD3: Lê Minh Châu - Chờ xác nhận - MoMo
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 3, 3, '2026-06-20 14:20:00', N'Lê Minh Châu', '0912111003', 'chau.le@gmail.com', N'78 Nguyễn Trãi, Q.5, TP.HCM', 1, 890000, 0, 890000, 890000, 1, 0, 1, N'Giao giờ hành chính');

-- HD4: Phạm Thị Lan - Đã xác nhận - Chuyển khoản
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 4, 1, '2026-06-22 09:00:00', '2026-06-22 09:30:00', N'Phạm Thị Lan', '0912111004', 'lan.pham@gmail.com', N'12 Võ Văn Tần, Q.3, TP.HCM', 1, 2100000, 300000, 1800000, 1800000, 1, 1, 1, N'Đóng gói cẩn thận làm quà tặng');

-- HD5: Hoàng Văn Dũng - Đã hủy - COD
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 5, 2, '2026-06-25 16:45:00', '2026-06-25 17:00:00', N'Hoàng Văn Dũng', '0912111005', 'dung.hoang@gmail.com', N'99 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM', 3, 3450000, 0, 3465000, 0, 0, 4, 1, N'Khách đổi ý không mua nữa');

-- HD6: Nguyễn Thị Mai - Hoàn thành - MoMo
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(2, 6, 3, '2026-06-28 11:00:00', '2026-06-28 11:30:00', N'Nguyễn Thị Mai', '0912111006', 'mai.nguyen@gmail.com', N'55 Lý Thường Kiệt, Q.Tân Bình, TP.HCM', 2, 4200000, 630000, 3570000, 3570000, 1, 3, 1, N'');

-- HD7: Vũ Đức Long - Đang giao - Chuyển khoản
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 7, 1, '2026-07-01 09:30:00', '2026-07-01 10:00:00', N'Vũ Đức Long', '0912111007', 'long.vu@gmail.com', N'20 Trần Hưng Đạo, Q.5, TP.HCM', 1, 1190000, 0, 1190000, 1190000, 1, 2, 1, N'');

-- HD8: Đỗ Thị Hương - Chờ xác nhận - COD
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(2, 8, 2, '2026-07-02 14:00:00', N'Đỗ Thị Hương', '0912111008', 'huong.do@gmail.com', N'77 Bạch Đằng, Q.Bình Thạnh, TP.HCM', 1, 990000, 0, 1005000, 0, 0, 0, 1, N'Giao buổi tối sau 18h');

-- HD9: Bùi Văn Tùng - Hoàn thành - Chuyển khoản
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 9, 1, '2026-07-03 08:00:00', '2026-07-03 08:30:00', N'Bùi Văn Tùng', '0912111009', 'tung.bui@gmail.com', N'33 Nguyễn Văn Cừ, Q.5, TP.HCM', 3, 5700000, 855000, 4845000, 4845000, 1, 3, 1, N'');

-- HD10: Lý Thị Thanh - Đã xác nhận - MoMo
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(2, 10, 3, '2026-07-04 15:00:00', '2026-07-04 15:30:00', N'Lý Thị Thanh', '0912111010', 'thanh.ly@gmail.com', N'8 Hàm Nghi, Q.1, TP.HCM', 1, 2000000, 0, 2000000, 2000000, 1, 1, 1, N'');

-- HD11: Nguyễn Văn An - Hoàn thành lần 2 - Chuyển khoản
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 1, 1, '2026-07-05 10:00:00', '2026-07-05 10:30:00', N'Nguyễn Văn An', '0912111001', 'an.nguyen@gmail.com', N'123 Nguyễn Huệ, Q.1, TP.HCM', 1, 2800000, 0, 2800000, 2800000, 1, 3, 1, N'');

-- HD12: Phạm Thị Lan - Đang giao - Chuyển khoản
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(2, 4, 1, '2026-07-06 09:00:00', '2026-07-06 09:30:00', N'Phạm Thị Lan', '0912111004', 'lan.pham@gmail.com', N'12 Võ Văn Tần, Q.3, TP.HCM', 2, 3140000, 471000, 2684000, 2684000, 1, 2, 1, N'Tặng kèm thiệp sinh nhật');

-- HD13: Nguyễn Thị Mai - Chờ xác nhận - COD
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 6, 2, '2026-07-07 12:00:00', N'Nguyễn Thị Mai', '0912111006', 'mai.nguyen@gmail.com', N'55 Lý Thường Kiệt, Q.Tân Bình, TP.HCM', 1, 2500000, 250000, 2265000, 0, 0, 0, 1, N'');

-- HD14: Bùi Văn Tùng - Đã xác nhận - MoMo
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(2, 9, 3, '2026-07-08 14:30:00', '2026-07-08 15:00:00', N'Bùi Văn Tùng', '0912111009', 'tung.bui@gmail.com', N'33 Nguyễn Văn Cừ, Q.5, TP.HCM', 1, 1590000, 0, 1590000, 1590000, 1, 1, 1, N'');

-- HD15: Vũ Đức Long - Hoàn thành - Chuyển khoản
INSERT INTO hoa_don (id_nhan_vien, id_khach_hang, id_phuong_thuc_thanh_toan, ngay_dat_hang, ngay_xac_nhan, ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang, tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, trang_thai_thanh_toan, trang_thai_don_hang, trang_thai, ghi_chu) VALUES
(1, 7, 1, '2026-07-09 09:00:00', '2026-07-09 09:30:00', N'Vũ Đức Long', '0912111007', 'long.vu@gmail.com', N'20 Trần Hưng Đạo, Q.5, TP.HCM', 2, 3990000, 0, 3990000, 3990000, 1, 3, 1, N'');

-- ----- CHI TIẾT HÓA ĐƠN -----
-- HD1: 1 cái áo khoác da nam Premium (ctsp id=1)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(1, 1, 1850000, 185000, 1, 1665000);

-- HD2: 2 biến thể bomber (ctsp id=4, 5)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(2, 4, 1290000, 0, 1, 1290000),
(2, 5, 1290000, 0, 1, 1290000);

-- HD3: 1 áo denim (ctsp id=7)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(3, 7, 890000, 0, 1, 890000);

-- HD4: 1 áo phao siêu nhẹ (ctsp id=10)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(4, 10, 2100000, 300000, 1, 1800000);

-- HD5: 3 cái gió windbreaker (ctsp id=13, 14, 15)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(5, 13, 1150000, 0, 1, 1150000),
(5, 14, 1150000, 0, 1, 1150000),
(5, 15, 1150000, 0, 1, 1150000);

-- HD6: 2 cái áo phao siêu nhẹ và da nữ (ctsp id=10, 16)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(6, 11, 2100000, 315000, 1, 1785000),
(6, 16, 2100000, 315000, 1, 1785000);

-- HD7: 1 bomber slim fit (ctsp id=19)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(7, 19, 1190000, 0, 1, 1190000);

-- HD8: 1 áo khoác len nữ (ctsp id=23)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(8, 23, 990000, 0, 1, 990000);

-- HD9: 3 áo (ctsp id=25, 27, 28)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(9, 25, 950000, 285000, 1, 665000),
(9, 27, 2100000, 285000, 1, 1815000),
(9, 28, 2100000, 285000, 1, 1815000);

-- HD10: 1 áo khoác da lộn suede (ctsp id=57)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(10, 57, 2000000, 0, 1, 2000000);

-- HD11: 1 áo khoác sherpa nữ (ctsp id=52)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(11, 52, 2800000, 0, 1, 2800000);

-- HD12: 2 sản phẩm khoác dạ nữ (ctsp id=31, 32)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(12, 31, 2200000, 330000, 1, 1870000),
(12, 32, 2200000, 330000, 1, 1870000);

-- HD13: 1 áo khoác da lộn (ctsp id=58)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(13, 58, 2000000, 200000, 1, 1800000);

-- HD14: 1 blazer (ctsp id=44)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(14, 44, 1590000, 0, 1, 1590000);

-- HD15: 2 track jacket (ctsp id=47, 48)
INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
(15, 47, 950000, 0, 1, 950000),
(15, 48, 950000, 0, 1, 950000);

-- ----- LỊCH SỬ HÓA ĐƠN -----
-- HD1 (Hoàn thành)
INSERT INTO lich_su_hoa_don (id_hoa_don, id_nguoi_thuc_hien, trang_thai_cu, trang_thai_moi, thoi_gian_cap_nhat, ghi_chu, trang_thai) VALUES
(1, 1, NULL, 0, '2026-06-10 08:30:00', N'Đơn hàng được đặt thành công', 1),
(1, 1, 0,    1, '2026-06-10 09:00:00', N'Xác nhận đơn hàng', 1),
(1, 1, 1,    2, '2026-06-11 08:00:00', N'Giao cho đơn vị vận chuyển', 1),
(1, 1, 2,    3, '2026-06-12 14:30:00', N'Giao hàng thành công', 1);

-- HD2 (Đang giao)
INSERT INTO lich_su_hoa_don (id_hoa_don, id_nguoi_thuc_hien, trang_thai_cu, trang_thai_moi, thoi_gian_cap_nhat, ghi_chu, trang_thai) VALUES
(2, 2, NULL, 0, '2026-06-15 10:15:00', N'Đơn hàng được đặt', 1),
(2, 2, 0,    1, '2026-06-15 11:00:00', N'Đã xác nhận', 1),
(2, 2, 1,    2, '2026-06-16 09:00:00', N'Đang giao hàng', 1);

-- HD3 (Chờ xác nhận)
INSERT INTO lich_su_hoa_don (id_hoa_don, id_nguoi_thuc_hien, trang_thai_cu, trang_thai_moi, thoi_gian_cap_nhat, ghi_chu, trang_thai) VALUES
(3, 1, NULL, 0, '2026-06-20 14:20:00', N'Đơn hàng mới', 1);

-- HD4 (Đã xác nhận)
INSERT INTO lich_su_hoa_don (id_hoa_don, id_nguoi_thuc_hien, trang_thai_cu, trang_thai_moi, thoi_gian_cap_nhat, ghi_chu, trang_thai) VALUES
(4, 1, NULL, 0, '2026-06-22 09:00:00', N'Đặt hàng', 1),
(4, 1, 0,    1, '2026-06-22 09:30:00', N'Đã xác nhận đơn hàng', 1);

-- HD5 (Đã hủy)
INSERT INTO lich_su_hoa_don (id_hoa_don, id_nguoi_thuc_hien, trang_thai_cu, trang_thai_moi, thoi_gian_cap_nhat, ghi_chu, trang_thai) VALUES
(5, 1, NULL, 0, '2026-06-25 16:45:00', N'Đặt hàng', 1),
(5, 1, 0,    1, '2026-06-25 17:00:00', N'Xác nhận', 1),
(5, 1, 1,    4, '2026-06-25 18:00:00', N'Hủy đơn: Khách đổi ý', 1);

-- HD6 (Hoàn thành)
INSERT INTO lich_su_hoa_don (id_hoa_don, id_nguoi_thuc_hien, trang_thai_cu, trang_thai_moi, thoi_gian_cap_nhat, ghi_chu, trang_thai) VALUES
(6, 2, NULL, 0, '2026-06-28 11:00:00', N'Đặt hàng', 1),
(6, 2, 0,    1, '2026-06-28 11:30:00', N'Xác nhận', 1),
(6, 2, 1,    2, '2026-06-29 08:00:00', N'Đang giao', 1),
(6, 2, 2,    3, '2026-06-30 15:00:00', N'Giao thành công', 1);

GO
