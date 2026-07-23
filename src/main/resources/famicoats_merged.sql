-- =====================================================================
-- FAMICOATS - FULL DATABASE SCRIPT (v3 - Chuẩn hóa 3NF)
-- Hệ CSDL: SQL Server
-- Mô tả: Script đầy đủ tạo database FamiCoats bán áo khoác
-- Structure:
--   PHẦN 1: Tạo Database, Drop bảng cũ, Tạo tất cả các Bảng (3NF)
--   PHẦN 2: Thêm dữ liệu mẫu vào các Bảng
-- =====================================================================

-- =====================================================================
-- TẠO DATABASE
-- =====================================================================
IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'FamiCoats')
BEGIN
    CREATE DATABASE FamiCoats;
END
GO

USE FamiCoats;
GO

-- =====================================================================
-- XÓA BẢNG THEO THỨ TỰ (tránh xung đột khóa ngoại)
-- =====================================================================
IF OBJECT_ID('lich_su_thanh_toan',     'U') IS NOT NULL DROP TABLE lich_su_thanh_toan;
IF OBJECT_ID('lich_su_hoa_don',        'U') IS NOT NULL DROP TABLE lich_su_hoa_don;
IF OBJECT_ID('chi_tiet_hoa_don',       'U') IS NOT NULL DROP TABLE chi_tiet_hoa_don;
IF OBJECT_ID('hoa_don',                'U') IS NOT NULL DROP TABLE hoa_don;
IF OBJECT_ID('phieu_giam_gia',         'U') IS NOT NULL DROP TABLE phieu_giam_gia;
IF OBJECT_ID('hinh_anh',               'U') IS NOT NULL DROP TABLE hinh_anh;
IF OBJECT_ID('chi_tiet_san_pham',      'U') IS NOT NULL DROP TABLE chi_tiet_san_pham;
IF OBJECT_ID('san_pham',               'U') IS NOT NULL DROP TABLE san_pham;
IF OBJECT_ID('xuat_xu',                'U') IS NOT NULL DROP TABLE xuat_xu;
IF OBJECT_ID('kieu_dang',              'U') IS NOT NULL DROP TABLE kieu_dang;
IF OBJECT_ID('kich_thuoc',             'U') IS NOT NULL DROP TABLE kich_thuoc;
IF OBJECT_ID('mau_sac',                'U') IS NOT NULL DROP TABLE mau_sac;
IF OBJECT_ID('chat_lieu',              'U') IS NOT NULL DROP TABLE chat_lieu;
IF OBJECT_ID('danh_muc',               'U') IS NOT NULL DROP TABLE danh_muc;
IF OBJECT_ID('thuong_hieu',            'U') IS NOT NULL DROP TABLE thuong_hieu;
IF OBJECT_ID('khach_hang_dia_chi',     'U') IS NOT NULL DROP TABLE khach_hang_dia_chi;
IF OBJECT_ID('nhan_vien',              'U') IS NOT NULL DROP TABLE nhan_vien;
IF OBJECT_ID('dia_chi',                'U') IS NOT NULL DROP TABLE dia_chi;
IF OBJECT_ID('khach_hang',             'U') IS NOT NULL DROP TABLE khach_hang;
IF OBJECT_ID('vai_tro',                'U') IS NOT NULL DROP TABLE vai_tro;
IF OBJECT_ID('phuong_thuc_thanh_toan', 'U') IS NOT NULL DROP TABLE phuong_thuc_thanh_toan;
GO

-- =====================================================================
-- PHẦN 1: TẠO TẤT CẢ CÁC BẢNG (CREATE TABLE - 3NF)
-- =====================================================================

-- 1. PHƯƠNG THỨC THANH TOÁN
CREATE TABLE phuong_thuc_thanh_toan (
    id                          INT IDENTITY(1,1)  PRIMARY KEY,
    phuong_thuc_thanh_toan_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_phuong_thuc             NVARCHAR(100)      NOT NULL,
    mo_ta                       NVARCHAR(MAX),
    logo                        NVARCHAR(500),
    phi_thanh_toan              FLOAT              DEFAULT 0,
    trang_thai                  INT                DEFAULT 1   -- 1: Hoạt động | 0: Ngừng
);
GO

-- 2. VAI TRÒ
CREATE TABLE vai_tro (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    code        VARCHAR(50)       NOT NULL UNIQUE,
    ten_vai_tro NVARCHAR(100)     NOT NULL,
    trang_thai  INT               DEFAULT 1
);
GO

-- 3. ĐỊA CHỈ (Vị trí địa lý thuần túy - Dùng chung cho KH & NV)
CREATE TABLE dia_chi (
    id               INT IDENTITY(1,1)  PRIMARY KEY,
    dia_chi_code     VARCHAR(50)        NOT NULL UNIQUE,
    tinh             NVARCHAR(150),
    huyen            NVARCHAR(100) NULL,
    xa               NVARCHAR(150),
    dia_chi_chi_tiet NVARCHAR(500)
);
GO

-- 4. NHÂN VIÊN (Nối 1 - 1 / 1 - N tới Địa chỉ)
CREATE TABLE nhan_vien (
    id             INT IDENTITY(1,1)  PRIMARY KEY,
    nhan_vien_code VARCHAR(50)        NOT NULL UNIQUE,
    id_vai_tro     INT                REFERENCES vai_tro(id),
    id_dia_chi     INT                NULL REFERENCES dia_chi(id),
    ten_nhan_vien  NVARCHAR(150)      NOT NULL,
    cccd           VARCHAR(20),
    email          NVARCHAR(200)      NOT NULL UNIQUE,
    mat_khau       VARCHAR(255),
    so_dien_thoai  NVARCHAR(20),
    ngay_sinh      DATE,
    gioi_tinh      BIT,               -- 1: Nam | 0: Nữ
    anh_dai_dien   NVARCHAR(500),
    trang_thai     INT                DEFAULT 1   -- 1: Đang làm | 0: Nghỉ
);
GO

-- 5. KHÁCH HÀNG
CREATE TABLE khach_hang (
    id              INT IDENTITY(1,1)  PRIMARY KEY,
    khach_hang_code VARCHAR(50)        NOT NULL UNIQUE,
    ho_ten          NVARCHAR(100)      NOT NULL,
    email           NVARCHAR(200)      NOT NULL UNIQUE,
    mat_khau        VARCHAR(255),
    so_dien_thoai   NVARCHAR(20)       NOT NULL,
    ngay_sinh       DATE,
    gioi_tinh       NVARCHAR(10),      -- 'Nam' / 'Nữ'
    anh_dai_dien    NVARCHAR(500),
    trang_thai      NVARCHAR(50)       DEFAULT N'Hoạt động'
);
GO

