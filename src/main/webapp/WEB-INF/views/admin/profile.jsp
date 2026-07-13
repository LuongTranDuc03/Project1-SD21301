<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Th�ng tin c� nh�n - FamiCoats</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    
    <style>
        .profile-container {
            display: flex;
            gap: 32px;
            padding: 0 32px 40px;
            align-items: flex-start;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .left-card {
            width: 320px;
            flex-shrink: 0;
            background: #FFFFFF;
            border-radius: 20px;
            border: 1px solid #E2E8F0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            padding: 32px 24px;
            text-align: center;
        }

        .avatar-box {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 16px;
        }
        
        .profile-avatar { 
            width: 100%; height: 100%; 
            border-radius: 50%; object-fit: cover; 
            border: 4px solid #F1F5F9;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        .profile-avatar-placeholder {
            width: 100%; height: 100%; border-radius: 50%;
            background: #EFF6FF;
            color: #2563EB; font-size: 48px; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            border: 4px solid #FFFFFF;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .change-avatar-btn {
            background-color: #F1F5F9; 
            border: 1px solid #CBD5E1; 
            color: #475569; 
            padding: 8px 16px; 
            border-radius: 8px; 
            font-weight: 600; 
            cursor: pointer; 
            font-size: 12px; 
            transition: all 0.2s;
            margin-top: 10px;
            display: inline-block;
        }
        .change-avatar-btn:hover {
            background-color: #E2E8F0;
        }

        .profile-name { margin: 16px 0 8px; font-size: 20px; font-weight: 700; color: #0F172A; }
        
        .profile-role-badge {
            display: inline-block; 
            background: #F0F9FF; color: #0369A1;
            border-radius: 8px; padding: 4px 12px; font-size: 12px;
            font-weight: 600; margin-bottom: 12px;
        }
        
        .status-badge { display: inline-block; border-radius: 8px; padding: 4px 12px; font-size: 12px; font-weight: 600; }
        .status-active   { background: #ECFDF5; color: #047857; }
        .status-inactive { background: #FEF2F2; color: #B91C1C; }

        .right-panel { flex: 1; display: flex; flex-direction: column; gap: 24px; }
        
        .section-card {
            background: #FFFFFF; border-radius: 20px;
            border: 1px solid #E2E8F0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            padding: 32px;
        }
        
        .section-title {
            font-size: 16px; font-weight: 700; color: #0F172A;
            margin-bottom: 24px; padding-bottom: 16px;
            border-bottom: 1px solid #E2E8F0;
        }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        
        .field-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        
        .field-group label {
            font-size: 11px;
            font-weight: 600;
            color: #64748B;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .field-group .value-span {
            font-size: 14px;
            color: #1E293B;
            font-weight: 600;
            padding: 10px 14px;
            background: #F8FAFC;
            border-radius: 8px;
            border: 1px solid #F1F5F9;
            min-height: 40px;
            display: flex;
            align-items: center;
        }

        .field-group input {
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #CBD5E1;
            font-family: inherit;
            font-size: 14px;
            outline: none;
            width: 100%;
            box-sizing: border-box;
            font-weight: 500;
        }
        .field-group input:focus {
            border-color: #3B82F6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        .submit-bar {
            display: flex;
            justify-content: flex-end;
            margin-top: 12px;
        }

        .btn-submit {
            background: #2563EB;
            color: #FFFFFF;
            border: none;
            padding: 10px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
            transition: all 0.2s;
        }
        .btn-submit:hover {
            background: #1D4ED8;
        }

        /* Toast Notifications */
        #toast-container { position: fixed; top: 20px; right: 20px; z-index: 9999; display: flex; flex-direction: column; gap: 10px; }
        .toast { min-width: 280px; background: #fff; padding: 16px 20px; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 12px; transform: translateX(120%); transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); border-left: 4px solid #3B82F6; }
        .toast.show { transform: translateX(0); }
        .toast.success { border-left-color: #10B981; }
        .toast.error { border-left-color: #EF4444; }
        .toast-icon { font-size: 20px; }
        .toast-msg { font-size: 14px; font-weight: 600; color: #1E293B; }

        @media(max-width: 900px) {
            .profile-container { flex-direction: column; padding: 0 16px 40px; }
            .left-card { width: 100%; }
            .info-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="admin-layout" style="display: flex;">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content" style="flex: 1;">
        <!-- Header -->
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats</span> / <span class="active-crumb">Th�ng tin c� nh�n</span>
            </div>
            <div class="navbar-right">
                <div class="profile-pill">
                    <span class="profile-avatar-mini">${fn:substring(employee.fullName, 0, 1)}</span>
                    <span>${employee.fullName}</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper" style="padding: 24px;">
            <div id="toast-container"></div>
            <% if (session.getAttribute("successMsg") != null) { %>
                <script>
                    window.addEventListener('DOMContentLoaded', () => {
                        showToast('success', '?', '<%= session.getAttribute("successMsg") %>');
                    });
                </script>
                <% session.removeAttribute("successMsg"); %>
            <% } %>
            <% if (session.getAttribute("errorMsg") != null) { %>
                <script>
                    window.addEventListener('DOMContentLoaded', () => {
                        showToast('error', '!', '<%= session.getAttribute("errorMsg") %>');
                    });
                </script>
                <% session.removeAttribute("errorMsg"); %>
            <% } %>

            <div class="profile-container">
                <!-- LEFT: Avatar -->
                <div class="left-card">
                    <div class="avatar-box">
                        <c:choose>
                            <c:when test="${not empty employee.avatar}">
                                <img src="${employee.avatar}" alt="Avatar" class="profile-avatar" id="avatarImg"/>
                            </c:when>
                            <c:otherwise>
                                <div class="profile-avatar-placeholder" id="avatarPlaceholder">
                                    ${fn:substring(employee.fullName, 0, 1)}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <button type="button" class="change-avatar-btn" onclick="document.getElementById('avatarFile').click()">
                        Thay ?nh d?i di?n
                    </button>
                    <input type="file" id="avatarFile" accept="image/*" style="display: none;"/>
                    
                    <h2 class="profile-name">${employee.fullName}</h2>
                    <p class="profile-role-badge">${employee.roleName}</p>
                    <div>
                        <c:choose>
                            <c:when test="${employee.status == 1}">
                                <span class="status-badge status-active">Dang l�m vi?c</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-inactive">D� ngh? vi?c</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- RIGHT: Detail Profile Form -->
                <div class="right-panel">
                    <form action="${pageContext.request.contextPath}/admin/profile" method="POST">
                        <input type="hidden" name="avatar" id="avatarHidden" value="${employee.avatar}"/>
                        
                        <div class="section-card">
                            <div class="section-title">
                                Th�ng tin c� nh�n
                            </div>
                            
                            <div class="info-grid">
                                <div class="field-group">
                                    <label>M� nh�n vi�n</label>
                                    <span class="value-span">${employee.id}</span>
                                </div>
                                
                                <div class="field-group">
                                    <label>H? v� t�n</label>
                                    <span class="value-span">${employee.fullName}</span>
                                </div>

                                <div class="field-group">
                                    <label>Email dang nh?p</label>
                                    <span class="value-span">${employee.email}</span>
                                </div>

                                <div class="field-group">
                                    <label>S? di?n tho?i</label>
                                    <input type="text" name="phoneNumber" value="${employee.phoneNumber}" required placeholder="S? di?n tho?i li�n h?"/>
                                </div>

                                <div class="field-group">
                                    <label>Gi?i t�nh</label>
                                    <span class="value-span">
                                        <c:choose>
                                            <c:when test="${employee.gender == true}">Nam</c:when>
                                            <c:otherwise>N?</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="field-group">
                                    <label>Ng�y sinh</label>
                                    <span class="value-span">
                                        <c:choose>
                                            <c:when test="${not empty employee.birthday}">
                                                <fmt:formatDate value="${employee.birthday}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="field-group">
                                    <label>Can cu?c c�ng d�n (CCCD)</label>
                                    <span class="value-span">${not empty employee.cccd ? employee.cccd : '-'}</span>
                                </div>

                                <div class="field-group">
                                    <label>D?a ch? li�n h?</label>
                                    <input type="text" name="address" value="S? 1 Tr?nh Van B�, Nam T? Li�m, H� N?i" required placeholder="D?a ch? hi?n t?i"/>
                                </div>

                                <div class="field-group">
                                    <label>Ch?c v? / Vai tr�</label>
                                    <span class="value-span">${employee.roleName}</span>
                                </div>

                                <div class="field-group">
                                    <label>Ng�y v�o l�m</label>
                                    <span class="value-span">
                                        <c:choose>
                                            <c:when test="${not empty employee.hireDate}">
                                                <fmt:formatDate value="${employee.hireDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="field-group">
                                    <label>M?c luong co b?n</label>
                                    <span class="value-span" style="color: #059669; font-weight: 700;">
                                        <fmt:formatNumber value="${employee.salary}" pattern="#,###"/> VND
                                    </span>
                                </div>
                            </div>

                            <div class="submit-bar">
                                <button type="submit" class="btn-submit">Luu thay d?i</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    // X? l� d?c ?nh File picker sang Base64
    const fileInput = document.getElementById('avatarFile');
    fileInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(evt) {
                const base64Str = evt.target.result;
                document.getElementById('avatarHidden').value = base64Str;
                
                // C?p nh?t ?nh preview
                let img = document.getElementById('avatarImg');
                if (img) {
                    img.src = base64Str;
                } else {
                    const placeholder = document.getElementById('avatarPlaceholder');
                    if (placeholder) {
                        placeholder.outerHTML = `<img src="${base64Str}" alt="Avatar" class="profile-avatar" id="avatarImg"/>`;
                    }
                }
                showToast('success', '?', 'D� t?i ?nh l�n th�nh c�ng. Nh?n Luu thay d?i d? luu.');
            };
            reader.readAsDataURL(file);
        }
    });

    // Toast function
    function showToast(type, icon, msg) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.innerHTML = `<span class="toast-icon">${icon}</span><span class="toast-msg">${msg}</span>`;
        container.appendChild(toast);
        
        setTimeout(() => toast.classList.add('show'), 100);
        
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 400);
        }, 3000);
    }
</script>
</body>
</html>
