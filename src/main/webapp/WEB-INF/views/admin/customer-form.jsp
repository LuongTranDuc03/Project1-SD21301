<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.Customer" %>
<%@ page import="project.duan1_sd21301.model.Address" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Customer c = (Customer) request.getAttribute("customer");
    boolean isEdit = (c != null);
    SimpleDateFormat isoDf = new SimpleDateFormat("yyyy-MM-dd");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - <%= isEdit ? "Cập nhật khách hàng" : "Thêm khách hàng" %></title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css">
    
    <style>
        .form-container {
            display: grid;
            grid-template-columns: 260px 1fr;
            gap: 24px;
            margin-top: 20px;
        }
        @media(max-width: 900px) {
            .form-container {
                grid-template-columns: 1fr;
            }
        }
        .avatar-preview-card {
            background-color: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            padding: 30px 20px;
            text-align: center;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: fit-content;
        }
        .preview-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #f1f5f9;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            margin-bottom: 16px;
            transition: all 0.3s;
        }
        .form-card {
            background-color: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            padding: 24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03);
        }
        .address-row {
            display: flex;
            gap: 10px;
            align-items: center;
            width: 100%;
        }
        .radio-lbl {
            font-size: 11px;
            font-weight: 600;
            color: #64748b;
            min-width: 65px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Nhúng Sidebar dùng chung -->
        <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

        <!-- Khu vực nội dung chính bên phải -->
        <main class="main-content">
            <!-- 1. Thanh Navbar trên cùng -->
            <header class="navbar">
                <div class="breadcrumb">
                    <span>FamiCoats Admin</span> / <span>Quản lý khách hàng</span> / <span class="active-crumb"><%= isEdit ? "Chỉnh sửa hồ sơ" : "Thêm mới" %></span>
                </div>
                <div class="navbar-right">
                    <button class="notif-btn">
                        <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                        <span class="notif-badge"></span>
                    </button>
                    <div class="date-pill">Thứ Ba, 30/06/2026</div>
                    <div class="profile-pill">
                        <span class="profile-avatar-mini">A</span>
                        <span>Admin</span>
                    </div>
                </div>
            </header>

            <!-- 2. Thân trang hiển thị form nhập liệu -->
            <div class="content-wrapper">
                <!-- Tiêu đề trang và điều hướng -->
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <div>
                        <h1><%= isEdit ? "Cập nhật hồ sơ khách hàng" : "Thêm khách hàng mới" %></h1>
                        <div class="subtitle"><%= (isEdit && c != null) ? "Chỉnh sửa các trường thông tin của " + c.getId() : "Điền đầy đủ thông tin để lưu khách hàng" %></div>
                    </div>
                    <a href="<%= contextPath %>/admin/customers<%= (isEdit && c != null) ? "?action=details&id=" + c.getId() : "" %>" class="btn-outline" style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none; border-radius: 8px; padding: 10px 16px; font-weight: 600;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 6px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                        <span>Quay lại</span>
                    </a>
                </div>

                <!-- Form Layout Container - Đã thêm enctype="multipart/form-data" -->
                <form action="<%= contextPath %>/admin/customers" method="post" id="customerForm" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                    <!-- Trường ẩn giữ URL ảnh cũ khi chỉnh sửa và không upload tệp mới -->
                    <input type="hidden" name="anhDaiDien" value="<%= (isEdit && c != null) ? c.getAnhDaiDien() : "" %>">
                    
                    <div class="form-container">
                        <!-- Cột trái: Live Preview Avatar -->
                        <div class="avatar-preview-card" style="border: none; background: none; box-shadow: none; padding: 10px 0; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                            <img src="<%= (isEdit && c != null) ? c.getAnhDaiDien() : "https://i.pravatar.cc/150?img=0" %>" id="avatarPreview" class="preview-avatar" alt="avatar preview" onerror="this.src='https://i.pravatar.cc/150?img=0'" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 1px solid #e2e8f0; margin-bottom: 16px;">
                            
                            <!-- Input chọn file ẩn đi -->
                            <input type="file" name="anhDaiDienFile" id="customerAvatarFile" accept="image/*" onchange="previewImage(this)" style="display: none;">
                            
                            <!-- Nút chọn ảnh được thiết kế theo đúng hình mẫu (Viền mỏng, chữ Chọn Ảnh) -->
                            <button type="button" onclick="document.getElementById('customerAvatarFile').click()" style="background-color: #ffffff; border: 1px solid #d1d5db; color: #374151; font-family: inherit; font-size: 13px; font-weight: 500; padding: 8px 16px; border-radius: 4px; cursor: pointer; transition: background-color 0.2s, border-color 0.2s; margin-bottom: 12px; min-width: 100px;">
                                Chọn Ảnh
                            </button>
                            
                            <!-- Phần chỉ dẫn giới hạn file và định dạng -->
                            <div style="font-size: 11px; color: #9ca3af; line-height: 1.5; text-align: center;">
                                Dung lượng file tối đa 1 MB<br>
                                Định dạng:.JPEG, .PNG
                            </div>
                        </div>

                        <!-- Cột phải: Khung điền biểu mẫu -->
                        <div class="form-card">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="customerId">Mã khách hàng <span style="color: #64748b;">*</span></label>
                                    <input type="text" name="id" id="customerId" placeholder="Ví dụ: KH005" required value="<%= (isEdit && c != null) ? c.getId() : "" %>" <%= isEdit ? "readonly" : "" %>>
                                </div>
                                <div class="form-group">
                                    <label for="customerName">Họ và tên <span style="color: #64748b;">*</span></label>
                                    <input type="text" name="hoTen" id="customerName" placeholder="Nhập đầy đủ họ tên" required value="<%= (isEdit && c != null) ? c.getHoTen() : "" %>">
                                </div>
                                <div class="form-group">
                                    <label for="customerEmail">Email liên hệ <span style="color: #64748b;">*</span></label>
                                    <input type="email" name="email" id="customerEmail" placeholder="example@gmail.com" required value="<%= (isEdit && c != null) ? c.getEmail() : "" %>">
                                </div>
                                <div class="form-group">
                                    <label for="customerPassword">Mật khẩu <span style="color: #64748b;">*</span></label>
                                    <input type="password" name="matKhau" id="customerPassword" placeholder="Mật khẩu tài khoản" required value="<%= (isEdit && c != null) ? c.getMatKhau() : "" %>">
                                </div>
                                <div class="form-group">
                                    <label for="customerPhone">Số điện thoại <span style="color: #64748b;">*</span></label>
                                    <input type="tel" name="soDienThoai" id="customerPhone" placeholder="Ví dụ: 0987654321" required value="<%= (isEdit && c != null) ? c.getSoDienThoai() : "" %>">
                                </div>
                                <div class="form-group">
                                    <label for="customerDob">Ngày sinh</label>
                                    <input type="date" name="ngaySinh" id="customerDob" value="<%= (isEdit && c != null && c.getNgaySinh() != null) ? isoDf.format(c.getNgaySinh()) : "" %>">
                                </div>
                                <div class="form-group">
                                    <label for="customerGender">Giới tính</label>
                                    <select name="gioiTinh" id="customerGender">
                                        <option value="Nam" <%= (isEdit && c != null && "Nam".equals(c.getGioiTinh())) ? "selected" : "" %>>Nam</option>
                                        <option value="Nữ" <%= (isEdit && c != null && "Nữ".equals(c.getGioiTinh())) ? "selected" : "" %>>Nữ</option>
                                        <option value="Khác" <%= (isEdit && c != null && "Khác".equals(c.getGioiTinh())) ? "selected" : "" %>>Khác</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="customerPoints">Điểm tích lũy</label>
                                    <input type="number" name="diemTichLuy" id="customerPoints" min="0" value="<%= (isEdit && c != null) ? c.getDiemTichLuy() : "0" %>">
                                </div>
                                <div class="form-group">
                                    <label for="customerRank">Hạng thành viên</label>
                                    <select name="hangThanhVien" id="customerRank">
                                        <option value="Đồng" <%= (isEdit && c != null && "Đồng".equals(c.getHangThanhVien())) ? "selected" : "" %>>Đồng</option>
                                        <option value="Bạc" <%= (isEdit && c != null && "Bạc".equals(c.getHangThanhVien())) ? "selected" : "" %>>Bạc</option>
                                        <option value="Vàng" <%= (isEdit && c != null && "Vàng".equals(c.getHangThanhVien())) ? "selected" : "" %>>Vàng</option>
                                        <option value="Kim cương" <%= (isEdit && c != null && "Kim cương".equals(c.getHangThanhVien())) ? "selected" : "" %>>Kim cương</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="customerStatus">Trạng thái</label>
                                    <select name="trangThai" id="customerStatus">
                                        <option value="Hoạt động" <%= (isEdit && c != null && "Hoạt động".equals(c.getTrangThai())) ? "selected" : "" %>>Hoạt động</option>
                                        <option value="Khóa" <%= (isEdit && c != null && "Khóa".equals(c.getTrangThai())) ? "selected" : "" %>>Khóa</option>
                                    </select>
                                </div>
                                
                                <!-- ĐỊA CHỈ MẶC ĐỊNH (Tên người nhận, SĐT, Địa chỉ chi tiết) -->
                                <div class="form-group form-group-full" style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; background-color: #f8fafc; display: flex; flex-direction: column; gap: 12px; margin-bottom: 16px;">
                                    <span style="font-size: 13px; font-weight: 600; color: #0f172a; display: block; border-bottom: 1px solid #e2e8f0; padding-bottom: 6px;">Địa chỉ mặc định</span>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label style="font-size: 11px; margin-bottom: 4px;">Tên người nhận <span style="color: #64748b;">*</span></label>
                                            <input type="text" name="diaChiMacDinhTen" id="defaultAddressTen" placeholder="Tên người nhận" required value="<%= (isEdit && c != null && c.getDiaChiMacDinh() != null) ? c.getDiaChiMacDinh().getTenNguoiNhan() : "" %>" style="height: 36px;">
                                        </div>
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label style="font-size: 11px; margin-bottom: 4px;">SĐT người nhận <span style="color: #64748b;">*</span></label>
                                            <input type="text" name="diaChiMacDinhSdt" id="defaultAddressSdt" placeholder="Số điện thoại" required value="<%= (isEdit && c != null && c.getDiaChiMacDinh() != null) ? c.getDiaChiMacDinh().getSdtNguoiNhan() : "" %>" style="height: 36px;">
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label style="font-size: 11px; margin-bottom: 4px;">Địa chỉ chi tiết <span style="color: #64748b;">*</span></label>
                                        <input type="text" name="diaChiMacDinh" id="customerDefaultAddress" placeholder="Số nhà, tên đường, phường/xã, quận/huyện..." required value="<%= (isEdit && c != null && c.getDiaChiMacDinh() != null) ? c.getDiaChiMacDinh().getChiTietDiaChi() : "" %>" style="height: 36px;">
                                    </div>
                                </div>
                                
                                <!-- CÁC ĐỊA CHỈ KHÁC (THÊM ĐỘNG BẰNG JS) -->
                                <div class="form-group form-group-full" style="margin-top: 12px;">
                                    <label style="display: flex; justify-content: space-between; align-items: center;">
                                        <span style="font-size: 12px; font-weight: 600; color: #475569;">Các địa chỉ khác</span>
                                        <button type="button" class="btn-outline" style="padding: 4px 10px; font-size: 11px; border-radius: 6px; cursor: pointer;" onclick="addAddressField()">+ Thêm địa chỉ mới</button>
                                    </label>
                                    <div id="otherAddressesContainer" style="display: flex; flex-direction: column; gap: 12px; margin-top: 6px;">
                                        <%
                                            if (isEdit && c != null && c.getDiaChiKhac() != null) {
                                                for (int i = 0; i < c.getDiaChiKhac().size(); i++) {
                                                    Address addr = c.getDiaChiKhac().get(i);
                                        %>
                                            <div class="address-card-row" style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; background-color: #ffffff; display: flex; flex-direction: column; gap: 12px; position: relative;">
                                                <div style="display: flex; justify-content: flex-end; gap: 8px;">
                                                    <button type="button" class="btn-outline" style="padding: 4px 8px; font-size: 11px; border-radius: 6px; cursor: pointer; height: 28px;" onclick="setDefaultAddress(this)">Đặt làm mặc định</button>
                                                    <button type="button" class="btn-outline" style="padding: 4px 8px; font-size: 11px; border-radius: 6px; cursor: pointer; height: 28px; border-color: #f1f5f9; color: #ef4444;" onclick="removeAddressField(this)">Xóa</button>
                                                </div>
                                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                                    <div class="form-group" style="margin-bottom: 0;">
                                                        <label style="font-size: 11px; margin-bottom: 4px;">Tên người nhận</label>
                                                        <input type="text" name="diaChiKhacTen" placeholder="Tên người nhận" value="<%= addr.getTenNguoiNhan() != null ? addr.getTenNguoiNhan() : "" %>" style="height: 36px;">
                                                    </div>
                                                    <div class="form-group" style="margin-bottom: 0;">
                                                        <label style="font-size: 11px; margin-bottom: 4px;">SĐT người nhận</label>
                                                        <input type="text" name="diaChiKhacSdt" placeholder="Số điện thoại" value="<%= addr.getSdtNguoiNhan() != null ? addr.getSdtNguoiNhan() : "" %>" style="height: 36px;">
                                                    </div>
                                                </div>
                                                <div class="form-group" style="margin-bottom: 0;">
                                                    <label style="font-size: 11px; margin-bottom: 4px;">Địa chỉ chi tiết</label>
                                                    <input type="text" name="diaChiKhac" placeholder="Số nhà, tên đường, phường/xã, quận/huyện..." value="<%= addr.getChiTietDiaChi() != null ? addr.getChiTietDiaChi() : "" %>" style="height: 36px;">
                                                </div>
                                            </div>
                                        <%
                                                }
                                            }
                                        %>
                                    </div>
                                </div>


                            </div>
                            
                            <!-- Nút submit hành động chuyển thành màu đen trung tính -->
                            <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #f1f5f9;">
                                <a href="<%= contextPath %>/admin/customers" class="btn-outline" style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none; border-radius: 8px; padding: 10px 16px; font-weight: 600;">Hủy bỏ</a>
                                <button type="submit" class="btn-export" style="background-color: #0f172a; border-radius: 8px; font-weight: 600; box-shadow: none;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 6px;"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                                    <span>Lưu thông tin</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <script>
        // Preview ảnh khi người dùng tải tệp ảnh lên từ máy tính
        function previewImage(input) {
            const previewImg = document.getElementById('avatarPreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                previewImg.src = "https://i.pravatar.cc/150?img=0";
            }
        }

        function addAddressField(ten = '', sdt = '', detail = '') {
            const container = document.getElementById('otherAddressesContainer');
            
            const div = document.createElement('div');
            div.className = 'address-card-row';
            div.style.cssText = 'border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; background-color: #ffffff; display: flex; flex-direction: column; gap: 12px; position: relative;';
            div.innerHTML = `
                <div style="display: flex; justify-content: flex-end; gap: 8px;">
                    <button type="button" class="btn-outline" style="padding: 4px 8px; font-size: 11px; border-radius: 6px; cursor: pointer; height: 28px;" onclick="setDefaultAddress(this)">Đặt làm mặc định</button>
                    <button type="button" class="btn-outline" style="padding: 4px 8px; font-size: 11px; border-radius: 6px; cursor: pointer; height: 28px; border-color: #f1f5f9; color: #ef4444;" onclick="removeAddressField(this)">Xóa</button>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label style="font-size: 11px; margin-bottom: 4px;">Tên người nhận</label>
                        <input type="text" name="diaChiKhacTen" placeholder="Tên người nhận" value="${ten}" style="height: 36px;">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label style="font-size: 11px; margin-bottom: 4px;">SĐT người nhận</label>
                        <input type="text" name="diaChiKhacSdt" placeholder="Số điện thoại" value="${sdt}" style="height: 36px;">
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <label style="font-size: 11px; margin-bottom: 4px;">Địa chỉ chi tiết</label>
                    <input type="text" name="diaChiKhac" placeholder="Số nhà, tên đường, phường/xã, quận/huyện..." value="${detail}" style="height: 36px;">
                </div>
            `;
            container.appendChild(div);
        }

        // Hoán đổi địa chỉ phụ được chọn lên làm địa chỉ mặc định chính thức
        function setDefaultAddress(button) {
            const card = button.closest('.address-card-row');
            
            const otherTen = card.querySelector('input[name="diaChiKhacTen"]');
            const otherSdt = card.querySelector('input[name="diaChiKhacSdt"]');
            const otherDetail = card.querySelector('input[name="diaChiKhac"]');
            
            const mainTen = document.getElementById('defaultAddressTen');
            const mainSdt = document.getElementById('defaultAddressSdt');
            const mainDetail = document.getElementById('customerDefaultAddress');
            
            if (otherTen && otherSdt && otherDetail && mainTen && mainSdt && mainDetail) {
                // Swap values
                const tempTen = mainTen.value;
                const tempSdt = mainSdt.value;
                const tempDetail = mainDetail.value;
                
                mainTen.value = otherTen.value;
                mainSdt.value = otherSdt.value;
                mainDetail.value = otherDetail.value;
                
                otherTen.value = tempTen;
                otherSdt.value = tempSdt;
                otherDetail.value = tempDetail;
                
                // Hiệu ứng màu nền chuyển động mượt mà
                const elements = [mainTen, mainSdt, mainDetail, otherTen, otherSdt, otherDetail];
                elements.forEach(el => {
                    el.style.transition = 'background-color 0.3s';
                    el.style.backgroundColor = '#f1f5f9';
                });
                setTimeout(() => {
                    elements.forEach(el => {
                        el.style.backgroundColor = '#ffffff';
                    });
                }, 300);
            }
        }

        function removeAddressField(button) {
            button.closest('.address-card-row').remove();
        }
    </script>
</body>
</html>
