<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户列表 - 智能快递柜管理系统</title>
    <style>
        body {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px;
        }
        .page-header {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .page-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin: 0;
        }
        .table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        .table thead th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            border: none;
            padding: 15px;
        }
        .table tbody tr {
            transition: all 0.3s ease;
        }
        .table tbody tr:hover {
            background: #f8f9fa;
            transform: translateX(5px);
        }
        .table td {
            vertical-align: middle;
            padding: 15px;
        }
        .badge-active {
            background: #28a745;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 600;
        }
        .badge-inactive {
            background: #6c757d;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 600;
        }
        .btn-action {
            padding: 5px 12px;
            font-size: 12px;
            margin-right: 5px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 600;
            color: white;
            text-decoration: none;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .nav-link-custom {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .nav-link-custom:hover {
            text-decoration: underline;
        }
        .btn-info {
            background: #17a2b8;
            color: white;
        }
        .btn-warning {
            background: #ffc107;
            color: #333;
        }
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #667eea;
            background: #f0f0f0;
        }
        .user-avatar-placeholder {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
        }
        .user-info-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }
    </style>
</head>
<body>
    <div class="page-header">
        <div>
            <h1 class="page-title">👥 用户管理</h1>
            <nav style="margin-top: 10px;">
                <a href="${pageContext.request.contextPath}/" class="nav-link-custom">首页</a>
                <span style="margin: 0 10px; color: #999;">/</span>
                <span style="color: #999;">用户列表</span>
            </nav>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/users/add" class="btn btn-primary">
                ➕ 新增用户
            </a>
        </div>
    </div>

    <div class="table-container">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>用户</th>
                    <th>用户名</th>
                    <th>真实姓名</th>
                    <th>手机号码</th>
                    <th>电子邮箱</th>
                    <th>地址</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty users}">
                        <tr>
                            <td colspan="9" style="text-align: center; padding: 50px;">
                                <div style="color: #999;">
                                    <div style="font-size: 48px; margin-bottom: 10px;">📭</div>
                                    <div>暂无用户数据</div>
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td>
                                    <div class="user-info-cell">
                                        <c:choose>
                                            <c:when test="${not empty user.avatar}">
                                                <img src="${pageContext.request.contextPath}${user.avatar}" alt="${user.realName}" class="user-avatar" onerror="this.style.display='none'">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="user-avatar-placeholder">${user.realName != null && user.realName.length() > 0 ? user.realName.substring(0,1) : '用'}</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td>
                                    <strong>${user.username}</strong>
                                </td>
                                <td>${user.realName}</td>
                                <td>${user.phone}</td>
                                <td>${user.email}</td>
                                <td>${user.address}</td>
                                <td>
                                    <c:if test="${user.status == 1}">
                                        <span class="badge-active">启用</span>
                                    </c:if>
                                    <c:if test="${user.status == 0}">
                                        <span class="badge-inactive">禁用</span>
                                    </c:if>
                                </td>
                                <td>${user.createTime}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/users/view/${user.id}"
                                       class="btn-action btn-info">查看</a>
                                    <a href="${pageContext.request.contextPath}/users/edit/${user.id}"
                                       class="btn-action btn-warning">编辑</a>
                                    <a href="${pageContext.request.contextPath}/users/delete/${user.id}"
                                       class="btn-action btn-danger"
                                       onclick="return confirm('确定要删除用户 ${user.realName} 吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</body>
</html>