-- 6. KHÁCH HÀNG - ĐỊA CHỈ (Bảng trung gian N - N)
CREATE TABLE khach_hang_dia_chi (
    id            INT IDENTITY(1,1)  PRIMARY KEY,
    id_khach_hang INT                NOT NULL REFERENCES khach_hang(id) ON DELETE CASCADE,
    id_dia_chi    INT                NOT NULL REFERENCES dia_chi(id) ON DELETE CASCADE,
    nguoi_nhan    NVARCHAR(150),
    so_dien_thoai NVARCHAR(20),
    mac_dinh      BIT                DEFAULT 0,
    ghi_chu       NVARCHAR(MAX)
);
GO

-- 7. THƯƠNG HIỆU
CREATE TABLE thuong_hieu (
    id               INT IDENTITY(1,1)  PRIMARY KEY,
    thuong_hieu_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_thuong_hieu  NVARCHAR(100)      NOT NULL,
    logo             NVARCHAR(500),
    trang_thai       NVARCHAR(50)       DEFAULT N'Hoạt động'
);
GO

-- 8. DANH MỤC
CREATE TABLE danh_muc (
    id            INT IDENTITY(1,1)  PRIMARY KEY,
    danh_muc_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_danh_muc  NVARCHAR(100)      NOT NULL,
    trang_thai    NVARCHAR(50)       DEFAULT N'Hoạt động'
);
GO

-- 9. CHẤT LIỆU
CREATE TABLE chat_lieu (
    id             INT IDENTITY(1,1)  PRIMARY KEY,
    chat_lieu_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_chat_lieu  NVARCHAR(100)      NOT NULL,
    trang_thai     NVARCHAR(50)       DEFAULT N'Hoạt động'
);
GO

-- 10. MÀU SẮC
CREATE TABLE mau_sac (
    id           INT IDENTITY(1,1)  PRIMARY KEY,
    mau_sac_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_mau      NVARCHAR(100)      NOT NULL,
    trang_thai   NVARCHAR(50)       DEFAULT N'Hoạt động'
);
GO

-- 11. KÍCH THƯỚC
CREATE TABLE kich_thuoc (
    id              INT IDENTITY(1,1)  PRIMARY KEY,
    kich_thuoc_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_kich_thuoc  NVARCHAR(50)       NOT NULL,
    trang_thai      NVARCHAR(50)       DEFAULT N'Hoạt động'
);
GO

-- 12. KIỂU DÁNG
CREATE TABLE kieu_dang (
    id             INT IDENTITY(1,1)  PRIMARY KEY,
    kieu_dang_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_kieu_dang  NVARCHAR(100)      NOT NULL,
    trang_thai     NVARCHAR(50)       DEFAULT N'Hoạt động'
);
GO

-- 12.5 XUẤT XỨ (Quốc gia sản xuất)
CREATE TABLE xuat_xu (
    id           INT IDENTITY(1,1)  PRIMARY KEY,
    xuat_xu_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_xuat_xu  NVARCHAR(100)      NOT NULL,
    trang_thai   NVARCHAR(50)       DEFAULT N'Hoạt động'
);
GO

-- 13. SẢN PHẨM
CREATE TABLE san_pham (
    id                 INT IDENTITY(1,1)  PRIMARY KEY,
    san_pham_code      VARCHAR(50)        NOT NULL UNIQUE,
    ten_san_pham       NVARCHAR(255)      NOT NULL,
    id_danh_muc        INT                REFERENCES danh_muc(id),
    id_thuong_hieu     INT                REFERENCES thuong_hieu(id),
    id_xuat_xu         INT                REFERENCES xuat_xu(id),
    mo_ta              NVARCHAR(MAX),
    doi_tuong          NVARCHAR(50),      -- 'Nam' / 'Nữ' / 'Unisex'
    xuat_xu            NVARCHAR(100),
    huong_dan_bao_quan NVARCHAR(MAX),
    gia_ban            FLOAT              DEFAULT 0,
    da_ban             INT                DEFAULT 0,
    trang_thai         NVARCHAR(50)       DEFAULT 'AVAILABLE' -- 'AVAILABLE': Còn hàng | 'OUT_OF_STOCK': Hết hàng
);
GO

-- 14. CHI TIẾT SẢN PHẨM
CREATE TABLE chi_tiet_san_pham (
    id                     INT IDENTITY(1,1)  PRIMARY KEY,
    chi_tiet_san_pham_code VARCHAR(50)        NOT NULL UNIQUE,
    id_san_pham            INT                NOT NULL REFERENCES san_pham(id) ON DELETE CASCADE,
    id_kich_thuoc          INT                REFERENCES kich_thuoc(id),
    id_mau_sac             INT                REFERENCES mau_sac(id),
    id_kieu_dang           INT                REFERENCES kieu_dang(id),
    gia_ban                FLOAT              DEFAULT 0,
    so_luong               INT                DEFAULT 0,
    trong_luong            FLOAT              DEFAULT 0,  -- kg
    chieu_dai              FLOAT              DEFAULT 0,  -- cm
    chieu_rong             FLOAT              DEFAULT 0,  -- cm
    do_day                 FLOAT              DEFAULT 0,  -- cm
    trang_thai             NVARCHAR(50)       DEFAULT 'AVAILABLE' -- 'AVAILABLE': Còn hàng | 'OUT_OF_STOCK': Hết hàng
);
GO

-- 15. HÌNH ẢNH
CREATE TABLE hinh_anh (
    id                   INT IDENTITY(1,1)  PRIMARY KEY,
    hinh_anh_code        VARCHAR(50)        NOT NULL UNIQUE,
    id_chi_tiet_san_pham INT                NOT NULL REFERENCES chi_tiet_san_pham(id) ON DELETE CASCADE,
    duong_dan            NVARCHAR(500),
    anh_chinh            BIT                DEFAULT 0,
    thu_tu               INT                DEFAULT 1
);
GO

