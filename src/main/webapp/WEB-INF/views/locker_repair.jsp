<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>故障报修 - 智能快递柜管理系统</title>
    <style>
        body {
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .main-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 30px;
            max-width: 800px;
            margin: 0 auto;
        }
        .header-title {
            font-size: 26px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 25px;
        }
        .locker-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
        }
        .info-row {
            margin-bottom: 10px;
            padding: 10px;
            background: white;
            border-radius: 10px;
        }
        .info-label { font-weight: 600; color: #495057; margin-right: 10px; }
        .info-value { color: #868e96; }
        .form-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            border-left: 4px solid #667eea;
            margin-bottom: 25px;
        }
        .form-group { margin-bottom: 20px; }
        .form-label { font-weight: 500; color: #495057; margin-bottom: 8px; display: block; }
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 14px;
            width: 100%;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        .form-control:focus {
            border-color: #667eea;
            outline: none;
        }
        textarea.form-control { resize: vertical; min-height: 120px; }
        .required { color: #dc3545; }
        .btn {
            padding: 12px 30px;
            border-radius: 20px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); }
        .btn-secondary {
            background: #868e96;
            color: white;
        }
        .alert {
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="main-container">
        <h1 class="header-title">🔧 故障报修</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">⚠️ ${error}</div>
        </c:if>

        <div class="locker-info">
            <div class="info-row">
                <span class="info-label">快递柜名称：</span>
                <span class="info-value">${locker.lockerName}</span>
            </div>
            <div class="info-row">
                <span class="info-label">位置：</span>
                <span class="info-value">${locker.location}</span>
            </div>
            <div class="info-row">
                <span class="info-label">详细地址：</span>
                <span class="info-value">${locker.address}</span>
            </div>
            <div class="info-row">
                <span class="info-label">当前故障状态：</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${locker.repairStatus == 1}">待维修</c:when>
                        <c:when test="${locker.repairStatus == 2}">维修中</c:when>
                        <c:when test="${locker.repairStatus == 3}">已维修</c:when>
                        <c:otherwise>无故障</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/lockers/repair/submit/${locker.id}" method="post">
            <div class="form-section">
                <div class="form-group">
                    <label class="form-label">
                        故障描述 <span class="required">*</span>
                    </label>
                    <textarea class="form-control" name="repairDesc" required
                              placeholder="请详细描述故障情况，例如：A1柜格无法打开、显示屏黑屏等">${locker.repairDesc}</textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">维修人员ID</label>
                    <input type="number" class="form-control" name="operatorId"
                           value="${locker.operatorId}"
                           placeholder="请输入维修人员ID（可选）">
                </div>
            </div>

            <div style="text-align: center;">
                <button type="submit" class="btn btn-primary">📤 提交报修</button>
                <a href="${pageContext.request.contextPath}/lockers/view/${locker.id}" class="btn btn-secondary">← 返回详情</a>
            </div>
        </form>
    </div>
</body>
</html>
