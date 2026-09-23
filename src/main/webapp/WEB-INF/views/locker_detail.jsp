<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>快递柜详情 - 智能快递柜系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .main-container {
            background: rgba(255, 255, 255, 0.96);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 30px;
            max-width: 1100px;
            margin: 0 auto;
        }
        .header-title {
            font-size: 26px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 25px;
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
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }
        .info-item {
            background: white;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        .info-label { font-size: 12px; color: #868e96; margin-bottom: 5px; }
        .info-value { font-weight: 600; color: #495057; font-size: 16px; }
        .badge { padding: 6px 14px; border-radius: 20px; font-weight: 500; font-size: 12px; }
        .badge-success { background: #51cf66; color: white; }
        .badge-warning { background: #fcc419; color: #212529; }
        .badge-danger { background: #ff6b6b; color: white; }
        .badge-secondary { background: #868e96; color: white; }
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }
        .stat-card h3 { font-size: 32px; margin: 8px 0; color: #667eea; }
        .stat-card p { margin: 0; color: #868e96; font-size: 13px; }
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
            border: 2px solid transparent;
        }
        .box-available { border-color: #51cf66; }
        .box-occupied { border-color: #fcc419; }
        .box-broken { border-color: #ff6b6b; }
        .box-code { font-weight: bold; font-size: 17px; margin-bottom: 5px; }
        .box-size { font-size: 11px; color: #868e96; margin-top: 5px; }
        .progress { height: 22px; border-radius: 12px; background: #e9ecef; overflow: hidden; margin-top: 10px; }
        .progress-bar {
            height: 100%;
            background: linear-gradient(135deg, #51cf66 0%, #37b24d 100%);
            color: white;
            font-weight: 600;
            font-size: 12px;
            line-height: 22px;
            text-align: center;
        }
        .btn {
            padding: 10px 20px;
            border-radius: 20px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin-right: 8px;
        }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); }
        .btn-warning { background: linear-gradient(135deg, #fcc419 0%, #fab005 100%); color: #212529; }
        .btn-secondary { background: #868e96; color: white; }
        .repair-info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .repair-info h5 { color: #856404; margin-bottom: 10px; }
        .repair-row { margin-bottom: 8px; color: #856404; }
        .empty-box { color: #999; font-style: italic; text-align: center; padding: 30px; grid-column: 1 / -1; }
    </style>
</head>
<body>
    <div class="main-container">
        <h1 class="header-title">📦 ${locker.lockerName} - 快递柜详情</h1>

        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/lockers/edit/${locker.id}" class="btn btn-primary">✏️ 编辑</a>
            <a href="${pageContext.request.contextPath}/lockers/repair/${locker.id}" class="btn btn-warning">🔧 故障报修</a>
            <a href="${pageContext.request.contextPath}/lockers" class="btn btn-secondary">← 返回列表</a>
        </div>

        <!-- 基本信息 -->
        <div class="info-section">
            <h4>基本信息</h4>
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
                            <c:when test="${locker.status == 1}"><span class="badge badge-success">启用</span></c:when>
                            <c:otherwise><span class="badge badge-secondary">禁用</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">故障状态</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${locker.repairStatus == 1}"><span class="badge badge-danger">待维修</span></c:when>
                            <c:when test="${locker.repairStatus == 2}"><span class="badge badge-warning">维修中</span></c:when>
                            <c:when test="${locker.repairStatus == 3}"><span class="badge badge-success">已维修</span></c:when>
                            <c:otherwise><span class="badge badge-secondary">无故障</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">创建时间</div>
                    <div class="info-value"><fmt:formatDate value="${locker.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
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
            <h4>柜格统计</h4>
            <div class="stats-cards">
                <div class="stat-card"><p>总柜格数</p><h3>${boxStats.totalBoxes}</h3></div>
                <div class="stat-card"><p>可用柜格</p><h3 style="color:#51cf66;">${boxStats.availableBoxes}</h3></div>
                <div class="stat-card"><p>已占用</p><h3 style="color:#fcc419;">${boxStats.occupiedBoxes}</h3></div>
                <div class="stat-card"><p>禁用柜格</p><h3 style="color:#ff6b6b;">${boxStats.brokenBoxes}</h3></div>
            </div>
            <c:if test="${boxStats.totalBoxes > 0}">
                <c:set var="percent" value="${(boxStats.availableBoxes / boxStats.totalBoxes) * 100}"/>
                <div style="background: white; padding: 15px; border-radius: 10px;">
                    <strong>可用率：</strong>
                    <div class="progress">
                        <div class="progress-bar" style="width: ${percent}%;">
                            <fmt:formatNumber value="${percent}" maxFractionDigits="1"/>%
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- 维修信息 -->
        <c:if test="${locker.repairStatus != null && locker.repairStatus != 0}">
            <div class="repair-info">
                <h5>🔧 维修信息</h5>
                <div class="repair-row">
                    <strong>故障状态：</strong>
                    <c:choose>
                        <c:when test="${locker.repairStatus == 1}">待维修</c:when>
                        <c:when test="${locker.repairStatus == 2}">维修中</c:when>
                        <c:when test="${locker.repairStatus == 3}">已维修</c:when>
                    </c:choose>
                </div>
                <div class="repair-row">
                    <strong>报修时间：</strong>
                    <fmt:formatDate value="${locker.repairTime}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
                <div class="repair-row"><strong>维修人员：</strong>${locker.operatorId}</div>
                <div class="repair-row"><strong>故障描述：</strong>${locker.repairDesc}</div>
            </div>
        </c:if>

        <!-- 柜格列表 -->
        <div class="info-section">
            <h4>柜格列表</h4>
            <div class="box-grid">
                <c:forEach items="${boxes}" var="box">
                    <div class="box-item
                        <c:choose>
                            <c:when test="${box.status == 1}">box-available</c:when>
                            <c:when test="${box.status == 2}">box-occupied</c:when>
                            <c:otherwise>box-broken</c:otherwise>
                        </c:choose>">
                        <div class="box-code">${box.boxNumber}</div>
                        <div>
                            <span class="badge
                                <c:choose>
                                    <c:when test="${box.status == 1}">badge-success</c:when>
                                    <c:when test="${box.status == 2}">badge-warning</c:when>
                                    <c:otherwise>badge-danger</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${box.status == 1}">空闲</c:when>
                                    <c:when test="${box.status == 2}">占用</c:when>
                                    <c:otherwise>禁用</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="box-size">
                            <c:choose>
                                <c:when test="${box.boxSize == 'SMALL'}">小型</c:when>
                                <c:when test="${box.boxSize == 'MEDIUM'}">中型</c:when>
                                <c:when test="${box.boxSize == 'LARGE'}">大型</c:when>
                                <c:otherwise>${box.boxSize}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty boxes}">
                    <div class="empty-box">暂无柜格数据</div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
