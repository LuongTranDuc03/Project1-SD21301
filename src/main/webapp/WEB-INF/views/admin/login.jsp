<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% String contextPath=request.getContextPath(); %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng nhập - FamiCoats Admin</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <script src="https://accounts.google.com/gsi/client" async defer></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/login.css">
        </head>

        <body>

            <div class="login-container">
                <!-- LEFT PANEL -->
                <div class="login-left">
                    <div class="login-left-content">
                        <div class="logo-box">
                            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="FamiCoats Logo">
                        </div>
                        <h2>FamiCoats Admin</h2>
                        <p class="subtitle">Hệ thống quản lý bán hàng thời trang chuyên nghiệp</p>

                        <ul class="feature-list">
                            <li>
                                <div class="feature-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                    </svg>
                                </div>
                                Quản lý đơn hàng & doanh thu
                            </li>
                            <li>
                                <div class="feature-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                                        <line x1="8" y1="21" x2="16" y2="21"></line>
                                        <line x1="12" y1="17" x2="12" y2="21"></line>
                                    </svg>
                                </div>
                                Kiểm soát tồn kho thông minh
                            </li>
                            <li>
                                <div class="feature-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </div>
                                Quản lý khách hàng & nhân viên
                            </li>
                            <li>
                                <div class="feature-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                </div>
                                Bảo mật & phân quyền chi tiết
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- RIGHT PANEL -->
                <div class="login-right">
                    <div class="login-form-wrapper">
                        <h2>Chào mừng trở lại!</h2>
                        <p class="desc">Đăng nhập để tiếp tục quản lý hệ thống</p>

                        <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                            <div class="error-alert">
                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2"
                                    fill="none">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                                <%= error %>
                            </div>
                            <% } %>

                                <form action="<%= contextPath %>/login" method="POST">
                                    <div class="form-group">
                                        <label>Email hoặc tên đăng nhập <span>*</span></label>
                                        <div class="input-group">
                                            <svg class="icon-left" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path
                                                    d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z">
                                                </path>
                                                <polyline points="22,6 12,13 2,6"></polyline>
                                            </svg>
                                            <input type="email" name="email" placeholder="admin@famicoats.vn" required
                                                autofocus>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label>Mật khẩu <span>*</span></label>
                                        <div class="input-group">
                                            <svg class="icon-left" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                            </svg>
                                            <input type="password" name="password" id="passwordInput"
                                                placeholder="••••••••" required>
                                            <button type="button" class="btn-eye" id="togglePassword">
                                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor"
                                                    stroke-width="2" fill="none" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                    <circle cx="12" cy="12" r="3"></circle>
                                                </svg>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="form-options">
                                        <label class="checkbox-label">
                                            <input type="checkbox" name="remember">
                                            Ghi nhớ đăng nhập
                                        </label>
                                        <a href="#" class="forgot-link">Quên mật khẩu?</a>
                                    </div>

                                    <button type="submit" class="btn-login">
                                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor"
                                            stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                                            <polyline points="10 17 15 12 10 7"></polyline>
                                            <line x1="15" y1="12" x2="3" y2="12"></line>
                                        </svg>
                                        Đăng nhập
                                    </button>

                                    <%-- Google One Tap --%>
                                        <div id="g_id_onload"
                                            data-client_id="35800930005-are3qqcamf2hb4tsuslmtdir1okmloaf.apps.googleusercontent.com"
                                            data-context="signin" data-ux_mode="popup"
                                            data-callback="handleGoogleCallback" data-auto_prompt="false">
                                        </div>

                                        <div class="divider">Hoặc</div>

                                        <button type="button" class="btn-google-login" id="googleSignInBtn"
                                            onclick="triggerGoogleSignIn()">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                viewBox="0 0 48 48">
                                                <path fill="#FFC107"
                                                    d="M43.6 20H24v8h11.3C33.6 33.1 29.3 36 24 36c-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.8 1.1 8 2.9l6-6C34.5 6.3 29.5 4 24 4 12.9 4 4 12.9 4 24s8.9 20 20 20c11 0 20-8 20-20 0-1.3-.1-2.7-.4-4z" />
                                                <path fill="#FF3D00"
                                                    d="M6.3 14.7l7 5.1C15.2 16.4 19.3 13 24 13c3.1 0 5.8 1.1 8 2.9l6-6C34.5 6.3 29.5 4 24 4 16.3 4 9.7 8.3 6.3 14.7z" />
                                                <path fill="#4CAF50"
                                                    d="M24 44c5.3 0 10.1-1.9 13.8-5.1l-6.4-5.4C29.4 35.1 26.8 36 24 36c-5.2 0-9.6-3-11.4-7.4l-7 5.4C9.2 40.2 16.1 44 24 44z" />
                                                <path fill="#1976D2"
                                                    d="M43.6 20H24v8h11.3c-.9 2.5-2.6 4.6-4.8 6l6.4 5.4C41.2 36.2 44 30.5 44 24c0-1.3-.1-2.7-.4-4z" />
                                            </svg>
                                            Đăng nhập với Google
                                        </button>

                                        <button type="button" class="btn-dev-login" onclick="triggerDevLogin()">
                                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor"
                                                stroke-width="2" fill="none" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <path d="M12 20h9"></path>
                                                <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z">
                                                </path>
                                            </svg>
                                            Đăng nhập Ảo (Dev Mode)
                                        </button>
                                </form>
                    </div>
                </div>
            </div>

            <script>
                const togglePassword = document.getElementById('togglePassword');
                const passwordInput = document.getElementById('passwordInput');

                togglePassword.addEventListener('click', function () {
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);

                    if (type === 'text') {
                        this.innerHTML = '<svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>';
                    } else {
                        this.innerHTML = '<svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>';
                    }
                });

                // ===== Google Sign-In =====
                function triggerGoogleSignIn() {
                    if (typeof google === 'undefined') {
                        alert('Thư viện Google chưa tải xong. Vui lòng kiểm tra lại mạng hoặc F5.');
                        return;
                    }
                    google.accounts.id.prompt();
                }

                function handleGoogleCallback(response) {
                    if (!response || !response.credential) {
                        alert('Đăng nhập Google thất bại. Vui lòng thử lại.');
                        return;
                    }
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/login-google';
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'credential';
                    input.value = response.credential;
                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
                }

                // ===== Dev Login =====
                function triggerDevLogin() {
                    const email = prompt("DEV MODE: Nhập Email nhân viên trong CSDL SQL Server để đăng nhập:", "tranluong11103@gmail.com");
                    if (email && email.trim() !== '') {
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '${pageContext.request.contextPath}/login-dev';
                        const input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = 'email';
                        input.value = email;
                        form.appendChild(input);
                        document.body.appendChild(form);
                        form.submit();
                    }
                }
            </script>
        </body>

        </html>