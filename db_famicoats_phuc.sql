-- =============================================================================
-- 1. PHUONG THUC THANH TOAN
-- =============================================================================
CREATE TABLE phuong_thuc_thanh_toan (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    ten_phuong_thuc NVARCHAR(100) NOT NULL,
    mo_ta           NVARCHAR(MAX),
    logo            NVARCHAR(500),
    phi_thanh_toan  FLOAT         DEFAULT 0,
    trang_thai      INT           DEFAULT 1
);

INSERT INTO phuong_thuc_thanh_toan (ten_phuong_thuc, mo_ta, logo, phi_thanh_toan, trang_thai) VALUES
(N'Tiền mặt',      N'Thanh toan truc tiep bang tien mat', NULL, 0, 1),
(N'VNPay',         N'Thanh toan qua vi VNPay & QR Code',  'vnpay.png',   0, 1),
(N'MoMo',          N'Thanh toan qua vi dien tu MoMo',     'momo.png',    0, 1),
(N'ZaloPay',       N'Thanh toan qua vi ZaloPay',          'zalopay.png', 0, 1);

-- =============================================================================
-- 2. DIA CHI  (15 ban ghi)
-- =============================================================================
CREATE TABLE dia_chi (
    id               INT IDENTITY(1,1) PRIMARY KEY,
    nguoi_nhan       NVARCHAR(150),
    so_dien_thoai    NVARCHAR(20),
    tinh             NVARCHAR(150),
    huyen            NVARCHAR(100),
    xa               NVARCHAR(150),
    dia_chi_chi_tiet NVARCHAR(500),
    mac_dinh         BIT          DEFAULT 0,
    ghi_chu          NVARCHAR(MAX)
);

INSERT INTO dia_chi (nguoi_nhan, so_dien_thoai, tinh, huyen, xa, dia_chi_chi_tiet, mac_dinh) VALUES
(N'Nguyen Van An',     '0901234567', N'Ha Noi',        NULL, N'Phuong Hang Gai',   N'25 Hang Gai', 1),
(N'Tran Thi Bich',     '0912345678', N'Ho Chi Minh',   NULL, N'Phuong Ben Nghe',   N'88 Le Loi', 1),
(N'Le Van Cuong',      '0923456789', N'Da Nang',       NULL, N'Phuong Hai Chau 1', N'12 Tran Phu', 1),
(N'Pham Thi Dung',     '0934567890', N'Hai Phong',     NULL, N'Phuong May To',     N'45 Dinh Tien Hoang', 0),
(N'Hoang Van Em',      '0945678901', N'Can Tho',       NULL, N'Phuong Tan An',     N'78 Nguyen Trai', 1),
(N'Ngo Thi Phuong',    '0956789012', N'Binh Duong',    NULL, N'Phuong Phu Loi',    N'99 Dai lo Binh Duong', 0),
(N'Dang Van Giang',    '0967890123', N'Dong Nai',      NULL, N'Phuong Trung Dung', N'3 Pham Van Thuan', 1),
(N'Bui Thi Ha',        '0978901234', N'Hue',           NULL, N'Phuong Phu Hoi',    N'22 Le Loi', 0),
(N'Dinh Van Inh',      '0989012345', N'Nha Trang',     NULL, N'Phuong Loc Tho',    N'56 Yersin', 1),
(N'Vu Thi Kim',        '0990123456', N'Quang Nam',     NULL, N'Phuong Minh An',    N'7 Tran Hung Dao', 0),
(N'Phan Van Long',     '0901234568', N'Bac Ninh',      NULL, N'Phuong Vu Ninh',    N'14 Ly Thai To', 1),
(N'Trinh Thi Mai',     '0912345679', N'Nam Dinh',      NULL, N'Phuong Ngo Quyen',  N'38 Tran Dang Ninh', 0),
(N'Cao Van Nghia',     '0923456780', N'Thanh Hoa',     NULL, N'Phuong Dien Bien',  N'67 Le Hoan', 1),
(N'Ly Thi Oanh',       '0934567891', N'Nghe An',       NULL, N'Phuong Le Mao',     N'5 Nguyen Gia Thieu', 0),
(N'Truong Van Phuc',   '0945678902', N'Ha Tinh',       NULL, N'Phuong Nam Ha',     N'92 Tran Phu', 1);