-- 16. PHIẾU GIẢM GIÁ
CREATE TABLE phieu_giam_gia (
    id                         INT IDENTITY(1,1)  PRIMARY KEY,
    phieu_giam_gia_code        VARCHAR(50)        NOT NULL UNIQUE,
    ten_chuong_trinh           NVARCHAR(255)      NOT NULL,
    loai_giam                  INT                NOT NULL,  -- 0: % | 1: VND cố định
    gia_tri_giam               FLOAT              NOT NULL,
    gia_tri_don_hang_toi_thieu FLOAT,
    giam_toi_da                FLOAT,
    so_luong                   INT,
    da_su_dung                 INT                DEFAULT 0,
    ngay_bat_dau               DATE,
    ngay_ket_thuc              DATE,
    mo_ta                      NVARCHAR(MAX),
    trang_thai                 INT                DEFAULT 1,
    -- 0: Chưa kích hoạt | 1: Đang áp dụng | 2: Kết thúc | 3: Đã hủy
    ngay_tao                   DATETIME           DEFAULT GETDATE()
);
GO

-- 17. HÓA ĐƠN
CREATE TABLE hoa_don (
    id                        INT IDENTITY(1,1)  PRIMARY KEY,
    hoa_don_code              VARCHAR(50)        NOT NULL UNIQUE,
    id_khach_hang             INT                REFERENCES khach_hang(id),
    id_nhan_vien              INT                REFERENCES nhan_vien(id),
    id_dia_chi                INT                REFERENCES dia_chi(id),
    id_phuong_thuc_thanh_toan INT                REFERENCES phuong_thuc_thanh_toan(id),
    id_ma_giam_gia            INT                REFERENCES phieu_giam_gia(id),
    ngay_dat_hang             DATETIME           DEFAULT GETDATE(),
    ngay_xac_nhan             DATETIME,
    ten_khach_hang            NVARCHAR(150),
    sdt_khach_hang            NVARCHAR(20),
    email_khach_hang          NVARCHAR(200),
    dia_chi_khach_hang        NVARCHAR(500),
    tong_so_luong             INT                DEFAULT 0,
    tam_tinh                  FLOAT              DEFAULT 0,
    tien_giam_hoa_don         FLOAT              DEFAULT 0,
    tong_thanh_toan           FLOAT              DEFAULT 0,
    da_thanh_toan             FLOAT              DEFAULT 0,
    lien_hoan                 FLOAT              DEFAULT 0,
    ghi_chu                   NVARCHAR(MAX),
    trang_thai_thanh_toan     INT                DEFAULT 0,  -- 0: Chưa TT | 1: Đã TT
    trang_thai_don_hang       INT                DEFAULT 0,
    -- 0: Chờ | 1: Xác nhận | 2: Đang giao | 3: Hoàn thành | 4: Hủy
    trang_thai                INT                DEFAULT 1
);
GO

-- 18. CHI TIẾT HÓA ĐƠN
CREATE TABLE chi_tiet_hoa_don (
    id                    INT IDENTITY(1,1)  PRIMARY KEY,
    chi_tiet_hoa_don_code VARCHAR(50)        NOT NULL UNIQUE,
    id_hoa_don            INT                NOT NULL REFERENCES hoa_don(id),
    id_chi_tiet_san_pham  INT                REFERENCES chi_tiet_san_pham(id),
    don_gia               FLOAT,
    gia_giam              FLOAT              DEFAULT 0,
    so_luong              INT                DEFAULT 1,
    thanh_tien            FLOAT,
    ghi_chu               NVARCHAR(MAX)
);
GO

-- 19. LỊCH SỬ HÓA ĐƠN
CREATE TABLE lich_su_hoa_don (
    id                   INT IDENTITY(1,1)  PRIMARY KEY,
    lich_su_hoa_don_code VARCHAR(50)        NOT NULL UNIQUE,
    id_hoa_don           INT                NOT NULL REFERENCES hoa_don(id),
    id_nguoi_thuc_hien   INT                REFERENCES nhan_vien(id),
    id_khach_hang        INT                REFERENCES khach_hang(id),
    trang_thai_cu        INT                NOT NULL,
    trang_thai_moi       INT                NOT NULL,
    ghi_chu              NVARCHAR(MAX),
    thoi_gian_cap_nhat   DATETIME           DEFAULT GETDATE(),
    trang_thai           INT                DEFAULT 1
);
GO

-- 20. LỊCH SỬ THANH TOÁN
CREATE TABLE lich_su_thanh_toan (
    id                      INT IDENTITY(1,1)  PRIMARY KEY,
    lich_su_thanh_toan_code VARCHAR(50)        NOT NULL UNIQUE,
    id_hoa_don              INT                NOT NULL REFERENCES hoa_don(id),
    ma_giao_dich_cong       NVARCHAR(200),
    so_tien                 FLOAT,
    noi_dung                NVARCHAR(MAX),
    trang_thai              INT                DEFAULT 1,  -- 0: Thất bại | 1: Thành công
    thoi_gian_giao_dich     DATETIME           DEFAULT GETDATE()
);
GO


-- =====================================================================
-- PHẦN 2: THÊM DỮ LIỆU MẪU (INSERT INTO)
-- =====================================================================

-- 1. PHƯƠNG THỨC THANH TOÁN
INSERT INTO phuong_thuc_thanh_toan
    (phuong_thuc_thanh_toan_code, ten_phuong_thuc, mo_ta, logo, phi_thanh_toan, trang_thai)
VALUES
('PTTT001', N'Tiền mặt',               N'Thanh toán trực tiếp bằng tiền mặt',        NULL,           0, 1),
('PTTT002', N'VNPay',                  N'Thanh toán qua ví VNPay',          'vnpay.png',    0, 1),
('PTTT003', N'MoMo',                   N'Thanh toán qua ví điện tử MoMo',             'momo.png',     0, 1),
('PTTT004', N'ZaloPay',                N'Thanh toán qua ví ZaloPay',                  'zalopay.png',  0, 1);
GO

-- 2. VAI TRÒ
INSERT INTO vai_tro (code, ten_vai_tro, trang_thai) VALUES
('ROLE01', N'Quản lý', 1),
('ROLE02', N'Nhân viên', 1);
GO

