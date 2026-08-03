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
IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'FamiCoatsDatabase')
BEGIN
    CREATE DATABASE FamiCoatsDatabase;
END
GO

USE FamiCoatsDatabase;
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
    loai_hoa_don              INT                NOT NULL DEFAULT 1,   -- 0: Tại quầy | 1: Online
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
    phi_van_chuyen            DECIMAL(18,2)      NOT NULL DEFAULT 0,   -- [1]
    ghi_chu                   NVARCHAR(MAX),
    trang_thai_thanh_toan     INT                NOT NULL DEFAULT 0,   -- 0: Chưa TT | 1: Đã TT
    trang_thai_don_hang       INT                NOT NULL DEFAULT 0,
    -- POS: 0: Chờ thanh toán | 1: Chờ giao hàng | 3: Hoàn thành | 4: Đã huỷ | 5: Đã hoàn tiền
    -- ONLINE: 1: Đã xác nhận | 2: Đang giao | 3: Hoàn thành | 4: Đã huỷ | 5: Đã hoàn tiền
    trang_thai                INT                NOT NULL DEFAULT 1,
    updated_at                DATETIME           NOT NULL DEFAULT GETDATE()   -- [6]
);
GO

CREATE INDEX IDX_hoa_don_loai ON hoa_don(loai_hoa_don);
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