-- =============================================================================
-- 3. SAN PHAM  (15 ban ghi)
-- =============================================================================
CREATE TABLE san_pham (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    code            VARCHAR(50),
    category        NVARCHAR(100),
    name            NVARCHAR(255),
    englishName     NVARCHAR(255),
    price           FLOAT         DEFAULT 0,
    oldPrice        FLOAT         DEFAULT 0,
    discountPercent INT           DEFAULT 0,
    stock           INT           DEFAULT 0,
    sold            INT           DEFAULT 0,
    rating          FLOAT         DEFAULT 0,
    brand           NVARCHAR(100),
    description     NVARCHAR(MAX),
    origin          NVARCHAR(100),
    warranty        NVARCHAR(100),
    careInstructions NVARCHAR(MAX),
    status          NVARCHAR(50)  DEFAULT 'AVAILABLE',
    bgColor         NVARCHAR(20),
    hinh_anh        NVARCHAR(500)
);

INSERT INTO san_pham (code, category, name, englishName, price, oldPrice, discountPercent, stock, sold, rating, brand, description, origin, warranty, status, bgColor, hinh_anh) VALUES
('SP001', N'Ao khoac', N'Ao khoac da nam cao cap',        'Men Premium Leather Jacket',   1850000, 2200000, 16, 50,  120, 4.8, N'FamiCoats', N'Chat lieu da that cao cap, lot long am',            N'Viet Nam', N'6 thang', 'AVAILABLE',  '#1a1a2e', 'sp001.jpg'),
('SP002', N'Ao khoac', N'Ao khoac denim nu thoi trang',   'Women Fashion Denim Jacket',   750000,  900000,  17, 80,  95,  4.6, N'FamiCoats', N'Denim nhap khau, form rong thoai mai',             N'Viet Nam', N'3 thang', 'AVAILABLE',  '#16213e', 'sp002.jpg'),
('SP003', N'Ao khoac', N'Ao khoac bomber unisex',         'Unisex Bomber Jacket',         1200000, 1400000, 14, 35,  78,  4.7, N'FamiCoats', N'Kieu dang bomber nang dong, chong gio',            N'Viet Nam', N'6 thang', 'AVAILABLE',  '#0f3460', 'sp003.jpg'),
('SP004', N'Ao khoac', N'Ao khoac len nu cong so',        'Women Office Wool Coat',       2100000, 2500000, 16, 25,  45,  4.9, N'FamiCoats', N'Len cao cap, thiet ke thanh lich',                 N'Viet Nam', N'6 thang', 'LOW_STOCK',  '#533483', 'sp004.jpg'),
('SP005', N'Ao khoac', N'Ao khoac gio nam the thao',      'Men Sport Windbreaker',        650000,  750000,  13, 100, 210, 4.5, N'FamiCoats', N'Chong gio, chong mua nhe, trong luong nhe',        N'Viet Nam', N'3 thang', 'AVAILABLE',  '#e94560', 'sp005.jpg'),
('SP006', N'Ao khoac', N'Ao khoac long vu nu giu nhiet',  'Women Down Jacket',            1650000, 2000000, 17, 40,  88,  4.8, N'FamiCoats', N'Long vu thien nhien, giu am toi uu',               N'Viet Nam', N'6 thang', 'AVAILABLE',  '#1a1a2e', 'sp006.jpg'),
('SP007', N'Ao khoac', N'Ao khoac trench coat nu',        'Women Trench Coat',            1900000, 2300000, 17, 20,  55,  4.7, N'FamiCoats', N'Trench coat co dien, thich hop cong so',           N'Viet Nam', N'6 thang', 'LOW_STOCK',  '#16213e', 'sp007.jpg'),
('SP008', N'Ao khoac', N'Ao khoac hoodie nam thuong ngay','Men Daily Hoodie Jacket',      550000,  650000,  15, 150, 320, 4.4, N'FamiCoats', N'Ni bong day dan, non lien kieu dang tre trung',   N'Viet Nam', N'3 thang', 'AVAILABLE',  '#0f3460', 'sp008.jpg'),
('SP009', N'Ao khoac', N'Ao khoac parka nam dong',        'Men Winter Parka Jacket',      2800000, 3200000, 12, 15,  32,  4.9, N'FamiCoats', N'Parka cao cap, chiu lanh cuc tot',                 N'Viet Nam', N'12 thang','LOW_STOCK',  '#533483', 'sp009.jpg'),
('SP010', N'Ao khoac', N'Ao khoac varsity unisex phoi mau','Unisex Varsity Jacket',       980000,  1200000, 18, 60,  140, 4.6, N'FamiCoats', N'Varsity jacket phong cach retro',                  N'Viet Nam', N'3 thang', 'AVAILABLE',  '#e94560', 'sp010.jpg'),
('SP011', N'Ao khoac', N'Ao khoac blazer nu thanh lich',  'Women Elegant Blazer',         1450000, 1750000, 17, 30,  68,  4.7, N'FamiCoats', N'Blazer form slim, phu hop cong so va dao pho',    N'Viet Nam', N'3 thang', 'AVAILABLE',  '#1a1a2e', 'sp011.jpg'),
('SP012', N'Ao khoac', N'Ao khoac jean nam wash cu',      'Men Washed Denim Jacket',      820000,  1000000, 18, 70,  180, 4.5, N'FamiCoats', N'Denim wash cu phong cach vintage',                 N'Viet Nam', N'3 thang', 'AVAILABLE',  '#16213e', 'sp012.jpg'),
('SP013', N'Ao khoac', N'Ao khoac long cuu nu mua dong',  'Women Sherpa Fleece Jacket',   1350000, 1600000, 16, 45,  95,  4.8, N'FamiCoats', N'Long cuu gia mem min, cuc am mua dong',            N'Viet Nam', N'6 thang', 'AVAILABLE',  '#0f3460', 'sp013.jpg'),
('SP014', N'Ao khoac', N'Ao khoac military nam',          'Men Military Jacket',          1100000, 1350000, 19, 55,  75,  4.6, N'FamiCoats', N'Phong cach military ca tinh, nhieu tui tien dung', N'Viet Nam', N'3 thang', 'AVAILABLE',  '#533483', 'sp014.jpg'),
('SP015', N'Ao khoac', N'Ao khoac cape nu sang trong',    'Women Luxury Cape Coat',       2500000, 3000000, 17, 10,  18,  5.0, N'FamiCoats', N'Cape coat da cao cap, dang doc dao',               N'Viet Nam', N'12 thang','LOW_STOCK',  '#e94560', 'sp015.jpg');

