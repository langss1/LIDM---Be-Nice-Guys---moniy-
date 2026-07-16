document.addEventListener('DOMContentLoaded', () => {
    // 1. Navigation Logic
    const navItems = document.querySelectorAll('.nav-item');
    const pages = document.querySelectorAll('.page-content');

    navItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            
            // Remove active class from all
            navItems.forEach(nav => nav.classList.remove('active'));
            pages.forEach(page => page.classList.add('hidden'));

            // Add active class to clicked
            item.classList.add('active');
            const targetPage = item.getAttribute('data-page');
            document.getElementById(`${targetPage}-page`).classList.remove('hidden');

            // Load data based on page
            if (targetPage === 'dashboard') loadDashboardData();
            if (targetPage === 'users') loadUsers();
        });
    });

    // Initialize Dashboard Charts
    let userGrowthChart, moduleCompletionChart;
    
    function initCharts() {
        Chart.defaults.color = '#9CA3AF';
        Chart.defaults.font.family = 'Poppins';
        
        const ctxUser = document.getElementById('userGrowthChart').getContext('2d');
        userGrowthChart = new Chart(ctxUser, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul'],
                datasets: [{
                    label: 'Pengguna Aktif',
                    data: [10, 25, 45, 80, 120, 180, 250],
                    borderColor: '#0056D2',
                    backgroundColor: 'rgba(0, 86, 210, 0.1)',
                    borderWidth: 3,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { grid: { color: 'rgba(255,255,255,0.05)' } },
                    x: { grid: { display: false } }
                }
            }
        });

        const ctxModule = document.getElementById('moduleCompletionChart').getContext('2d');
        moduleCompletionChart = new Chart(ctxModule, {
            type: 'doughnut',
            data: {
                labels: ['Selesai', 'Sedang Belajar', 'Belum Mulai'],
                datasets: [{
                    data: [45, 30, 25],
                    backgroundColor: ['#00C9A7', '#F59E0B', '#8B5CF6'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' }
                },
                cutout: '70%'
            }
        });
    }

    // Load Dashboard Data
    async function loadDashboardData() {
        try {
            const res = await fetch('/api/dashboard/stats');
            const json = await res.json();
            
            if (json.success) {
                document.getElementById('stat-users').textContent = json.data.totalUsers;
                document.getElementById('stat-modules').textContent = json.data.totalModules;
                document.getElementById('stat-groups').textContent = json.data.totalGroups;
                document.getElementById('stat-posts').textContent = json.data.totalPosts;
            }
        } catch (err) {
            showToast('Gagal memuat data dashboard', true);
        }
    }

    // Load Users
    async function loadUsers() {
        const tbody = document.getElementById('users-table-body');
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">Loading data...</td></tr>';
        
        try {
            const res = await fetch('/api/users');
            const json = await res.json();
            
            if (json.success) {
                tbody.innerHTML = '';
                json.data.forEach(user => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>#${user.id}</td>
                        <td>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <img src="${user.avatar || `https://ui-avatars.com/api/?name=${user.name}&background=random`}" style="width:32px; height:32px; border-radius:50%;">
                                ${user.name}
                            </div>
                        </td>
                        <td>${user.email}</td>
                        <td>Level ${user.level || 1}</td>
                        <td>${user.xp || 0} XP</td>
                        <td><span style="background:rgba(255,255,255,0.1); padding:4px 8px; border-radius:4px; font-size:12px;">${user.role}</span></td>
                        <td>
                            <button class="icon-btn" style="width:32px; height:32px;"><i data-lucide="edit-2" style="width:16px;"></i></button>
                            <button class="icon-btn" style="width:32px; height:32px; color:#ef4444;"><i data-lucide="trash-2" style="width:16px;"></i></button>
                        </td>
                    `;
                    tbody.appendChild(tr);
                });
                lucide.createIcons();
            }
        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center" style="color:#ef4444;">Gagal memuat data</td></tr>';
            showToast('Error memuat user', true);
        }
    }

    // Toast Notification helper
    function showToast(message, isError = false) {
        const toast = document.getElementById('toast');
        toast.textContent = message;
        toast.style.background = isError ? '#ef4444' : '#00C9A7';
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3000);
    }

    // Initial load
    initCharts();
    loadDashboardData();
});
