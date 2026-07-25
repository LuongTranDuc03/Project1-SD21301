-- =====================================================================
-- FAMICOATS - FULL DATABASE SCRIPT (v4 - Cải tiến bảo mật & hiệu năng)
-- Hệ CSDL: SQL Server
-- Mô tả: Script đầy đủ tạo database FamiCoats bán áo khoác
-- Changelog từ v3:
--   [1] FLOAT → DECIMAL(18,2)  cho tất cả cột tiền tệ
--   [3] Thêm INDEX trên FK và cột WHERE thường dùng
--   [4] Xóa cột xuat_xu thừa trong san_pham (chỉ giữ id_xuat_xu FK)
--   [5] Chuẩn hóa trang_thai → INT thống nhất ở các bảng lookup
--   [6] Thêm created_at / updated_at vào các bảng chính
--   [7] Thêm UNIQUE constraint cho biến thể sản phẩm
-- Lưu ý [2]: Hash mật khẩu (bcrypt/Argon2) xử lý ở application layer,
--            không thể thực hiện trong SQL. Cột mat_khau chỉ lưu hash.
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
-- PHẦN 1: TẠO TẤT CẢ CÁC BẢNG
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. PHƯƠNG THỨC THANH TOÁN
-- [1] phi_thanh_toan: FLOAT → DECIMAL(18,2)
-- [5] trang_thai: đã là INT, giữ nguyên (nhất quán)
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE phuong_thuc_thanh_toan (
    id                          INT IDENTITY(1,1)  PRIMARY KEY,
    phuong_thuc_thanh_toan_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_phuong_thuc             NVARCHAR(100)      NOT NULL,
    mo_ta                       NVARCHAR(MAX),
    logo                        NVARCHAR(500),
    phi_thanh_toan              DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    trang_thai                  INT                NOT NULL DEFAULT 1,   -- 1: Hoạt động | 0: Ngừng
    created_at                  DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 2. VAI TRÒ
-- [5] trang_thai: đã là INT, giữ nguyên
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE vai_tro (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    code        VARCHAR(50)       NOT NULL UNIQUE,
    ten_vai_tro NVARCHAR(100)     NOT NULL,
    trang_thai  INT               NOT NULL DEFAULT 1,   -- 1: Hoạt động | 0: Ngừng
    created_at  DATETIME          NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 3. ĐỊA CHỈ (dùng chung cho khách hàng & nhân viên)
-- Không có trang_thai (địa chỉ là dữ liệu thuần túy)
-- ---------------------------------------------------------------------
CREATE TABLE dia_chi (
    id               INT IDENTITY(1,1)  PRIMARY KEY,
    dia_chi_code     VARCHAR(50)        NOT NULL UNIQUE,
    tinh             NVARCHAR(150),
    huyen            NVARCHAR(100)      NULL,
    xa               NVARCHAR(150),
    dia_chi_chi_tiet NVARCHAR(500),
    created_at       DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 4. NHÂN VIÊN
-- [2] mat_khau: chỉ lưu hash (bcrypt/Argon2) — xử lý ở app layer
-- [5] trang_thai: đã là INT, giữ nguyên
-- [6] thêm created_at, updated_at
-- ---------------------------------------------------------------------
CREATE TABLE nhan_vien (
    id             INT IDENTITY(1,1)  PRIMARY KEY,
    nhan_vien_code VARCHAR(50)        NOT NULL UNIQUE,
    id_vai_tro     INT                REFERENCES vai_tro(id),
    id_dia_chi     INT                NULL REFERENCES dia_chi(id),
    ten_nhan_vien  NVARCHAR(150)      NOT NULL,
    cccd           VARCHAR(20),
    email          NVARCHAR(200)      NOT NULL UNIQUE,
    mat_khau       VARCHAR(255)       NOT NULL,   -- [2] phải lưu bcrypt/Argon2 hash, KHÔNG plain text
    so_dien_thoai  NVARCHAR(20),
    ngay_sinh      DATE,
    gioi_tinh      BIT,               -- 1: Nam | 0: Nữ
    anh_dai_dien   NVARCHAR(500),
    trang_thai     INT                NOT NULL DEFAULT 1,   -- 1: Đang làm | 0: Nghỉ
    created_at     DATETIME           NOT NULL DEFAULT GETDATE(),  -- [6]
    updated_at     DATETIME           NOT NULL DEFAULT GETDATE()   -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 5. KHÁCH HÀNG
-- [2] mat_khau: chỉ lưu hash (bcrypt/Argon2) — xử lý ở app layer
-- [5] trang_thai: NVARCHAR → INT
-- [6] thêm created_at, updated_at
-- ---------------------------------------------------------------------
CREATE TABLE khach_hang (
    id              INT IDENTITY(1,1)  PRIMARY KEY,
    khach_hang_code VARCHAR(50)        NOT NULL UNIQUE,
    ho_ten          NVARCHAR(100)      NOT NULL,
    email           NVARCHAR(200)      NOT NULL UNIQUE,
    mat_khau        VARCHAR(255)       NOT NULL,   -- [2] phải lưu bcrypt/Argon2 hash, KHÔNG plain text
    so_dien_thoai   NVARCHAR(20)       NOT NULL,
    ngay_sinh       DATE,
    gioi_tinh       NVARCHAR(10),      -- 'Nam' / 'Nữ' / 'Khác'
    anh_dai_dien    NVARCHAR(500),
    trang_thai      INT                NOT NULL DEFAULT 1,   -- [5] 1: Hoạt động | 0: Bị khóa
    created_at      DATETIME           NOT NULL DEFAULT GETDATE(),  -- [6]
    updated_at      DATETIME           NOT NULL DEFAULT GETDATE()   -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 6. KHÁCH HÀNG - ĐỊA CHỈ (bảng trung gian N-N)
-- ---------------------------------------------------------------------
CREATE TABLE khach_hang_dia_chi (
    id            INT IDENTITY(1,1)  PRIMARY KEY,
    id_khach_hang INT                NOT NULL REFERENCES khach_hang(id) ON DELETE CASCADE,
    id_dia_chi    INT                NOT NULL REFERENCES dia_chi(id) ON DELETE CASCADE,
    nguoi_nhan    NVARCHAR(150),
    so_dien_thoai NVARCHAR(20),
    mac_dinh      BIT                NOT NULL DEFAULT 0,
    ghi_chu       NVARCHAR(MAX),
    created_at    DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 7. THƯƠNG HIỆU
-- [5] trang_thai: NVARCHAR → INT
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE thuong_hieu (
    id               INT IDENTITY(1,1)  PRIMARY KEY,
    thuong_hieu_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_thuong_hieu  NVARCHAR(100)      NOT NULL,
    logo             NVARCHAR(500),
    trang_thai       INT                NOT NULL DEFAULT 1,   -- [5] 1: Hoạt động | 0: Ngừng
    created_at       DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 8. DANH MỤC
-- [5] trang_thai: NVARCHAR → INT
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE danh_muc (
    id            INT IDENTITY(1,1)  PRIMARY KEY,
    danh_muc_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_danh_muc  NVARCHAR(100)      NOT NULL,
    trang_thai    INT                NOT NULL DEFAULT 1,   -- [5] 1: Hoạt động | 0: Ngừng
    created_at    DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 9. CHẤT LIỆU
-- [5] trang_thai: NVARCHAR → INT
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE chat_lieu (
    id             INT IDENTITY(1,1)  PRIMARY KEY,
    chat_lieu_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_chat_lieu  NVARCHAR(100)      NOT NULL,
    trang_thai     INT                NOT NULL DEFAULT 1,   -- [5] 1: Hoạt động | 0: Ngừng
    created_at     DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 10. MÀU SẮC
-- [5] trang_thai: NVARCHAR → INT
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE mau_sac (
    id           INT IDENTITY(1,1)  PRIMARY KEY,
    mau_sac_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_mau      NVARCHAR(100)      NOT NULL,
    ma_hex       VARCHAR(20),
    trang_thai   INT                NOT NULL DEFAULT 1,   -- [5] 1: Hoạt động | 0: Ngừng
    created_at   DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 11. KÍCH THƯỚC
-- [5] trang_thai: NVARCHAR → INT
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE kich_thuoc (
    id              INT IDENTITY(1,1)  PRIMARY KEY,
    kich_thuoc_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_kich_thuoc  NVARCHAR(50)       NOT NULL,
    thu_tu          INT                NOT NULL DEFAULT 0,
    trang_thai      INT                NOT NULL DEFAULT 1,   -- [5] 1: Hoạt động | 0: Ngừng
    created_at      DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 12. KIỂU DÁNG
-- [5] trang_thai: NVARCHAR → INT
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE kieu_dang (
    id             INT IDENTITY(1,1)  PRIMARY KEY,
    kieu_dang_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_kieu_dang  NVARCHAR(100)      NOT NULL,
    trang_thai     INT                NOT NULL DEFAULT 1,   -- [5] 1: Hoạt động | 0: Ngừng
    created_at     DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 13. XUẤT XỨ
-- [5] trang_thai: NVARCHAR → INT
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE xuat_xu (
    id           INT IDENTITY(1,1)  PRIMARY KEY,
    xuat_xu_code VARCHAR(50)        NOT NULL UNIQUE,
    ten_xuat_xu  NVARCHAR(100)      NOT NULL,
    trang_thai   INT                NOT NULL DEFAULT 1,   -- [5] 1: Hoạt động | 0: Ngừng
    created_at   DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 14. SẢN PHẨM
-- [1] gia_goc, gia_ban: FLOAT → DECIMAL(18,2)
-- [4] XÓA cột xuat_xu NVARCHAR thừa — chỉ dùng id_xuat_xu FK
-- [5] trang_thai: đổi NVARCHAR thành INT (1: Hoạt động, 0: Ngừng)
-- [6] thêm created_at, updated_at
-- ---------------------------------------------------------------------
CREATE TABLE san_pham (
    id                 INT IDENTITY(1,1)  PRIMARY KEY,
    san_pham_code      VARCHAR(50)        NOT NULL UNIQUE,
    ten_san_pham       NVARCHAR(255)      NOT NULL,
    id_danh_muc        INT                REFERENCES danh_muc(id),
    id_thuong_hieu     INT                REFERENCES thuong_hieu(id),
    id_xuat_xu         INT                REFERENCES xuat_xu(id),       -- [4] chỉ giữ FK này
    mo_ta              NVARCHAR(MAX),
    doi_tuong          NVARCHAR(50),      -- 'Nam' / 'Nữ' / 'Unisex'
    huong_dan_bao_quan NVARCHAR(MAX),
    gia_goc            DECIMAL(18,2)      NOT NULL DEFAULT 0,           -- [1]
    gia_ban            DECIMAL(18,2)      NOT NULL DEFAULT 0,           -- [1]
    da_ban             INT                NOT NULL DEFAULT 0,
    trang_thai         INT                NOT NULL DEFAULT 1,           -- 1: AVAILABLE | 0: OUT_OF_STOCK
    created_at         DATETIME           NOT NULL DEFAULT GETDATE(),   -- [6]
    updated_at         DATETIME           NOT NULL DEFAULT GETDATE()    -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 15. CHI TIẾT SẢN PHẨM (biến thể)
-- [1] gia_goc, gia_ban: FLOAT → DECIMAL(18,2)
-- [6] thêm created_at, updated_at
-- [7] UNIQUE constraint cho tổ hợp (san_pham, kich_thuoc, mau_sac, kieu_dang)
-- ---------------------------------------------------------------------
CREATE TABLE chi_tiet_san_pham (
    id                     INT IDENTITY(1,1)  PRIMARY KEY,
    chi_tiet_san_pham_code VARCHAR(50)        NOT NULL UNIQUE,
    id_san_pham            INT                NOT NULL REFERENCES san_pham(id) ON DELETE CASCADE,
    id_kich_thuoc          INT                REFERENCES kich_thuoc(id),
    id_mau_sac             INT                REFERENCES mau_sac(id),
    id_kieu_dang           INT                REFERENCES kieu_dang(id),
    ma_vach                VARCHAR(100),
    gia_nhap               DECIMAL(18,2)      NOT NULL DEFAULT 0,           -- [1]
    gia_ban                DECIMAL(18,2)      NOT NULL DEFAULT 0,           -- [1]
    so_luong               INT                NOT NULL DEFAULT 0,
    trong_luong            DECIMAL(8,3)       NOT NULL DEFAULT 0,  -- kg (DECIMAL thay FLOAT)
    chieu_dai              DECIMAL(8,2)       NOT NULL DEFAULT 0,  -- cm
    chieu_rong             DECIMAL(8,2)       NOT NULL DEFAULT 0,  -- cm
    do_day                 DECIMAL(8,2)       NOT NULL DEFAULT 0,  -- cm
    trang_thai             INT                NOT NULL DEFAULT 1,           -- 1: AVAILABLE | 0: OUT_OF_STOCK
    created_at             DATETIME           NOT NULL DEFAULT GETDATE(),   -- [6]
    updated_at             DATETIME           NOT NULL DEFAULT GETDATE(),   -- [6]

    -- [7] Không cho phép 2 biến thể trùng màu + size + kiểu dáng trong cùng 1 sản phẩm
    CONSTRAINT UQ_ctsp_variant UNIQUE (id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang)
);
GO

-- ---------------------------------------------------------------------
-- 16. HÌNH ẢNH
-- ---------------------------------------------------------------------
CREATE TABLE hinh_anh (
    id                   INT IDENTITY(1,1)  PRIMARY KEY,
    hinh_anh_code        VARCHAR(50)        NOT NULL UNIQUE,
    id_chi_tiet_san_pham INT                NOT NULL REFERENCES chi_tiet_san_pham(id) ON DELETE CASCADE,
    duong_dan            NVARCHAR(500),
    anh_chinh            BIT                NOT NULL DEFAULT 0,
    thu_tu               INT                NOT NULL DEFAULT 1,
    created_at           DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 17. PHIẾU GIẢM GIÁ
-- [1] gia_tri_giam, gia_tri_don_hang_toi_thieu, giam_toi_da: FLOAT → DECIMAL(18,2)
-- [5] trang_thai: đã là INT, giữ nguyên
-- [6] ngay_tao đã có, thêm updated_at
-- ---------------------------------------------------------------------
CREATE TABLE phieu_giam_gia (
    id                         INT IDENTITY(1,1)  PRIMARY KEY,
    phieu_giam_gia_code        VARCHAR(50)        NOT NULL UNIQUE,
    ten_chuong_trinh           NVARCHAR(255)      NOT NULL,
    loai_giam                  INT                NOT NULL,  -- 0: % | 1: VND cố định
    gia_tri_giam               DECIMAL(18,2)      NOT NULL,  -- [1]
    gia_tri_don_hang_toi_thieu DECIMAL(18,2)      NULL,      -- [1]
    giam_toi_da                DECIMAL(18,2)      NULL,      -- [1]
    so_luong                   INT                NULL,
    da_su_dung                 INT                NOT NULL DEFAULT 0,
    han_su_dung_moi_khach      INT                NOT NULL DEFAULT 1,
    ngay_bat_dau               DATETIME,
    ngay_ket_thuc              DATETIME,
    mo_ta                      NVARCHAR(MAX),
    trang_thai                 INT                NOT NULL DEFAULT 1,
    -- 0: Chưa kích hoạt | 1: Đang áp dụng | 2: Kết thúc | 3: Đã hủy
    created_at                 DATETIME           NOT NULL DEFAULT GETDATE(),  -- [6] (đổi tên từ ngay_tao)
    updated_at                 DATETIME           NOT NULL DEFAULT GETDATE()   -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 18. HÓA ĐƠN
-- [1] tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan, lien_hoan: FLOAT → DECIMAL(18,2)
-- [5] trang_thai_thanh_toan, trang_thai_don_hang, trang_thai: đã là INT
-- [6] thêm updated_at (ngay_dat_hang đã là created_at thực tế)
-- ---------------------------------------------------------------------
CREATE TABLE hoa_don (
    id                        INT IDENTITY(1,1)  PRIMARY KEY,
    hoa_don_code              VARCHAR(50)        NOT NULL UNIQUE,
    id_khach_hang             INT                REFERENCES khach_hang(id),
    id_nhan_vien              INT                REFERENCES nhan_vien(id),
    id_dia_chi                INT                REFERENCES dia_chi(id),
    id_phuong_thuc_thanh_toan INT                REFERENCES phuong_thuc_thanh_toan(id),
    id_ma_giam_gia            INT                REFERENCES phieu_giam_gia(id),
    ngay_dat_hang             DATETIME           NOT NULL DEFAULT GETDATE(),
    ngay_xac_nhan             DATETIME,
    ngay_giao_du_kien         DATETIME,
    ngay_hoan_thanh           DATETIME,
    ten_khach_nhan            NVARCHAR(150),
    sdt_khach_nhan            NVARCHAR(20),
    dia_chi_khach_nhan        NVARCHAR(500),
    dia_chi_snapshot          NVARCHAR(MAX),
    tong_so_luong             INT                NOT NULL DEFAULT 0,
    tam_tinh                  DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    tien_giam_hoa_don         DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    tong_thanh_toan           DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    da_thanh_toan             DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    lien_hoan                 DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    ghi_chu                   NVARCHAR(MAX),
    trang_thai_thanh_toan     INT                NOT NULL DEFAULT 0,   -- 0: Chưa TT | 1: Đã TT
    trang_thai_don_hang       INT                NOT NULL DEFAULT 0,
    -- 0: Chờ xác nhận | 1: Đã xác nhận | 2: Đang giao | 3: Hoàn thành | 4: Đã hủy
    trang_thai                INT                NOT NULL DEFAULT 1,
    updated_at                DATETIME           NOT NULL DEFAULT GETDATE()   -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 19. CHI TIẾT HÓA ĐƠN
-- [1] don_gia, gia_giam, thanh_tien: FLOAT → DECIMAL(18,2)
-- [6] thêm created_at
-- ---------------------------------------------------------------------
CREATE TABLE chi_tiet_hoa_don (
    id                    INT IDENTITY(1,1)  PRIMARY KEY,
    chi_tiet_hoa_don_code VARCHAR(50)        NOT NULL UNIQUE,
    id_hoa_don            INT                NOT NULL REFERENCES hoa_don(id),
    id_chi_tiet_san_pham  INT                REFERENCES chi_tiet_san_pham(id),
    ten_sp_tai_thoi_diem  NVARCHAR(255),
    mo_ta_variant         NVARCHAR(255),
    don_gia               DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    gia_giam              DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    so_luong              INT                NOT NULL DEFAULT 1,
    thanh_tien            DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    ghi_chu               NVARCHAR(MAX),
    created_at            DATETIME           NOT NULL DEFAULT GETDATE()  -- [6]
);
GO

-- ---------------------------------------------------------------------
-- 20. LỊCH SỬ HÓA ĐƠN
-- [5] trang_thai: đã là INT
-- ---------------------------------------------------------------------
CREATE TABLE lich_su_hoa_don (
    id                   INT IDENTITY(1,1)  PRIMARY KEY,
    lich_su_hoa_don_code VARCHAR(50)        NOT NULL UNIQUE,
    id_hoa_don           INT                NOT NULL REFERENCES hoa_don(id),
    id_nguoi_thuc_hien   INT                REFERENCES nhan_vien(id),
    id_khach_hang        INT                REFERENCES khach_hang(id),
    trang_thai_cu        INT                NOT NULL,
    trang_thai_moi       INT                NOT NULL,
    ghi_chu              NVARCHAR(MAX),
    thoi_gian_cap_nhat   DATETIME           NOT NULL DEFAULT GETDATE(),
    trang_thai           INT                NOT NULL DEFAULT 1
);
GO

-- ---------------------------------------------------------------------
-- 21. LỊCH SỬ THANH TOÁN
-- [1] so_tien: FLOAT → DECIMAL(18,2)
-- [5] trang_thai: đã là INT
-- ---------------------------------------------------------------------
CREATE TABLE lich_su_thanh_toan (
    id                      INT IDENTITY(1,1)  PRIMARY KEY,
    lich_su_thanh_toan_code VARCHAR(50)        NOT NULL UNIQUE,
    id_hoa_don              INT                NOT NULL REFERENCES hoa_don(id),
    ma_giao_dich_cong       NVARCHAR(200),
    so_tien                 DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    noi_dung                NVARCHAR(MAX),
    trang_thai              INT                NOT NULL DEFAULT 1,   -- 0: Thất bại | 1: Thành công
    thoi_gian_giao_dich     DATETIME           NOT NULL DEFAULT GETDATE()
);
GO

-- =====================================================================
-- [3] TẠO INDEX
-- Thứ tự: bảng có lưu lượng truy vấn cao nhất trước
-- =====================================================================

-- hoa_don — bảng trung tâm, được JOIN và filter nhiều nhất
CREATE INDEX IX_hoa_don_khach_hang        ON hoa_don (id_khach_hang);
CREATE INDEX IX_hoa_don_nhan_vien         ON hoa_don (id_nhan_vien);
CREATE INDEX IX_hoa_don_trang_thai_don    ON hoa_don (trang_thai_don_hang);
CREATE INDEX IX_hoa_don_trang_thai_tt     ON hoa_don (trang_thai_thanh_toan);
CREATE INDEX IX_hoa_don_ngay_dat          ON hoa_don (ngay_dat_hang);
CREATE INDEX IX_hoa_don_ma_giam_gia       ON hoa_don (id_ma_giam_gia);
GO

-- chi_tiet_hoa_don — JOIN với hoa_don thường xuyên
CREATE INDEX IX_cthd_hoa_don             ON chi_tiet_hoa_don (id_hoa_don);
CREATE INDEX IX_cthd_ctsp                ON chi_tiet_hoa_don (id_chi_tiet_san_pham);
GO

-- chi_tiet_san_pham — lọc theo sản phẩm, màu, size
CREATE INDEX IX_ctsp_san_pham            ON chi_tiet_san_pham (id_san_pham);
CREATE INDEX IX_ctsp_mau_sac             ON chi_tiet_san_pham (id_mau_sac);
CREATE INDEX IX_ctsp_kich_thuoc          ON chi_tiet_san_pham (id_kich_thuoc);
CREATE INDEX IX_ctsp_trang_thai          ON chi_tiet_san_pham (trang_thai);
GO

-- san_pham — tìm kiếm theo danh mục, thương hiệu, xuất xứ
CREATE INDEX IX_sp_danh_muc              ON san_pham (id_danh_muc);
CREATE INDEX IX_sp_thuong_hieu           ON san_pham (id_thuong_hieu);
CREATE INDEX IX_sp_xuat_xu               ON san_pham (id_xuat_xu);
CREATE INDEX IX_sp_trang_thai            ON san_pham (trang_thai);
GO

-- hinh_anh — lấy ảnh theo biến thể sản phẩm
CREATE INDEX IX_hinh_anh_ctsp            ON hinh_anh (id_chi_tiet_san_pham);
GO

-- khach_hang_dia_chi — lấy địa chỉ theo khách hàng
CREATE INDEX IX_kh_dia_chi_khach_hang    ON khach_hang_dia_chi (id_khach_hang);
GO

-- lich_su_hoa_don & lich_su_thanh_toan — tra cứu theo hóa đơn
CREATE INDEX IX_lshd_hoa_don             ON lich_su_hoa_don (id_hoa_don);
CREATE INDEX IX_lstt_hoa_don             ON lich_su_thanh_toan (id_hoa_don);
GO

-- nhan_vien — lọc theo vai trò
CREATE INDEX IX_nhan_vien_vai_tro        ON nhan_vien (id_vai_tro);
GO


-- =====================================================================
-- PHẦN 2: THÊM DỮ LIỆU MẪU (INSERT INTO)
-- Lưu ý: mat_khau trong môi trường thực PHẢI là giá trị đã hash.
--        Ở đây dùng chuỗi gợi nhắc để rõ ràng.
-- =====================================================================

-- 1. PHƯƠNG THỨC THANH TOÁN
INSERT INTO phuong_thuc_thanh_toan
    (phuong_thuc_thanh_toan_code, ten_phuong_thuc, mo_ta, logo, phi_thanh_toan, trang_thai)
VALUES
('PTTT001', N'Tiền mặt',  N'Thanh toán trực tiếp bằng tiền mặt', NULL,          0.00, 1),
('PTTT002', N'VNPay',     N'Thanh toán qua ví VNPay',             'vnpay.png',   0.00, 1),
('PTTT003', N'MoMo',      N'Thanh toán qua ví điện tử MoMo',      'momo.png',    0.00, 1),
('PTTT004', N'ZaloPay',   N'Thanh toán qua ví ZaloPay',           'zalopay.png', 0.00, 1);
GO

-- 2. VAI TRÒ
INSERT INTO vai_tro (code, ten_vai_tro, trang_thai) VALUES
('ROLE01', N'Quản lý',   1),
('ROLE02', N'Nhân viên', 1);
GO

-- 3. ĐỊA CHỈ
INSERT INTO dia_chi (dia_chi_code, tinh, huyen, xa, dia_chi_chi_tiet) VALUES
('DC001', N'Hà Nội',      N'Quận Hoàn Kiếm',  N'Phường Hàng Gai',   N'25 Hàng Gai'),
('DC002', N'Hồ Chí Minh', N'Quận 1',          N'Phường Bến Nghé',   N'88 Lê Lợi'),
('DC003', N'Đà Nẵng',     N'Quận Hải Châu',   N'Phường Hải Châu 1', N'12 Trần Phú'),
('DC004', N'Hải Phòng',   N'Quận Ngô Quyền',  N'Phường Máy Tơ',     N'45 Đinh Tiên Hoàng'),
('DC005', N'Cần Thơ',     N'Quận Ninh Kiều',  N'Phường Tân An',     N'78 Nguyễn Trãi'),
('DC006', N'Bình Dương',  N'TP Thủ Dầu Một',  N'Phường Phú Lợi',   N'99 Đại lộ Bình Dương'),
('DC007', N'Đồng Nai',    N'TP Biên Hòa',     N'Phường Trung Dũng', N'3 Phạm Văn Thuận'),
('DC008', N'Huế',         N'TP Huế',           N'Phường Phú Hội',   N'22 Lê Lợi'),
('DC009', N'Nha Trang',   N'TP Nha Trang',     N'Phường Lộc Thọ',   N'56 Yersin'),
('DC010', N'Quảng Nam',   N'TP Hội An',        N'Phường Minh An',   N'7 Trần Hưng Đạo'),
('DC011', N'Bắc Ninh',    N'TP Bắc Ninh',      N'Phường Vũ Ninh',   N'14 Lý Thái Tổ'),
('DC012', N'Nam Định',    N'TP Nam Định',       N'Phường Ngô Quyền', N'38 Trần Đăng Ninh'),
('DC013', N'Thanh Hóa',   N'TP Thanh Hóa',     N'Phường Điện Biên', N'67 Lê Hoàn'),
('DC014', N'Nghệ An',     N'TP Vinh',           N'Phường Lê Mao',    N'5 Nguyễn Gia Thiều'),
('DC015', N'Hà Tĩnh',     N'TP Hà Tĩnh',        N'Phường Nam Hà',    N'92 Trần Phú'),
('DC016', N'Hà Nội',      N'Quận Cầu Giấy',   N'Phường Dịch Vọng', N'100 Cầu Giấy'),
('DC017', N'Hà Nội',      N'Quận Đống Đa',    N'Phường Láng Hạ',   N'50 Láng Hạ'),
('DC018', N'Hà Nội',      N'Quận Thanh Xuân', N'Phường Nhân Chính',N'12 Nguyễn Trãi');
GO

-- 4. NHÂN VIÊN
-- [2] mat_khau phải được hash ở app trước khi INSERT. Dùng placeholder rõ ràng.
INSERT INTO nhan_vien
    (nhan_vien_code, id_vai_tro, id_dia_chi, ten_nhan_vien, cccd, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, trang_thai)
VALUES
('NV001', 1, 16, N'Nguyễn Văn Phúc', '001099123456', 'phuc@famicoats.com',  '$2b$12$PLACEHOLDER_HASH_NV001', '0988888888', '1998-03-15', 1, 1),
('NV002', 1, 17, N'Lê Minh Đức',     '002099234567', 'duc@famicoats.com',   '$2b$12$PLACEHOLDER_HASH_NV002', '0911111111', '1997-07-22', 1, 1),
('NV003', 2, 18, N'Trần Đại Lương',  '003099345678', 'luong@famicoats.com', '$2b$12$PLACEHOLDER_HASH_NV003', '0922222222', '1999-01-10', 1, 1);
GO

-- 5. KHÁCH HÀNG
-- [2] mat_khau phải được hash ở app trước khi INSERT.
-- [5] trang_thai đổi thành INT: 1 = Hoạt động
INSERT INTO khach_hang
    (khach_hang_code, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, trang_thai)
VALUES
('KH001', N'Nguyễn Văn An',   'an.nguyen@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH001', '0901234567', '1995-05-20', N'Nam', 1),
('KH002', N'Trần Thị Bích',   'bich.tran@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH002', '0912345678', '1998-10-15', N'Nữ',  1),
('KH003', N'Lê Văn Cường',    'cuong.le@gmail.com',    '$2b$12$PLACEHOLDER_HASH_KH003', '0923456789', '1993-03-08', N'Nam', 1),
('KH004', N'Phạm Thị Dung',   'dung.pham@yahoo.com',   '$2b$12$PLACEHOLDER_HASH_KH004', '0934567890', '2000-12-05', N'Nữ',  1),
('KH005', N'Hoàng Văn Em',    'em.hoang@gmail.com',    '$2b$12$PLACEHOLDER_HASH_KH005', '0945678901', '1990-07-14', N'Nam', 1),
('KH006', N'Ngô Thị Phương',  'phuong.ngo@gmail.com',  '$2b$12$PLACEHOLDER_HASH_KH006', '0956789012', '1997-02-28', N'Nữ',  1),
('KH007', N'Đặng Văn Giang',  'giang.dang@gmail.com',  '$2b$12$PLACEHOLDER_HASH_KH007', '0967890123', '1994-09-30', N'Nam', 1),
('KH008', N'Bùi Thị Hà',      'ha.bui@gmail.com',      '$2b$12$PLACEHOLDER_HASH_KH008', '0978901234', '1999-06-17', N'Nữ',  1),
('KH009', N'Đinh Văn Ính',    'inh.dinh@gmail.com',    '$2b$12$PLACEHOLDER_HASH_KH009', '0989012345', '1992-11-03', N'Nam', 1),
('KH010', N'Vũ Thị Kim',      'kim.vu@gmail.com',      '$2b$12$PLACEHOLDER_HASH_KH010', '0990123456', '1996-04-25', N'Nữ',  1),
('KH011', N'Phan Văn Long',   'long.phan@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH011', '0901234568', '1988-08-12', N'Nam', 1),
('KH012', N'Trịnh Thị Mai',   'mai.trinh@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH012', '0912345679', '2001-01-20', N'Nữ',  1),
('KH013', N'Cao Văn Nghĩa',   'nghia.cao@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH013', '0923456780', '1991-05-05', N'Nam', 1),
('KH014', N'Lý Thị Oanh',     'oanh.ly@gmail.com',     '$2b$12$PLACEHOLDER_HASH_KH014', '0934567891', '1998-03-22', N'Nữ',  1),
('KH015', N'Trương Văn Phúc', 'phuc.truong@gmail.com', '$2b$12$PLACEHOLDER_HASH_KH015', '0945678902', '1995-12-10', N'Nam', 1);
GO

-- 6. KHÁCH HÀNG - ĐỊA CHỈ
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

-- 7. THƯƠNG HIỆU — [5] trang_thai đổi thành INT
INSERT INTO thuong_hieu (thuong_hieu_code, ten_thuong_hieu, trang_thai)
VALUES
('BR001', N'FamiCoats',      1),
('BR002', N'Zara',           1),
('BR003', N'Levi''s',        1),
('BR004', N'Uniqlo',         1),
('BR005', N'The North Face', 1);
GO

-- 8. DANH MỤC — [5] trang_thai đổi thành INT
INSERT INTO danh_muc (danh_muc_code, ten_danh_muc, trang_thai)
VALUES
('CAT001', N'Áo khoác da',  1),
('CAT002', N'Áo bomber',    1),
('CAT003', N'Áo denim',     1),
('CAT004', N'Áo phao',      1),
('CAT005', N'Áo khoác len', 1),
('CAT006', N'Áo khoác gió', 1),
('CAT007', N'Trench coat',  1),
('CAT008', N'Áo hoodie',    1);
GO

-- 9. CHẤT LIỆU — [5] trang_thai đổi thành INT
INSERT INTO chat_lieu (chat_lieu_code, ten_chat_lieu, trang_thai)
VALUES
('MAT001', N'Da cừu',       1),
('MAT002', N'Vải gió',      1),
('MAT003', N'Denim',        1),
('MAT004', N'Lông vũ',      1),
('MAT005', N'Len cao cấp',  1),
('MAT006', N'Nỉ bông',      1),
('MAT007', N'Lông cừu giả', 1),
('MAT008', N'Da tổng hợp',  1);
GO

-- 10. MÀU SẮC — [5] trang_thai đổi thành INT
INSERT INTO mau_sac (mau_sac_code, ten_mau, trang_thai)
VALUES
('MS001', N'Đen',       1),
('MS002', N'Nâu',       1),
('MS003', N'Xanh nhạt', 1),
('MS004', N'Kem',       1),
('MS005', N'Xám',       1),
('MS006', N'Olive',     1),
('MS007', N'Trắng',     1),
('MS008', N'Hồng nhạt', 1),
('MS009', N'Be',        1),
('MS010', N'Xanh navy', 1),
('MS011', N'Xám đậm',   1);
GO

-- 11. KÍCH THƯỚC — [5] trang_thai đổi thành INT
INSERT INTO kich_thuoc (kich_thuoc_code, ten_kich_thuoc, thu_tu, trang_thai)
VALUES
('KT001', N'S',   1, 1),
('KT002', N'M',   2, 1),
('KT003', N'L',   3, 1),
('KT004', N'XL',  4, 1),
('KT005', N'XXL', 5, 1);
GO

-- 12. KIỂU DÁNG — [5] trang_thai đổi thành INT
INSERT INTO kieu_dang (kieu_dang_code, ten_kieu_dang, trang_thai)
VALUES
('KD001', N'Regular',   1),
('KD002', N'Oversize',  1),
('KD003', N'Slim',      1),
('KD004', N'Fitted',    1),
('KD005', N'Classic',   1),
('KD006', N'Oversized', 1);
GO

-- 13. XUẤT XỨ — [5] trang_thai đổi thành INT
INSERT INTO xuat_xu (xuat_xu_code, ten_xuat_xu, trang_thai)
VALUES
('XX001', N'Việt Nam',   1),
('XX002', N'Nhật Bản',   1),
('XX003', N'Hàn Quốc',   1),
('XX004', N'Trung Quốc', 1),
('XX005', N'Ý',          1),
('XX006', N'Pháp',       1),
('XX007', N'Nhập khẩu',  1);
GO

-- 14. SẢN PHẨM
-- [4] Bỏ cột xuat_xu NVARCHAR thừa — chỉ truyền id_xuat_xu
-- [1] gia_ban dùng DECIMAL
INSERT INTO san_pham
    (san_pham_code, ten_san_pham, id_danh_muc, id_thuong_hieu, id_xuat_xu,
     mo_ta, doi_tuong, huong_dan_bao_quan,
     gia_ban, da_ban, trang_thai)
VALUES
('SP001', N'Áo khoác da nam cao cấp',         1, 1, 1, N'Chất liệu da thật cao cấp, lót lông ấm',            N'Nam',    N'Chỉ giặt khô',    1850000.00, 120, 1),
('SP002', N'Áo khoác denim nữ thời trang',    3, 1, 1, N'Denim nhập khẩu, form rộng thoải mái',              N'Nữ',     N'Giặt riêng màu',   750000.00,  95,  1),
('SP003', N'Áo khoác bomber unisex',           2, 1, 1, N'Kiểu dáng bomber năng động, chống gió',             N'Unisex', N'Giặt máy nhẹ',    1200000.00,  78,  1),
('SP004', N'Áo khoác len nữ công sở',          5, 1, 1, N'Len cao cấp, thiết kế thanh lịch',                  N'Nữ',     N'Giặt khô',        2100000.00,  45,  1),
('SP005', N'Áo khoác gió nam thể thao',        6, 1, 1, N'Chống gió, chống mưa nhẹ, trọng lượng nhẹ',        N'Nam',    N'Giặt máy thường',  650000.00, 210,  1),
('SP006', N'Áo khoác lông vũ nữ giữ nhiệt',   4, 1, 2, N'Lông vũ thiên nhiên, giữ ấm tối ưu',               N'Nữ',     N'Giặt máy nhẹ',    1650000.00,  88,  1),
('SP007', N'Áo khoác trench coat nữ',          7, 1, 1, N'Trench coat cổ điển, thích hợp công sở',            N'Nữ',     N'Giặt khô',        1900000.00,  55,  1),
('SP008', N'Áo khoác hoodie nam thường ngày',  8, 1, 1, N'Nỉ bông dày dặn, nón liền kiểu dáng trẻ trung',    N'Nam',    N'Giặt máy thường',  550000.00, 320,  1),
('SP009', N'Áo khoác parka nam đông',          1, 1, 7, N'Parka cao cấp, chịu lạnh cực tốt',                  N'Nam',    N'Giặt khô',        2800000.00,  32,  0),
('SP010', N'Áo khoác varsity unisex phối màu', 2, 1, 1, N'Varsity jacket phong cách retro',                   N'Unisex', N'Giặt máy nhẹ',     980000.00, 140,  1),
('SP011', N'Áo khoác blazer nữ thanh lịch',   5, 1, 1, N'Blazer form slim, phù hợp công sở và dạo phố',     N'Nữ',     N'Giặt khô',        1450000.00,  68,  1),
('SP012', N'Áo khoác jean nam wash cũ',        3, 1, 1, N'Denim wash cũ phong cách vintage',                  N'Nam',    N'Giặt riêng màu',   820000.00, 180,  1),
('SP013', N'Áo khoác lông cừu nữ mùa đông',   4, 1, 1, N'Lông cừu giả mềm mịn, cực ấm mùa đông',           N'Nữ',     N'Giặt máy nhẹ',    1350000.00,  95,  1),
('SP014', N'Áo khoác military nam',            6, 1, 1, N'Phong cách military cá tính, nhiều túi tiện dụng', N'Nam',    N'Giặt máy thường', 1100000.00,  75,  1),
('SP015', N'Áo khoác cape nữ sang trọng',      7, 1, 7, N'Cape coat da cao cấp, dáng độc đáo',               N'Nữ',     N'Chỉ giặt khô',    2500000.00,  18,  0);
GO

-- 15. CHI TIẾT SẢN PHẨM
-- [1] gia_ban dùng DECIMAL
-- [7] UNIQUE constraint đã được khai báo ở DDL — dữ liệu không vi phạm
INSERT INTO chi_tiet_san_pham
    (chi_tiet_san_pham_code, id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang,
     gia_nhap, gia_ban, so_luong, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai)
VALUES
('CTSP001',  1, 2,  1, 1,  1200000.00, 1850000.00, 15, 0.900, 70, 55, 0.30, 1),
('CTSP002',  1, 3,  1, 1,  1200000.00, 1850000.00, 12, 0.950, 72, 57, 0.30, 1),
('CTSP003',  1, 4,  2, 1,  1300000.00, 1950000.00,  8, 1.000, 74, 59, 0.30, 1),
('CTSP004',  2, 1,  3, 2,   450000.00,  750000.00, 20, 0.500, 65, 50, 0.20, 1),
('CTSP005',  2, 2,  3, 2,   450000.00,  750000.00, 25, 0.520, 67, 52, 0.20, 1),
('CTSP006',  3, 2,  1, 3,   750000.00, 1200000.00, 10, 0.650, 68, 54, 0.25, 1),
('CTSP007',  3, 3,  6, 3,   750000.00, 1200000.00, 10, 0.680, 70, 56, 0.25, 1),
('CTSP008',  4, 1,  4, 4,  1350000.00, 2100000.00,  8, 0.850, 66, 52, 0.35, 1),
('CTSP009',  4, 2,  5, 4,  1350000.00, 2100000.00,  6, 0.880, 68, 54, 0.35, 1),
('CTSP010',  5, 2,  1, 1,   400000.00,  650000.00, 30, 0.350, 68, 52, 0.15, 1),
('CTSP011',  5, 3, 10, 1,   400000.00,  650000.00, 35, 0.370, 70, 54, 0.15, 1),
('CTSP012',  6, 2,  7, 1,  1050000.00, 1650000.00, 12, 0.800, 68, 54, 0.40, 1),
('CTSP013',  6, 3,  8, 1,  1050000.00, 1650000.00, 15, 0.820, 70, 56, 0.40, 1),
('CTSP014',  7, 1,  9, 5,  1200000.00, 1900000.00,  0, 0.900, 64, 50, 0.35, 0),
('CTSP015',  8, 4, 11, 6,   320000.00,  550000.00, 50, 0.550, 72, 58, 0.30, 1),
('CTSP016',  9, 3,  1, 2,  1800000.00, 2800000.00, 15, 1.200, 80, 60, 0.50, 1),
('CTSP017',  9, 4,  6, 2,  1800000.00, 2800000.00, 10, 1.250, 82, 62, 0.50, 1),
('CTSP018', 10, 2, 10, 1,   600000.00,  980000.00, 25, 0.700, 68, 54, 0.25, 1),
('CTSP019', 10, 3,  1, 1,   600000.00,  980000.00, 30, 0.720, 70, 56, 0.25, 1),
('CTSP020', 11, 1,  4, 3,   900000.00, 1450000.00, 18, 0.600, 66, 48, 0.20, 1),
('CTSP021', 11, 2,  5, 3,   900000.00, 1450000.00, 22, 0.620, 68, 50, 0.20, 1),
('CTSP022', 12, 2,  3, 5,   500000.00,  820000.00, 35, 0.750, 67, 52, 0.25, 1),
('CTSP023', 12, 3,  3, 5,   500000.00,  820000.00, 40, 0.780, 69, 54, 0.25, 1),
('CTSP024', 13, 2,  9, 2,   850000.00, 1350000.00, 16, 0.850, 70, 55, 0.40, 1),
('CTSP025', 14, 3,  6, 1,   700000.00, 1100000.00, 20, 0.800, 72, 56, 0.30, 1),
('CTSP026', 15, 2,  1, 4,  1600000.00, 2500000.00, 12, 0.950, 75, 58, 0.35, 1);
GO

-- 16. HÌNH ẢNH
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
('IMG016', 15, 1, 1),
('IMG017', 16, 1, 1),
('IMG018', 17, 1, 1),
('IMG019', 18, 1, 1),
('IMG020', 19, 1, 1),
('IMG021', 20, 1, 1),
('IMG022', 21, 1, 1),
('IMG023', 22, 1, 1),
('IMG024', 23, 1, 1),
('IMG025', 24, 1, 1),
('IMG026', 25, 1, 1),
('IMG027', 26, 1, 1);
GO

-- 17. PHIẾU GIẢM GIÁ — [1] giá trị tiền dùng DECIMAL
INSERT INTO phieu_giam_gia
    (phieu_giam_gia_code, ten_chuong_trinh, loai_giam, gia_tri_giam,
     gia_tri_don_hang_toi_thieu, giam_toi_da, so_luong, da_su_dung,
     ngay_bat_dau, ngay_ket_thuc, mo_ta, trang_thai)
VALUES
('PGG001', N'Giảm 15% toàn bộ đơn hàng', 0,     15.00, 2000000.00, 200000.00, 100, 32, '2026-06-01', '2026-12-31', N'Áp dụng cho tất cả đơn từ 2 triệu',         1),
('PGG002', N'Khách mới giảm 5%',          0,      5.00,  800000.00,       NULL, 120, 58, '2026-04-01', '2026-12-31', N'Ưu đãi dành cho khách hàng mới đăng ký',    1),
('PGG003', N'Thành viên giảm 500K',       1, 500000.00, 4000000.00,       NULL,  40, 12, '2026-04-01', '2026-04-28', N'Ưu đãi đặc biệt cho thành viên thân thiết', 2),
('PGG004', N'Ưu đãi vest cưới 20%',       0,     20.00, 3000000.00, 500000.00,  50, 18, '2026-04-01', '2026-12-31', N'Dành cho cặp đôi mua vest cưới',            1),
('PGG005', N'Hỗ trợ vận chuyển 30K',      1,  30000.00,  500000.00,       NULL, 200, 87, '2026-04-01', '2026-12-31', N'Giảm phí ship cho đơn từ 500K',             1);
GO

-- 18. HÓA ĐƠN — [1] các cột tiền dùng DECIMAL
INSERT INTO hoa_don
    (hoa_don_code, id_khach_hang, id_nhan_vien, id_dia_chi,
     id_phuong_thuc_thanh_toan, id_ma_giam_gia,
     ngay_dat_hang, ngay_xac_nhan,
     ten_khach_nhan, sdt_khach_nhan, dia_chi_khach_nhan,
     tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan,
     trang_thai_thanh_toan, trang_thai_don_hang, trang_thai)
VALUES
('HD001',  1, 1,  1, 1, NULL, '2026-06-01 08:30:00', NULL, N'Nguyễn Văn An',   '0901234567', N'25 Hàng Gai, Hà Nội',           2, 3700000.00,      0.00, 3700000.00, 3700000.00, 1, 0, 1),
('HD002',  2, 2,  2, 2,    1, '2026-06-03 10:15:00', NULL, N'Trần Thị Bích',   '0912345678', N'88 Lê Lợi, Hồ Chí Minh',       3, 5400000.00, 810000.00, 4590000.00, 4590000.00, 1, 0, 1),
('HD003',  3, 3,  3, 3, NULL, '2026-06-05 14:00:00', NULL, N'Lê Văn Cường',    '0923456789', N'12 Trần Phú, Đà Nẵng',          1, 1200000.00,      0.00, 1200000.00, 1200000.00, 1, 0, 1),
('HD004',  4, 1,  4, 1,    5, '2026-06-08 09:00:00', NULL, N'Phạm Thị Dung',   '0934567890', N'45 Đinh Tiên Hoàng, Hải Phòng', 2, 3100000.00,  30000.00, 2800000.00, 2800000.00, 1, 0, 1),
('HD005',  5, 2,  5, 2,    2, '2026-06-10 11:30:00', NULL, N'Hoàng Văn Em',    '0945678901', N'78 Nguyễn Trãi, Cần Thơ',       1,  650000.00,      0.00,  617500.00,       0.00, 0, 0, 1),
('HD006',  6, 3,  6, 1, NULL, '2026-06-12 16:00:00', NULL, N'Ngô Thị Phương',  '0956789012', N'99 Đại lộ Bình Dương',           4, 6600000.00,      0.00, 6600000.00, 6600000.00, 1, 0, 1),
('HD007',  7, 1,  7, 1,    4, '2026-06-15 08:45:00', NULL, N'Đặng Văn Giang',  '0967890123', N'3 Phạm Văn Thuận, Đồng Nai',    3, 4650000.00, 465000.00, 4185000.00, 4185000.00, 1, 0, 1),
('HD008',  8, 2,  8, 3, NULL, '2026-06-18 13:00:00', NULL, N'Bùi Thị Hà',      '0978901234', N'22 Lê Lợi, Huế',                2, 2900000.00,      0.00, 2900000.00, 2900000.00, 1, 0, 1),
('HD009',  9, 3,  9, 2,    1, '2026-06-20 10:00:00', NULL, N'Đinh Văn Ính',    '0989012345', N'56 Yersin, Nha Trang',           1, 1850000.00, 200000.00, 1650000.00,       0.00, 0, 0, 1),
('HD010', 10, 1, 10, 4, NULL, '2026-06-22 09:30:00', NULL, N'Vũ Thị Kim',      '0990123456', N'7 Trần Hưng Đạo, Quảng Nam',    5, 8250000.00,      0.00, 8250000.00, 8250000.00, 1, 0, 1),
('HD011', 11, 1, 11, 4,    2, '2026-06-25 11:00:00', NULL, N'Phan Văn Long',   '0901234568', N'14 Lý Thái Tổ, Bắc Ninh',       2, 4000000.00, 500000.00, 3500000.00, 3500000.00, 1, 0, 1),
('HD012', 12, 3, 12, 3, NULL, '2026-06-28 15:30:00', NULL, N'Trịnh Thị Mai',   '0912345679', N'38 Trần Đăng Ninh, Nam Định',   3, 3750000.00,      0.00, 3750000.00,       0.00, 0, 0, 1),
('HD013', 13, 2, 13, 1, NULL, '2026-07-01 08:00:00', NULL, N'Cao Văn Nghĩa',   '0923456780', N'67 Lê Hoàn, Thanh Hóa',         1, 2100000.00, 300000.00, 1800000.00, 1800000.00, 1, 0, 1),
('HD014', 14, 1, 14, 2, NULL, '2026-07-05 10:30:00', NULL, N'Lý Thị Oanh',     '0934567891', N'5 Nguyễn Gia Thiều, Nghệ An',   2, 1500000.00,  75000.00, 1425000.00, 1425000.00, 1, 0, 1),
('HD015', 15, 1, 15, 4, NULL, '2026-07-10 14:00:00', NULL, N'Trương Văn Phúc', '0945678902', N'92 Trần Phú, Hà Tĩnh',           4, 7400000.00, 740000.00, 6660000.00,       0.00, 0, 0, 1);
GO

-- 19. CHI TIẾT HÓA ĐƠN — [1] cột tiền dùng DECIMAL
INSERT INTO chi_tiet_hoa_don
    (chi_tiet_hoa_don_code, id_hoa_don, id_chi_tiet_san_pham,
     don_gia, gia_giam, so_luong, thanh_tien)
VALUES
('CTHD001',  1,  1, 1850000.00,      0.00, 2, 3700000.00),
('CTHD002',  2,  4,  750000.00,  67500.00, 1,  682500.00),
('CTHD003',  2,  6, 1200000.00, 108000.00, 2, 2184000.00),
('CTHD004',  3,  6, 1200000.00,      0.00, 1, 1200000.00),
('CTHD005',  4, 12, 1650000.00,      0.00, 2, 3300000.00),
('CTHD006',  5, 10,  650000.00,  32500.00, 1,  617500.00),
('CTHD007',  6,  1, 1850000.00,      0.00, 2, 3700000.00),
('CTHD008',  6,  3, 1950000.00,      0.00, 1, 1950000.00),
('CTHD009',  7,  9, 2100000.00, 210000.00, 2, 3780000.00),
('CTHD010',  8,  5,  750000.00,      0.00, 2, 1500000.00),
('CTHD011',  9,  1, 1850000.00, 200000.00, 1, 1650000.00),
('CTHD012', 10, 15,  550000.00,      0.00, 5, 2750000.00),
('CTHD013', 11,  8, 2100000.00, 500000.00, 2, 3200000.00),
('CTHD014', 12,  7, 1200000.00,      0.00, 3, 3600000.00),
('CTHD015', 13,  9, 2100000.00, 300000.00, 1, 1800000.00),
('CTHD016', 14, 11, 1450000.00,      0.00, 1, 1450000.00),
('CTHD017', 15, 13, 1350000.00,      0.00, 5, 6750000.00);
GO

-- 20. LỊCH SỬ HÓA ĐƠN
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

-- 21. LỊCH SỬ THANH TOÁN — [1] so_tien dùng DECIMAL
INSERT INTO lich_su_thanh_toan
    (lich_su_thanh_toan_code, id_hoa_don, ma_giao_dich_cong,
     so_tien, noi_dung, trang_thai, thoi_gian_giao_dich)
VALUES
('LSTT001',  1, 'TXN20260601001', 3700000.00, N'Thanh toán tiền mặt - HD001',      1, '2026-06-01 09:05:00'),
('LSTT002',  2, 'VNP20260603001', 4590000.00, N'Thanh toán VNPay - HD002',         1, '2026-06-03 10:50:00'),
('LSTT003',  3, 'MOM20260605001', 1200000.00, N'Thanh toán MoMo - HD003',          1, '2026-06-05 14:35:00'),
('LSTT004',  4, 'TXN20260608001', 2800000.00, N'Thanh toán tiền mặt - HD004',      1, '2026-06-08 09:35:00'),
('LSTT005',  6, 'CK20260612001',  6600000.00, N'Chuyển khoản MB Bank - HD006',     1, '2026-06-13 07:55:00'),
('LSTT006',  7, 'TXN20260615001', 4185000.00, N'Thanh toán tiền mặt - HD007',      1, '2026-06-15 09:20:00'),
('LSTT007',  8, 'MOM20260618001', 2900000.00, N'Thanh toán MoMo - HD008',          1, '2026-06-18 13:50:00'),
('LSTT008', 10, 'ZAL20260622001', 8250000.00, N'Thanh toán ZaloPay - HD010',       1, '2026-06-22 10:05:00'),
('LSTT009', 11, 'TXN20260625001', 3500000.00, N'Thanh toán tiền mặt - HD011',      1, '2026-06-25 11:35:00'),
('LSTT010', 13, 'VNP20260701001', 1800000.00, N'Thanh toán VNPay - HD013',         1, '2026-07-01 08:50:00'),
('LSTT011', 14, 'CK20260705001',  1425000.00, N'Chuyển khoản Vietcombank - HD014', 1, '2026-07-05 11:05:00'),
('LSTT012',  9, 'VNP20260620001', 1650000.00, N'VNPay - HD009 - Thất bại',         0, '2026-06-20 10:05:00'),
('LSTT013',  5, 'VNP20260610001',  617500.00, N'VNPay - HD005 - Thất bại',         0, '2026-06-10 11:35:00'),
('LSTT014', 15, 'VNP20260710001', 6660000.00, N'VNPay - HD015 - Chờ xử lý',        0, '2026-07-10 14:05:00'),
('LSTT015',  2, 'VNP20260603002',       0.00, N'Kiểm tra kết nối VNPay - HD002',   0, '2026-06-03 10:47:00');
GO

-- =====================================================================
-- THỐNG KÊ KẾT QUẢ
-- =====================================================================
PRINT N'';
PRINT N'============================================================';
PRINT N'   FamiCoats v4 - Khởi tạo database thành công!';
PRINT N'   Các cải tiến đã áp dụng:';
PRINT N'   [1] FLOAT → DECIMAL(18,2) cho tất cả cột tiền tệ';
PRINT N'   [3] INDEX được tạo cho FK và cột WHERE thường dùng';
PRINT N'   [4] Xóa cột xuat_xu thừa trong san_pham';
PRINT N'   [5] trang_thai chuẩn hóa về INT ở các bảng lookup';
PRINT N'   [6] Thêm created_at / updated_at vào các bảng chính';
PRINT N'   [7] UNIQUE constraint (sp + màu + size + kiểu dáng)';
PRINT N'============================================================';
GO
-- =====================================================================
-- BẢN VÁ v5: ÁP DỤNG CHO HOÁ ĐƠN VÀ CHI TIẾT HOÁ ĐƠN
-- =====================================================================

-- 1. hoa_don: Thêm loai_hoa_don (0=POS | 1=Online)
IF COL_LENGTH('hoa_don', 'loai_hoa_don') IS NULL
BEGIN
    ALTER TABLE hoa_don ADD loai_hoa_don INT NOT NULL DEFAULT 1;
END

-- 2. hoa_don: Thêm phi_van_chuyen
IF COL_LENGTH('hoa_don', 'phi_van_chuyen') IS NULL
BEGIN
    ALTER TABLE hoa_don ADD phi_van_chuyen DECIMAL(18,2) NOT NULL DEFAULT 0;
END

-- 3. Cập nhật dữ liệu cũ: Đổi trạng thái 'Hoàn thành' từ 2 sang 3 để khớp logic v5, 'Đã hủy' từ 3 sang 4
UPDATE hoa_don SET trang_thai_don_hang = 4 WHERE trang_thai_don_hang = 3;
UPDATE hoa_don SET trang_thai_don_hang = 3 WHERE trang_thai_don_hang = 2;

-- 4. chi_tiet_hoa_don: Thêm 3 cột snapshot biến thể
IF COL_LENGTH('chi_tiet_hoa_don', 'mau_sac_snapshot') IS NULL
BEGIN
    ALTER TABLE chi_tiet_hoa_don ADD mau_sac_snapshot NVARCHAR(100);
END
IF COL_LENGTH('chi_tiet_hoa_don', 'kich_thuoc_snapshot') IS NULL
BEGIN
    ALTER TABLE chi_tiet_hoa_don ADD kich_thuoc_snapshot NVARCHAR(20);
END
IF COL_LENGTH('chi_tiet_hoa_don', 'kieu_dang_snapshot') IS NULL
BEGIN
    ALTER TABLE chi_tiet_hoa_don ADD kieu_dang_snapshot NVARCHAR(100);
END

-- 5. Tạo Index cho loai_hoa_don
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_hoa_don_loai' AND object_id = OBJECT_ID('hoa_don'))
BEGIN
    CREATE INDEX IX_hoa_don_loai ON hoa_don (loai_hoa_don);
END
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_hoa_don_loai_trangthai' AND object_id = OBJECT_ID('hoa_don'))
BEGIN
    CREATE INDEX IX_hoa_don_loai_trangthai ON hoa_don (loai_hoa_don, trang_thai_don_hang);
END
GO

-- =====================================================================
-- BẢN VÁ v6: SỬA TÊN CỘT gia_goc THÀNH gia_nhap VÀ BỔ SUNG DỮ LIỆU
-- =====================================================================

IF COL_LENGTH('chi_tiet_san_pham', 'gia_goc') IS NOT NULL
BEGIN
    EXEC sp_rename 'chi_tiet_san_pham.gia_goc', 'gia_nhap', 'COLUMN';
END
GO

IF NOT EXISTS (SELECT 1 FROM chi_tiet_san_pham WHERE chi_tiet_san_pham_code = 'CTSP016')
BEGIN
    INSERT INTO chi_tiet_san_pham (chi_tiet_san_pham_code, id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang, gia_nhap, gia_ban, so_luong, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES
    ('CTSP016',  9, 3,  1, 2,  1800000.00, 2800000.00, 15, 1.200, 80, 60, 0.50, 1),
    ('CTSP017',  9, 4,  6, 2,  1800000.00, 2800000.00, 10, 1.250, 82, 62, 0.50, 1),
    ('CTSP018', 10, 2, 10, 1,   600000.00,  980000.00, 25, 0.700, 68, 54, 0.25, 1),
    ('CTSP019', 10, 3,  1, 1,   600000.00,  980000.00, 25, 0.720, 70, 56, 0.25, 1),
    ('CTSP020', 11, 1,  4, 3,   800000.00, 1450000.00, 30, 0.600, 62, 48, 0.25, 1),
    ('CTSP021', 11, 2,  5, 3,   800000.00, 1450000.00, 40, 0.620, 64, 50, 0.25, 1),
    ('CTSP022', 12, 2,  3, 5,   500000.00,  820000.00, 35, 0.750, 67, 52, 0.25, 1),
    ('CTSP023', 12, 3,  3, 5,   500000.00,  820000.00, 35, 0.780, 69, 54, 0.25, 1),
    ('CTSP024', 13, 2,  9, 2,   950000.00, 1350000.00, 50, 0.850, 70, 55, 0.35, 1),
    ('CTSP025', 14, 3,  6, 1,   700000.00, 1100000.00, 20, 0.800, 72, 56, 0.30, 1),
    ('CTSP026', 15, 2,  1, 4,  1600000.00, 2500000.00, 12, 0.950, 75, 58, 0.35, 1);
END
GO