-- =============================================================================
-- 4. CHI TIET SAN PHAM  (15 ban ghi)
-- =============================================================================
CREATE TABLE chi_tiet_san_pham (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    product_id   VARCHAR(50),
    size         NVARCHAR(50),
    color        NVARCHAR(100),
    style        NVARCHAR(100),
    import_price FLOAT        DEFAULT 0,
    price        FLOAT        DEFAULT 0,
    promo_price  FLOAT        DEFAULT 0,
    stock        INT          DEFAULT 0,
    weight       FLOAT        DEFAULT 0,
    length       FLOAT        DEFAULT 0,
    width        FLOAT        DEFAULT 0,
    thickness    FLOAT        DEFAULT 0,
    status       NVARCHAR(50) DEFAULT 'AVAILABLE'
);

INSERT INTO chi_tiet_san_pham (product_id, size, color, style, import_price, price, promo_price, stock, weight, length, width, thickness, status) VALUES
('SP001', 'M',  N'Den',       N'Regular',  900000,  1850000, 1700000, 15, 0.90, 70, 55, 0.30, 'AVAILABLE'),
('SP001', 'L',  N'Den',       N'Regular',  900000,  1850000, 1700000, 12, 0.95, 72, 57, 0.30, 'AVAILABLE'),
('SP001', 'XL', N'Nau',       N'Regular',  920000,  1950000, 1800000,  8, 1.00, 74, 59, 0.30, 'AVAILABLE'),
('SP002', 'S',  N'Xanh nhat', N'Oversize', 350000,  750000,  680000,  20, 0.50, 65, 50, 0.20, 'AVAILABLE'),
('SP002', 'M',  N'Xanh nhat', N'Oversize', 350000,  750000,  680000,  25, 0.52, 67, 52, 0.20, 'AVAILABLE'),
('SP003', 'M',  N'Den',       N'Slim',     580000,  1200000, 1100000, 10, 0.65, 68, 54, 0.25, 'AVAILABLE'),
('SP003', 'L',  N'Olive',     N'Slim',     580000,  1200000, 1100000, 10, 0.68, 70, 56, 0.25, 'AVAILABLE'),
('SP004', 'S',  N'Kem',       N'Fitted',   1000000, 2100000, 1950000,  8, 0.85, 66, 52, 0.35, 'LOW_STOCK'),
('SP004', 'M',  N'Xam',       N'Fitted',   1000000, 2100000, 1950000,  6, 0.88, 68, 54, 0.35, 'LOW_STOCK'),
('SP005', 'M',  N'Den',       N'Regular',  300000,  650000,  600000,  30, 0.35, 68, 52, 0.15, 'AVAILABLE'),
('SP005', 'L',  N'Xanh navy', N'Regular',  300000,  650000,  600000,  35, 0.37, 70, 54, 0.15, 'AVAILABLE'),
('SP006', 'M',  N'Trang',     N'Regular',  800000,  1650000, 1500000, 12, 0.80, 68, 54, 0.40, 'AVAILABLE'),
('SP006', 'L',  N'Hong nhat', N'Regular',  800000,  1650000, 1500000, 15, 0.82, 70, 56, 0.40, 'AVAILABLE'),
('SP007', 'S',  N'Be',        N'Classic',  900000,  1900000, 1750000,  7, 0.90, 64, 50, 0.35, 'LOW_STOCK'),
('SP008', 'XL', N'Xam dam',   N'Oversized',250000,  550000,  490000,  50, 0.55, 72, 58, 0.30, 'AVAILABLE');

