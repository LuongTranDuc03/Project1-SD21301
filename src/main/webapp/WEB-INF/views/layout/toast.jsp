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
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout/toast.css">

<div id="toast-container" class="toast-container"></div>

<script src="${pageContext.request.contextPath}/assets/js/layout/toast.js"></script>

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