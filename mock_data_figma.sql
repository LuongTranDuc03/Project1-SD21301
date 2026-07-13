-- =========================================================================
-- FILE: mock_data_figma.sql
-- MỤC ĐÍCH: Dữ liệu mẫu (Mock Data) chuẩn bị sẵn để hiển thị giao diện 
-- trang danh sách nhân viên cho giống y hệt thiết kế Figma (có Avatar thật, 
-- dữ liệu phong phú, trạng thái đang làm/đã nghỉ, nhiều mức lương khác nhau).
-- 
-- HƯỚNG DẪN SỬ DỤNG: 
-- 1. Mở SQL Server Management Studio (SSMS).
-- 2. Chọn Database dự án của bạn (ví dụ: USE FamiCoatsDB).
-- 3. Bôi đen và chạy (Execute) đoạn Script bên dưới.
-- =========================================================================

-- (Tùy chọn) Xóa dữ liệu cũ để tránh trùng lặp mã NV
-- DELETE FROM nhan_vien;
-- DELETE FROM vai_tro;

-- 1. CHÈN DỮ LIỆU CÁC VAI TRÒ (Phòng ban giống Figma)
IF NOT EXISTS (SELECT 1 FROM vai_tro WHERE ten_vai_tro = N'Admin')
    INSERT INTO vai_tro (ten_vai_tro, mo_ta, trang_thai) VALUES (N'Admin', N'Toàn quyền quản trị hệ thống', 1);

IF NOT EXISTS (SELECT 1 FROM vai_tro WHERE ten_vai_tro = N'Kinh doanh')
    INSERT INTO vai_tro (ten_vai_tro, mo_ta, trang_thai) VALUES (N'Kinh doanh', N'Nhân viên bán hàng, tư vấn khách hàng', 1);

IF NOT EXISTS (SELECT 1 FROM vai_tro WHERE ten_vai_tro = N'Kho')
    INSERT INTO vai_tro (ten_vai_tro, mo_ta, trang_thai) VALUES (N'Kho', N'Quản lý nhập xuất kho, kiểm kê hàng hóa', 1);

IF NOT EXISTS (SELECT 1 FROM vai_tro WHERE ten_vai_tro = N'CSKH')
    INSERT INTO vai_tro (ten_vai_tro, mo_ta, trang_thai) VALUES (N'CSKH', N'Chăm sóc khách hàng, hỗ trợ sau bán hàng', 1);

IF NOT EXISTS (SELECT 1 FROM vai_tro WHERE ten_vai_tro = N'IT')
    INSERT INTO vai_tro (ten_vai_tro, mo_ta, trang_thai) VALUES (N'IT', N'Quản trị hệ thống công nghệ thông tin', 1);

IF NOT EXISTS (SELECT 1 FROM vai_tro WHERE ten_vai_tro = N'Kế toán')
    INSERT INTO vai_tro (ten_vai_tro, mo_ta, trang_thai) VALUES (N'Kế toán', N'Quản lý tài chính, kế toán doanh nghiệp', 1);

IF NOT EXISTS (SELECT 1 FROM vai_tro WHERE ten_vai_tro = N'Vận chuyển')
    INSERT INTO vai_tro (ten_vai_tro, mo_ta, trang_thai) VALUES (N'Vận chuyển', N'Xử lý giao nhận hàng hóa', 1);

-- 2. CHÈN DỮ LIỆU MẪU NHÂN VIÊN (Mock Data xịn, hình avatar từ pravatar)
-- Xóa tạm vài NV cũ nếu bị trùng ID
DELETE FROM nhan_vien WHERE id IN ('NV001','NV002','NV003','NV004','NV005','NV006','NV007','NV008','NV009','NV010','NV011','NV012');

INSERT INTO nhan_vien (id, id_vai_tro, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, cccd, luong, ngay_vao_lam, anh_dai_dien, trang_thai) 
VALUES 
-- Đội ngũ Admin & IT (Lương cao, Avatar ngầu)
('NV001', 1, N'Nguyễn Cảnh Quỳnh', 'quynhnc@famicoats.vn', '123456', '0987654321', '1995-05-15', 1, '001095000001', 35000000, '2023-01-10', 'https://i.pravatar.cc/150?img=11', 1),
('NV002', 5, N'Trần Đình Long', 'longtd@famicoats.vn', '123456', '0912345678', '1998-10-20', 1, '001098000002', 25000000, '2023-03-15', 'https://i.pravatar.cc/150?img=13', 1),

-- Đội Kinh Doanh & CSKH (Nữ nhiều, Avatar đẹp)
('NV003', 2, N'Lê Thị Hương Giang', 'gianglth@famicoats.vn', '123456', '0909090909', '2000-02-28', 0, '001100000003', 18000000, '2023-05-20', 'https://i.pravatar.cc/150?img=5', 1),
('NV004', 2, N'Vũ Phương Nga', 'ngavp@famicoats.vn', '123456', '0933777888', '1997-07-01', 0, '001097000004', 16500000, '2023-07-01', 'https://i.pravatar.cc/150?img=9', 1),
('NV005', 4, N'Nguyễn Mai Lan', 'lannm@famicoats.vn', '123456', '0922111333', '1999-09-15', 0, '001099000005', 14000000, '2023-10-05', 'https://i.pravatar.cc/150?img=1', 1),
('NV006', 4, N'Phạm Bích Ngọc', 'ngocpb@famicoats.vn', '123456', '0911999000', '2001-03-12', 0, '001101000006', 12500000, '2024-02-05', 'https://i.pravatar.cc/150?img=10', 1),

-- Đội Kế toán
('NV007', 6, N'Đinh Bảo Trâm', 'tramdb@famicoats.vn', '123456', '0988777666', '1990-11-22', 0, '001090000007', 22000000, '2022-12-01', 'https://i.pravatar.cc/150?img=19', 1),

-- Đội Kho & Vận chuyển (Nam nhiều)
('NV008', 3, N'Hoàng Quốc Việt', 'viethq@famicoats.vn', '123456', '0977112233', '1994-08-08', 1, '001094000008', 15000000, '2023-06-12', 'https://i.pravatar.cc/150?img=59', 1),
('NV009', 3, N'Lương Mạnh Hải', 'hailm@famicoats.vn', '123456', '0901234567', '1996-04-30', 1, '001096000009', 14500000, '2024-01-20', 'https://i.pravatar.cc/150?img=51', 1),
('NV010', 7, N'Ngô Hữu Phước', 'phuocnh@famicoats.vn', '123456', '0918111222', '1993-02-14', 1, '001093000010', 13000000, '2023-11-15', 'https://i.pravatar.cc/150?img=53', 1),

-- Các nhân sự đã nghỉ việc (Status = 0)
('NV011', 2, N'Lý Phương Dung', 'dunglp@famicoats.vn', '123456', '0934999888', '1998-05-19', 0, '001098000011', 15000000, '2023-02-10', 'https://i.pravatar.cc/150?img=35', 0),
('NV012', 7, N'Bùi Tấn Tài', 'taibt@famicoats.vn', '123456', '0999888777', '1995-12-25', 1, '001095000012', 12000000, '2023-08-05', 'https://i.pravatar.cc/150?img=12', 0);

PRINT N'Thêm Mock Data Figma thành công! Vui lòng refresh lại trang danh sách nhân viên trên Web.';