-- 3. ĐỊA CHỈ
INSERT INTO dia_chi (dia_chi_code, tinh, huyen, xa, dia_chi_chi_tiet) VALUES
('DC001', N'Hà Nội',      N'Quận Hoàn Kiếm',  N'Phường Hàng Gai',   N'25 Hàng Gai'),
('DC002', N'Hồ Chí Minh', N'Quận 1',           N'Phường Bến Nghé',   N'88 Lê Lợi'),
('DC003', N'Đà Nẵng',     N'Quận Hải Châu',    N'Phường Hải Châu 1', N'12 Trần Phú'),
('DC004', N'Hải Phòng',   N'Quận Ngô Quyền',   N'Phường Máy Tơ',     N'45 Đinh Tiên Hoàng'),
('DC005', N'Cần Thơ',     N'Quận Ninh Kiều',   N'Phường Tân An',     N'78 Nguyễn Trãi'),
('DC006', N'Bình Dương',  N'TP Thủ Dầu Một',   N'Phường Phú Lợi',    N'99 Đại lộ Bình Dương'),
('DC007', N'Đồng Nai',    N'TP Biên Hòa',      N'Phường Trung Dũng', N'3 Phạm Văn Thuận'),
('DC008', N'Huế',         N'TP Huế',            N'Phường Phú Hội',    N'22 Lê Lợi'),
('DC009', N'Nha Trang',   N'TP Nha Trang',      N'Phường Lộc Thọ',    N'56 Yersin'),
('DC010', N'Quảng Nam',   N'TP Hội An',         N'Phường Minh An',    N'7 Trần Hưng Đạo'),
('DC011', N'Bắc Ninh',    N'TP Bắc Ninh',       N'Phường Vũ Ninh',    N'14 Lý Thái Tổ'),
('DC012', N'Nam Định',    N'TP Nam Định',        N'Phường Ngô Quyền',  N'38 Trần Đăng Ninh'),
('DC013', N'Thanh Hóa',   N'TP Thanh Hóa',      N'Phường Điện Biên',  N'67 Lê Hoàn'),
('DC014', N'Nghệ An',     N'TP Vinh',            N'Phường Lê Mao',     N'5 Nguyễn Gia Thiều'),
('DC015', N'Hà Tĩnh',     N'TP Hà Tĩnh',         N'Phường Nam Hà',     N'92 Trần Phú'),
('DC016', N'Hà Nội',      N'Quận Cầu Giấy',   N'Phường Dịch Vọng',  N'100 Cầu Giấy'),
('DC017', N'Hà Nội',      N'Quận Đống Đa',    N'Phường Láng Hạ',    N'50 Láng Hạ'),
('DC018', N'Hà Nội',      N'Quận Thanh Xuân', N'Phường Nhân Chính', N'12 Nguyễn Trãi');
GO

-- 4. NHÂN VIÊN
INSERT INTO nhan_vien
    (nhan_vien_code, id_vai_tro, id_dia_chi, ten_nhan_vien, cccd, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, trang_thai)
VALUES
('NV001', 1, 16, N'Nguyễn Văn Phúc', '001099123456', 'phuc@famicoats.com',  '123456', '0988888888', '1998-03-15', 1, 1),
('NV002', 1, 17, N'Lê Minh Đức',     '002099234567', 'duc@famicoats.com',   '123456', '0911111111', '1997-07-22', 1, 1),
('NV003', 2, 18, N'Trần Đại Lương',  '003099345678', 'luong@famicoats.com', '123456', '0922222222', '1999-01-10', 1, 1);
GO

-- 5. KHÁCH HÀNG
INSERT INTO khach_hang
    (khach_hang_code, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, trang_thai)
VALUES
('KH001', N'Nguyễn Văn An',   'an.nguyen@gmail.com',   '123456', '0901234567', '1995-05-20', N'Nam', N'Hoạt động'),
('KH002', N'Trần Thị Bích',   'bich.tran@gmail.com',   '123456', '0912345678', '1998-10-15', N'Nữ',  N'Hoạt động'),
('KH003', N'Lê Văn Cường',    'cuong.le@gmail.com',    '123456', '0923456789', '1993-03-08', N'Nam', N'Hoạt động'),
('KH004', N'Phạm Thị Dung',   'dung.pham@yahoo.com',   '123456', '0934567890', '2000-12-05', N'Nữ',  N'Hoạt động'),
('KH005', N'Hoàng Văn Em',    'em.hoang@gmail.com',    '123456', '0945678901', '1990-07-14', N'Nam', N'Hoạt động'),
('KH006', N'Ngô Thị Phương',  'phuong.ngo@gmail.com',  '123456', '0956789012', '1997-02-28', N'Nữ',  N'Hoạt động'),
('KH007', N'Đặng Văn Giang',  'giang.dang@gmail.com',  '123456', '0967890123', '1994-09-30', N'Nam', N'Hoạt động'),
('KH008', N'Bùi Thị Hà',      'ha.bui@gmail.com',      '123456', '0978901234', '1999-06-17', N'Nữ',  N'Hoạt động'),
('KH009', N'Đinh Văn Ính',    'inh.dinh@gmail.com',    '123456', '0989012345', '1992-11-03', N'Nam', N'Hoạt động'),
('KH010', N'Vũ Thị Kim',      'kim.vu@gmail.com',      '123456', '0990123456', '1996-04-25', N'Nữ',  N'Hoạt động'),
('KH011', N'Phan Văn Long',   'long.phan@gmail.com',   '123456', '0901234568', '1988-08-12', N'Nam', N'Hoạt động'),
('KH012', N'Trịnh Thị Mai',   'mai.trinh@gmail.com',   '123456', '0912345679', '2001-01-20', N'Nữ',  N'Hoạt động'),
('KH013', N'Cao Văn Nghĩa',   'nghia.cao@gmail.com',   '123456', '0923456780', '1991-05-05', N'Nam', N'Hoạt động'),
('KH014', N'Lý Thị Oanh',     'oanh.ly@gmail.com',     '123456', '0934567891', '1998-03-22', N'Nữ',  N'Hoạt động'),
('KH015', N'Trương Văn Phúc', 'phuc.truong@gmail.com', '123456', '0945678902', '1995-12-10', N'Nam', N'Hoạt động');
GO

-- 6. KHÁCH HÀNG - ĐỊA CHỈ (Bảng trung gian N - N)
INSERT INTO khach_hang_dia_chi
    (id_khach_hang, id_dia_chi, nguoi_nhan, so_dien_thoai, mac_dinh)