-- =============================================================================
-- 5. PHIEU GIAM GIA  (5 ban ghi)
-- =============================================================================
CREATE TABLE phieu_giam_gia (
    id                         INT IDENTITY(1,1) PRIMARY KEY,
    ma_phieu                   NVARCHAR(50)  NOT NULL UNIQUE,
    ten_chuong_trinh           NVARCHAR(255) NOT NULL,
    loai_giam                  INT           NOT NULL,  -- 0: %, 1: VND
    gia_tri_giam               FLOAT         NOT NULL,
    gia_tri_don_hang_toi_thieu FLOAT,
    giam_toi_da                FLOAT,
    so_luong                   INT,
    da_su_dung                 INT           DEFAULT 0,
    ngay_bat_dau               DATE,
    ngay_ket_thuc              DATE,
    mo_ta                      NVARCHAR(MAX),
    trang_thai                 INT           DEFAULT 1, -- 0: Chua kich hoat, 1: Dang ap dung, 2: Ket thuc, 3: Da huy
    ngay_tao                   DATETIME      DEFAULT GETDATE()
);

INSERT INTO phieu_giam_gia (ma_phieu, ten_chuong_trinh, loai_giam, gia_tri_giam, gia_tri_don_hang_toi_thieu, giam_toi_da, so_luong, da_su_dung, ngay_bat_dau, ngay_ket_thuc, mo_ta, trang_thai) VALUES
('SALE15',    N'Giam 15% toan bo don hang',          0,  15,      2000000, 200000, 100, 32,  '2026-06-01', '2026-12-31', N'Ap dung cho tat ca don tu 2 trieu',          1),
('NEW2026',   N'Khach moi giam 5%',                  0,  5,       800000,  NULL,   120, 58,  '2026-04-01', '2026-12-31', N'Uu dai danh cho khach hang moi dang ky',     1),
('MEMBER500', N'Thanh vien giam 500K',               1,  500000,  4000000, NULL,   40,  12,  '2026-04-01', '2026-04-28', N'Uu dai dac biet cho thanh vien than thiet',  2),
('WEDDING',   N'Uu dai vest cuoi 20%',               0,  20,      3000000, 500000, 50,  18,  '2026-04-01', '2026-12-31', N'Danh cho cap doi mua vest cuoi',             1),
('FREESHIP',  N'Ho tro van chuyen 30K',              1,  30000,   500000,  NULL,   200, 87,  '2026-04-01', '2026-12-31', N'Giam phi ship cho don tu 500K',              1);

