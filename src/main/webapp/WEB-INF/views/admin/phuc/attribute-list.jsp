<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.dto.phuc.AttributeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<AttributeDTO> attributeList = (List<AttributeDTO>) request.getAttribute("attributeList");
    String currentType = (String) request.getAttribute("currentType");
    if (currentType == null) currentType = "category";
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    // Define tab titles
    java.util.Map<String, String> typeNames = new java.util.LinkedHashMap<>();
    typeNames.put("category", "Danh mục");
    typeNames.put("brand", "Thương hiệu");
    typeNames.put("origin", "Xuất xứ");
    typeNames.put("color", "Màu sắc");
    typeNames.put("size", "Kích cỡ");
    typeNames.put("style", "Kiểu dáng");
    
    String currentTypeName = typeNames.getOrDefault(currentType, "Thuộc tính");
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="FamiCoats Admin - Quản lý thuộc tính">
    <title>FamiCoats Admin - Quản lý thuộc tính</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=<%= System.currentTimeMillis() %>">
</head>

<body>
    <div class="app-container">
        <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

        <main class="main-content">
            <header class="navbar">
                <div class="breadcrumb">
                    <span>FamiCoats</span>
                    <span>/</span>
                    <span class="active-crumb">Quản lý thuộc tính</span>
                </div>
                <div class="navbar-right">
                    <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                    <div class="date-pill" id="currentDate"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                    <div class="profile-pill">
                        <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                    </div>
                </div>
            </header>

            <div class="content-wrapper">
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <div>
                        <h1>Quản lý thuộc tính</h1>
                        <div class="subtitle">Quản lý tập trung các thuộc tính sản phẩm</div>
                    </div>
                </div>
                
                <%-- Tabs and Buttons Container --%>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; border-bottom: 1px solid #e2e8f0; padding-bottom: 16px; flex-wrap: wrap; gap: 16px;">
                    
                    <%-- Tabs --%>
                    <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                        <% for (java.util.Map.Entry<String, String> entry : typeNames.entrySet()) { %>
                            <a href="${pageContext.request.contextPath}/admin/attributes?type=<%= entry.getKey() %>" 
                               class="tab-btn <%= entry.getKey().equals(currentType) ? "active" : "" %>">
                                <%= entry.getValue() %>
                            </a>
                        <% } %>
                    </div>
                    
                    <%-- Buttons --%>
                    <div style="display: flex; justify-content: flex-end; align-items: center; gap: 10px;">
                        <a href="${pageContext.request.contextPath}/admin/attributes/export?type=<%= currentType %>" class="btn-export" style="background-color: #10B981; border: 1px solid #10B981; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="8" y1="13" x2="16" y2="13"></line><line x1="8" y1="17" x2="16" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            <span>Xuất Excel</span>
                        </a>
                        <button type="button" class="btn-add" onclick="openModal()" style="background-color: #E11D48; border: 1px solid #E11D48; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                            <span>Thêm <%= currentTypeName.toLowerCase() %></span>
                        </button>
                    </div>
                </div>

                <div class="custom-card">
                    <div class="card-header-bar">
                        <span class="card-header-title">&#8226; Danh sách <%= currentTypeName.toLowerCase() %></span>
                    </div>
                    <div class="card-body-content" style="padding: 0;">
                        <div style="overflow-x: auto;">
                            <table class="attribute-table">
                                <thead>
                                    <tr>
                                        <th style="width: 5%; text-align: center;">STT</th>
                                        <th style="width: 15%;">Mã <%= currentTypeName.toLowerCase() %></th>
                                        <th style="width: 30%;">Tên <%= currentTypeName.toLowerCase() %></th>
                                        <th style="width: 20%;">Ngày tạo</th>
                                        <th style="width: 15%; text-align: center;">Trạng thái</th>
                                        <th style="width: 15%; text-align: center;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (attributeList != null && !attributeList.isEmpty()) { 
                                        int stt = 1;
                                        for (AttributeDTO attr : attributeList) {
                                            String code = attr.getCode() != null ? attr.getCode() : "";
                                            String name = attr.getName() != null ? attr.getName() : "";
                                            String date = attr.getCreatedAt() != null ? sdf.format(attr.getCreatedAt()) : "—";
                                            boolean isActive = attr.getStatus() != null && attr.getStatus() == 1;
                                    %>
                                    <tr>
                                        <td style="text-align: center; color: #64748b;"><%= stt++ %></td>
                                        <td><span class="code-text"><%= code %></span></td>
                                        <td><span class="name-text"><%= name %></span></td>
                                        <td style="color: #64748b;"><%= date %></td>
                                        <td style="text-align: center;">
                                            <span class="badge-status <%= isActive ? "status-active" : "status-inactive" %>">
                                                <%= isActive ? "Hoạt động" : "Ngừng hoạt động" %>
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <div class="action-buttons">
                                                <button type="button" class="btn-icon btn-edit" title="Chỉnh sửa" 
                                                        onclick="openModal('<%= attr.getId() %>', '<%= code %>', '<%= name %>', '<%= attr.getStatus() %>')">
                                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                                </button>
                                                <form action="${pageContext.request.contextPath}/admin/attributes/toggle-status" method="post" style="display: flex; align-items: center; margin: 0;">
                                                    <input type="hidden" name="type" value="<%= currentType %>">
                                                    <input type="hidden" name="id" value="<%= attr.getId() %>">
                                                    <label class="switch" title="Đổi trạng thái" style="margin: 0;">
                                                      <input type="checkbox" <%= isActive ? "checked" : "" %> onchange="if(confirm('Bạn có chắc chắn muốn thay đổi trạng thái không?')) { this.form.submit(); } else { this.checked = !this.checked; }">
                                                      <span class="slider"></span>
                                                    </label>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: #94a3b8; padding: 32px 16px;">
                                            Chưa có dữ liệu <%= currentTypeName.toLowerCase() %>.
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        
                        <%-- Phân trang --%>
                        <%
                            Integer currentPage = (Integer) request.getAttribute("currentPage");
                            Integer totalPages = (Integer) request.getAttribute("totalPages");
                            if (totalPages != null && totalPages > 1) {
                        %>
                        <div class="pagination-container" style="padding: 16px; border-top: 1px solid #e2e8f0; display: flex; justify-content: flex-end;">
                            <ul class="pagination">
                                <li class="page-item <%= (currentPage == 0) ? "disabled" : "" %>">
                                    <a class="page-link" href="?type=<%= currentType %>&page=<%= (currentPage > 0) ? currentPage - 1 : 0 %>">&laquo;</a>
                                </li>
                                <% for (int i = 0; i < totalPages; i++) { %>
                                <li class="page-item <%= (currentPage == i) ? "active" : "" %>">
                                    <a class="page-link" href="?type=<%= currentType %>&page=<%= i %>"><%= i + 1 %></a>
                                </li>
                                <% } %>
                                <li class="page-item <%= (currentPage == totalPages - 1) ? "disabled" : "" %>">
                                    <a class="page-link" href="?type=<%= currentType %>&page=<%= (currentPage < totalPages - 1) ? currentPage + 1 : totalPages - 1 %>">&raquo;</a>
                                </li>
                            </ul>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Thêm/Sửa Thuộc Tính -->
    <div class="modal-overlay" id="attributeModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">Thêm <%= currentTypeName %></h3>
                <button class="btn-close" onclick="closeModal()">
                    <svg viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/attributes/save" method="post">
                <input type="hidden" name="type" value="<%= currentType %>">
                <input type="hidden" id="attrId" name="id" value="">
                
                <div class="modal-body">
                    <div class="form-group">
                        <label for="attrCode">Mã <%= currentTypeName.toLowerCase() %></label>
                        <input type="text" id="attrCode" name="code" class="form-control" readonly placeholder="Hệ thống tự động sinh mã">
                    </div>
                    
                    <div class="form-group">
                        <label for="attrName">Tên <%= currentTypeName.toLowerCase() %><span class="required-star">*</span></label>
                        <input type="text" id="attrName" name="name" class="form-control" required placeholder="Nhập tên <%= currentTypeName.toLowerCase() %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="attrStatus">Trạng thái<span class="required-star">*</span></label>
                        <select id="attrStatus" name="status" class="form-control" required>
                            <option value="1">Hoạt động</option>
                            <option value="0">Ngừng hoạt động</option>
                        </select>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal()">Hủy bỏ</button>
                    <button type="submit" class="btn-primary">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>

    <%-- Hiển thị thông báo --%>
    <%
        String msg = (String) session.getAttribute("message");
        String msgType = (String) session.getAttribute("messageType");
        if (msg != null) {
    %>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof showToast === 'function') {
                showToast('<%= msg %>', '<%= msgType %>');
            } else {
                alert('<%= msg %>');
            }
        });
    </script>
    <%
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        }
    %>

    <script>
        (function () {
            var d = new Date();
            var days = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
            var dd = String(d.getDate()).padStart(2, '0');
            var mm = String(d.getMonth() + 1).padStart(2, '0');
            var el = document.getElementById('currentDate');
            if (el) el.textContent = days[d.getDay()] + ', ' + dd + '/' + mm + '/' + d.getFullYear();
        })();

        const modal = document.getElementById('attributeModal');
        
        function openModal(id = '', code = '', name = '', status = '1') {
            document.getElementById('attrId').value = id;
            document.getElementById('attrCode').value = code || '${nextCode}';
            document.getElementById('attrName').value = name;
            document.getElementById('attrStatus').value = status;
            
            document.getElementById('modalTitle').textContent = id ? 'Cập nhật <%= currentTypeName %>' : 'Thêm <%= currentTypeName %> mới';
            document.getElementById('attrCode').readOnly = true; // Luôn hiển thị mã tự sinh (chỉ đọc)
            
            modal.classList.add('active');
        }

        function closeModal() {
            modal.classList.remove('active');
        }

        // Đóng modal khi bấm ra ngoài
        window.onclick = function(event) {
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
    <jsp:include page="/WEB-INF/views/layout/toast.jsp" />
</body>
</html>
