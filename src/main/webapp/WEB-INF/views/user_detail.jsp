<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户详情 - 智能快递柜管理系统</title>
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
        }
        .detail-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 900px;
            margin: 0 auto;
        }
        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #667eea;
        }
        .detail-header h3 {
            color: #333;
            font-weight: bold;
            margin: 0;
            font-size: 24px;
        }
        .detail-row {
            display: flex;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            width: 150px;
            font-weight: 600;
            color: #666;
            flex-shrink: 0;
        }
        .detail-value {
            flex-grow: 1;
            color: #333;
        }
        .badge-active {
            background: #28a745;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 600;
            color: white;
        }
        .badge-inactive {
            background: #6c757d;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 600;
            color: white;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 600;
            margin-right: 10px;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 600;
            background: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .user-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #667eea;
            background: #f0f0f0;
            margin-bottom: 15px;
        }
        .user-avatar-placeholder {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 72px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .nav-link-custom {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .nav-link-custom:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="page-header">
        <div>
            <h1 style="font-size: 24px; font-weight: bold; color: #333; margin: 0;">👤 用户详情</h1>
            <nav style="margin-top: 10px;">
                <a href="${pageContext.request.contextPath}/" class="nav-link-custom">首页</a>
                <span style="margin: 0 10px; color: #999;">/</span>
                <a href="${pageContext.request.contextPath}/users" class="nav-link-custom">用户列表</a>
                <span style="margin: 0 10px; color: #999;">/</span>
                <span style="color: #999;">用户详情</span>
            </nav>
        </div>
    </div>

    <div class="detail-container">
        <div class="detail-header">
            <div>
                <h3>${user.realName}</h3>
                <p style="margin: 5px 0 0; color: #666;">@${user.username}</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/users/edit/${user.id}" class="btn btn-primary">
                    ✏️ 编辑
                </a>
                <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">
                    返回列表
                </a>
            </div>
        </div>

        <div style="text-align: center; margin-bottom: 30px;">
            <div>
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${pageContext.request.contextPath}${user.avatar}" alt="${user.realName}" class="user-avatar" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        <div class="user-avatar-placeholder" style="display: none;">${user.realName != null && user.realName.length() > 0 ? user.realName.substring(0,1) : '用'}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="user-avatar-placeholder">${user.realName != null && user.realName.length() > 0 ? user.realName.substring(0,1) : '用'}</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div style="margin-top: 15px;">
                <c:if test="${user.status == 1}">
                    <span class="badge-active">启用</span>
                </c:if>
                <c:if test="${user.status == 0}">
                    <span class="badge-inactive">禁用</span>
                </c:if>
            </div>
        </div>

        <div class="detail-content">
            <div class="detail-row">
                <div class="detail-label">用户ID：</div>
                <div class="detail-value">${user.id}</div>
            </div>

            <div class="detail-row">
                <div class="detail-label">用户名：</div>
                <div class="detail-value">
                    <strong>${user.username}</strong>
                </div>
            </div>

            <div class="detail-row">
                <div class="detail-label">真实姓名：</div>
                <div class="detail-value">
                    <strong>${user.realName}</strong>
                </div>
            </div>

            <div class="detail-row">
                <div class="detail-label">手机号码：</div>
                <div class="detail-value">
                    <a href="tel:${user.phone}" style="color: #667eea; text-decoration: none;">
                        📱 ${user.phone}
                    </a>
                </div>
            </div>

            <div class="detail-row">
                <div class="detail-label">电子邮箱：</div>
                <div class="detail-value">
                    <c:if test="${not empty user.email}">
                        <a href="mailto:${user.email}" style="color: #667eea; text-decoration: none;">
                            📧 ${user.email}
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="detail-row">
                <div class="detail-label">地址：</div>
                <div class="detail-value">
                    <c:if test="${not empty user.address}">
                        📍 ${user.address}
                    </c:if>
                </div>
            </div>

            <div class="detail-row">
                <div class="detail-label">创建时间：</div>
                <div class="detail-value">${user.createTime}</div>
            </div>
        </div>
    </div>
</body>
</html>