-- =============================================================================
-- 6. NHAN VIEN
-- =============================================================================
CREATE TABLE nhan_vien (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    ma_nhan_vien  VARCHAR(50) UNIQUE,
    ten_nhan_vien NVARCHAR(150),
    sdt           NVARCHAR(20),
    email         NVARCHAR(200),
    trang_thai    INT DEFAULT 1
);

INSERT INTO nhan_vien (ma_nhan_vien, ten_nhan_vien, sdt, email) VALUES
('NV001', N'Nguyen Van Phuc', '0988888888', 'phuc@famicoats.com'),
('NV002', N'Le Minh Duc', '0911111111', 'duc@famicoats.com'),
('NV003', N'Tran Dai Luong', '0922222222', 'luong@famicoats.com');

-- =============================================================================
-- 7. HOA DON  (15 ban ghi)
-- =============================================================================
CREATE TABLE hoa_don (
    id                        INT IDENTITY(1,1) PRIMARY KEY,
    id_dia_chi                INT REFERENCES dia_chi(id),
    id_phuong_thuc_thanh_toan INT REFERENCES phuong_thuc_thanh_toan(id),
    id_ma_giam_gia            INT REFERENCES phieu_giam_gia(id),
    id_nhan_vien              INT REFERENCES nhan_vien(id),
    ngay_dat_hang             DATETIME,
    ngay_xac_nhan             DATETIME,
    ten_khach_hang            NVARCHAR(150),
    sdt_khach_hang            NVARCHAR(20),
    email_khach_hang          NVARCHAR(200),
    dia_chi_khach_hang        NVARCHAR(500),
    tong_so_luong             INT   DEFAULT 0,
    tam_tinh                  FLOAT,
    tien_giam_hoa_don         FLOAT DEFAULT 0,
    tong_thanh_toan           FLOAT,
    da_thanh_toan             FLOAT DEFAULT 0,
    lien_hoan                 FLOAT DEFAULT 0,
    ghi_chu                   NVARCHAR(MAX),
    trang_thai_thanh_toan     INT   DEFAULT 0, -- 0: Chua TT, 1: Da TT
    trang_thai_don_hang       INT   DEFAULT 0, -- 0: Cho, 1: Xac nhan, 2: Dang giao, 3: Hoan thanh, 4: Huy
    trang_thai                INT   DEFAULT 1
);

INSERT INTO hoa_don (id_dia_chi, id_phuong_thuc_thanh_toan, id_ma_giam_gia, id_nhan_vien,
    ngay_dat_hang, ngay_xac_nhan,
    ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang,
    tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan,
    trang_thai_thanh_toan, trang_thai_don_hang, trang_thai) VALUES
