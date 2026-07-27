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
('PTTT002', N'Chuyển khoản',     N'Thanh toán qua chuyển khoản',             'transfer.png',   0.00, 1);
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
    (nhan_vien_code, id_vai_tro, id_dia_chi, ten_nhan_vien, cccd, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, trang_thai, anh_dai_dien)
VALUES
('NV001', 1, 16, N'Nguyễn Văn Phúc', '001099123456', 'phuc@famicoats.com',  '$2b$12$PLACEHOLDER_HASH_NV001', '0988888888', '1998-03-15', 1, 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169423/pexels-tswegha-34440831_gslhqf.jpg'),
('NV002', 1, 17, N'Lê Minh Đức',     '002099234567', 'duc@famicoats.com',   '$2b$12$PLACEHOLDER_HASH_NV002', '0911111111', '1997-07-22', 1, 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169436/images_3_jaolbv.jpg'),
('NV003', 2, 18, N'Trần Đại Lương',  '003099345678', 'luong@famicoats.com', '$2b$12$PLACEHOLDER_HASH_NV003', '0922222222', '1999-01-10', 1, 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169486/images_2_a5naxp.jpg');
GO

-- 5. KHÁCH HÀNG
-- [2] mat_khau phải được hash ở app trước khi INSERT.
-- [5] trang_thai đổi thành INT: 1 = Hoạt động
INSERT INTO khach_hang
    (khach_hang_code, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, trang_thai, anh_dai_dien)
VALUES
('KH001', N'Nguyễn Văn An',   'an.nguyen@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH001', '0901234567', '1995-05-20', N'Nam', 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169563/pexels-caio-58463_sai8kj.jpg'),
('KH002', N'Trần Thị Bích',   'bich.tran@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH002', '0912345678', '1998-10-15', N'Nữ',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169567/pexels-snapwire-6969_f433zr.jpg'),
('KH003', N'Lê Văn Cường',    'cuong.le@gmail.com',    '$2b$12$PLACEHOLDER_HASH_KH003', '0923456789', '1993-03-08', N'Nam', 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169568/pexels-pixabay-41008_fbcjqh.jpg'),
('KH004', N'Phạm Thị Dung',   'dung.pham@yahoo.com',   '$2b$12$PLACEHOLDER_HASH_KH004', '0934567890', '2000-12-05', N'Nữ',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169570/pexels-islam-hussien-9062-59554_do1d7r.jpg'),
('KH005', N'Hoàng Văn Em',    'em.hoang@gmail.com',    '$2b$12$PLACEHOLDER_HASH_KH005', '0945678901', '1990-07-14', N'Nam', 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169578/pexels-freestocks-14661_o3qozf.jpg'),
('KH006', N'Ngô Thị Phương',  'phuong.ngo@gmail.com',  '$2b$12$PLACEHOLDER_HASH_KH006', '0956789012', '1997-02-28', N'Nữ',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169581/pexels-ivan-cujic-20495-105543_eipajr.jpg'),
('KH007', N'Đặng Văn Giang',  'giang.dang@gmail.com',  '$2b$12$PLACEHOLDER_HASH_KH007', '0967890123', '1994-09-30', N'Nam', 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169582/pexels-gladsonfx-111738_jcpt2x.jpg'),
('KH008', N'Bùi Thị Hà',      'ha.bui@gmail.com',      '$2b$12$PLACEHOLDER_HASH_KH008', '0978901234', '1999-06-17', N'Nữ',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169589/pexels-victor-koonoo-462525669-27911294_m8m1en.jpg'),
('KH009', N'Đinh Văn Ính',    'inh.dinh@gmail.com',    '$2b$12$PLACEHOLDER_HASH_KH009', '0989012345', '1992-11-03', N'Nam', 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169590/pexels-bocman-109851_yxll5c.jpg'),
('KH010', N'Vũ Thị Kim',      'kim.vu@gmail.com',      '$2b$12$PLACEHOLDER_HASH_KH010', '0990123456', '1996-04-25', N'Nữ',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169606/pexels-uday-ahir-634841123-38074344_hkru4e.jpg'),
('KH011', N'Phan Văn Long',   'long.phan@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH011', '0901234568', '1988-08-12', N'Nam', 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169615/pexels-fernando-ortiz-p-522599658-18505360_jgtilw.jpg'),
('KH012', N'Trịnh Thị Mai',   'mai.trinh@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH012', '0912345679', '2001-01-20', N'Nữ',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169615/pexels-ikowh-16622_nykfyf.jpg'),
('KH013', N'Cao Văn Nghĩa',   'nghia.cao@gmail.com',   '$2b$12$PLACEHOLDER_HASH_KH013', '0923456780', '1991-05-05', N'Nam', 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169563/pexels-caio-58463_sai8kj.jpg'),
('KH014', N'Lý Thị Oanh',     'oanh.ly@gmail.com',     '$2b$12$PLACEHOLDER_HASH_KH014', '0934567891', '1998-03-22', N'Nữ',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169567/pexels-snapwire-6969_f433zr.jpg'),
('KH015', N'Trương Văn Phúc', 'phuc.truong@gmail.com', '$2b$12$PLACEHOLDER_HASH_KH015', '0945678902', '1995-12-10', N'Nam', 1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785169568/pexels-pixabay-41008_fbcjqh.jpg');
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
INSERT INTO hinh_anh (hinh_anh_code, id_chi_tiet_san_pham, duong_dan, anh_chinh, thu_tu)
VALUES
('IMG001',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147225/jean_jbhizr.webp', 1, 1),
('IMG002',  1, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147225/%C3%A1o_gi%C3%B3_nmtdmx.webp', 0, 2),
('IMG003',  2, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147226/unisex_ljol3s.jpg', 1, 1),
('IMG004',  3, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147227/military_pmtbej.jpg', 1, 1),
('IMG005',  4, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147227/da_y34xds.jpg', 1, 1),
('IMG006',  5, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147227/parka_xgsdgn.jpg', 1, 1),
('IMG007',  6, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147228/hoodie_xbjupl.jpg', 1, 1),
('IMG008',  7, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147235/bomber_unisex_chzxdp.webp', 1, 1),
('IMG009',  8, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147256/jean_nzt3fk.webp', 1, 1),
('IMG010',  9, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147256/blazer_dbuqkv.avif', 1, 1),
('IMG011', 10, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147256/l%C3%B4ng_c%E1%BB%ABu_vujngk.webp', 1, 1),
('IMG012', 11, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147257/l%C3%B4ng_v%C5%A9_pdxvoz.avif', 1, 1),
('IMG013', 12, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147257/cape_irf4fw.avif', 1, 1),
('IMG014', 13, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147257/trend_coat_er6cv0.avif', 1, 1),
('IMG015', 14, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147258/kho%C3%A1c_len_ooolob.jpg', 1, 1),
('IMG016', 15, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147284/ao-khoac-nam-trung-nien-co-be-bhg-18-new_flptdb.jpg', 1, 1),
('IMG017', 16, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147290/goods_484610_sub14_3x4_cfxxia.avif', 1, 1),
('IMG018', 17, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147225/jean_jbhizr.webp', 1, 1),
('IMG019', 18, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147225/%C3%A1o_gi%C3%B3_nmtdmx.webp', 1, 1),
('IMG020', 19, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147226/unisex_ljol3s.jpg', 1, 1),
('IMG021', 20, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147227/military_pmtbej.jpg', 1, 1),
('IMG022', 21, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147227/da_y34xds.jpg', 1, 1),
('IMG023', 22, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147227/parka_xgsdgn.jpg', 1, 1),
('IMG024', 23, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147228/hoodie_xbjupl.jpg', 1, 1),
('IMG025', 24, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147235/bomber_unisex_chzxdp.webp', 1, 1),
('IMG026', 25, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147256/jean_nzt3fk.webp', 1, 1),
('IMG027', 26, 'https://res.cloudinary.com/hpjixeta/image/upload/v1785147256/blazer_dbuqkv.avif', 1, 1);
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
     id_phuong_thuc_thanh_toan, id_ma_giam_gia, loai_hoa_don,
     ngay_dat_hang, ngay_xac_nhan,
     ten_khach_nhan, sdt_khach_nhan, dia_chi_khach_nhan,
     tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, da_thanh_toan,
     trang_thai_thanh_toan, trang_thai_don_hang, trang_thai)
VALUES
('HD001',  1, 1,  1, 1, NULL, 1, '2026-06-01 08:30:00', NULL, N'Nguyễn Văn An',   '0901234567', N'25 Hàng Gai, Hà Nội',           2, 3700000.00,      0.00, 3700000.00, 3700000.00, 1, 0, 1),
('HD002',  2, 2,  2, 2,    1, 1, '2026-06-03 10:15:00', NULL, N'Trần Thị Bích',   '0912345678', N'88 Lê Lợi, Hồ Chí Minh',       3, 5400000.00, 810000.00, 4590000.00, 4590000.00, 1, 0, 1),
('HD003',  3, 3,  3, 2, NULL, 1, '2026-06-05 14:00:00', NULL, N'Lê Văn Cường',    '0923456789', N'12 Trần Phú, Đà Nẵng',          1, 1200000.00,      0.00, 1200000.00, 1200000.00, 1, 0, 1),
('HD004',  4, 1,  4, 1,    5, 1, '2026-06-08 09:00:00', NULL, N'Phạm Thị Dung',   '0934567890', N'45 Đinh Tiên Hoàng, Hải Phòng', 2, 3100000.00,  30000.00, 2800000.00, 2800000.00, 1, 0, 1),
('HD005',  5, 2,  5, 2,    2, 1, '2026-06-10 11:30:00', NULL, N'Hoàng Văn Em',    '0945678901', N'78 Nguyễn Trãi, Cần Thơ',       1,  650000.00,      0.00,  617500.00,       0.00, 0, 0, 1),
('HD006',  6, 3,  6, 1, NULL, 1, '2026-06-12 16:00:00', NULL, N'Ngô Thị Phương',  '0956789012', N'99 Đại lộ Bình Dương',           4, 6600000.00,      0.00, 6600000.00, 6600000.00, 1, 0, 1),
('HD007',  7, 1,  7, 1,    4, 1, '2026-06-15 08:45:00', NULL, N'Đặng Văn Giang',  '0967890123', N'3 Phạm Văn Thuận, Đồng Nai',    3, 4650000.00, 465000.00, 4185000.00, 4185000.00, 1, 0, 1),
('HD008',  8, 2,  8, 2, NULL, 1, '2026-06-18 13:00:00', NULL, N'Bùi Thị Hà',      '0978901234', N'22 Lê Lợi, Huế',                2, 2900000.00,      0.00, 2900000.00, 2900000.00, 1, 0, 1),
('HD009',  9, 3,  9, 2,    1, 1, '2026-06-20 10:00:00', NULL, N'Đinh Văn Ính',    '0989012345', N'56 Yersin, Nha Trang',           1, 1850000.00, 200000.00, 1650000.00,       0.00, 0, 0, 1),
('HD010', 10, 1, 10, 2, NULL, 1, '2026-06-22 09:30:00', NULL, N'Vũ Thị Kim',      '0990123456', N'7 Trần Hưng Đạo, Quảng Nam',    5, 8250000.00,      0.00, 8250000.00, 8250000.00, 1, 0, 1),
('HD011', 11, 1, 11, 2,    2, 1, '2026-06-25 11:00:00', NULL, N'Phan Văn Long',   '0901234568', N'14 Lý Thái Tổ, Bắc Ninh',       2, 4000000.00, 500000.00, 3500000.00, 3500000.00, 1, 0, 1),
('HD012', 12, 3, 12, 2, NULL, 1, '2026-06-28 15:30:00', NULL, N'Trịnh Thị Mai',   '0912345679', N'38 Trần Đăng Ninh, Nam Định',   3, 3750000.00,      0.00, 3750000.00,       0.00, 0, 0, 1),
('HD013', 13, 2, 13, 1, NULL, 1, '2026-07-01 08:00:00', NULL, N'Cao Văn Nghĩa',   '0923456780', N'67 Lê Hoàn, Thanh Hóa',         1, 2100000.00, 300000.00, 1800000.00, 1800000.00, 1, 0, 1),
('HD014', 14, 1, 14, 2, NULL, 1, '2026-07-05 10:30:00', NULL, N'Lý Thị Oanh',     '0934567891', N'5 Nguyễn Gia Thiều, Nghệ An',   2, 1500000.00,  75000.00, 1425000.00, 1425000.00, 1, 0, 1),
('HD015', 15, 1, 15, 2, NULL, 1, '2026-07-10 14:00:00', NULL, N'Trương Văn Phúc', '0945678902', N'92 Trần Phú, Hà Tĩnh',           4, 7400000.00, 740000.00, 6660000.00,       0.00, 0, 0, 1);
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