VALUES
( 1,  1, N'Nguyễn Văn An',   '0901234567', 1),
( 2,  2, N'Trần Thị Bích',   '0912345678', 1),
( 3,  3, N'Lê Văn Cường',    '0923456789', 1),
( 4,  4, N'Phạm Thị Dung',   '0934567890', 0),
( 5,  5, N'Hoàng Văn Em',    '0945678901', 1),
( 6,  6, N'Ngô Thị Phương',  '0956789012', 0),
( 7,  7, N'Đặng Văn Giang',  '0967890123', 1),
( 8,  8, N'Bùi Thị Hà',      '0978901234', 0),
( 9,  9, N'Đinh Văn Ính',    '0989012345', 1),
(10, 10, N'Vũ Thị Kim',      '0990123456', 0),
(11, 11, N'Phan Văn Long',   '0901234568', 1),
(12, 12, N'Trịnh Thị Mai',   '0912345679', 0),
(13, 13, N'Cao Văn Nghĩa',   '0923456780', 1),
(14, 14, N'Lý Thị Oanh',     '0934567891', 0),
(15, 15, N'Trương Văn Phúc', '0945678902', 1);
GO

-- 7. THƯƠNG HIỆU
INSERT INTO thuong_hieu (thuong_hieu_code, ten_thuong_hieu, trang_thai)
VALUES
('BR001', N'FamiCoats',      N'Hoạt động'),
('BR002', N'Zara',           N'Hoạt động'),
('BR003', N'Levi''s',        N'Hoạt động'),
('BR004', N'Uniqlo',         N'Hoạt động'),
('BR005', N'The North Face', N'Hoạt động');
GO

-- 8. DANH MỤC
INSERT INTO danh_muc (danh_muc_code, ten_danh_muc, trang_thai)
VALUES
('CAT001', N'Áo khoác da',  N'Hoạt động'),
('CAT002', N'Áo bomber',    N'Hoạt động'),
('CAT003', N'Áo denim',     N'Hoạt động'),
('CAT004', N'Áo phao',      N'Hoạt động'),
('CAT005', N'Áo khoác len', N'Hoạt động'),
('CAT006', N'Áo khoác gió', N'Hoạt động'),
('CAT007', N'Trench coat',  N'Hoạt động'),
('CAT008', N'Áo hoodie',    N'Hoạt động');
GO

-- 9. CHẤT LIỆU
INSERT INTO chat_lieu (chat_lieu_code, ten_chat_lieu, trang_thai)
VALUES
('MAT001', N'Da cừu',       N'Hoạt động'),
('MAT002', N'Vải gió',      N'Hoạt động'),
('MAT003', N'Denim',        N'Hoạt động'),
('MAT004', N'Lông vũ',      N'Hoạt động'),
('MAT005', N'Len cao cấp',  N'Hoạt động'),
('MAT006', N'Nỉ bông',      N'Hoạt động'),
('MAT007', N'Lông cừu giả', N'Hoạt động'),
('MAT008', N'Da tổng hợp',  N'Hoạt động');
GO

-- 10. MÀU SẮC
INSERT INTO mau_sac (mau_sac_code, ten_mau, trang_thai)
VALUES
('MS001', N'Đen',       N'Hoạt động'),
('MS002', N'Nâu',       N'Hoạt động'),
('MS003', N'Xanh nhạt', N'Hoạt động'),
('MS004', N'Kem',       N'Hoạt động'),
('MS005', N'Xám',       N'Hoạt động'),
('MS006', N'Olive',     N'Hoạt động'),
('MS007', N'Trắng',     N'Hoạt động'),
('MS008', N'Hồng nhạt', N'Hoạt động'),
('MS009', N'Be',        N'Hoạt động'),
('MS010', N'Xanh navy', N'Hoạt động'),
('MS011', N'Xám đậm',   N'Hoạt động');
GO

-- 11. KÍCH THƯỚC
INSERT INTO kich_thuoc (kich_thuoc_code, ten_kich_thuoc, trang_thai)
VALUES
('KT001', N'S',   N'Hoạt động'),
('KT002', N'M',   N'Hoạt động'),
('KT003', N'L',   N'Hoạt động'),
('KT004', N'XL',  N'Hoạt động'),
('KT005', N'XXL', N'Hoạt động');
GO

-- 12. KIỂU DÁNG
INSERT INTO kieu_dang (kieu_dang_code, ten_kieu_dang, trang_thai)
VALUES
('KD001', N'Regular',   N'Hoạt động'),
('KD002', N'Oversize',  N'Hoạt động'),
('KD003', N'Slim',      N'Hoạt động'),
('KD004', N'Fitted',    N'Hoạt động'),
('KD005', N'Classic',   N'Hoạt động'),
('KD006', N'Oversized', N'Hoạt động');
GO

-- 12.5 XUẤT XỨ
INSERT INTO xuat_xu (xuat_xu_code, ten_xuat_xu, trang_thai)
VALUES
('XX001', N'Việt Nam',  N'Hoạt động'),
('XX002', N'Nhật Bản',   N'Hoạt động'),
('XX003', N'Hàn Quốc',   N'Hoạt động'),
('XX004', N'Trung Quốc', N'Hoạt động'),
('XX005', N'Ý',          N'Hoạt động'),
('XX006', N'Mỹ',         N'Hoạt động'),
('XX007', N'Nhập khẩu',  N'Hoạt động');
GO

-- 13. SẢN PHẨM
INSERT INTO san_pham
    (san_pham_code, ten_san_pham, id_danh_muc, id_thuong_hieu, id_xuat_xu,
     mo_ta, doi_tuong, xuat_xu, huong_dan_bao_quan,
     gia_ban, da_ban, trang_thai)
