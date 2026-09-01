<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能快递柜管理系统 - 故障报修</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/font-awesome.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .main-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 30px;
            backdrop-filter: blur(10px);
            max-width: 800px;
            margin: 0 auto;
        }
        .header-title {
            font-size: 28px;
            font-weight: bold;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 30px;
        }
        .locker-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        .locker-info h4 {
            color: #667eea;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .info-row {
            margin-bottom: 10px;
            padding: 10px;
            background: white;
            border-radius: 10px;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            margin-right: 10px;
        }
        .info-value {
            color: #868e96;
        }
        .form-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            border-left: 4px solid #667eea;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
        }
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }
        .required {
            color: #dc3545;
        }
        .btn {
            padding: 12px 30px;
            border-radius: 20px;
            border: none;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        .btn-secondary {
            background: linear-gradient(135deg, #868e96 0%, #6c757d 100%);
            color: white;
        }
        .btn-secondary:hover {
            color: white;
        }
        .repair-history {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 15px;
        }
        .repair-history h5 {
            color: #856404;
            margin-bottom: 10px;
        }
        .alert {
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="container main-container">
        <!-- 标题 -->
        <h1 class="header-title">
            <i class="fas fa-wrench"></i> 故障报修
        </h1>

        <!-- 消息提示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <!-- 快递柜信息 -->
        <div class="locker-info">
            <h4><i class="fas fa-box"></i> 快递柜信息</h4>
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
                <span class="info-label">当前状态：</span>
                <c:choose>
                    <c:when test="${locker.lockerStatus == 1}">
                        <span class="badge badge-success">正常</span>
                    </c:when>
                    <c:when test="${locker.lockerStatus == 2}">
                        <span class="badge badge-danger">故障</span>
                    </c:when>
                    <c:when test="${locker.lockerStatus == 3}">
                        <span class="badge badge-warning">维护中</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-secondary">-</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="info-row">
                <span class="info-label">总柜格数：</span>
                <span class="info-value">${locker.totalBoxes}</span>
            </div>
            <div class="info-row">
                <span class="info-label">可用柜格数：</span>
                <span class="info-value">${locker.availableBoxes}</span>
            </div>
        </div>

        <!-- 之前的维修记录 -->
        <c:if test="${locker.repairStatus != null && locker.repairStatus != 0}">
            <div class="repair-history mb-3">
                <h5><i class="fas fa-history"></i> 之前的维修记录</h5>
                <div style="background: white; padding: 15px; border-radius: 10px;">
                    <div class="row">
                        <div class="col-md-4">
                            <strong>故障状态：</strong>
                            <c:choose>
                                <c:when test="${locker.repairStatus == 1}">
                                    <span class="badge badge-danger">待维修</span>
                                </c:when>
                                <c:when test="${locker.repairStatus == 2}">
                                    <span class="badge badge-warning">维修中</span>
                                </c:when>
                                <c:when test="${locker.repairStatus == 3}">
                                    <span class="badge badge-success">已维修</span>
                                </c:when>
                            </c:choose>
                        </div>
                        <div class="col-md-4">
                            <strong>报修时间：</strong>
                            <fmt:formatDate value="${locker.repairTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>
                        <div class="col-md-4">
                            <strong>维修人员：</strong>
                            ${locker.operatorId}
                        </div>
                    </div>
                    <div style="margin-top: 10px;">
                        <strong>故障描述：</strong>
                        ${locker.repairDesc}
                    </div>
                </div>
            </div>
        </c:if>

        <!-- 报修表单 -->
        <form action="${pageContext.request.contextPath}/lockers/repair/submit/${locker.id}" method="post">
            <div class="form-section">
                <h4><i class="fas fa-edit"></i> 填写报修信息</h4>
                <div class="form-group">
                    <label class="form-label">
                        故障描述 <span class="required">*</span>
                    </label>
                    <textarea class="form-control" name="repairDesc" required
                              placeholder="请详细描述故障情况，例如：A1柜格无法打开、显示屏黑屏等">${locker.repairDesc}</textarea>
                    <small class="text-muted">
                        <i class="fas fa-info-circle"></i> 请尽量详细描述故障现象，以便维修人员快速定位问题
                    </small>
                </div>
                <div class="form-group">
                    <label class="form-label">维修人员ID</label>
                    <input type="number" class="form-control" name="operatorId"
                           value="${locker.operatorId}"
                           placeholder="请输入维修人员ID（可选）">
                    <small class="text-muted">
                        <i class="fas fa-info-circle"></i> 如果已有指定的维修人员，可以填写其ID
                    </small>
                </div>
            </div>

            <!-- 操作按钮 -->
            <div class="text-center">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i> 提交报修
                </button>
                <a href="${pageContext.request.contextPath}/lockers/view/${locker.id}" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> 返回详情
                </a>
            </div>
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
