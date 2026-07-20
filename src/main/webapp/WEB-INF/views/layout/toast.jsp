<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    ============================================================
    Toast thông báo dùng chung (hiển thị giữa - phía trên màn hình,
    tự động biến mất sau một khoảng thời gian ngắn).

    * Dùng phía server (sau khi xử lý thành công rồi redirect):
          request.getSession().setAttribute("toastMessage", "Thêm sản phẩm thành công!");
          request.getSession().setAttribute("toastType", "success"); // success | error | info
      ProductController sẽ tự chuyển 2 giá trị này từ session -> request khi GET.

    * Dùng phía client (JavaScript):
          window.showToast("Nội dung thông báo", "success");
    ============================================================
--%>
<style>
    .toast-container {
        position: fixed;
        top: 24px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 99999;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
        pointer-events: none;
    }
    .toast {
        min-width: 280px;
        max-width: 92vw;
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 18px;
        border-radius: 12px;
        background: #ffffff;
        box-shadow: 0 12px 32px rgba(15, 23, 42, 0.18);
        border-left: 4px solid #10b981;
        font-family: 'Inter', sans-serif;
        font-size: 14px;
        font-weight: 500;
        color: #0f172a;
        opacity: 0;
        transform: translateY(-16px);
        transition: opacity .3s ease, transform .3s ease;
        pointer-events: auto;
    }
    .toast.show { opacity: 1; transform: translateY(0); }
    .toast .toast-icon {
        flex-shrink: 0;
        width: 22px;
        height: 22px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #ffffff;
    }
    .toast .toast-text { flex: 1; line-height: 1.4; }
    .toast.success { border-left-color: #10b981; }
    .toast.success .toast-icon { background: #10b981; }
    .toast.error { border-left-color: #ef4444; }
    .toast.error .toast-icon { background: #ef4444; }
    .toast.info { border-left-color: #3b82f6; }
    .toast.info .toast-icon { background: #3b82f6; }
</style>

<div id="toast-container" class="toast-container"></div>

<script>
    (function () {
        var ICONS = {
            success: '<svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>',
            error: '<svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>',
            info: '<svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>'
        };

        window.showToast = function (message, type, duration) {
            if (!message) return;
            type = type || 'success';
            duration = duration || 3000;

            var container = document.getElementById('toast-container');
            if (!container) return;

            var toast = document.createElement('div');
            toast.className = 'toast ' + type;

            var icon = document.createElement('span');
            icon.className = 'toast-icon';
            icon.innerHTML = ICONS[type] || ICONS.success;

            var text = document.createElement('span');
            text.className = 'toast-text';
            text.textContent = message;

            toast.appendChild(icon);
            toast.appendChild(text);
            container.appendChild(toast);

            // Kích hoạt hiệu ứng trượt xuống + hiện dần
            requestAnimationFrame(function () { toast.classList.add('show'); });

            // Tự động ẩn sau `duration` mili-giây
            setTimeout(function () {
                toast.classList.remove('show');
                setTimeout(function () {
                    if (toast.parentNode) toast.parentNode.removeChild(toast);
                }, 300);
            }, duration);
        };

        // Tự hiển thị toast do server gửi xuống (flash message)
        document.addEventListener('DOMContentLoaded', function () {
            var flash = document.getElementById('server-flash-toast');
            if (flash) {
                window.showToast(flash.getAttribute('data-message'), flash.getAttribute('data-type') || 'success');
                if (flash.parentNode) flash.parentNode.removeChild(flash);
            }
        });
    })();
</script>

<%
    String __toastMsg = (String) request.getAttribute("toastMessage");
    String __toastType = (String) request.getAttribute("toastType");
    if (__toastMsg != null && !__toastMsg.isEmpty()) {
        String __safeMsg = __toastMsg
                .replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
        String __safeType = (__toastType == null || __toastType.isEmpty()) ? "success" : __toastType;
%>
<div id="server-flash-toast" data-message="<%= __safeMsg %>" data-type="<%= __safeType %>" style="display:none;"></div>
<%
    }
%>