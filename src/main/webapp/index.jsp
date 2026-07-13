<%-- Tự động điều hướng đến trang quản trị admin/dashboard --%>
<%
    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
%>