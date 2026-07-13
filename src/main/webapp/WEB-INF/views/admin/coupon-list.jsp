<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.Coupon" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - Quản lý phiếu giảm giá</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        /* CSS nội bộ bổ sung để tối ưu layout của trang */
        .coupon-cond-pill {
            font-size: 11px;
            font-weight: 500;
            background-color: #f1f5f9;
            color: #475569;
            padding: 2px 8px;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
            display: inline-block;
        }
        .status-pill.upcoming {
            background-color: #eff6ff;
            color: #1d4ed8;
        }
        .status-pill.expired {
            background-color: #fee2e2;
            color: #b91c1c;
        }
        .status-pill.inactive {
            background-color: #f1f5f9;
            color: #475569;
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
                    <span>FamiCoats Admin</span> / <span class="active-crumb">${requestScope.pageTitle}</span>
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

            <!-- 2. Thân trang hiển thị danh sách phiếu giảm giá -->
            <div class="content-wrapper">
                
                <!-- Hiển thị Alert nếu có thông báo -->
                <% if (request.getAttribute("successMsg") != null) { %>
                    <div class="alert-banner success">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <span><%= request.getAttribute("successMsg") %></span>
                    </div>
                <% } %>
                <% if (request.getAttribute("errorMsg") != null) { %>
                    <div class="alert-banner error">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <span><%= request.getAttribute("errorMsg") %></span>
                    </div>
                <% } %>

                <!-- Tiêu đề trang -->
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <div>
                        <h1>Quản lý phiếu giảm giá</h1>
                        <div class="subtitle">Tổng số: ${requestScope.totalCount} chương trình khuyến mãi</div>
                    </div>
                    <button class="btn-export" style="background-color: #E11D48; border-color: #E11D48; display: inline-flex; align-items: center; gap: 8px;" onclick="openAddModal()">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        <span>Thêm phiếu giảm giá</span>
                    </button>
                </div>

                <!-- 4 Ô thống kê trạng thái phiếu giảm giá -->
                <div class="metrics-grid">
                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box blue" style="background-color: rgba(59, 130, 246, 0.1); color: #3b82f6;">
                                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                            </div>
                        </div>
                        <div class="metric-value">${requestScope.totalCount}</div>
                        <div class="metric-label">Tổng số lượng mã</div>
                        <div class="metric-trend">Tất cả chương trình</div>
                    </div>

                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box pink" style="background-color: rgba(16, 185, 129, 0.1); color: #10b981;">
                                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            </div>
                        </div>
                        <div class="metric-value">${requestScope.activeCount}</div>
                        <div class="metric-label">Đang hoạt động</div>
                        <div class="metric-trend">Đang áp dụng mua sắm</div>
                    </div>

                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box purple" style="background-color: rgba(139, 92, 246, 0.1); color: #8b5cf6;">
                                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </div>
                        </div>
                        <div class="metric-value">${requestScope.upcomingCount}</div>
                        <div class="metric-label">Chưa diễn ra</div>
                        <div class="metric-trend">Lên lịch chờ kích hoạt</div>
                    </div>

                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box yellow" style="background-color: rgba(245, 158, 11, 0.1); color: #f59e0b;">
                                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                            </div>
                        </div>
                        <div class="metric-value"><%= (int)request.getAttribute("expiredCount") + (int)request.getAttribute("inactiveCount") %></div>
                        <div class="metric-label">Hết hạn / Tạm dừng</div>
                        <div class="metric-trend">Đã dừng hoặc hết hạn</div>
                    </div>
                </div>

                <!-- Thanh tìm kiếm & bộ lọc trạng thái -->
                <%
                    String currentFilter = (String) request.getAttribute("statusFilter");
                    if (currentFilter == null) currentFilter = "ALL";
                    String currentSearch = (String) request.getAttribute("searchQuery");
                    if (currentSearch == null) currentSearch = "";
                %>
                <div class="filter-search-container">
                    <div class="search-input-group">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <input type="text" class="search-input" value="<%= currentSearch %>" placeholder="Tìm theo mã hoặc tên khuyến mãi..." onkeypress="handleSearchPress(event)">
                    </div>
                    <div class="filter-pills">
                        <button class="filter-pill <%= "ALL".equals(currentFilter) ? "active" : "" %>" onclick="filterByStatus('ALL')">Tất cả</button>
                        <button class="filter-pill <%= "ACTIVE".equals(currentFilter) ? "active" : "" %>" onclick="filterByStatus('ACTIVE')">Đang hoạt động</button>
                        <button class="filter-pill <%= "UPCOMING".equals(currentFilter) ? "active" : "" %>" onclick="filterByStatus('UPCOMING')">Chưa diễn ra</button>
                        <button class="filter-pill <%= "EXPIRED".equals(currentFilter) ? "active" : "" %>" onclick="filterByStatus('EXPIRED')">Đã hết hạn</button>
                        <button class="filter-pill <%= "INACTIVE".equals(currentFilter) ? "active" : "" %>" onclick="filterByStatus('INACTIVE')">Tạm dừng</button>
                    </div>
                </div>

                <!-- Bảng danh sách phiếu giảm giá -->
                <div class="card" style="padding: 0; overflow: hidden;">
                    <div class="table-responsive">
                        <table class="invoice-table">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Thông tin chương trình</th>
                                    <th>Mức giảm</th>
                                    <th>Điều kiện đơn</th>
                                    <th>Giảm tối đa</th>
                                    <th style="width: 180px;">Đã sử dụng / Tổng</th>
                                    <th>Thời hạn áp dụng</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align: center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Coupon> coupons = (List<Coupon>) request.getAttribute("coupons");
                                    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                    SimpleDateFormat dfISO = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                                    if (coupons != null && !coupons.isEmpty()) {
                                        for (Coupon c : coupons) {
                                            // Thiết lập trạng thái
                                            String statusClass = "";
                                            String statusLabel = "";
                                            if ("ACTIVE".equalsIgnoreCase(c.getTrangThai())) {
                                                statusClass = "success";
                                                statusLabel = "Đang diễn ra";
                                            } else if ("UPCOMING".equalsIgnoreCase(c.getTrangThai())) {
                                                statusClass = "upcoming";
                                                statusLabel = "Chưa diễn ra";
                                            } else if ("EXPIRED".equalsIgnoreCase(c.getTrangThai())) {
                                                statusClass = "expired";
                                                statusLabel = "Hết hạn";
                                            } else if ("INACTIVE".equalsIgnoreCase(c.getTrangThai())) {
                                                statusClass = "inactive";
                                                statusLabel = "Tạm dừng";
                                            }

                                            // Định dạng mức giảm giá
                                            String mucGiam = "";
                                            if ("PERCENT".equalsIgnoreCase(c.getLoaiGiam())) {
                                                mucGiam = String.format("%.0f%%", c.getGiaTriGiam());
                                            } else {
                                                mucGiam = String.format("%,.0fđ", c.getGiaTriGiam()).replace(",", ".");
                                            }

                                            // Định dạng điều kiện
                                            String donToiThieu = String.format("%,.0fđ", c.getGiaTriDonHangToiThieu()).replace(",", ".");
                                            String giamMaxText = "---";
                                            if (c.getGiamToiDa() > 0) {
                                                giamMaxText = String.format("%,.0fđ", c.getGiamToiDa()).replace(",", ".");
                                            }

                                            // Tính phần trăm sử dụng cho thanh progress
                                            double usagePercent = 0;
                                            if (c.getSoLuong() > 0) {
                                                usagePercent = ((double) c.getDaSuDung() / c.getSoLuong()) * 100;
                                                if (usagePercent > 100) usagePercent = 100;
                                            }
                                %>
                                <tr>
                                    <!-- Mã phiếu -->
                                    <td style="font-family: 'Inter', sans-serif; font-size: 14px; line-height: 20px; font-weight: 600; color: #E11D48;"><%= c.getId() %></td>
                                    
                                    <!-- Thông tin chương trình -->
                                    <td>
                                        <div class="customer-cell">
                                            <span class="customer-name-text"><%= c.getTenChuongTrinh() %></span>
                                            <span class="customer-phone-text" style="max-width: 250px; display: inline-block; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="<%= c.getMoTa() != null ? c.getMoTa() : "" %>">
                                                <%= c.getMoTa() != null ? c.getMoTa() : "Không có mô tả" %>
                                            </span>
                                        </div>
                                    </td>

                                    <!-- Mức giảm -->
                                    <td style="font-family: 'Inter', sans-serif; font-size: 14px; font-weight: 700; color: #0f172a;"><%= mucGiam %></td>

                                    <!-- Điều kiện đơn tối thiểu -->
                                    <td>
                                        <span class="coupon-cond-pill"><%= donToiThieu %></span>
                                    </td>

                                    <!-- Giảm tối đa -->
                                    <td style="color: #475569; font-weight: 500;"><%= giamMaxText %></td>

                                    <!-- Đã sử dụng / Tổng số lượng -->
                                    <td>
                                        <div class="coupon-usage-wrapper">
                                            <div class="coupon-usage-text">
                                                <span>Đã dùng: <strong><%= c.getDaSuDung() %></strong></span>
                                                <span><%= c.getSoLuong() %></span>
                                            </div>
                                            <div class="coupon-usage-bar-bg" title="Đã sử dụng <%= String.format("%.1f", usagePercent) %>%">
                                                <div class="coupon-usage-bar-fill" style="width: <%= usagePercent %>%;"></div>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Thời hạn áp dụng -->
                                    <td style="font-size: 12px; color: #64748b; line-height: 1.6;">
                                        <div>BĐ: <strong><%= df.format(c.getNgayBatDau()) %></strong></div>
                                        <div>KT: <strong><%= df.format(c.getNgayKetThuc()) %></strong></div>
                                    </td>

                                    <!-- Trạng thái -->
                                    <td>
                                        <span class="status-pill <%= statusClass %>"><%= statusLabel %></span>
                                    </td>

                                    <!-- Thao tác -->
                                    <td style="text-align: center; white-space: nowrap;">
                                        <button class="action-icon-btn edit" title="Sửa phiếu giảm giá" onclick='openEditModal({
                                            "id": "<%= c.getId() %>",
                                            "tenChuongTrinh": "<%= c.getTenChuongTrinh().replace("\"", "\\\"") %>",
                                            "loaiGiam": "<%= c.getLoaiGiam() %>",
                                            "giaTriGiam": <%= c.getGiaTriGiam() %>,
                                            "giaTriDonHangToiThieu": <%= c.getGiaTriDonHangToiThieu() %>,
                                            "giamToiDa": <%= c.getGiamToiDa() %>,
                                            "soLuong": <%= c.getSoLuong() %>,
                                            "daSuDung": <%= c.getDaSuDung() %>,
                                            "ngayBatDau": "<%= dfISO.format(c.getNgayBatDau()) %>",
                                            "ngayKetThuc": "<%= dfISO.format(c.getNgayKetThuc()) %>",
                                            "moTa": "<%= c.getMoTa() != null ? c.getMoTa().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "" %>",
                                            "trangThai": "<%= c.getTrangThai() %>"
                                        })' style="color: #4f46e5; border-color: rgba(79, 70, 229, 0.2); background: rgba(79, 70, 229, 0.05); padding: 6px; border-radius: 6px; cursor: pointer; border: 1px solid transparent; display: inline-flex; align-items: center; justify-content: center;">
                                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                        </button>
                                        <button class="action-icon-btn delete" title="Xoá phiếu giảm giá" onclick="confirmDelete('<%= c.getId() %>')" style="margin-left: 6px; color: #dc2626; border-color: rgba(220, 38, 38, 0.2); background: rgba(220, 38, 38, 0.05); padding: 6px; border-radius: 6px; cursor: pointer; border: 1px solid transparent; display: inline-flex; align-items: center; justify-content: center;">
                                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                                        </button>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 40px; color: #9ca3af;">Không tìm thấy dữ liệu phiếu giảm giá phù hợp.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- 3. Modal Thêm / Sửa Phiếu Giảm Giá -->
    <div class="modal-overlay" id="couponModal" onclick="handleOverlayClick(event)">
        <div class="modal-container">
            <header class="modal-header">
                <h3 id="modalTitle">
                    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                    <span>Thêm Phiếu Giảm Giá Mới</span>
                </h3>
                <button class="modal-close-btn" onclick="closeModal()">
                    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </header>
            
            <form action="${pageContext.request.contextPath}/admin/coupons" method="POST" id="couponForm">
                <input type="hidden" name="action" id="formAction" value="add">
                
                <div class="modal-body">
                    <div class="form-grid">
                        <!-- Mã phiếu giảm giá -->
                        <div class="form-group">
                            <label for="couponId">Mã giảm giá <span class="required">*</span></label>
                            <input type="text" name="id" id="couponId" class="form-control" placeholder="Ví dụ: PGG-SUMMER" required>
                        </div>
                        
                        <!-- Tên chương trình -->
                        <div class="form-group">
                            <label for="tenChuongTrinh">Tên chương trình <span class="required">*</span></label>
                            <input type="text" name="tenChuongTrinh" id="tenChuongTrinh" class="form-control" placeholder="Nhập tên chương trình..." required>
                        </div>
                        
                        <!-- Loại giảm -->
                        <div class="form-group">
                            <label for="loaiGiam">Loại hình giảm giá <span class="required">*</span></label>
                            <select name="loaiGiam" id="loaiGiam" class="form-control" onchange="toggleTypePlaceholder()">
                                <option value="PERCENT">Phần trăm (%)</option>
                                <option value="CASH">Tiền mặt (đ)</option>
                            </select>
                        </div>
                        
                        <!-- Giá trị giảm -->
                        <div class="form-group">
                            <label for="giaTriGiam">Giá trị giảm <span class="required">*</span></label>
                            <div class="input-group">
                                <input type="number" step="any" name="giaTriGiam" id="giaTriGiam" class="form-control" placeholder="15" min="1" required>
                                <span class="input-group-addon" id="valAddon">%</span>
                            </div>
                        </div>

                        <!-- Điều kiện đơn hàng tối thiểu -->
                        <div class="form-group">
                            <label for="giaTriDonHangToiThieu">Giá trị đơn hàng tối thiểu <span class="required">*</span></label>
                            <div class="input-group">
                                <input type="number" step="any" name="giaTriDonHangToiThieu" id="giaTriDonHangToiThieu" class="form-control" placeholder="200,000" min="0" required>
                                <span class="input-group-addon">đ</span>
                            </div>
                        </div>

                        <!-- Giảm tối đa -->
                        <div class="form-group">
                            <label for="giamToiDa">Số tiền giảm tối đa</label>
                            <div class="input-group">
                                <input type="number" step="any" name="giamToiDa" id="giamToiDa" class="form-control" placeholder="50,000 (để 0 nếu không giới hạn)" min="0">
                                <span class="input-group-addon">đ</span>
                            </div>
                        </div>

                        <!-- Số lượng mã -->
                        <div class="form-group">
                            <label for="soLuong">Số lượng phát hành <span class="required">*</span></label>
                            <input type="number" name="soLuong" id="soLuong" class="form-control" placeholder="100" min="1" required>
                        </div>

                        <!-- Đã sử dụng (Ẩn hoặc để readonly khi sửa) -->
                        <div class="form-group">
                            <label for="daSuDung">Đã sử dụng</label>
                            <input type="number" name="daSuDung" id="daSuDung" class="form-control" placeholder="0" min="0" value="0">
                        </div>

                        <!-- Ngày bắt đầu -->
                        <div class="form-group">
                            <label for="ngayBatDau">Ngày bắt đầu <span class="required">*</span></label>
                            <input type="datetime-local" name="ngayBatDau" id="ngayBatDau" class="form-control" required>
                        </div>

                        <!-- Ngày kết thúc -->
                        <div class="form-group">
                            <label for="ngayKetThuc">Ngày kết thúc <span class="required">*</span></label>
                            <input type="datetime-local" name="ngayKetThuc" id="ngayKetThuc" class="form-control" required>
                        </div>

                        <!-- Trạng thái -->
                        <div class="form-group full-width">
                            <label for="trangThai">Trạng thái phiếu</label>
                            <select name="trangThai" id="trangThai" class="form-control">
                                <option value="ACTIVE">Hoạt động (Đang diễn ra)</option>
                                <option value="UPCOMING">Chưa bắt đầu (Lên lịch)</option>
                                <option value="INACTIVE">Tạm ngưng hoạt động</option>
                            </select>
                        </div>

                        <!-- Mô tả -->
                        <div class="form-group full-width">
                            <label for="moTa">Mô tả chương trình</label>
                            <textarea name="moTa" id="moTa" rows="3" class="form-control" placeholder="Viết mô tả ngắn gọn về chương trình khuyến mãi..."></textarea>
                        </div>
                    </div>
                </div>
                
                <footer class="modal-footer">
                    <button type="button" class="btn btn-outline" style="padding: 8px 16px; border-radius: 8px;" onclick="closeModal()">Hủy</button>
                    <button type="submit" class="btn-export" style="border-radius: 8px; padding: 10px 20px;">Lưu lại</button>
                </footer>
            </form>
        </div>
    </div>

    <!-- JavaScript xử lý Modal & Filter -->
    <script>
        const modal = document.getElementById("couponModal");
        const modalTitle = document.getElementById("modalTitle");
        const formAction = document.getElementById("formAction");
        const valAddon = document.getElementById("valAddon");
        const valInput = document.getElementById("giaTriGiam");

        function openAddModal() {
            modalTitle.innerHTML = `
                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                <span>Thêm Phiếu Giảm Giá Mới</span>
            `;
            formAction.value = "add";
            
            // Xóa sạch form
            document.getElementById("couponForm").reset();
            document.getElementById("couponId").readOnly = false;
            document.getElementById("daSuDung").value = "0";
            document.getElementById("daSuDung").readOnly = true; // add mới thì luôn là 0 sử dụng
            
            toggleTypePlaceholder();
            modal.classList.add("show");
        }

        function openEditModal(coupon) {
            modalTitle.innerHTML = `
                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                <span>Chỉnh Sửa Phiếu Giảm Giá</span>
            `;
            formAction.value = "edit";
            
            // Điền dữ liệu
            document.getElementById("couponId").value = coupon.id;
            document.getElementById("couponId").readOnly = true; // Sửa thì không được thay đổi khoá chính
            document.getElementById("tenChuongTrinh").value = coupon.tenChuongTrinh;
            document.getElementById("loaiGiam").value = coupon.loaiGiam;
            document.getElementById("giaTriGiam").value = coupon.giaTriGiam;
            document.getElementById("giaTriDonHangToiThieu").value = coupon.giaTriDonHangToiThieu;
            document.getElementById("giamToiDa").value = coupon.giamToiDa;
            document.getElementById("soLuong").value = coupon.soLuong;
            document.getElementById("daSuDung").value = coupon.daSuDung;
            document.getElementById("daSuDung").readOnly = false;
            document.getElementById("ngayBatDau").value = coupon.ngayBatDau;
            document.getElementById("ngayKetThuc").value = coupon.ngayKetThuc;
            document.getElementById("moTa").value = coupon.moTa;
            document.getElementById("trangThai").value = coupon.trangThai;
            
            toggleTypePlaceholder();
            modal.classList.add("show");
        }

        function closeModal() {
            modal.classList.remove("show");
        }

        function handleOverlayClick(event) {
            if (event.target === modal) {
                closeModal();
            }
        }

        function toggleTypePlaceholder() {
            const loai = document.getElementById("loaiGiam").value;
            if (loai === "PERCENT") {
                valAddon.innerText = "%";
                valInput.placeholder = "15";
                valInput.max = "100";
            } else {
                valAddon.innerText = "đ";
                valInput.placeholder = "50,000";
                valInput.removeAttribute("max");
            }
        }

        function handleSearchPress(event) {
            if (event.key === "Enter") {
                const searchVal = event.target.value;
                const status = "<%= currentFilter %>";
                window.location.href = "${pageContext.request.contextPath}/admin/coupons?status=" + status + "&search=" + encodeURIComponent(searchVal);
            }
        }

        function filterByStatus(status) {
            const searchVal = document.querySelector(".search-input").value;
            let url = "${pageContext.request.contextPath}/admin/coupons?status=" + status;
            if (searchVal) {
                url += "&search=" + encodeURIComponent(searchVal);
            }
            window.location.href = url;
        }

        function confirmDelete(id) {
            if (confirm("Bạn có chắc chắn muốn xóa vĩnh viễn phiếu giảm giá " + id + " không?")) {
                const form = document.createElement("form");
                form.method = "POST";
                form.action = "${pageContext.request.contextPath}/admin/coupons";
                
                const actionInput = document.createElement("input");
                actionInput.type = "hidden";
                actionInput.name = "action";
                actionInput.value = "delete";
                
                const idInput = document.createElement("input");
                idInput.type = "hidden";
                idInput.name = "id";
                idInput.value = id;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
