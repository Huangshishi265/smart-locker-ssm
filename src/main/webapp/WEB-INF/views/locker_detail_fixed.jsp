<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能快递柜管理系统 - 快递柜详情</title>
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
        }
        .header-title {
            font-size: 28px;
            font-weight: bold;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 30px;
        }
        .info-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
        }
        .info-section h4 {
            color: #667eea;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .info-item {
            background: white;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        .info-label {
            font-size: 12px;
            color: #868e96;
            margin-bottom: 5px;
        }
        .info-value {
            font-weight: 600;
            color: #495057;
            font-size: 16px;
        }
        .badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
        }
        .badge-success { background: #51cf66; color: white; }
        .badge-warning { background: #fcc419; color: #212529; }
        .badge-danger { background: #ff6b6b; color: white; }
        .badge-secondary { background: #868e96; color: white; }
        .badge-primary { background: #667eea; color: white; }
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .stat-card h3 {
            font-size: 32px;
            margin: 10px 0;
            color: #667eea;
        }
        .stat-card p {
            margin: 0;
            color: #868e96;
            font-size: 14px;
        }
        .box-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
            gap: 15px;
        }
        .box-item {
            background: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        .box-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }
        .box-available {
            border-color: #51cf66;
        }
        .box-occupied {
            border-color: #fcc419;
        }
        .box-broken {
            border-color: #ff6b6b;
        }
        .box-code {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 5px;
        }
        .box-status {
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 10px;
        }
        .progress {
            height: 25px;
            border-radius: 12px;
            overflow: hidden;
            margin-top: 10px;
        }
        .progress-bar {
            font-weight: 600;
            line-height: 25px;
        }
        .btn {
            padding: 10px 25px;
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
        .btn-warning {
            background: linear-gradient(135deg, #fcc419 0%, #fab005 100%);
            color: #212529;
        }
        .btn-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #fa5252 100%);
            color: white;
        }
        .repair-info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .repair-info h5 {
            color: #856404;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container main-container">
        <!-- 标题 -->
        <h1 class="header-title">
            <i class="fas fa-box"></i> ${locker.lockerName} - 快递柜详情
        </h1>

        <!-- 操作按钮 -->
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/lockers/edit/${locker.id}"
               class="btn btn-primary">
                <i class="fas fa-edit"></i> 编辑
            </a>
            <a href="${pageContext.request.contextPath}/lockers/repair/${locker.id}"
               class="btn btn-warning">
                <i class="fas fa-wrench"></i> 故障报修
            </a>
            <a href="${pageContext.request.contextPath}/lockers" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> 返回列表
            </a>
        </div>

        <!-- 基本信息 -->
        <div class="info-section">
            <h4><i class="fas fa-info-circle"></i> 基本信息</h4>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">快递柜名称</div>
                    <div class="info-value">${locker.lockerName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">位置</div>
                    <div class="info-value">${locker.location}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">详细地址</div>
                    <div class="info-value">${locker.address}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">状态</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${locker.status == 1}">
                                <span class="badge badge-success">启用</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">禁用</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">柜子状态</div>
                    <div class="info-value">
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
                            <c:when test="${locker.lockerStatus == 4}">
                                <span class="badge badge-secondary">已停用</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-primary">-</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">故障状态</div>
                    <div class="info-value">
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
                            <c:otherwise>
                                <span class="badge badge-secondary">无故障</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">创建时间</div>
                    <div class="info-value">
                        <fmt:formatDate value="${locker.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">更新时间</div>
                    <div class="info-value">
                        <fmt:formatDate value="${locker.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </div>
                </div>
            </div>
            <c:if test="${not empty locker.description}">
                <div style="margin-top: 20px; background: white; padding: 15px; border-radius: 10px;">
                    <strong>描述：</strong>${locker.description}
                </div>
            </c:if>
        </div>

        <!-- 柜格统计 -->
        <div class="info-section">
            <h4><i class="fas fa-chart-pie"></i> 柜格统计</h4>
            <div class="stats-cards">
                <div class="stat-card">
                    <p>总柜格数</p>
                    <h3>${boxStats.totalBoxes}</h3>
                </div>
                <div class="stat-card">
                    <p>可用柜格</p>
                    <h3 style="color: #51cf66;">${boxStats.availableBoxes}</h3>
                </div>
                <div class="stat-card">
                    <p>已占用</p>
                    <h3 style="color: #fcc419;">${boxStats.occupiedBoxes}</h3>
                </div>
                <div class="stat-card">
                    <p>故障柜格</p>
                    <h3 style="color: #ff6b6b;">${boxStats.brokenBoxes}</h3>
                </div>
            </div>
            <c:if test="${boxStats.totalBoxes > 0}">
                <c:set var="percent" value="${(boxStats.availableBoxes / boxStats.totalBoxes) * 100}"/>
                <div style="background: white; padding: 15px; border-radius: 10px;">
                    <strong>可用率：</strong>
                    <div class="progress">
                        <div class="progress-bar bg-success" style="width: ${percent}%">
                            ${percent}%
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- 维修信息 -->
        <c:if test="${locker.repairStatus != null && locker.repairStatus != 0}">
            <div class="repair-info">
                <h5><i class="fas fa-wrench"></i> 维修信息</h5>
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
        </c:if>

        <!-- 柜格列表 -->
        <div class="info-section">
            <h4><i class="fas fa-th-large"></i> 柜格列表</h4>
            <div class="box-grid">
                <c:if test="${not empty boxes}">
                    <c:forEach items="${boxes}" var="box">
                        <div class="box-item
                            <c:choose>
                                <c:when test="${box.status == 0}">box-available</c:when>
                                <c:when test="${box.status == 1}">box-occupied</c:when>
                                <c:when test="${box.status == 2}">box-broken</c:when>
                            </c:choose>">
                            <div class="box-code">${box.boxCode}</div>
                            <div class="box-status">
                                <c:choose>
                                    <c:when test="${box.status == 0}">
                                        <span class="badge badge-success">空闲</span>
                                    </c:when>
                                    <c:when test="${box.status == 1}">
                                        <span class="badge badge-warning">占用</span>
                                    </c:when>
                                    <c:when test="${box.status == 2}">
                                        <span class="badge badge-danger">故障</span>
                                    </c:when>
                                </c:choose>
                            </div>
                            <div style="font-size: 10px; margin-top: 5px; color: #868e96;">
                                <c:choose>
                                    <c:when test="${box.boxSize == 1}">小柜</c:when>
                                    <c:when test="${box.boxSize == 2}">中柜</c:when>
                                    <c:when test="${box.boxSize == 3}">大柜</c:when>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty boxes}">
                    <div class="text-center text-muted" style="grid-column: 1 / -1; padding: 30px;">
                        <i class="fas fa-inbox fa-3x"></i>
                        <p style="margin-top: 15px;">暂无柜格数据</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