( 1, 1, NULL, 1, '2026-06-01 08:30:00', NULL,                  N'Nguyen Van An',   '0901234567', 'an.nguyen@gmail.com',    N'25 Hang Gai, Ha Noi',           2, 3700000, 0,      3700000, 3700000, 1, 0, 1),
( 2, 2, 1,    2, '2026-06-03 10:15:00', NULL,                  N'Tran Thi Bich',   '0912345678', 'bich.tran@gmail.com',    N'88 Le Loi, Ho Chi Minh',        3, 5400000, 810000, 4590000, 4590000, 1, 0, 1),
( 3, 3, NULL, 3, '2026-06-05 14:00:00', NULL,                  N'Le Van Cuong',    '0923456789', 'cuong.le@gmail.com',     N'12 Tran Phu, Da Nang',          1, 1200000, 0,      1200000, 1200000, 1, 0, 1),
( 4, 1, 5,    1, '2026-06-08 09:00:00', NULL,                  N'Pham Thi Dung',   '0934567890', 'dung.pham@yahoo.com',    N'45 Dinh Tien Hoang, Hai Phong', 2, 3100000, 300000, 2800000, 2800000, 1, 0, 1),
( 5, 2, 2,    2, '2026-06-10 11:30:00', NULL,                  N'Hoang Van Em',    '0945678901', 'em.hoang@gmail.com',     N'78 Nguyen Trai, Can Tho',       1, 650000,  0,      617500,  0,       0, 0, 1),
( 6, 1, NULL, 3, '2026-06-12 16:00:00', NULL,                  N'Ngo Thi Phuong',  '0956789012', 'phuong.ngo@gmail.com',   N'99 Dai lo Binh Duong',          4, 6600000, 0,      6600000, 6600000, 1, 0, 1),
( 7, 1, 4,    1, '2026-06-15 08:45:00', NULL,                  N'Dang Van Giang',  '0967890123', 'giang.dang@gmail.com',   N'3 Pham Van Thuan, Dong Nai',    3, 4650000, 465000, 4185000, 4185000, 1, 0, 1),
( 8, 3, NULL, 2, '2026-06-18 13:00:00', NULL,                  N'Bui Thi Ha',      '0978901234', 'ha.bui@gmail.com',       N'22 Le Loi, Hue',                2, 2900000, 0,      2900000, 2900000, 1, 0, 1),
( 9, 2, 1,    3, '2026-06-20 10:00:00', NULL,                  N'Dinh Van Inh',    '0989012345', 'inh.dinh@gmail.com',     N'56 Yersin, Nha Trang',          1, 1850000, 200000, 1650000, 0,       0, 0, 1),
(10, 4, NULL, 1, '2026-06-22 09:30:00', NULL,                  N'Vu Thi Kim',      '0990123456', 'kim.vu@gmail.com',       N'7 Tran Hung Dao, Quang Nam',    5, 8250000, 0,      8250000, 8250000, 1, 0, 1),
(11, 1, 4,    2, '2026-06-25 11:00:00', NULL,                  N'Phan Van Long',   '0901234568', 'long.phan@gmail.com',    N'14 Ly Thai To, Bac Ninh',       2, 4000000, 500000, 3500000, 3500000, 1, 0, 1),
(12, 3, NULL, 3, '2026-06-28 15:30:00', NULL,                  N'Trinh Thi Mai',   '0912345679', 'mai.trinh@gmail.com',    N'38 Tran Dang Ninh, Nam Dinh',   3, 3750000, 0,      3750000, 0,       0, 0, 1),
(13, 2, 3,    1, '2026-07-01 08:00:00', NULL,                  N'Cao Van Nghia',   '0923456780', 'nghia.cao@gmail.com',    N'67 Le Hoan, Thanh Hoa',         1, 2100000, 300000, 1800000, 1800000, 1, 0, 1),
(14, 1, 2,    2, '2026-07-05 10:30:00', NULL,                  N'Ly Thi Oanh',     '0934567891', 'oanh.ly@gmail.com',      N'5 Nguyen Gia Thieu, Nghe An',   2, 1500000, 75000,  1425000, 1425000, 1, 0, 1),
(15, 1, 5,    3, '2026-07-10 14:00:00', NULL,                  N'Truong Van Phuc', '0945678902', 'phuc.truong@gmail.com',  N'92 Tran Phu, Ha Tinh',          4, 7400000, 740000, 6660000, 0,       0, 0, 1);

