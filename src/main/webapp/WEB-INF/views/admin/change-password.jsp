<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>D?i m?t kh?u - FamiCoats</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    
    <style>
        .pwd-container {
            max-width: 500px;
            margin: 40px auto;
            background: #FFFFFF;
            border-radius: 20px;
            border: 1px solid #E2E8F0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            padding: 32px;
        }
        
        .section-title {
            font-size: 16px; font-weight: 700; color: #0F172A;
            margin-bottom: 24px; padding-bottom: 16px;
            border-bottom: 1px solid #E2E8F0;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 18px;
        }
        
        .form-group label {
            font-size: 11px;
            font-weight: 600;
            color: #64748B;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input {
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #CBD5E1;
            font-family: inherit;
            font-size: 14px;
            outline: none;
            width: 100%;
            box-sizing: border-box;
        }
        .form-group input:focus {
            border-color: #3B82F6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
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
            width: 100%;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
            transition: all 0.2s;
            margin-top: 8px;
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
    </style>
</head>
<body>
<div class="admin-layout" style="display: flex;">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content" style="flex: 1;">
        <!-- Header -->
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats</span> / <span class="active-crumb">D?i m?t kh?u</span>
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

            <div class="pwd-container">
                <div class="section-title">
                    D?i m?t kh?u t�i kho?n
                </div>
                
                <form action="${pageContext.request.contextPath}/admin/change-password" method="POST">
                    <div class="form-group">
                        <label>M?t kh?u hi?n t?i</label>
                        <input type="password" name="currentPassword" required placeholder="Nh?p m?t kh?u hi?n t?i"/>
                    </div>
                    
                    <div class="form-group">
                        <label>M?t kh?u m?i</label>
                        <input type="password" name="newPassword" required placeholder="Nh?p m?t kh?u m?i"/>
                    </div>
                    
                    <div class="form-group">
                        <label>X�c nh?n m?t kh?u m?i</label>
                        <input type="password" name="confirmPassword" required placeholder="Nh?p l?i m?t kh?u m?i"/>
                    </div>
                    
                    <button type="submit" class="btn-submit">C?p nh?t m?t kh?u</button>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
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
