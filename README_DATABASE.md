# FamiCoats — Tài liệu Database v5

> **Hệ CSDL:** SQL Server  
> **Phiên bản:** v5 — Production Ready  
> **Cập nhật:** 2026-07-23

---

## Mục lục

1. [Tổng quan hệ thống](#1-tổng-quan-hệ-thống)
2. [Sơ đồ quan hệ (ERD tóm tắt)](#2-sơ-đồ-quan-hệ-erd-tóm-tắt)
3. [Những thay đổi từ v4 → v5](#3-những-thay-đổi-từ-v4--v5)
4. [Thiết kế chi tiết từng module](#4-thiết-kế-chi-tiết-từng-module)
   - [4.1 Sản phẩm](#41-sản-phẩm)
   - [4.2 Phiếu giảm giá](#42-phiếu-giảm-giá)
   - [4.3 Hóa đơn](#43-hóa-đơn)
5. [Luồng nghiệp vụ](#5-luồng-nghiệp-vụ)
   - [5.1 Luồng bán hàng Online (Website)](#51-luồng-bán-hàng-online-website)
   - [5.2 Luồng bán hàng tại quầy (POS)](#52-luồng-bán-hàng-tại-quầy-pos)
   - [5.3 Luồng áp dụng phiếu giảm giá](#53-luồng-áp-dụng-phiếu-giảm-giá)
   - [5.4 Luồng hủy đơn & hoàn tiền](#54-luồng-hủy-đơn--hoàn-tiền)
   - [5.5 Luồng đánh giá sản phẩm](#55-luồng-đánh-giá-sản-phẩm)
6. [Quy tắc quan trọng](#6-quy-tắc-quan-trọng)
7. [Giải thích từng bảng mới / thay đổi](#7-giải-thích-từng-bảng-mới--thay-đổi)

---

## 1. Tổng quan hệ thống

FamiCoats là website bán áo khoác phục vụ **2 nghiệp vụ chính**:

| Nghiệp vụ | Người dùng | Giao diện |
|---|---|---|
| **Bán hàng online** | Khách hàng tự mua | Website / Mobile |
| **Bán hàng tại quầy (POS)** | Nhân viên tạo đơn hộ | Trang admin |

Cả hai nghiệp vụ đều dùng chung bảng `hoa_don`, phân biệt nhau qua cột `nguon_don_hang` và `loai_don_hang`.

---

## 2. Sơ đồ quan hệ (ERD tóm tắt)

```
khach_hang ──────┬──── khach_hang_dia_chi ──── dia_chi
                 │
                 ├──── khach_hang_phieu_giam_gia ──── phieu_giam_gia
                 │                                         │
                 │                             phieu_giam_gia_danh_muc
                 │                             phieu_giam_gia_san_pham
                 │
                 └──── hoa_don ──┬──── chi_tiet_hoa_don ──── chi_tiet_san_pham ──── san_pham
                                 │                                                        │
                                 ├──── lich_su_hoa_don              hinh_anh ────────────┘
                                 ├──── lich_su_thanh_toan            san_pham_chat_lieu
                                 └──── hoan_tien                         │
                                                                      chat_lieu
nhan_vien ──── vai_tro
     │
     └──── dia_chi

san_pham ──── danh_muc
          ──── thuong_hieu
          ──── xuat_xu
          ──── chat_lieu (chính)

chi_tiet_san_pham ──── kich_thuoc
                   ──── mau_sac
                   ──── kieu_dang
                   ──── chat_lieu (override)

danh_gia ──── san_pham
          ──── khach_hang
          ──── chi_tiet_hoa_don (verified purchase)
```

---

## 3. Những thay đổi từ v4 → v5

### 3.1 Bảng HÓA ĐƠN (`hoa_don`)

| Thay đổi | v4 | v5 | Lý do |
|---|---|---|---|
| `trang_thai_don_hang` | `INT` (0,1,2,3,4,5) | `NVARCHAR` ('PENDING','CONFIRMED','SHIPPING','DONE','CANCELLED','REFUNDED') | Tránh nhầm magic number khi đọc code. Canifa, Routine đều dùng string enum. |
| `nguon_don_hang` | Không có | `NVARCHAR` ('WEBSITE','ADMIN_POS','MOBILE') | Phân biệt rõ nguồn đơn để thống kê và xử lý khác nhau |
| `dia_chi_snapshot` | Không có | `NVARCHAR(MAX)` JSON | Lưu toàn bộ địa chỉ lúc đặt — không thay đổi dù KH sau này xóa địa chỉ |
| `ngay_giao_du_kien` | Không có | `DATETIME` | Hiển thị ETA cho KH trên trang theo dõi đơn |
| `ngay_hoan_thanh` | Không có | `DATETIME` | Ghi nhận khi đơn thực sự giao xong |
| `ghi_chu_huy` | Không có | `NVARCHAR(MAX)` | Lý do hủy — bắt buộc khi admin/KH hủy đơn |
| `lien_hoan` | `FLOAT` cột trong hoa_don | Xóa → tách sang bảng `hoan_tien` | Mỗi lần hoàn tiền có thể xảy ra nhiều lần (partial refund), cần theo dõi riêng |
| `loai_don_hang` | Giữ nguyên INT | Giữ nguyên (tương thích Java Entity) | Kết hợp với `nguon_don_hang` mới thêm |

### 3.2 Bảng PHIẾU GIẢM GIÁ (`phieu_giam_gia`)

| Thay đổi | v4 | v5 | Lý do |
|---|---|---|---|
| `trang_thai` | `INT` (0,1,2,3) | `NVARCHAR` ('INACTIVE','ACTIVE','EXPIRED','CANCELLED') | Tương tự hoa_don — tránh nhầm |
| `loai_ap_dung` | Không có | `INT` (0: Tất cả, 1: Danh mục, 2: SP cụ thể) | Canifa có flash sale theo danh mục riêng |
| `han_su_dung_moi_khach` | Không có | `INT` NULL | Giới hạn mỗi KH được dùng tối đa N lần/phiếu |
| `ngay_cap_nhat` | Không có | `DATETIME` | Audit trail |
| `ngay_bat_dau/ket_thuc` | `DATE` | `DATETIME` | Flash sale cần chính xác tới giờ (VD: 00:00 - 23:59) |
| `da_su_dung` trong `khach_hang_phieu_giam_gia` | `BIT` (đã/chưa) | `INT` (đếm số lần) | Hỗ trợ `han_su_dung_moi_khach` |
| Bảng `phieu_giam_gia_danh_muc` | Không có | Thêm mới | Phiếu áp dụng cho danh mục cụ thể |
| Bảng `phieu_giam_gia_san_pham` | Không có | Thêm mới | Phiếu áp dụng cho SP cụ thể |

### 3.3 Bảng SẢN PHẨM

| Thay đổi | v4 | v5 | Lý do |
|---|---|---|---|
| `id_chat_lieu` trong `san_pham` | Không có | FK → `chat_lieu` | Hiển thị chất liệu chính ngay trang danh sách SP |
| `gia_goc` trong `san_pham` + `chi_tiet_san_pham` | Không có | `FLOAT` | Tính margin, báo cáo lợi nhuận cho admin |
| `luot_xem` | Không có | `INT` | Thống kê SP hot, gợi ý "Sản phẩm phổ biến" |
| `ma_vach` trong `chi_tiet_san_pham` | Không có | `VARCHAR(100) UNIQUE` | Quét barcode khi bán tại quầy |
| Bảng `san_pham_chat_lieu` | Không có | Thêm mới N-N | Áo khoác da + lót len = 2 chất liệu |

### 3.4 Bảng mới hoàn toàn

| Bảng | Mục đích |
|---|---|
| `hoan_tien` | Quản lý từng lần hoàn tiền (hỗ trợ hoàn một phần) |
| `danh_gia` | Review sản phẩm sau khi mua (verified purchase) |
| `san_pham_chat_lieu` | N-N: một SP có nhiều chất liệu |
| `phieu_giam_gia_danh_muc` | Phiếu áp dụng theo danh mục |
| `phieu_giam_gia_san_pham` | Phiếu áp dụng theo sản phẩm cụ thể |

### 3.5 Cột nhỏ khác

| Bảng | Cột thêm | Lý do |
|---|---|---|
| `mau_sac` | `ma_hex CHAR(7)` | Render chip màu ở frontend (#000000) |
| `kich_thuoc` | `thu_tu INT` | Sắp xếp đúng thứ tự S < M < L < XL |
| `khach_hang` | `ngay_dang_ky DATETIME` | Chạy chương trình "Khách mới" |
| `chi_tiet_hoa_don` | `ten_sp_tai_thoi_diem`, `mo_ta_variant` | Snapshot tên SP + mô tả variant lúc mua |

---

## 4. Thiết kế chi tiết từng module

### 4.1 Sản phẩm

#### Cấu trúc 2 tầng: SP cha → Variant (SKU)

```
san_pham (SP cha)
  ├── ten_san_pham: "Áo khoác da nam cao cấp"
  ├── gia_ban: 1,850,000  (giá niêm yết cấp SP)
  ├── id_chat_lieu → "Da cừu"  (chất liệu chính)
  └── trang_thai: AVAILABLE | OUT_OF_STOCK | HIDDEN

      chi_tiet_san_pham (variant/SKU)
        ├── ma_vach: "FC-001-BLK-M"   ← quét khi bán tại quầy
        ├── id_kich_thuoc → M
        ├── id_mau_sac → Đen
        ├── gia_ban: 1,850,000  (có thể khác SP cha nếu variant đặc biệt)
        ├── gia_goc: 900,000    ← tính margin
        ├── so_luong: 15
        └── trang_thai: AVAILABLE | OUT_OF_STOCK

            hinh_anh (ảnh của từng variant)
              ├── duong_dan: "sp001-den-m-1.jpg"
              └── anh_chinh: 1 (ảnh đại diện)
```

**Khi nào `trang_thai = OUT_OF_STOCK`?**
- `chi_tiet_san_pham`: khi `so_luong = 0`
- `san_pham`: khi TẤT CẢ variants đều OUT_OF_STOCK

**`trang_thai = HIDDEN`**: Admin ẩn SP khỏi website (vẫn còn hàng nhưng không bán tạm thời).

#### Luồng thêm sản phẩm mới (Admin)

```
1. Tạo bản ghi trong san_pham (tên, danh mục, thương hiệu, giá niêm yết)
2. Với mỗi biến thể (size + màu):
   - INSERT vào chi_tiet_san_pham với ma_vach riêng
   - Upload ảnh → INSERT vào hinh_anh
3. Nếu SP có nhiều chất liệu → INSERT vào san_pham_chat_lieu
```

---

### 4.2 Phiếu giảm giá

#### Phân loại phiếu theo phạm vi áp dụng

```
loai_ap_dung = 0  →  Toàn bộ đơn hàng
  VD: "Giảm 15% cho đơn từ 2 triệu"

loai_ap_dung = 1  →  Theo danh mục
  → Đọc thêm bảng phieu_giam_gia_danh_muc
  VD: "Giảm 20% áo khoác len + trench coat"

loai_ap_dung = 2  →  Theo sản phẩm cụ thể
  → Đọc thêm bảng phieu_giam_gia_san_pham
  VD: "Flash sale SP001 giảm 30%"
```

#### Phân loại phiếu theo đối tượng

```
la_phieu_ca_nhan = 0  →  Công khai (ai cũng dùng được)
  → KH nhập mã code khi checkout

la_phieu_ca_nhan = 1  →  Cá nhân hóa
  → Chỉ KH có trong khach_hang_phieu_giam_gia mới dùng được
  VD: Voucher sinh nhật, bù đền đơn lỗi
```

#### Logic tính giảm giá

```
loai_giam = 0 (Theo %):
  so_tien_giam = MIN(tam_tinh × gia_tri_giam / 100, giam_toi_da)
  (* nếu giam_toi_da IS NULL thì không giới hạn)

loai_giam = 1 (Số tiền cố định):
  so_tien_giam = gia_tri_giam
  (* không cần giam_toi_da)

Điều kiện áp dụng:
  1. tam_tinh >= gia_tri_don_hang_toi_thieu
  2. GETDATE() BETWEEN ngay_bat_dau AND ngay_ket_thuc
  3. trang_thai = 'ACTIVE'
  4. (so_luong IS NULL) OR (da_su_dung < so_luong)
  5. Nếu la_phieu_ca_nhan = 1:
     → KH phải có trong khach_hang_phieu_giam_gia
     → so_lan_da_dung < han_su_dung_moi_khach
```

#### Sau khi áp dụng phiếu thành công

```sql
-- Tăng da_su_dung toàn cục
UPDATE phieu_giam_gia SET da_su_dung = da_su_dung + 1 WHERE id = ?

-- Tăng đếm của KH (nếu phiếu cá nhân)
UPDATE khach_hang_phieu_giam_gia
SET so_lan_da_dung = so_lan_da_dung + 1,
    ngay_su_dung_cuoi = GETDATE()
WHERE id_khach_hang = ? AND id_phieu = ?
```

---

### 4.3 Hóa đơn

#### Công thức tính tiền

```
tam_tinh         = SUM(don_gia × so_luong)  của chi_tiet_hoa_don
tien_giam_hoa_don = Số tiền giảm từ phiếu
phi_van_chuyen   = Phí ship (0 nếu bán tại quầy)
tong_thanh_toan  = tam_tinh - tien_giam_hoa_don + phi_van_chuyen
```

#### Vòng đời trạng thái đơn hàng

```
                    ┌──────────────────────────────────────┐
                    ▼                                      │
[KH/NV tạo đơn] → PENDING → CONFIRMED → SHIPPING → DONE  │
                      │                              │     │
                      └──────────────────────────────┘     │
                                   │                       │
                               CANCELLED               REFUNDED
                           (ghi ghi_chu_huy)        (có bản ghi hoan_tien)
```

**Chi tiết từng trạng thái:**

| Trạng thái | Ai thay đổi | Điều kiện |
|---|---|---|
| `PENDING` | Hệ thống tự đặt khi tạo đơn | — |
| `CONFIRMED` | Admin/NV xác nhận | Chỉ từ PENDING |
| `SHIPPING` | Admin/NV cập nhật sau khi bàn giao vận chuyển | Chỉ từ CONFIRMED |
| `DONE` | Admin/NV xác nhận giao thành công | Từ SHIPPING (online) hoặc thẳng từ PENDING (POS) |
| `CANCELLED` | KH hủy (PENDING) hoặc Admin hủy | PENDING hoặc CONFIRMED. Bắt buộc nhập `ghi_chu_huy` |
| `REFUNDED` | Admin sau khi xử lý hoàn tiền | Từ CANCELLED hoặc DONE (đổi trả) |

#### Thiết kế địa chỉ giao hàng (quan trọng)

Hóa đơn lưu địa chỉ theo **2 tầng**:

```
id_dia_chi (FK)           → Trỏ tới sổ địa chỉ KH lúc đặt
                             Có thể NULL nếu KH xóa địa chỉ sau này

dia_chi_snapshot (JSON)   → Bất biến, luôn có giá trị
                             Đây là nguồn tin cậy để in hóa đơn, hiển thị lịch sử

dia_chi_khach_nhan (text) → Text ngắn "25 Hàng Gai, Hà Nội" — dùng hiển thị nhanh
```

**Khi in hóa đơn hoặc hiển thị địa chỉ giao hàng → LUÔN đọc `dia_chi_snapshot`.**

Ví dụ JSON snapshot:
```json
{
  "tinh": "Hà Nội",
  "huyen": "Quận Hoàn Kiếm",
  "xa": "Phường Hàng Gai",
  "chi_tiet": "25 Hàng Gai",
  "nguoi_nhan": "Nguyễn Văn An",
  "sdt": "0901234567"
}
```

#### Snapshot giá trong chi tiết hóa đơn

Tương tự địa chỉ, giá SP có thể thay đổi theo thời gian. Bảng `chi_tiet_hoa_don` lưu:
- `don_gia`: Giá bán lúc đặt (không thay đổi)
- `ten_sp_tai_thoi_diem`: Tên SP lúc đặt
- `mo_ta_variant`: VD "Đen - Size M" lúc đặt

---

## 5. Luồng nghiệp vụ

### 5.1 Luồng bán hàng Online (Website)

```
KH duyệt SP
    │
    ▼
KH chọn variant (size + màu) → kiểm tra so_luong > 0
    │
    ▼
KH thêm vào giỏ hàng (giỏ hàng lưu ở session/localStorage phía client)
    │
    ▼
KH nhập địa chỉ giao hàng
  → Đọc khach_hang_dia_chi lấy danh sách địa chỉ đã lưu
  → Hoặc nhập địa chỉ mới
    │
    ▼
KH chọn phương thức thanh toán
    │
    ▼
KH áp dụng mã giảm giá (nếu có)
  → Validate phiếu (xem mục 4.2)
    │
    ▼
KH xác nhận đặt hàng
  → INSERT hoa_don (trang_thai_don_hang = 'PENDING', nguon_don_hang = 'WEBSITE')
  → INSERT chi_tiet_hoa_don (snapshot tên SP, giá, variant)
  → Lưu dia_chi_snapshot JSON
  → INSERT lich_su_hoa_don (PENDING → PENDING, "Tạo đơn hàng online")
    │
    ▼
KH thanh toán
  ┌─ Tiền mặt khi nhận (COD): da_thanh_toan = 0, chờ NV xác nhận
  └─ Online (VNPay/MoMo/ZaloPay):
       → Chuyển hướng cổng thanh toán
       → Nhận callback kết quả
       → INSERT lich_su_thanh_toan
       → Nếu thành công: UPDATE hoa_don SET da_thanh_toan = tong_thanh_toan
    │
    ▼
Admin/NV xác nhận đơn
  → UPDATE hoa_don SET trang_thai_don_hang = 'CONFIRMED', ngay_xac_nhan = NOW()
  → INSERT lich_su_hoa_don (PENDING → CONFIRMED)
    │
    ▼
Bàn giao vận chuyển
  → UPDATE hoa_don SET trang_thai_don_hang = 'SHIPPING'
  → INSERT lich_su_hoa_don (CONFIRMED → SHIPPING)
  → (Có thể cập nhật ngay_giao_du_kien)
    │
    ▼
Giao hàng thành công
  → UPDATE hoa_don SET trang_thai_don_hang = 'DONE', ngay_hoan_thanh = NOW()
  → INSERT lich_su_hoa_don (SHIPPING → DONE)
  → Nếu COD: UPDATE da_thanh_toan = tong_thanh_toan, trang_thai_thanh_toan = 1
```

---

### 5.2 Luồng bán hàng tại quầy (POS)

```
NV tìm KH (theo SĐT hoặc khach_hang_code)
  → Nếu chưa có KH: tạo KH vãng lai (có thể thiếu email)
    │
    ▼
NV quét barcode hoặc tìm SP
  → Đọc chi_tiet_san_pham.ma_vach
  → Kiểm tra so_luong
    │
    ▼
NV tạo đơn hàng
  → INSERT hoa_don (
       nguon_don_hang = 'ADMIN_POS',
       loai_don_hang = 1,
       id_nhan_vien = NV đang login,
       id_dia_chi = NULL (không giao hàng),
       phi_van_chuyen = 0,
       trang_thai_don_hang = 'PENDING'
     )
  → INSERT chi_tiet_hoa_don
    │
    ▼
KH trả tiền
  → Tiền mặt: UPDATE da_thanh_toan, trang_thai_thanh_toan = 1
  → QR/Chuyển khoản: INSERT lich_su_thanh_toan
    │
    ▼
Hoàn thành ngay (không qua SHIPPING)
  → UPDATE trang_thai_don_hang = 'DONE', ngay_hoan_thanh = NOW()
  → INSERT lich_su_hoa_don (PENDING → DONE, "Thanh toán tại quầy")
    │
    ▼
Trừ tồn kho
  → UPDATE chi_tiet_san_pham SET so_luong = so_luong - so_luong_mua
  → Nếu so_luong = 0: UPDATE trang_thai = 'OUT_OF_STOCK'
```

---

### 5.3 Luồng áp dụng phiếu giảm giá

```
KH nhập mã phiếu tại trang checkout
    │
    ▼
Hệ thống tìm phiếu theo phieu_giam_gia_code
    │
    ├─ Không tìm thấy → "Mã giảm giá không tồn tại"
    │
    ▼
Kiểm tra trang_thai = 'ACTIVE'
    ├─ INACTIVE / EXPIRED / CANCELLED → "Phiếu đã hết hạn hoặc không hợp lệ"
    │
    ▼
Kiểm tra thời gian: NOW() BETWEEN ngay_bat_dau AND ngay_ket_thuc
    │
    ▼
Kiểm tra so_luong: (so_luong IS NULL) OR (da_su_dung < so_luong)
    │
    ▼
Kiểm tra giá trị đơn: tam_tinh >= gia_tri_don_hang_toi_thieu
    │
    ▼
Kiểm tra la_phieu_ca_nhan:
  = 0 (Công khai):
    → Kiểm tra han_su_dung_moi_khach:
       - NULL: KH dùng được
       - Có giá trị: đếm so_lan_da_dung trong khach_hang_phieu_giam_gia
  = 1 (Cá nhân):
    → Kiểm tra KH có trong khach_hang_phieu_giam_gia
    → Kiểm tra so_lan_da_dung < han_su_dung_moi_khach
    │
    ▼
Kiểm tra loai_ap_dung:
  = 0: Áp dụng cho toàn đơn
  = 1: Chỉ tính tam_tinh của items thuộc danh mục trong phieu_giam_gia_danh_muc
  = 2: Chỉ tính tam_tinh của items là SP trong phieu_giam_gia_san_pham
    │
    ▼
Tính tiền giảm (xem công thức mục 4.2)
    │
    ▼
Hiển thị cho KH xác nhận → KH đặt hàng thành công
    │
    ▼
Cập nhật phiếu sau khi đơn DONE hoặc CONFIRMED:
  UPDATE phieu_giam_gia SET da_su_dung = da_su_dung + 1
  (Nếu cá nhân) UPDATE khach_hang_phieu_giam_gia SET so_lan_da_dung = so_lan_da_dung + 1
```

---

### 5.4 Luồng hủy đơn & hoàn tiền

#### Hủy đơn

```
KH hủy (chỉ khi PENDING):
  → UPDATE trang_thai_don_hang = 'CANCELLED'
  → UPDATE ghi_chu_huy = "Khách yêu cầu hủy: [lý do]"
  → INSERT lich_su_hoa_don (PENDING → CANCELLED)
  → Hoàn lại tồn kho: UPDATE chi_tiet_san_pham SET so_luong = so_luong + so_luong_da_mua
  → Hoàn lại phiếu giảm giá (nếu có):
       UPDATE phieu_giam_gia SET da_su_dung = da_su_dung - 1

Admin hủy (PENDING hoặc CONFIRMED):
  → Tương tự trên + ghi chú rõ lý do admin
```

#### Hoàn tiền

```
Đơn CANCELLED có da_thanh_toan > 0 → Cần hoàn tiền:
  → INSERT hoan_tien (id_hoa_don, so_tien_hoan, ly_do, trang_thai = 'PENDING')
  → Admin duyệt: UPDATE hoan_tien SET trang_thai = 'APPROVED', ngay_xu_ly = NOW()
  → Thực hiện hoàn tiền (chuyển khoản / cash)
  → UPDATE hoa_don SET trang_thai_don_hang = 'REFUNDED'
  → INSERT lich_su_hoa_don (CANCELLED → REFUNDED)
```

**Hoàn tiền một phần (partial refund):**  
Mỗi lần hoàn = 1 bản ghi trong `hoan_tien`. Có thể có nhiều bản ghi cho 1 hóa đơn.

---

### 5.5 Luồng đánh giá sản phẩm

```
Đơn hàng đạt trạng thái DONE
    │
    ▼
Hệ thống mở khóa nút "Đánh giá" cho từng sản phẩm trong đơn
    │
    ▼
KH nhấn đánh giá SP X trong đơn HD001
    │
    ▼
Kiểm tra: KH có chi_tiet_hoa_don nào liên kết SP X thuộc đơn DONE không?
    ├─ Không → Không cho phép (chặn review "ảo")
    │
    ▼
KH nhập điểm (1-5 sao), tiêu đề, nội dung, ảnh
    │
    ▼
INSERT danh_gia (
  id_chi_tiet_hoa_don = id dòng mua,  ← verified purchase
  id_san_pham, id_khach_hang,
  diem, tieu_de, noi_dung, anh_danh_gia (JSON array)
)
    │
    ▼
Tính lại điểm trung bình hiển thị trên trang SP:
  SELECT AVG(diem) FROM danh_gia WHERE id_san_pham = ? AND an_hien = 1
```

---

## 6. Quy tắc quan trọng

### Không bao giờ sửa các cột snapshot sau khi tạo đơn
- `dia_chi_snapshot` trong `hoa_don`
- `don_gia`, `ten_sp_tai_thoi_diem`, `mo_ta_variant` trong `chi_tiet_hoa_don`

### Trừ tồn kho
- Trừ khi đơn chuyển sang `CONFIRMED` (không phải lúc tạo đơn `PENDING`)
- Hoàn lại khi đơn bị `CANCELLED`

### Phiếu giảm giá
- Đếm `da_su_dung` khi đơn `CONFIRMED` (không phải PENDING)
- Hoàn lại khi đơn bị `CANCELLED`

### Ghi lịch sử hóa đơn
- Mỗi lần thay đổi `trang_thai_don_hang` → INSERT một bản ghi `lich_su_hoa_don`
- Không UPDATE hay DELETE lịch sử

### Soft delete
- Tất cả bảng dùng cột `trang_thai` (0/1) để ẩn/hiện, không DELETE cứng
- Riêng `san_pham` có thêm trạng thái `HIDDEN` (ẩn khỏi website nhưng còn hàng)

---

## 7. Giải thích từng bảng mới / thay đổi

### `hoan_tien`
Tách khỏi cột `lien_hoan` trong `hoa_don` vì:
- Có thể hoàn nhiều lần (đổi trả từng món trong đơn nhiều SP)
- Cần theo dõi trạng thái duyệt (PENDING → APPROVED / REJECTED)
- Cần ghi nhận ai duyệt, bằng phương thức nào

### `danh_gia`
Ràng buộc `id_chi_tiet_hoa_don` đảm bảo "Verified Purchase" — chỉ KH thực sự mua mới review được, tránh spam. Tham khảo từ cách Shopee, Tiki, Lazada triển khai.

### `san_pham_chat_lieu`
Áo khoác thực tế thường có nhiều chất liệu (VD: mặt ngoài da tổng hợp, lót nỉ bông, đệm lông vũ). Bảng này giải quyết quan hệ N-N thay vì nhồi text vào một cột.

### `phieu_giam_gia_danh_muc` + `phieu_giam_gia_san_pham`
Tham khảo từ Canifa và Routine: Flash sale thường chỉ áp dụng cho 1-2 danh mục, không phải toàn bộ shop. Hai bảng trung gian này cho phép phiếu giảm giá khoanh vùng chính xác mà không cần hardcode vào code Java.

### `ma_hex` trong `mau_sac`
Frontend cần render ô màu (color swatch) khi KH chọn biến thể. Lưu `#000000` vào DB thay vì hardcode trong CSS.

### `thu_tu` trong `kich_thuoc`
Nếu không có cột này, ORDER BY `ten_kich_thuoc` sẽ sắp xếp alphabet: L, M, S, XL, XXL — sai thứ tự mặc định. Cột `thu_tu` đảm bảo hiển thị đúng S → M → L → XL → XXL.

### `ma_vach` trong `chi_tiet_san_pham`
Bán tại quầy cần quét barcode. Định dạng khuyến nghị: `FC-{mã_sp}-{màu}-{size}`, VD `FC-001-BLK-M`. UNIQUE để tránh trùng lặp khi nhập kho.

---

*Tài liệu này phản ánh thiết kế database FamiCoats v5. Mọi thay đổi schema cần cập nhật file này đồng thời.*
