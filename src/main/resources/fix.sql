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
