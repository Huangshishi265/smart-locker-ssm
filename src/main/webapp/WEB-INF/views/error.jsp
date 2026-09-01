<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统错误 - 智能快递柜管理系统</title>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        .error-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 60px 40px;
            max-width: 600px;
            text-align: center;
        }
        .error-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        .error-title {
            color: #dc3545;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .error-message {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-custom {
            padding: 12px 30px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: inline-block;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background: #f8f9fa;
            color: #333;
            border: 2px solid #dee2e6;
        }
        .btn-secondary:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <div class="error-title">系统发生错误</div>

        <c:choose>
            <c:when test="${not empty errorMessage}">
                <div class="error-message">${errorMessage}</div>
            </c:when>
            <c:otherwise>
                <div class="error-message">
                    系统发生错误，请稍后重试。<br>
                    如果问题持续存在，请联系系统管理员。
                </div>
            </c:otherwise>
        </c:choose>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/packages" class="btn-custom btn-primary">返回快递列表</a>
            <a href="${pageContext.request.contextPath}/boxes" class="btn-custom btn-secondary">查看储物格</a>
            <a href="${pageContext.request.contextPath}/" class="btn-custom btn-secondary">返回首页</a>
        </div>
    </div>
</body>
</html>