VALUES
('SP001', N'Áo khoác da nam cao cấp',         1, 1, 1, N'Chất liệu da thật cao cấp, lót lông ấm',            N'Nam',    N'Việt Nam', N'Chỉ giặt khô',    1850000, 120, 'AVAILABLE'),
('SP002', N'Áo khoác denim nữ thời trang',    3, 1, 1, N'Denim nhập khẩu, form rộng thoải mái',              N'Nữ',     N'Việt Nam', N'Giặt riêng màu',   750000,  95,  'AVAILABLE'),
('SP003', N'Áo khoác bomber unisex',           2, 1, 1, N'Kiểu dáng bomber năng động, chống gió',             N'Unisex', N'Việt Nam', N'Giặt máy nhẹ',    1200000, 78,  'AVAILABLE'),
('SP004', N'Áo khoác len nữ công sở',          5, 1, 1, N'Len cao cấp, thiết kế thanh lịch',                  N'Nữ',     N'Việt Nam', N'Giặt khô',        2100000, 45,  'AVAILABLE'),
('SP005', N'Áo khoác gió nam thể thao',        6, 1, 1, N'Chống gió, chống mưa nhẹ, trọng lượng nhẹ',        N'Nam',    N'Việt Nam', N'Giặt máy thường',  650000,  210, 'AVAILABLE'),
('SP006', N'Áo khoác lông vũ nữ giữ nhiệt',   4, 1, 2, N'Lông vũ thiên nhiên, giữ ấm tối ưu',               N'Nữ',     N'Nhật Bản', N'Giặt máy nhẹ',    1650000, 88,  'AVAILABLE'),
('SP007', N'Áo khoác trench coat nữ',          7, 1, 1, N'Trench coat cổ điển, thích hợp công sở',            N'Nữ',     N'Việt Nam', N'Giặt khô',        1900000, 55,  'AVAILABLE'),
('SP008', N'Áo khoác hoodie nam thường ngày',  8, 1, 1, N'Nỉ bông dày dặn, nón liền kiểu dáng trẻ trung',    N'Nam',    N'Việt Nam', N'Giặt máy thường',  550000,  320, 'AVAILABLE'),
('SP009', N'Áo khoác parka nam đông',          1, 1, 7, N'Parka cao cấp, chịu lạnh cực tốt',                  N'Nam',    N'Nhập khẩu', N'Giặt khô',       2800000, 32,  'OUT_OF_STOCK'),
('SP010', N'Áo khoác varsity unisex phối màu', 2, 1, 1, N'Varsity jacket phong cách retro',                   N'Unisex', N'Việt Nam', N'Giặt máy nhẹ',     980000, 140, 'AVAILABLE'),
('SP011', N'Áo khoác blazer nữ thanh lịch',   5, 1, 1, N'Blazer form slim, phù hợp công sở và dạo phố',     N'Nữ',     N'Việt Nam', N'Giặt khô',        1450000, 68,  'AVAILABLE'),
('SP012', N'Áo khoác jean nam wash cũ',        3, 1, 1, N'Denim wash cũ phong cách vintage',                  N'Nam',    N'Việt Nam', N'Giặt riêng màu',   820000, 180, 'AVAILABLE'),
('SP013', N'Áo khoác lông cừu nữ mùa đông',   4, 1, 1, N'Lông cừu giả mềm mịn, cực ấm mùa đông',           N'Nữ',     N'Việt Nam', N'Giặt máy nhẹ',    1350000, 95,  'AVAILABLE'),
('SP014', N'Áo khoác military nam',            6, 1, 1, N'Phong cách military cá tính, nhiều túi tiện dụng', N'Nam',    N'Việt Nam', N'Giặt máy thường', 1100000, 75,  'AVAILABLE'),
('SP015', N'Áo khoác cape nữ sang trọng',      7, 1, 7, N'Cape coat da cao cấp, dáng độc đáo',               N'Nữ',     N'Nhập khẩu', N'Chỉ giặt khô',   2500000, 18,  'OUT_OF_STOCK');
GO

-- 14. CHI TIẾT SẢN PHẨM
INSERT INTO chi_tiet_san_pham
    (chi_tiet_san_pham_code, id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang,
     gia_ban, so_luong,
     trong_luong, chieu_dai, chieu_rong, do_day, trang_thai)
VALUES
('CTSP001',  1, 2,  1, 1,  1850000, 15, 0.90, 70, 55, 0.30, 'AVAILABLE'),
('CTSP002',  1, 3,  1, 1,  1850000, 12, 0.95, 72, 57, 0.30, 'AVAILABLE'),
('CTSP003',  1, 4,  2, 1,  1950000,  8, 1.00, 74, 59, 0.30, 'AVAILABLE'),
('CTSP004',  2, 1,  3, 2,   750000, 20, 0.50, 65, 50, 0.20, 'AVAILABLE'),
('CTSP005',  2, 2,  3, 2,   750000, 25, 0.52, 67, 52, 0.20, 'AVAILABLE'),
('CTSP006',  3, 2,  1, 3,  1200000, 10, 0.65, 68, 54, 0.25, 'AVAILABLE'),
('CTSP007',  3, 3,  6, 3,  1200000, 10, 0.68, 70, 56, 0.25, 'AVAILABLE'),
('CTSP008',  4, 1,  4, 4,  2100000,  8, 0.85, 66, 52, 0.35, 'AVAILABLE'),
('CTSP009',  4, 2,  5, 4,  2100000,  6, 0.88, 68, 54, 0.35, 'AVAILABLE'),
('CTSP010',  5, 2,  1, 1,   650000, 30, 0.35, 68, 52, 0.15, 'AVAILABLE'),
('CTSP011',  5, 3, 10, 1,   650000, 35, 0.37, 70, 54, 0.15, 'AVAILABLE'),
('CTSP012',  6, 2,  7, 1,  1650000, 12, 0.80, 68, 54, 0.40, 'AVAILABLE'),
('CTSP013',  6, 3,  8, 1,  1650000, 15, 0.82, 70, 56, 0.40, 'AVAILABLE'),
('CTSP014',  7, 1,  9, 5,  1900000,  0, 0.90, 64, 50, 0.35, 'OUT_OF_STOCK'),
('CTSP015',  8, 4, 11, 6,   550000, 50, 0.55, 72, 58, 0.30, 'AVAILABLE');
GO

-- 15. HÌNH ẢNH
INSERT INTO hinh_anh (hinh_anh_code, id_chi_tiet_san_pham, anh_chinh, thu_tu)
VALUES
('IMG001',  1, 1, 1),
('IMG002',  1, 0, 2),
('IMG003',  2, 1, 1),
('IMG004',  3, 1, 1),
('IMG005',  4, 1, 1),
('IMG006',  5, 1, 1),
('IMG007',  6, 1, 1),
('IMG008',  7, 1, 1),
('IMG009',  8, 1, 1),
('IMG010',  9, 1, 1),
('IMG011', 10, 1, 1),
('IMG012', 11, 1, 1),
('IMG013', 12, 1, 1),
('IMG014', 13, 1, 1),
('IMG015', 14, 1, 1),
('IMG016', 15, 1, 1);
GO

-- 16. PHIẾU GIẢM GIÁ
INSERT INTO phieu_giam_gia
    (phieu_giam_gia_code, ten_chuong_trinh, loai_giam, gia_tri_giam,
     gia_tri_don_hang_toi_thieu, giam_toi_da, so_luong, da_su_dung,
     ngay_bat_dau, ngay_ket_thuc, mo_ta, trang_thai)
