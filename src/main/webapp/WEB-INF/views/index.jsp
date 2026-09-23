<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能快递柜管理系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #0066cc;
            --primary-light: #3399ff;
            --primary-dark: #004d99;
            --secondary: #003366;
            --accent: #00aaff;
            --light: #ffffff;
            --light-gray: #f8f9fa;
            --gray: #e9ecef;
            --dark-gray: #6c757d;
            --dark: #212529;
            --success: #00cc88;
            --warning: #ffaa00;
            --gradient: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            --gradient-light: linear-gradient(135deg, var(--primary-light) 0%, var(--primary) 100%);
            --shadow: 0 8px 30px rgba(0, 102, 204, 0.12);
            --shadow-hover: 0 15px 40px rgba(0, 102, 204, 0.18);
        }

        body {
            font-family: 'Segoe UI', 'Microsoft YaHei', 'PingFang SC', sans-serif;
            background-color: var(--light-gray);
            color: var(--dark);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* 动态背景效果 */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background:
                radial-gradient(circle at 10% 20%, rgba(0, 102, 204, 0.05) 0%, transparent 30%),
                radial-gradient(circle at 90% 80%, rgba(0, 102, 204, 0.04) 0%, transparent 30%),
                radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 1) 0%, transparent 100%);
        }

        /* 导航栏 */
        .navbar {
            background: var(--light);
            border-bottom: 1px solid var(--gray);
            padding: 18px 0;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(0, 102, 204, 0.08);
        }

        .navbar.scrolled {
            padding: 12px 0;
            box-shadow: 0 6px 25px rgba(0, 102, 204, 0.12);
        }

        .navbar-container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 0 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo-icon {
            font-size: 32px;
            background: var(--gradient);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-dark);
        }

        .logo-subtext {
            font-size: 12px;
            color: var(--dark-gray);
            font-weight: 500;
            margin-left: 10px;
            letter-spacing: 1px;
        }

        .nav-items {
            display: flex;
            gap: 35px;
        }

        .nav-item {
            color: var(--dark-gray);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            position: relative;
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-item i {
            font-size: 18px;
            color: var(--primary);
        }

        .nav-item:hover {
            color: var(--primary);
        }

        .nav-item.active {
            color: var(--primary);
        }

        .nav-item::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 3px;
            background: var(--gradient);
            border-radius: 3px;
            transition: width 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .nav-item:hover::after,
        .nav-item.active::after {
            width: 100%;
        }

        /* 主内容区 */
        .main-content {
            padding-top: 120px;
            min-height: 100vh;
            padding-bottom: 80px;
        }

        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 0 40px;
        }

        /* 英雄区域 */
        .hero-section {
            text-align: center;
            padding: 80px 0 60px;
            position: relative;
        }

        .hero-title {
            font-size: 64px;
            font-weight: 800;
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            line-height: 1.1;
        }

        .hero-subtitle {
            font-size: 24px;
            color: var(--dark-gray);
            margin-bottom: 30px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.5;
        }

        .hero-description {
            font-size: 18px;
            color: var(--dark-gray);
            max-width: 900px;
            margin: 0 auto 40px;
            line-height: 1.7;
        }

        .ai-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, rgba(0, 102, 204, 0.1) 0%, rgba(0, 170, 255, 0.1) 100%);
            border: 1px solid rgba(0, 102, 204, 0.2);
            border-radius: 50px;
            padding: 12px 25px;
            margin-top: 30px;
            font-weight: 600;
            color: var(--primary-dark);
        }

        .ai-badge i {
            color: var(--accent);
            font-size: 20px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }

        /* 统计数据卡片 */
        .stats-section {
            padding: 40px 0;
            position: relative;
        }

        .section-title {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 50px;
            text-align: center;
            position: relative;
            display: inline-block;
            left: 50%;
            transform: translateX(-50%);
            color: var(--secondary);
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--gradient);
            border-radius: 2px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-bottom: 60px;
        }

        .stat-card {
            background: var(--light);
            border-radius: 20px;
            padding: 40px 30px;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            text-decoration: none;
            position: relative;
            overflow: hidden;
            border: 1px solid var(--gray);
            box-shadow: var(--shadow);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: var(--gradient);
        }

        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-hover);
            border-color: var(--primary-light);
        }

        .stat-icon {
            font-size: 56px;
            margin-bottom: 25px;
            display: inline-block;
            background: var(--gradient);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-value {
            font-size: 52px;
            font-weight: 800;
            margin-bottom: 10px;
            color: var(--primary);
            line-height: 1;
        }

        .stat-label {
            font-size: 18px;
            color: var(--dark-gray);
            font-weight: 600;
            letter-spacing: 0.5px;
            margin-bottom: 15px;
        }

        .stat-change {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            background: rgba(0, 204, 136, 0.1);
            color: var(--success);
        }

        .positive {
            background: rgba(0, 204, 136, 0.1);
            color: var(--success);
        }

        /* 功能特性区域 */
        .feature-section {
            padding: 80px 0;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
        }

        .feature-card {
            background: var(--light);
            border-radius: 20px;
            padding: 40px 30px;
            transition: all 0.4s;
            border: 1px solid var(--gray);
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }

        .feature-card:hover {
            transform: translateY(-8px);
            border-color: var(--primary-light);
            box-shadow: var(--shadow-hover);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: var(--gradient);
        }

        .feature-icon {
            font-size: 48px;
            margin-bottom: 25px;
            display: inline-block;
            background: var(--gradient);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .feature-title {
            font-size: 24px;
            font-weight: 700;
            color: var(--secondary);
            margin-bottom: 20px;
        }

        .feature-description {
            color: var(--dark-gray);
            line-height: 1.7;
            font-size: 16px;
        }

        /* 实时数据面板 */
        .realtime-section {
            padding: 60px 0;
        }

        .realtime-panel {
            background: var(--light);
            border-radius: 20px;
            padding: 40px;
            margin-top: 40px;
            border: 1px solid var(--gray);
            box-shadow: var(--shadow);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .panel-title {
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 15px;
            color: var(--secondary);
        }

        .panel-title i {
            color: var(--accent);
            font-size: 28px;
        }

        .realtime-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
        }

        .realtime-item {
            background: var(--light-gray);
            border-radius: 16px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s;
            border: 1px solid var(--gray);
        }

        .realtime-item:hover {
            background: var(--light);
            border-color: var(--primary-light);
            box-shadow: 0 5px 20px rgba(0, 102, 204, 0.1);
        }

        .realtime-label {
            font-size: 16px;
            color: var(--dark-gray);
            margin-bottom: 10px;
        }

        .realtime-value {
            font-size: 32px;
            font-weight: 700;
            color: var(--primary);
        }

        .realtime-trend {
            font-size: 14px;
            margin-top: 8px;
            font-weight: 600;
        }

        .positive {
            color: var(--success);
        }

        /* 响应式设计 */
        @media (max-width: 1200px) {
            .hero-title {
                font-size: 54px;
            }

            .container, .navbar-container {
                padding: 0 30px;
            }
        }

        @media (max-width: 992px) {
            .hero-title {
                font-size: 44px;
            }

            .nav-items {
                gap: 25px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 38px;
            }

            .hero-subtitle {
                font-size: 20px;
            }

            .nav-items {
                display: none; /* 移动端可考虑添加汉堡菜单 */
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .feature-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- 动态背景 -->
    <div class="bg-animation"></div>

    <!-- 导航栏 -->
    <nav class="navbar" id="navbar">
        <div class="navbar-container">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-robot"></i>
                </div>
                <div>
                    <div class="logo-text">智能快递柜管理系统</div>
                    <div class="logo-subtext">AI-POWERED LOCKER SYSTEM</div>
                </div>
            </div>
            <div class="nav-items">
                <a href="${pageContext.request.contextPath}/" class="nav-item active">
                    <i class="fas fa-home"></i> 首页
                </a>
                <a href="${pageContext.request.contextPath}/packages" class="nav-item">
                    <i class="fas fa-box-open"></i> 快递管理
                </a>
                <a href="${pageContext.request.contextPath}/boxes" class="nav-item">
                    <i class="fas fa-cube"></i> 储物格管理
                </a>
                <a href="${pageContext.request.contextPath}/lockers" class="nav-item">
                    <i class="fas fa-server"></i> 快递柜管理
                </a>
                <a href="${pageContext.request.contextPath}/users" class="nav-item">
                    <i class="fas fa-users"></i> 用户管理
                </a>
                <a href="${pageContext.request.contextPath}/assistant" class="nav-item">
                    <i class="fas fa-robot"></i> AI 客服
                </a>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <div class="container">
            <!-- 欢迎横幅 -->
            <div class="hero-section">
                <h1 class="hero-title">智能快递柜管理系统</h1>
                <p class="hero-subtitle">快递存取全流程数字化管理，数据真实、流程闭环</p>
                <p class="hero-description">
                    系统覆盖快递入库、柜格自动分配、用户取件、故障报修与维修等完整业务流程。
                    首页所有统计数字均来自数据库实时计算，杜绝假数据；
                    AI 智能客服让用户输入手机号即可查询快递、一键生成取件通知文案。
                </p>
                <div class="ai-badge">
                    <i class="fas fa-brain"></i>
                    <span>AI 智能客服 · 数据实时统计</span>
                </div>
            </div>

            <!-- 统计数据 -->
            <div class="stats-section">
                <h2 class="section-title">系统概览</h2>
                <div class="stats-grid">
                    <a href="${pageContext.request.contextPath}/packages" class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-box"></i>
                        </div>
                        <div class="stat-value">${stats.packageCount}</div>
                        <div class="stat-label">快递总数</div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i> 今日新增: ${stats.todayPackages}
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/boxes" class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-cubes"></i>
                        </div>
                        <div class="stat-value">${stats.boxCount}</div>
                        <div class="stat-label">储物格总数</div>
                        <div class="stat-change positive">
                            可用: ${stats.availableBoxes} (使用率 ${stats.boxUsageRate}%)
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/lockers" class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-network-wired"></i>
                        </div>
                        <div class="stat-value">${stats.lockerCount}</div>
                        <div class="stat-label">快递柜总数</div>
                        <div class="stat-change positive">
                            在线: ${stats.onlineLockers}
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/users" class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-user-friends"></i>
                        </div>
                        <div class="stat-value">${stats.userCount}</div>
                        <div class="stat-label">用户总数</div>
                        <div class="stat-change positive">
                            今日活跃: ${stats.activeUsers}
                        </div>
                    </a>
                </div>
            </div>

            <!-- 实时数据面板 -->
            <div class="realtime-section">
                <div class="realtime-panel">
                    <div class="panel-header">
                        <div class="panel-title">
                            <i class="fas fa-chart-line"></i>
                            实时数据监控
                        </div>
                        <div style="color: var(--accent); font-size: 14px; font-weight: 600;">
                            <i class="fas fa-circle"></i> 实时更新中
                        </div>
                    </div>
                    <div class="realtime-grid">
                        <div class="realtime-item">
                            <div class="realtime-label">待取件快递</div>
                            <div class="realtime-value">${stats.pendingPackages}</div>
                            <div class="realtime-trend positive">
                                需用户及时取件
                            </div>
                        </div>
                        <div class="realtime-item">
                            <div class="realtime-label">今日新增快递</div>
                            <div class="realtime-value">${stats.todayPackages}</div>
                            <div class="realtime-trend positive">
                                实时统计
                            </div>
                        </div>
                        <div class="realtime-item">
                            <div class="realtime-label">在线快递柜</div>
                            <div class="realtime-value">${stats.onlineLockers}</div>
                            <div class="realtime-trend positive">
                                共 ${stats.lockerCount} 台
                            </div>
                        </div>
                        <div class="realtime-item">
                            <div class="realtime-label">可用柜格</div>
                            <div class="realtime-value">${stats.availableBoxes}</div>
                            <div class="realtime-trend positive">
                                共 ${stats.boxCount} 格
                            </div>
                        </div>
                        <div class="realtime-item">
                            <div class="realtime-label">柜格使用率</div>
                            <div class="realtime-value">${stats.boxUsageRate}%</div>
                            <div class="realtime-trend positive">
                                占用 ${stats.occupiedBoxes} 格
                            </div>
                        </div>
                        <div class="realtime-item">
                            <div class="realtime-label">活跃用户</div>
                            <div class="realtime-value">${stats.activeUsers}</div>
                            <div class="realtime-trend positive">
                                共 ${stats.userCount} 人
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 功能特性 -->
            <div class="feature-section">
                <h2 class="section-title">核心功能</h2>
                <div class="feature-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-box-open"></i>
                        </div>
                        <div class="feature-title">快递存取闭环</div>
                        <div class="feature-description">
                            快递入库自动分配空闲柜格，用户取件释放柜格，全流程状态可追溯，形成完整业务闭环。
                        </div>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-cubes"></i>
                        </div>
                        <div class="feature-title">智能柜格管理</div>
                        <div class="feature-description">
                            小/中/大三种规格柜格自动初始化与分配，实时统计空闲、占用与禁用柜格数量。
                        </div>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-wrench"></i>
                        </div>
                        <div class="feature-title">故障报修追踪</div>
                        <div class="feature-description">
                            报修→维修→完成全流程记录，故障状态实时可见，维修人员与时间全程可追踪。
                        </div>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="feature-title">登录与权限</div>
                        <div class="feature-description">
                            登录拦截器统一鉴权，未登录无法访问后台，管理员与普通用户角色区分。
                        </div>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-robot"></i>
                        </div>
                        <div class="feature-title">AI 智能客服</div>
                        <div class="feature-description">
                            输入手机号即可查询快递状态，一键生成取件通知文案；模型失败自动降级为模板话术。
                        </div>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <div class="feature-title">真实数据看板</div>
                        <div class="feature-description">
                            首页统计数字全部来自数据库实时计算，杜绝假数据，真实反映系统运行状态。
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 导航栏滚动效果
        window.addEventListener('scroll', function() {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // 卡片悬停效果增强
        document.querySelectorAll('.stat-card, .feature-card, .realtime-item').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.zIndex = '10';
            });

            card.addEventListener('mouseleave', function() {
                this.style.zIndex = '1';
            });
        });

        // 页面加载动画
        window.addEventListener('load', function() {
            document.body.style.opacity = '0';
            document.body.style.transition = 'opacity 0.8s';

            setTimeout(() => {
                document.body.style.opacity = '1';
            }, 100);

            // 卡片逐次显示效果
            const cards = document.querySelectorAll('.stat-card, .feature-card, .realtime-item');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.5s, transform 0.5s';

                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, 100 + index * 80);
            });
        });

        // 导航菜单激活状态
        document.querySelectorAll('.nav-item').forEach(item => {
            item.addEventListener('click', function() {
                document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
                this.classList.add('active');
            });
        });
    </script>
</body>
</html>