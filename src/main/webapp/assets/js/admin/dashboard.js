// Bar Chart with evenly spaced Y-axis
const ctx = document.getElementById('revenueChart').getContext('2d');

const labels = window.CHART_LABELS || [];
const dataVals = window.CHART_DATA || [];

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