VALUES
('PGG001', N'Giảm 15% toàn bộ đơn hàng', 0,  15,      2000000, 200000, 100, 32, '2026-06-01', '2026-12-31', N'Áp dụng cho tất cả đơn từ 2 triệu',         1),
('PGG002', N'Khách mới giảm 5%',          0,  5,        800000,   NULL,  120, 58, '2026-04-01', '2026-12-31', N'Ưu đãi dành cho khách hàng mới đăng ký',    1),
('PGG003', N'Thành viên giảm 500K',       1,  500000,  4000000,   NULL,   40, 12, '2026-04-01', '2026-04-28', N'Ưu đãi đặc biệt cho thành viên thân thiết', 2),
('PGG004', N'Ưu đãi vest cưới 20%',       0,  20,      3000000, 500000,   50, 18, '2026-04-01', '2026-12-31', N'Dành cho cặp đôi mua vest cưới',            1),
('PGG005', N'Hỗ trợ vận chuyển 30K',      1,  30000,    500000,   NULL,  200, 87, '2026-04-01', '2026-12-31', N'Giảm phí ship cho đơn từ 500K',             1);
GO

-- 17. HÓA ĐƠN
INSERT INTO hoa_don
    (hoa_don_code, id_khach_hang, id_nhan_vien, id_dia_chi,
     id_phuong_thuc_thanh_toan, id_ma_giam_gia,
     ngay_dat_hang, ngay_xac_nhan,
     ten_khach_hang, sdt_khach_hang, email_khach_hang, dia_chi_khach_hang,
     tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan,
     trang_thai_thanh_toan, trang_thai_don_hang, trang_thai)
VALUES
('HD001',  1, 1,  1, 1, NULL, '2026-06-01 08:30:00', NULL, N'Nguyễn Văn An',   '0901234567', 'an.nguyen@gmail.com',   N'25 Hàng Gai, Hà Nội',           2, 3700000,      0, 3700000, 3700000, 1, 0, 1),
('HD002',  2, 2,  2, 2,    1, '2026-06-03 10:15:00', NULL, N'Trần Thị Bích',   '0912345678', 'bich.tran@gmail.com',   N'88 Lê Lợi, Hồ Chí Minh',       3, 5400000, 810000, 4590000, 4590000, 1, 0, 1),
('HD003',  3, 3,  3, 3, NULL, '2026-06-05 14:00:00', NULL, N'Lê Văn Cường',    '0923456789', 'cuong.le@gmail.com',    N'12 Trần Phú, Đà Nẵng',          1, 1200000,      0, 1200000, 1200000, 1, 0, 1),
('HD004',  4, 1,  4, 1,    5, '2026-06-08 09:00:00', NULL, N'Phạm Thị Dung',   '0934567890', 'dung.pham@yahoo.com',   N'45 Đinh Tiên Hoàng, Hải Phòng', 2, 3100000, 300000, 2800000, 2800000, 1, 0, 1),
('HD005',  5, 2,  5, 2,    2, '2026-06-10 11:30:00', NULL, N'Hoàng Văn Em',    '0945678901', 'em.hoang@gmail.com',    N'78 Nguyễn Trãi, Cần Thơ',       1,  650000,      0,  617500,       0, 0, 0, 1),
('HD006',  6, 3,  6, 1, NULL, '2026-06-12 16:00:00', NULL, N'Ngô Thị Phương',  '0956789012', 'phuong.ngo@gmail.com',  N'99 Đại lộ Bình Dương',           4, 6600000,      0, 6600000, 6600000, 1, 0, 1),
('HD007',  7, 1,  7, 1,    4, '2026-06-15 08:45:00', NULL, N'Đặng Văn Giang',  '0967890123', 'giang.dang@gmail.com',  N'3 Phạm Văn Thuận, Đồng Nai',    3, 4650000, 465000, 4185000, 4185000, 1, 0, 1),
('HD008',  8, 2,  8, 3, NULL, '2026-06-18 13:00:00', NULL, N'Bùi Thị Hà',      '0978901234', 'ha.bui@gmail.com',      N'22 Lê Lợi, Huế',                2, 2900000,      0, 2900000, 2900000, 1, 0, 1),
('HD009',  9, 3,  9, 2,    1, '2026-06-20 10:00:00', NULL, N'Đinh Văn Ính',    '0989012345', 'inh.dinh@gmail.com',    N'56 Yersin, Nha Trang',           1, 1850000, 200000, 1650000,       0, 0, 0, 1),
('HD010', 10, 1, 10, 4, NULL, '2026-06-22 09:30:00', NULL, N'Vũ Thị Kim',      '0990123456', 'kim.vu@gmail.com',      N'7 Trần Hưng Đạo, Quảng Nam',    5, 8250000,      0, 8250000, 8250000, 1, 0, 1),
('HD011', 11, 1, 11, 4,    2, '2026-06-25 11:00:00', NULL, N'Phan Văn Long',   '0901234568', 'long.phan@gmail.com',   N'14 Lý Thái Tổ, Bắc Ninh',       2, 4000000, 500000, 3500000, 3500000, 1, 0, 1),
('HD012', 12, 3, 12, 3, NULL, '2026-06-28 15:30:00', NULL, N'Trịnh Thị Mai',   '0912345679', 'mai.trinh@gmail.com',   N'38 Trần Đăng Ninh, Nam Định',   3, 3750000,      0, 3750000,       0, 0, 0, 1),
('HD013', 13, 2, 13, 1, NULL, '2026-07-01 08:00:00', NULL, N'Cao Văn Nghĩa',   '0923456780', 'nghia.cao@gmail.com',   N'67 Lê Hoàn, Thanh Hóa',         1, 2100000, 300000, 1800000, 1800000, 1, 0, 1),
('HD014', 14, 1, 14, 2, NULL, '2026-07-05 10:30:00', NULL, N'Lý Thị Oanh',     '0934567891', 'oanh.ly@gmail.com',     N'5 Nguyễn Gia Thiều, Nghệ An',   2, 1500000,  75000, 1425000, 1425000, 1, 0, 1),
('HD015', 15, 1, 15, 4, NULL, '2026-07-10 14:00:00', NULL, N'Trương Văn Phúc', '0945678902', 'phuc.truong@gmail.com', N'92 Trần Phú, Hà Tĩnh',           4, 7400000, 740000, 6660000,       0, 0, 0, 1);
GO

-- 18. CHI TIẾT HÓA ĐƠN
INSERT INTO chi_tiet_hoa_don
    (chi_tiet_hoa_don_code, id_hoa_don, id_chi_tiet_san_pham,
     don_gia, gia_giam, so_luong, thanh_tien)