-- =============================================================================
-- 8. CHI TIET HOA DON
-- =============================================================================
CREATE TABLE chi_tiet_hoa_don (
    id                   INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don           INT NOT NULL REFERENCES hoa_don(id),
    id_chi_tiet_san_pham INT REFERENCES chi_tiet_san_pham(id),
    don_gia              FLOAT,
    gia_giam             FLOAT DEFAULT 0,
    so_luong             INT   DEFAULT 1,
    thanh_tien           FLOAT,
    ghi_chu              NVARCHAR(MAX)
);

INSERT INTO chi_tiet_hoa_don (id_hoa_don, id_chi_tiet_san_pham, don_gia, gia_giam, so_luong, thanh_tien) VALUES
( 1,  1, 1850000, 0,      2, 3700000),
( 2,  4,  750000, 67500,  1,  682500),
( 2,  6, 1200000, 108000, 2, 2184000),
( 3,  6, 1200000, 0,      1, 1200000),
( 4, 12, 1650000, 0,      2, 3300000),
( 5, 10,  650000, 32500,  1,  617500),
( 6,  1, 1850000, 0,      2, 3700000),
( 6,  3, 1950000, 0,      1, 1950000),
( 7,  9, 2100000, 210000, 2, 3780000),
( 8,  5,  750000, 0,      2, 1500000),
( 9,  1, 1850000, 200000, 1, 1650000),
(10, 15,  550000, 0,      5, 2750000),
(11,  8, 2100000, 500000, 2, 3200000),
(12,  7, 1200000, 0,      3, 3600000),
(13,  9, 2100000, 300000, 1, 1800000),
(14, 11, 1450000, 0,      1, 1450000),
(15, 13, 1350000, 0,      5, 6750000);

-- =============================================================================
-- 9. LICH SU HOA DON
-- =============================================================================
CREATE TABLE lich_su_hoa_don (
    id                 INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don         INT NOT NULL REFERENCES hoa_don(id),
    trang_thai_cu      INT NOT NULL,
    trang_thai_moi     INT NOT NULL,
    ghi_chu            NVARCHAR(MAX),
    thoi_gian_cap_nhat DATETIME DEFAULT GETDATE(),
    trang_thai         INT      DEFAULT 1
);

INSERT INTO lich_su_hoa_don (id_hoa_don, trang_thai_cu, trang_thai_moi, ghi_chu, thoi_gian_cap_nhat, trang_thai) VALUES
( 1, 0, 0, N'Tạo đơn hàng', '2026-06-01 08:30:00', 1),
( 2, 0, 0, N'Tạo đơn hàng', '2026-06-03 10:15:00', 1),
( 3, 0, 0, N'Tạo đơn hàng', '2026-06-05 14:00:00', 1),
( 4, 0, 0, N'Tạo đơn hàng', '2026-06-08 09:00:00', 1),
( 5, 0, 0, N'Tạo đơn hàng', '2026-06-10 11:30:00', 1),
( 6, 0, 0, N'Tạo đơn hàng', '2026-06-12 16:00:00', 1),
( 7, 0, 0, N'Tạo đơn hàng', '2026-06-15 08:45:00', 1),
( 8, 0, 0, N'Tạo đơn hàng', '2026-06-18 13:00:00', 1),
( 9, 0, 0, N'Tạo đơn hàng', '2026-06-20 10:00:00', 1),
(10, 0, 0, N'Tạo đơn hàng', '2026-06-22 09:30:00', 1),
(11, 0, 0, N'Tạo đơn hàng', '2026-06-25 11:00:00', 1),
(12, 0, 0, N'Tạo đơn hàng', '2026-06-28 15:30:00', 1),
(13, 0, 0, N'Tạo đơn hàng', '2026-07-01 08:00:00', 1),
(14, 0, 0, N'Tạo đơn hàng', '2026-07-05 10:30:00', 1),
(15, 0, 0, N'Tạo đơn hàng', '2026-07-10 14:00:00', 1);

