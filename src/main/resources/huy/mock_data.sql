-- =====================================================================
-- KỊCH BẢN TẠO BẢNG VÀ THÊM DỮ LIỆU MẪU CHO MODULE NHÂN VIÊN (HUY)
-- Hệ cơ sở dữ liệu: SQL Server (FamiCoatsDB)
-- Tham chiếu: resources/huy/mock_data.json
-- =====================================================================

-- XÓA BẢNG (nếu cần reset)
IF OBJECT_ID('dbo.nhan_vien', 'U') IS NOT NULL DROP TABLE dbo.nhan_vien;
IF OBJECT_ID('dbo.vai_tro', 'U') IS NOT NULL DROP TABLE dbo.vai_tro;
GO

-- 1. BẢNG VAI TRÒ (vai_tro)
CREATE TABLE dbo.vai_tro (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_vai_tro NVARCHAR(100) NOT NULL,
    mo_ta NVARCHAR(500) NULL,
    trang_thai INT DEFAULT 1
);
GO

-- 2. BẢNG NHÂN VIÊN (nhan_vien)
CREATE TABLE dbo.nhan_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma_nhan_vien VARCHAR(50) NOT NULL UNIQUE,
    id_vai_tro INT FOREIGN KEY REFERENCES dbo.vai_tro(id),
    ho_ten NVARCHAR(200) NOT NULL,
    email NVARCHAR(200) NOT NULL UNIQUE,
    mat_khau NVARCHAR(200) NOT NULL,
    so_dien_thoai NVARCHAR(20) NULL,
    ngay_sinh DATE NULL,
    gioi_tinh BIT NULL,
    cccd NVARCHAR(20) NULL,
    luong FLOAT DEFAULT 0,
    ngay_vao_lam DATE NULL,
    anh_dai_dien NVARCHAR(MAX) NULL,
    dia_chi NVARCHAR(MAX) NULL,
    trang_thai INT DEFAULT 1
);
GO

-- 3. DỮ LIỆU MẪU VAI TRÒ
SET IDENTITY_INSERT dbo.vai_tro ON;
INSERT INTO dbo.vai_tro (id, ten_vai_tro, mo_ta, trang_thai) VALUES
(1, N'Admin', N'Quản trị viên hệ thống', 1),
(2, N'Quản lý', N'Quản lý cửa hàng', 1),
(3, N'Nhân viên', N'Nhân viên bán hàng', 1);
SET IDENTITY_INSERT dbo.vai_tro OFF;
GO

-- 4. DỮ LIỆU MẪU NHÂN VIÊN
SET IDENTITY_INSERT dbo.nhan_vien ON;
INSERT INTO dbo.nhan_vien (id, ma_nhan_vien, id_vai_tro, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, cccd, luong, ngay_vao_lam, anh_dai_dien, dia_chi, trang_thai) VALUES
(1, 'NV001', 1, N'Nguyễn Văn Admin', 'admin@famicoats.vn', '123456', '0987654321', '1990-01-15', 1, '001200000001', 35000000.0, '2024-01-01', '', N'Hà Nội', 1),
(2, 'NV002', 2, N'Trần Thị Quản Lý', 'quanly@famicoats.vn', '123456', '0912345678', '1992-05-20', 0, '001200000002', 25000000.0, '2024-03-15', '', N'Hà Nội', 1),
(3, 'NV003', 3, N'Lê Văn Bán Hàng', 'nhanvien@famicoats.vn', '123456', '0909123456', '1998-08-10', 1, '001200000003', 12000000.0, '2025-01-10', '', N'Hà Nội', 1),
(4, 'NV004', 3, N'Phạm Thị Nghỉ Việc', 'nghiviec@famicoats.vn', '123456', '0938765432', '1995-11-25', 0, '001200000004', 10000000.0, '2023-06-01', '', N'Hà Nội', 0);
SET IDENTITY_INSERT dbo.nhan_vien OFF;
GO
