<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能快递柜管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            overflow: hidden;
        }

        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* 侧边栏样式 */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            transition: all 0.3s ease;
            box-shadow: 4px 0 15px rgba(0, 0, 0, 0.3);
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 25px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.2);
        }

        .logo-text {
            font-size: 22px;
            font-weight: 700;
            color: #fff;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
            letter-spacing: 1px;
        }

        .logo-text i {
            margin-right: 10px;
            color: #4CAF50;
        }

        .user-info {
            padding: 20px;
            background: rgba(0, 0, 0, 0.15);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: bold;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }

        .user-details h5 {
            margin: 0;
            font-size: 15px;
            font-weight: 600;
        }

        .user-details small {
            color: rgba(255, 255, 255, 0.7);
            font-size: 12px;
        }

        .sidebar-menu {
            padding: 15px 0;
        }

        .menu-category {
            padding: 10px 25px;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .menu-item {
            padding: 12px 25px;
            display: flex;
            align-items: center;
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            cursor: pointer;
        }

        .menu-item:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            border-left-color: #4CAF50;
        }

        .menu-item.active {
            background: rgba(255, 255, 255, 0.15);
            color: #fff;
            border-left-color: #4CAF50;
            box-shadow: inset 4px 0 0 #4CAF50;
        }

        .menu-item i {
            margin-right: 12px;
            font-size: 18px;
            width: 24px;
            text-align: center;
        }

        .menu-item span {
            font-size: 14px;
            font-weight: 500;
        }

        /* 主内容区域 */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* 顶部导航栏 */
        .top-navbar {
            background: rgba(255, 255, 255, 0.95);
            padding: 0 30px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .navbar-brand {
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .navbar-brand i {
            margin-right: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .nav-item {
            color: #555;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 8px 16px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-item:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
        }

        .nav-item.logout {
            color: #dc3545;
        }

        .nav-item.logout:hover {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }

        /* 内容区域 */
        .content-wrapper {
            flex: 1;
            padding: 25px;
            overflow-y: auto;
            background: rgba(255, 255, 255, 0.95);
        }

        .content-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .content-header h2 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
            color: #333;
        }

        .content-header p {
            margin: 5px 0 0 0;
            color: #666;
            font-size: 14px;
        }

        /* iframe 样式 */
        #main-frame {
            width: 100%;
            height: calc(100% - 80px);
            border: none;
            border-radius: 10px;
            background: #f8f9fa;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        /* 响应式设计 */
        @media (max-width: 992px) {
            .sidebar {
                width: 200px;
            }

            .logo-text {
                font-size: 18px;
            }

            .user-info {
                padding: 15px;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                font-size: 16px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                left: -260px;
                height: 100vh;
            }

            .sidebar.active {
                left: 0;
            }

            .top-navbar {
                padding: 0 20px;
            }

            .navbar-brand {
                font-size: 20px;
            }

            .nav-links {
                gap: 10px;
            }

            .nav-item span {
                display: none;
            }

            .menu-toggle {
                display: block !important;
            }
        }

        .menu-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 24px;
            color: #667eea;
            cursor: pointer;
            margin-right: 15px;
        }

        /* 滚动条样式 */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
        }

        ::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.5);
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <!-- 侧边栏 -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="logo-text">
                    <i class="bi bi-box-seam"></i>
                    智能快递柜系统
                </div>
            </div>

            <div class="user-info">
                <div class="user-avatar">${sessionScope.user.realName != null ? sessionScope.user.realName.substring(0, 1) : 'A'}</div>
                <div class="user-details">
                    <h5>${sessionScope.user.realName != null ? sessionScope.user.realName : '管理员'}</h5>
                    <small>${sessionScope.user.username}</small>
                </div>
            </div>

            <div class="sidebar-menu">
                <div class="menu-category">快递管理</div>
                <a href="javascript:void(0)" class="menu-item active" onclick="loadPage('/packages')">
                    <i class="bi bi-box2"></i>
                    <span>快递列表</span>
                </a>
                <a href="javascript:void(0)" class="menu-item" onclick="loadPage('/packages/add')">
                    <i class="bi bi-plus-circle"></i>
                    <span>快递入库</span>
                </a>

                <div class="menu-category">储物格管理</div>
                <a href="javascript:void(0)" class="menu-item" onclick="loadPage('/boxes')">
                    <i class="bi bi-grid"></i>
                    <span>储物格列表</span>
                </a>
                <a href="javascript:void(0)" class="menu-item" onclick="loadPage('/boxes/add')">
                    <i class="bi bi-plus-square"></i>
                    <span>新增储物格</span>
                </a>

                <div class="menu-category">快递柜管理</div>
                <a href="javascript:void(0)" class="menu-item" onclick="loadPage('/lockers')">
                    <i class="bi bi-building"></i>
                    <span>快递柜列表</span>
                </a>
                <a href="javascript:void(0)" class="menu-item" onclick="loadPage('/lockers/add')">
                    <i class="bi bi-plus-lg"></i>
                    <span>新增快递柜</span>
                </a>

                <div class="menu-category">系统管理</div>
                <a href="javascript:void(0)" class="menu-item" onclick="loadPage('/users')">
                    <i class="bi bi-people"></i>
                    <span>用户管理</span>
                </a>
                <a href="javascript:void(0)" class="menu-item" onclick="loadPage('/users/add')">
                    <i class="bi bi-person-plus"></i>
                    <span>新增用户</span>
                </a>
                <a href="javascript:void(0)" class="menu-item" onclick="loadPage('/users/register')">
                    <i class="bi bi-person-lines-fill"></i>
                    <span>用户注册</span>
                </a>

                <div class="menu-category">智能服务</div>
                <a href="${pageContext.request.contextPath}/assistant" class="menu-item" target="_blank">
                    <i class="bi bi-robot"></i>
                    <span>AI 智能客服</span>
                </a>
            </div>
        </aside>

        <!-- 主内容区 -->
        <div class="main-content">
            <!-- 顶部导航栏 -->
            <nav class="top-navbar">
                <div style="display: flex; align-items: center;">
                    <button class="menu-toggle" onclick="toggleSidebar()">
                        <i class="bi bi-list"></i>
                    </button>
                    <span class="navbar-brand">
                        <i class="bi bi-speedometer2"></i>
                        管理后台
                    </span>
                </div>

                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/" class="nav-item">
                        <i class="bi bi-house"></i>
                        <span>首页</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/assistant" class="nav-item" target="_blank">
                        <i class="bi bi-robot"></i>
                        <span>AI 客服</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="nav-item logout">
                        <i class="bi bi-box-arrow-right"></i>
                        <span>退出登录</span>
                    </a>
                </div>
            </nav>

            <!-- 内容区域 -->
            <div class="content-wrapper">
                <div class="content-header">
                    <h2 id="page-title">快递列表</h2>
                    <p id="page-desc">查看和管理所有快递信息</p>
                </div>
                <iframe id="main-frame" src="${pageContext.request.contextPath}/packages" frameborder="0"></iframe>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 页面标题映射
        const pageTitles = {
            '/packages': { title: '快递列表', desc: '查看和管理所有快递信息' },
            '/packages/add': { title: '快递入库', desc: '录入新的快递信息' },
            '/packages/edit': { title: '编辑快递', desc: '修改快递信息' },
            '/boxes': { title: '储物格列表', desc: '查看和管理所有储物格' },
            '/boxes/add': { title: '新增储物格', desc: '添加新的储物格' },
            '/boxes/edit': { title: '编辑储物格', desc: '修改储物格信息' },
            '/lockers': { title: '快递柜列表', desc: '查看和管理所有快递柜' },
            '/lockers/add': { title: '新增快递柜', desc: '添加新的快递柜' },
            '/lockers/edit': { title: '编辑快递柜', desc: '修改快递柜信息' },
            '/users': { title: '用户管理', desc: '查看和管理系统用户' },
            '/users/add': { title: '新增用户', desc: '添加新的系统用户' },
            '/users/register': { title: '用户注册', desc: '用户自主注册账号' }
        };

        // 加载页面
        function loadPage(url) {
            const iframe = document.getElementById('main-frame');
            const pageTitle = document.getElementById('page-title');
            const pageDesc = document.getElementById('page-desc');
            const fullPath = '${pageContext.request.contextPath}' + url;

            // 更新iframe
            iframe.src = fullPath;

            // 更新标题
            const pageInfo = pageTitles[url] || pageTitles[url.replace('/edit', '')];
            if (pageInfo) {
                pageTitle.textContent = pageInfo.title;
                pageDesc.textContent = pageInfo.desc;
            }

            // 更新菜单激活状态
            updateActiveMenu(url);
        }

        // 更新菜单激活状态
        function updateActiveMenu(url) {
            const menuItems = document.querySelectorAll('.menu-item');
            menuItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('onclick').includes(url)) {
                    item.classList.add('active');
                }
            });
        }

        // 切换侧边栏（移动端）
        function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar');
            sidebar.classList.toggle('active');
        }

        // 页面加载完成后的初始化
        document.addEventListener('DOMContentLoaded', function() {
            // 如果当前URL包含具体参数，可以自动加载对应页面
            const currentPath = window.location.pathname;
            if (currentPath.includes('/packages/edit')) {
                updateActiveMenu('/packages/edit');
            }
        });

        // 监听iframe加载完成
        document.getElementById('main-frame').addEventListener('load', function() {
            // 可以在这里添加iframe加载完成后的处理逻辑
        });
    </script>
</body>
</html>
