# Hướng dẫn tích hợp API Tỉnh/Xã (chuẩn 2 cấp) vào project bán áo

## Bối cảnh dự án
- Entity **giữ nguyên**, các cột địa chỉ là kiểu String (không phải khóa ngoại):
  - `province` (cột `tinh`)
  - `district` (cột `huyen`) — **không dùng nữa, luôn để `null`**
  - `ward` (cột `xa`)
  - `addressDetail` (cột `dia_chi_chi_tiet`)

## Quyết định thiết kế (đã chốt — không thay đổi)
1. **Chuẩn hoá 2 cấp**: Tỉnh/Thành → Xã/Phường. Không dùng cấp Huyện.
2. **Dùng API v2**: `https://provinces.open-api.vn/api/v2` (đúng địa giới hành chính hiện hành, sau sáp nhập 2025).
3. **KHÔNG tạo entity mới** (không có `Province`, `Ward` entity).
4. **KHÔNG tạo bảng mới** trong DB (không `CREATE TABLE province`, không `CREATE TABLE ward`).
5. Lấy dữ liệu tỉnh/xã bằng cách **gọi API trực tiếp lúc runtime** qua servlet proxy, sau đó lưu **tên (String)** trực tiếp vào các cột `province`/`ward` có sẵn của bảng `dia_chi`.
6. Cột `district` (`huyen`) giữ nguyên trong DB (không xoá) nhưng luôn insert `null` — không hiển thị, không dùng trên form.

## Endpoint API sẽ dùng
```
GET https://provinces.open-api.vn/api/v2/p/                → danh sách tất cả tỉnh/thành
GET https://provinces.open-api.vn/api/v2/p/{code}?depth=2  → 1 tỉnh kèm mảng "wards" (xã/phường trực thuộc)
```
Lưu ý: không lạm dụng `depth=3` (hạ tầng API miễn phí).

## Luồng hoạt động cần cài đặt
```
JSP (form nhập/sửa địa chỉ)
   → dropdown Tỉnh: JS fetch GET /api/provinces (servlet nội bộ)
   → Servlet proxy gọi API ngoài GET .../api/v2/p/ → trả JSON tên+code tỉnh
   → User chọn tỉnh → JS fetch GET /api/provinces?provinceCode=xxx
   → Servlet proxy gọi .../api/v2/p/{code}?depth=2 → trả JSON kèm wards
   → dropdown Xã/Phường đổ dữ liệu
   → User chọn xã → submit form
   → AddressServlet nhận request, lưu TÊN tỉnh + TÊN xã (String) vào bảng dia_chi có sẵn
   → district luôn set null
```

## Các file cần tạo/sửa (không tạo entity, không tạo bảng)
1. `ProvinceApiClient.java` — class gọi HTTP tới API ngoài (dùng `java.net.http.HttpClient`), trả về JSON string thô.
2. `ProvinceProxyServlet.java` — servlet `@WebServlet("/api/provinces")`:
   - Không có param `provinceCode` → trả toàn bộ danh sách tỉnh.
   - Có param `provinceCode` → trả tỉnh đó kèm `wards` (dùng `depth=2`).
3. Form JSP nhập địa chỉ — 2 dropdown (Tỉnh, Xã/Phường) + input ẩn lưu tên tương ứng để submit.
4. JS trong JSP — load tỉnh khi trang mở; khi đổi tỉnh thì gọi lại servlet lấy xã theo `provinceCode`; lưu tên vào input ẩn khi user chọn.
5. `AddressServlet.java` (đã có, chỉ sửa `doPost`) — map `request.getParameter("province")`, `request.getParameter("ward")` vào `Address.builder()`, set `district(null)`.

## Cải tiến nên làm thêm (tuỳ chọn, không bắt buộc)
- Cache danh sách tỉnh ở server (`ServletContext` attribute, load 1 lần khi `contextInitialized`) để tránh gọi API ngoài mỗi lần mở form.
- Validate ở server: đối chiếu tên tỉnh/xã submit lên có khớp với dữ liệu thật từ API (theo code) trước khi lưu, tránh user sửa tay HTML gửi sai dữ liệu.

## Việc KHÔNG được làm (tránh AI đề xuất lại nhầm hướng cũ)
- Không tạo bảng `province`, `ward` trong SQL Server.
- Không tạo entity `Province`, `Ward`, không thêm `@ManyToOne` vào `Address`.
- Không đồng bộ (sync/seed) toàn bộ dữ liệu tỉnh/xã vào DB dự án.
- Không dùng cấu trúc 3 cấp (Tỉnh/Huyện/Xã) hay API v1.
