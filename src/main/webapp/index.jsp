<%-- Tự động điều hướng đến trang chủ /admin/home khi truy cập website --%>
<%
    response.sendRedirect(request.getContextPath() + "/admin/home");
%>