<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - <%= request.getAttribute("pageTitle") %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { overflow-x: hidden; }
        .app-container, .main-content, .content-wrapper {
            max-width: 100%;
            overflow-x: hidden;
            box-sizing: border-box;
        }
        .page-bg { background-color: #f1f5f9; min-height: 100vh; padding: 20px; }
        .page-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
        }

        /* 4 KPI Cards */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }
        .kpi-card {
            background: #fff;
            border-radius: 12px;
            padding: 16px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            position: relative;
        }
        .kpi-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }
        .kpi-icon-btn {
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 4px 6px;
            color: #64748b;
            cursor: pointer;
        }
        .kpi-revenue {
            font-size: 22px;
            font-weight: 700;
            color: #111;
            margin-bottom: 4px;
        }
        .kpi-subtitle {
            font-size: 12px;
            color: #777;
            margin-bottom: 12px;
        }
        .kpi-status-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
        }
        .status-box {
            border-radius: 6px;
            padding: 6px 8px;
            display: flex;
            flex-direction: column;
            gap: 4px;
            font-size: 11px;
            font-weight: 600;
        }
        .status-box.success { background: #effcf5; color: #32c48d; border: 1px solid #e0f6eb; }
        .status-box.danger { background: #fff1f2; color: #f43f5e; border: 1px solid #ffe4e6; }
        .status-box.warning { background: #fdf9f1; color: #bca476; border: 1px solid #faeedb; }
        .status-box .val { font-size: 14px; font-weight: 700; }

        /* Chart Section */
        .chart-section {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            margin-bottom: 20px;
        }
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .chart-title-left {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 15px;
            font-weight: 700;
            color: #333;
        }
        .chart-title-left select {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 4px 8px;
            font-size: 13px;
            color: #555;
            outline: none;
        }
        .btn-compare {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 6px 12px;
            font-size: 13px;
            font-weight: 500;
            color: #555;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .chart-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 12px;
            font-size: 13px;
            color: #555;
        }
        .chart-filter-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-top: 1px solid #eee;
            padding-top: 16px;
            margin-top: 16px;
        }
        .date-picker-group {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .date-input {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 6px 12px;
            font-size: 13px;
            width: 140px;
        }
        .filter-btns button {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            margin-left: 8px;
        }
        .btn-loc { background: #3b82f6; color: #fff; border: none; }
        .btn-reset { background: #fff; color: #555; border: 1px solid #ddd; }

        /* Tables Section */
        .tables-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
        }
        .data-card {
            background: #fff;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            overflow-x: auto;
            overflow-y: hidden;
            min-width: 0;
        }
        .data-card-header {
            background: #f8fafc;
            padding: 12px 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #334155;
            border-bottom: 1px solid #e2e8f0;
        }
        .data-card-title {
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-top {
            background: #fff;
            color: #334155;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            padding: 4px 10px;
            font-size: 12px;
            font-weight: 600;
        }
        .table-responsive {
            overflow-x: auto;
            width: 100%;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            white-space: nowrap;
        }
        .data-table th {
            padding: 12px 16px;
            font-size: 13px;
            font-weight: 700;
            color: #333;
            border-bottom: 1px solid #eee;
        }
        .data-table td {
            padding: 14px 16px;
            font-size: 13px;
            color: #555;
            border-bottom: 1px solid #f9f9f9;
        }
        .data-table tr:last-child td { border-bottom: none; }
    </style>
</head>
<body>
<%
    Map<String, Map<String, Object>> timeframes = (Map<String, Map<String, Object>>) request.getAttribute("timeframes");
    
    // Hàm format tiền
    java.text.NumberFormat format = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
    
    // Helper function to render a KPI card
    java.util.function.Function<String, String> renderCard = (key) -> {
        Map<String, Object> data = timeframes.get(key);
        if (data == null) data = new java.util.HashMap<>();
        String title = "";
        if (key.equals("today")) {
            title = (String) request.getAttribute("kpi1Title");
            if (title == null) title = "Hôm nay";
        } else {
            title = key.equals("week") ? "Tuần này" : key.equals("month") ? "Tháng này" : "Năm nay";
        }
        double rev = (Double) data.getOrDefault("revenue", 0.0);
        long orders = (Long) data.getOrDefault("totalOrders", 0L);
        long sold = (Long) data.getOrDefault("productsSold", 0L);
        long c_comp = (Long) data.getOrDefault("countCompleted", 0L);
        long c_canc = (Long) data.getOrDefault("countCancelled", 0L);
        
        return "<div class='kpi-card'>" +
               "<div class='kpi-header'><span>" + title + "</span><button class='kpi-icon-btn'><svg width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2'><rect x='3' y='4' width='18' height='18' rx='2' ry='2'></rect><line x1='16' y1='2' x2='16' y2='6'></line><line x1='8' y1='2' x2='8' y2='6'></line><line x1='3' y1='10' x2='21' y2='10'></line></svg></button></div>" +
               "<div class='kpi-revenue'>" + format.format(rev) + " đ</div>" +
               "<div class='kpi-subtitle'>Sản phẩm đã bán " + sold + " - Đơn hàng " + orders + "</div>" +
               "<div class='kpi-status-row'>" +
               "<div class='status-box success'>Hoàn thành <span class='val'>" + c_comp + "</span></div>" +
               "<div class='status-box danger'>Hủy <span class='val'>" + c_canc + "</span></div>" +
               "</div></div>";
    };
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats</span> / <span class="active-crumb">Thống kê</span>
            </div>
            <div class="navbar-right">
                <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                <div class="profile-pill">
                    <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="page-title">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                Thống kê
            </div>
            
            <!-- Global Date Filter Row -->
            <div class="chart-filter-row" style="background: #fff; border-radius: 12px; padding: 16px 20px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.02); margin-bottom: 20px; margin-top: 0; border-top: 1px solid #e2e8f0;">
                <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" style="display: flex; justify-content: space-between; align-items: flex-end; width: 100%; margin: 0;">
                    <div class="date-picker-group">
                        <div>
                            <div style="font-size:12px; color:#777; margin-bottom:4px;">Từ ngày</div>
                            <input type="date" name="fromDate" class="date-input" value="<%= request.getAttribute("fromDate") %>">
                        </div>
                        <div style="color:#aaa; margin-top:16px;">→</div>
                        <div>
                            <div style="font-size:12px; color:#777; margin-bottom:4px;">Đến ngày</div>
                            <input type="date" name="toDate" class="date-input" value="<%= request.getAttribute("toDate") %>">
                        </div>
                    </div>
            
                    <div class="filter-btns">
                        <button type="submit" class="btn-loc">
                            <svg style="vertical-align: middle; margin-right:4px;" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon></svg>
                            Lọc dữ liệu
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-reset" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center; padding: 4px 10px; border: 1px solid #e2e8f0; border-radius: 4px; color: #64748b; font-size: 13px; height: 32px; box-sizing: border-box;">
                            <svg style="vertical-align: middle; margin-right:4px;" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"></path></svg>
                            Đặt lại
                        </a>
                    </div>
                </form>
            </div>

        <!-- 4 KPI Cards -->
        <div class="kpi-grid">
            <% 
               out.print(renderCard.apply("today"));
               out.print(renderCard.apply("week"));
               out.print(renderCard.apply("month"));
               out.print(renderCard.apply("year"));
            %>
        </div>

        <!-- Chart Section -->
        <div class="chart-section">
            <div class="chart-header">
                <div class="chart-title-left">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="3" y1="9" x2="21" y2="9"></line><line x1="9" y1="21" x2="9" y2="9"></line></svg>
                    Doanh thu
                </div>
            </div>
            
            <canvas id="revenueChart" height="80"></canvas>
            
            <div class="chart-footer">
                <div>Tổng doanh thu: <strong><%= format.format(request.getAttribute("totalMonthlyRevenue")) %> đ</strong></div>
                <div style="color: #999;">Đơn vị: VNĐ</div>
            </div>
        </div>



        <!-- Tables Section -->
        <div class="tables-grid">
            <!-- Top Products -->
            <div class="data-card">
                <div class="data-card-header">
                    <div class="data-card-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path><path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path><path d="M4 22h16"></path><path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22"></path><path d="M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22"></path><path d="M18 2H6v7a6 6 0 0 0 12 0V2Z"></path></svg>
                        Top sản phẩm bán chạy
                    </div>
                    <button class="btn-top">Top 5</button>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th style="text-align:center;">Đã bán</th>
                                <th style="text-align:right;">Tồn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                               List<Map<String, Object>> topProducts = (List<Map<String, Object>>) request.getAttribute("topProducts");
                               if (topProducts != null && !topProducts.isEmpty()) { 
                                   for (Map<String, Object> p : topProducts) {
                            %>
                            <tr>
                                <td><%= p.get("name") %></td>
                                <td style="text-align:center;"><%= p.get("quantity") %></td>
                                <td style="text-align:right;"><%= p.get("stock") %></td>
                            </tr>
                            <%     }
                               } else { %>
                               <tr><td colspan="3" style="text-align:center;">Chưa có dữ liệu</td></tr>
                               <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Top Customers -->
            <div class="data-card">
                <div class="data-card-header">
                    <div class="data-card-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        Khách hàng tiềm năng
                    </div>
                    <button class="btn-top">Top chi tiêu</button>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Khách hàng</th>
                                <th style="text-align:center;">Số đơn</th>
                                <th style="text-align:right;">Tổng chi tiêu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                               List<Map<String, Object>> topCustomers = (List<Map<String, Object>>) request.getAttribute("topCustomers");
                               if (topCustomers != null && !topCustomers.isEmpty()) { 
                                   for (Map<String, Object> c : topCustomers) {
                            %>
                            <tr>
                                <td><%= c.get("name") %></td>
                                <td style="text-align:center;"><%= c.get("orders") %></td>
                                <td style="text-align:right;"><%= format.format(c.get("spent")) %> đ</td>
                            </tr>
                            <%     }
                               } else { %>
                               <tr><td colspan="3" style="text-align:center;">Chưa có dữ liệu</td></tr>
                               <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>


        </div>
    </main>
</div>

<script>
    // Bar Chart with evenly spaced Y-axis
    const ctx = document.getElementById('revenueChart').getContext('2d');

    const labels = <%= request.getAttribute("chartLabels") %>;
    const dataVals = <%= request.getAttribute("chartData") %>;

    // Tick values and their display labels
    const tickValues = [0, 500000, 1000000, 3000000, 5000000, 7000000, 10000000];
    const tickLabels = ['0', '500K', '1M', '3M', '5M', '7M', '10M'];

    // Map real VND value → linear position 0-6 (each tick = 1 unit, evenly spaced)
    function mapToScale(val) {
        if (val <= 0) return 0;
        for (let i = 1; i < tickValues.length; i++) {
            if (val <= tickValues[i]) {
                return (i - 1) + (val - tickValues[i - 1]) / (tickValues[i] - tickValues[i - 1]);
            }
        }
        return tickValues.length - 1;
    }

    // Reverse: linear position 0-6 → VND value (for tooltip)
    function mapFromScale(pos) {
        const i = Math.floor(pos);
        if (i >= tickValues.length - 1) return tickValues[tickValues.length - 1];
        const frac = pos - i;
        return tickValues[i] + frac * (tickValues[i + 1] - tickValues[i]);
    }

    const mappedData = dataVals.map(mapToScale);

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu',
                data: mappedData,
                backgroundColor: 'rgba(59, 130, 246, 0.8)',
                borderColor: '#3b82f6',
                borderWidth: 1,
                borderRadius: 4,
                barPercentage: 0.5,
                categoryPercentage: 0.6
            }]
        },
        options: {
            responsive: true,
            interaction: { mode: 'index', intersect: false },
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            // Show original VND value in tooltip
                            const orig = dataVals[context.dataIndex];
                            return orig.toLocaleString('vi-VN') + ' đ';
                        }
                    }
                }
            },
            scales: {
                y: {
                    min: 0,
                    max: tickValues.length - 1,
                    ticks: {
                        stepSize: 1,
                        callback: function(value) {
                            const idx = Math.round(value);
                            return (idx >= 0 && idx < tickLabels.length) ? tickLabels[idx] : '';
                        },
                        font: { size: 11, weight: 'bold' },
                        color: '#555'
                    },
                    grid: { color: '#f5f5f5' }
                },
                x: {
                    grid: { display: false },
                    ticks: { font: { size: 11, weight: 'bold' }, color: '#555' }
                }
            }
        }
    });

    // Date display
    function updateDate() {
        var el = document.getElementById('currentDate');
        if (el) {
            var days = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
            var d = new Date();
            var day = days[d.getDay()];
            var date = d.getDate().toString().padStart(2, '0');
            var month = (d.getMonth() + 1).toString().padStart(2, '0');
            var year = d.getFullYear();
            el.innerHTML = day + ', ' + date + '/' + month + '/' + year;
        }
    }
    updateDate();
</script>
</body>
</html>