VALUES
('CTHD001',  1,  1, 1850000,      0, 2, 3700000),
('CTHD002',  2,  4,  750000,  67500, 1,  682500),
('CTHD003',  2,  6, 1200000, 108000, 2, 2184000),
('CTHD004',  3,  6, 1200000,      0, 1, 1200000),
('CTHD005',  4, 12, 1650000,      0, 2, 3300000),
('CTHD006',  5, 10,  650000,  32500, 1,  617500),
('CTHD007',  6,  1, 1850000,      0, 2, 3700000),
('CTHD008',  6,  3, 1950000,      0, 1, 1950000),
('CTHD009',  7,  9, 2100000, 210000, 2, 3780000),
('CTHD010',  8,  5,  750000,      0, 2, 1500000),
('CTHD011',  9,  1, 1850000, 200000, 1, 1650000),
('CTHD012', 10, 15,  550000,      0, 5, 2750000),
('CTHD013', 11,  8, 2100000, 500000, 2, 3200000),
('CTHD014', 12,  7, 1200000,      0, 3, 3600000),
('CTHD015', 13,  9, 2100000, 300000, 1, 1800000),
('CTHD016', 14, 11, 1450000,      0, 1, 1450000),
('CTHD017', 15, 13, 1350000,      0, 5, 6750000);
GO

-- 19. LỊCH SỬ HÓA ĐƠN
INSERT INTO lich_su_hoa_don
    (lich_su_hoa_don_code, id_hoa_don, id_nguoi_thuc_hien,
     trang_thai_cu, trang_thai_moi, ghi_chu, thoi_gian_cap_nhat)
VALUES
('LSHD001',  1, 1, 0, 0, N'Tạo đơn hàng', '2026-06-01 08:30:00'),
('LSHD002',  2, 2, 0, 0, N'Tạo đơn hàng', '2026-06-03 10:15:00'),
('LSHD003',  3, 3, 0, 0, N'Tạo đơn hàng', '2026-06-05 14:00:00'),
('LSHD004',  4, 1, 0, 0, N'Tạo đơn hàng', '2026-06-08 09:00:00'),
('LSHD005',  5, 2, 0, 0, N'Tạo đơn hàng', '2026-06-10 11:30:00'),
('LSHD006',  6, 3, 0, 0, N'Tạo đơn hàng', '2026-06-12 16:00:00'),
('LSHD007',  7, 1, 0, 0, N'Tạo đơn hàng', '2026-06-15 08:45:00'),
('LSHD008',  8, 2, 0, 0, N'Tạo đơn hàng', '2026-06-18 13:00:00'),
('LSHD009',  9, 3, 0, 0, N'Tạo đơn hàng', '2026-06-20 10:00:00'),
('LSHD010', 10, 1, 0, 0, N'Tạo đơn hàng', '2026-06-22 09:30:00'),
('LSHD011', 11, 1, 0, 0, N'Tạo đơn hàng', '2026-06-25 11:00:00'),
('LSHD012', 12, 3, 0, 0, N'Tạo đơn hàng', '2026-06-28 15:30:00'),
('LSHD013', 13, 2, 0, 0, N'Tạo đơn hàng', '2026-07-01 08:00:00'),
('LSHD014', 14, 1, 0, 0, N'Tạo đơn hàng', '2026-07-05 10:30:00'),
('LSHD015', 15, 1, 0, 0, N'Tạo đơn hàng', '2026-07-10 14:00:00');
GO

-- 20. LỊCH SỬ THANH TOÁN
INSERT INTO lich_su_thanh_toan
    (lich_su_thanh_toan_code, id_hoa_don, ma_giao_dich_cong,
     so_tien, noi_dung, trang_thai, thoi_gian_giao_dich)
VALUES
('LSTT001',  1, 'TXN20260601001', 3700000, N'Thanh toán tiền mặt - HD001',      1, '2026-06-01 09:05:00'),
('LSTT002',  2, 'VNP20260603001', 4590000, N'Thanh toán VNPay - HD002',         1, '2026-06-03 10:50:00'),
('LSTT003',  3, 'MOM20260605001', 1200000, N'Thanh toán MoMo - HD003',          1, '2026-06-05 14:35:00'),
('LSTT004',  4, 'TXN20260608001', 2800000, N'Thanh toán tiền mặt - HD004',      1, '2026-06-08 09:35:00'),
('LSTT005',  6, 'CK20260612001',  6600000, N'Chuyển khoản MB Bank - HD006',     1, '2026-06-13 07:55:00'),
('LSTT006',  7, 'TXN20260615001', 4185000, N'Thanh toán tiền mặt - HD007',      1, '2026-06-15 09:20:00'),
('LSTT007',  8, 'MOM20260618001', 2900000, N'Thanh toán MoMo - HD008',          1, '2026-06-18 13:50:00'),
('LSTT008', 10, 'ZAL20260622001', 8250000, N'Thanh toán ZaloPay - HD010',       1, '2026-06-22 10:05:00'),
('LSTT009', 11, 'TXN20260625001', 3500000, N'Thanh toán tiền mặt - HD011',      1, '2026-06-25 11:35:00'),
('LSTT010', 13, 'VNP20260701001', 1800000, N'Thanh toán VNPay - HD013',         1, '2026-07-01 08:50:00'),
('LSTT011', 14, 'CK20260705001',  1425000, N'Chuyển khoản Vietcombank - HD014', 1, '2026-07-05 11:05:00'),
('LSTT012',  9, 'VNP20260620001', 1650000, N'VNPay - HD009 - Thất bại',         0, '2026-06-20 10:05:00'),
('LSTT013',  5, 'VNP20260610001',  617500, N'VNPay - HD005 - Thất bại',         0, '2026-06-10 11:35:00'),
('LSTT014', 15, 'VNP20260710001', 6660000, N'VNPay - HD015 - Chờ xử lý',        0, '2026-07-10 14:05:00'),
('LSTT015',  2, 'VNP20260603002',       0, N'Kiểm tra kết nối VNPay - HD002',   0, '2026-06-03 10:47:00');
GO

-- =====================================================================
-- THỐNG KÊ KẾT QUẢ
-- =====================================================================
PRINT N'';
PRINT N'============================================================';
PRINT N'   FamiCoats v3 - Khởi tạo database 3NF thành công!';
PRINT N'============================================================';
GO