-- =============================================================================
-- 10. LICH SU THANH TOAN
-- =============================================================================
CREATE TABLE lich_su_thanh_toan (
    id                  INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don          INT NOT NULL REFERENCES hoa_don(id),
    ma_giao_dich_cong   NVARCHAR(200),
    so_tien             FLOAT,
    noi_dung            NVARCHAR(MAX),
    trang_thai          INT      DEFAULT 1,  -- 0: That bai, 1: Thanh cong
    thoi_gian_giao_dich DATETIME DEFAULT GETDATE()
);

INSERT INTO lich_su_thanh_toan (id_hoa_don, ma_giao_dich_cong, so_tien, noi_dung, trang_thai, thoi_gian_giao_dich) VALUES
( 1, 'TXN20260601001', 3700000, N'Thanh toan tien mat - HD001',          1, '2026-06-01 09:05:00'),
( 2, 'VNP20260603001', 4590000, N'Thanh toan VNPay - HD002',             1, '2026-06-03 10:50:00'),
( 3, 'MOM20260605001', 1200000, N'Thanh toan MoMo - HD003',              1, '2026-06-05 14:35:00'),
( 4, 'TXN20260608001', 2800000, N'Thanh toan tien mat - HD004',          1, '2026-06-08 09:35:00'),
( 6, 'CK20260612001',  6600000, N'Chuyen khoan MB Bank - HD006',         1, '2026-06-13 07:55:00'),
( 7, 'TXN20260615001', 4185000, N'Thanh toan tien mat - HD007',          1, '2026-06-15 09:20:00'),
( 8, 'MOM20260618001', 2900000, N'Thanh toan MoMo - HD008',              1, '2026-06-18 13:50:00'),
(10, 'ZAL20260622001', 8250000, N'Thanh toan ZaloPay - HD010',           1, '2026-06-22 10:05:00'),
(11, 'TXN20260625001', 3500000, N'Thanh toan tien mat - HD011',          1, '2026-06-25 11:35:00'),
(13, 'VNP20260701001', 1800000, N'Thanh toan VNPay - HD013',             1, '2026-07-01 08:50:00'),
(14, 'CK20260705001',  1425000, N'Chuyen khoan Vietcombank - HD014',     1, '2026-07-05 11:05:00'),
( 9, 'VNP20260620001', 1650000, N'VNPay - HD009 - That bai',             0, '2026-06-20 10:05:00'),
( 5, 'VNP20260610001',  617500, N'VNPay - HD005 - That bai',             0, '2026-06-10 11:35:00'),
(15, 'VNP20260710001', 6660000, N'VNPay - HD015 - Cho xu ly',            0, '2026-07-10 14:05:00'),
( 2, 'VNP20260603002',       0, N'Kiem tra ket noi VNPay - HD002',       0, '2026-06-03 10:47:00');

-- =============================================================================
-- Ket thuc script
-- =============================================================================
PRINT N'Database FamiCoats khoi tao thanh cong!';
PRINT N'  phuong_thuc_thanh_toan : 5  ban ghi';
PRINT N'  dia_chi                : 15 ban ghi';
PRINT N'  san_pham               : 15 ban ghi';
PRINT N'  chi_tiet_san_pham      : 15 ban ghi';
PRINT N'  phieu_giam_gia         : 5 ban ghi';
PRINT N'  nhan_vien              : 3 ban ghi';
PRINT N'  hoa_don                : 15 ban ghi';
PRINT N'  chi_tiet_hoa_don       : 17 ban ghi';
PRINT N'  lich_su_hoa_don        : 15 ban ghi';
PRINT N'  lich_su_thanh_toan     : 15 ban ghi';
