<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết nhân viên - FamiCoats</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

    <style>
        .form-container { background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); padding: 16px 24px; margin: 0 auto; }
        .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px 24px; }
        .form-group-full { grid-column: span 3; }
        .form-group { display: flex; flex-direction: column; gap: 4px; }
        .form-group label { font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 0; }
        .readonly-text { width: 100%; box-sizing: border-box; padding: 8px 12px; border-radius: 6px; border: 1px solid #CBD5E1; background: #F8FAFC; font-family: inherit; font-size: 13px; color: #0F172A; font-weight: 500; }
        .detail-role-badge { display: inline-block; background: #F0F9FF; color: #0369A1; border-radius: 6px; padding: 2px 10px; font-size: 12px; font-weight: 600; }
        .status-badge { display: inline-block; border-radius: 6px; padding: 2px 10px; font-size: 12px; font-weight: 600; }
        .status-active   { background: #ECFDF5; color: #047857; }
        .status-inactive { background: #FEF2F2; color: #B91C1C; }
        .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 16px; padding-top: 12px; border-top: 1px solid #E2E8F0; }
        .btn-cancel { background-color: #ffffff; border: 1px solid #CBD5E1; color: #475569; padding: 6px 16px; border-radius: 6px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        .btn-save { background: #1E293B; border: none; color: #ffffff; padding: 6px 16px; border-radius: 6px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        .btn-delete { background: #EF4444; border: none; color: #ffffff; padding: 6px 16px; border-radius: 6px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        @media(max-width: 768px) { .form-grid { grid-template-columns: 1fr 1fr; } .form-group-full { grid-column: span 2; } }
        @media(max-width: 480px) { .form-grid { grid-template-columns: 1fr; } .form-group-full { grid-column: span 1; } }
    </style>
</head>
<body>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats</span> / <a href="${pageContext.request.contextPath}/admin/employees" style="text-decoration: none; color: inherit;">Quản lý nhân viên</a> / <span class="active-crumb">Chi tiết</span>
            </div>
            <div class="navbar-right">
                <div class="date-pill" id="live-date">Thứ Năm, 09/07/2026</div>
                <div class="profile-pill">
                    <span class="profile-avatar-mini">A</span>
                    <span>Admin</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper" style="padding: 24px;">
            <div class="form-container">
                <h2 style="font-size: 20px; font-weight: 700; color: #0F172A; margin-top: 0; margin-bottom: 24px;">Chi tiết thông tin nhân viên</h2>

                <div class="form-grid">
                    <%-- Ảnh đại diện + Tên + Badge --%>
                    <div class="form-group form-group-full">
                        <label>Ảnh đại diện</label>
                        <div style="display: flex; align-items: center; gap: 16px; margin-top: 4px;">
                            <div style="width: 64px; height: 64px; border-radius: 50%; background-color: #E2E8F0; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px solid #CBD5E1; flex-shrink: 0;">
                                <c:choose>
                                    <c:when test="${not empty employee.avatar}">
                                        <img src="${employee.avatar}" style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <span style="font-size: 24px; color: #94A3B8;">&#128100;</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="flex: 1; display: flex; flex-direction: column; align-items: flex-start; gap: 4px;">
                                <div style="font-weight: 700; font-size: 16px; color: #0F172A;">${employee.fullName}</div>
                                <div style="display: flex; gap: 8px; align-items: center;">
                                    <span class="detail-role-badge">${employee.roleName}</span>
                                    <c:choose>
                                        <c:when test="${employee.status == 1}">
                                            <span class="status-badge status-active">Đang làm việc</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">Đã nghỉ việc</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Row 1: Mã NV | Họ tên | SĐT --%>
                    <div class="form-group">
                        <label>Mã Nhân Viên</label>
                        <div class="readonly-text">${employee.id}</div>
                    </div>
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <div class="readonly-text">${employee.fullName}</div>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <div class="readonly-text">${not empty employee.phoneNumber ? employee.phoneNumber : '-'}</div>
                    </div>

                    <%-- Row 2: CCCD | Địa chỉ | Lương --%>
                    <div class="form-group">
                        <label>Số CCCD</label>
                        <div class="readonly-text">${not empty employee.cccd ? employee.cccd : '-'}</div>
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <div class="readonly-text">${not empty employee.address ? employee.address : '-'}</div>
                    </div>
                    <div class="form-group">
                        <label>Mức lương (VNĐ)</label>
                        <div class="readonly-text" style="color: #059669; font-weight: 700;">
                            <fmt:formatNumber value="${employee.salary}" pattern="#,###"/> VNĐ
                        </div>
                    </div>

                    <%-- Row 3: Giới tính | Vai trò | Ngày sinh --%>
                    <div class="form-group">
                        <label>Giới tính</label>
                        <div class="readonly-text">
                            <c:choose>
                                <c:when test="${employee.gender == true}">Nam</c:when>
                                <c:when test="${employee.gender == false}">Nữ</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Vai trò chức vụ</label>
                        <div class="readonly-text">${employee.roleName}</div>
                    </div>
                    <div class="form-group">
                        <label>Ngày sinh</label>
                        <div class="readonly-text">
                            <c:choose>
                                <c:when test="${not empty employee.birthday}"><fmt:formatDate value="${employee.birthday}" pattern="dd/MM/yyyy"/></c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%-- Row 4: Ngày vào làm --%>
                    <div class="form-group">
                        <label>Ngày vào làm</label>
                        <div class="readonly-text">
                            <c:choose>
                                <c:when test="${not empty employee.hireDate}"><fmt:formatDate value="${employee.hireDate}" pattern="dd/MM/yyyy"/></c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="form-group" style="visibility: hidden;"><label>&nbsp;</label><div class="readonly-text">&nbsp;</div></div>
                    <div class="form-group" style="visibility: hidden;"><label>&nbsp;</label><div class="readonly-text">&nbsp;</div></div>

                    <%-- Phần Tài khoản đăng nhập --%>
                    <div class="form-group form-group-full" style="margin-top: 12px; padding-top: 12px; border-top: 1px dashed #E2E8F0;">
                        <label style="font-size: 14px; color: #0F172A;">Tài khoản đăng nhập</label>
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ Email</label>
                        <div class="readonly-text">${employee.email}</div>
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu đăng nhập</label>
                        <div class="readonly-text">........</div>
                    </div>
                    <div class="form-group" style="visibility: hidden;"><label>&nbsp;</label><div class="readonly-text">&nbsp;</div></div>
                </div>

                <%-- Nút hành động --%>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/employees" class="btn-cancel">Quay lại</a>
                    <a href="${pageContext.request.contextPath}/admin/employees?action=edit&id=${employee.id}" class="btn-save">Chỉnh sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/employees?action=delete&id=${employee.id}" class="btn-delete" onclick="return confirm('Xác nhận xóa nhân viên này?')">Xóa</a>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
