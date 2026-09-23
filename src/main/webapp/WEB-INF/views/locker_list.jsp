<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>快递柜管理 - 智能快递柜系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 { font-size: 28px; color: #333; }

        .header a {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 25px;
            border-radius: 10px;
            text-decoration: none;
            transition: transform 0.3s;
        }

        .header a:hover { transform: translateY(-2px); }

        .toolbar { display: flex; gap: 10px; align-items: center; margin-bottom: 20px; flex-wrap: wrap; }

        .filter-section {
            margin-bottom: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .filter-section label { margin-right: 10px; font-weight: bold; color: #333; }

        .filter-section input, .filter-section select {
            padding: 8px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            margin-right: 15px;
        }

        .table-container { overflow-x: auto; }

        table { width: 100%; border-collapse: collapse; margin-top: 20px; }

        th {
            background: #f8f9fa;
            color: #333;
            font-weight: bold;
            padding: 15px;
            text-align: left;
            border-bottom: 3px solid #667eea;
        }

        td { padding: 15px; border-bottom: 1px solid #e9ecef; color: #555; }

        tr:hover { background: #f8f9fa; }

        .badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-1 { background: #d4edda; color: #155724; }
        .status-0 { background: #f8d7da; color: #721c24; }
        .repair-0 { background: #e2e3e5; color: #383d41; }
        .repair-1 { background: #f8d7da; color: #721c24; }
        .repair-2 { background: #fff3cd; color: #856404; }
        .repair-3 { background: #d4edda; color: #155724; }

        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            margin-right: 5px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-view { background: #17a2b8; color: white; }
        .btn-view:hover { background: #138496; }
        .btn-edit { background: #ffc107; color: #333; }
        .btn-edit:hover { background: #e0a800; }
        .btn-repair { background: #fd7e14; color: white; }
        .btn-repair:hover { background: #e8690a; }
        .btn-complete { background: #28a745; color: white; }
        .btn-complete:hover { background: #218838; }
        .btn-delete { background: #dc3545; color: white; }
        .btn-delete:hover { background: #c82333; }
        .btn-add { background: #28a745; color: white; padding: 12px 25px; }
        .btn-add:hover { background: #218838; }
        .btn-muted { background: #6c757d; color: white; }
        .btn-muted:hover { background: #5a6268; }

        .actions { display: flex; gap: 5px; align-items: center; flex-wrap: wrap; }
        .actions form { display: inline; margin: 0; }

        .alert {
            padding: 12px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .empty { color: #999; font-style: italic; text-align: center; padding: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📦 快递柜管理</h1>
            <a href="${pageContext.request.contextPath}/" class="btn">返回首页</a>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <div class="toolbar">
            <a href="${pageContext.request.contextPath}/lockers/add" class="btn btn-add">+ 新增快递柜</a>
            <c:choose>
                <c:when test="${isBrokenList}">
                    <a href="${pageContext.request.contextPath}/lockers" class="btn btn-muted">查看全部快递柜</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/lockers/broken" class="btn btn-repair">🔧 故障快递柜</a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 查询条件 -->
        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/lockers/search" method="get" style="margin: 0;">
                <label>快递柜名称：</label>
                <input type="text" name="lockerName" value="${params.lockerName}" placeholder="请输入名称">
                <label>位置：</label>
                <input type="text" name="location" value="${params.location}" placeholder="请输入位置">
                <label>状态：</label>
                <select name="status">
                    <option value="">全部</option>
                    <option value="1" ${params.status == 1 ? 'selected' : ''}>正常</option>
                    <option value="0" ${params.status == 0 ? 'selected' : ''}>禁用</option>
                </select>
                <button type="submit" class="btn btn-view" style="margin-right:0;">查询</button>
            </form>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>名称</th>
                        <th>位置</th>
                        <th>详细地址</th>
                        <th>状态</th>
                        <th>故障状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${lockers}" var="locker">
                        <tr>
                            <td>${locker.id}</td>
                            <td><strong>${locker.lockerName}</strong></td>
                            <td>${locker.location}</td>
                            <td>${locker.address}</td>
                            <td>
                                <span class="badge status-${locker.status}">
                                    ${locker.status == 1 ? '正常' : '禁用'}
                                </span>
                            </td>
                            <td>
                                <span class="badge repair-${locker.repairStatus}">
                                    <c:choose>
                                        <c:when test="${locker.repairStatus == 1}">待维修</c:when>
                                        <c:when test="${locker.repairStatus == 2}">维修中</c:when>
                                        <c:when test="${locker.repairStatus == 3}">已维修</c:when>
                                        <c:otherwise>无故障</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/lockers/view/${locker.id}" class="btn btn-view">详情</a>
                                <a href="${pageContext.request.contextPath}/lockers/edit/${locker.id}" class="btn btn-edit">编辑</a>
                                <a href="${pageContext.request.contextPath}/lockers/repair/${locker.id}" class="btn btn-repair">报修</a>
                                <c:if test="${locker.repairStatus == 1 || locker.repairStatus == 2}">
                                    <form action="${pageContext.request.contextPath}/lockers/repair/complete/${locker.id}" method="post"
                                          onsubmit="return confirm('确认已完成维修 ${locker.lockerName} 吗？')">
                                        <button type="submit" class="btn btn-complete">完成维修</button>
                                    </form>
                                </c:if>
                                <form action="${pageContext.request.contextPath}/lockers/status/${locker.id}" method="post"
                                      onsubmit="return confirm('确认${locker.status == 1 ? '禁用' : '启用'} ${locker.lockerName} 吗？')">
                                    <input type="hidden" name="status" value="${locker.status == 1 ? 0 : 1}">
                                    <button type="submit" class="btn btn-muted">${locker.status == 1 ? '禁用' : '启用'}</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/lockers/delete/${locker.id}" method="post"
                                      onsubmit="return confirm('确定要删除快递柜 ${locker.lockerName} 吗？此操作不可恢复。')">
                                    <button type="submit" class="btn btn-delete">删除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${empty lockers}">
                <div class="empty">暂无快递柜数据</div>
            </c:if>
        </div>
    </div>
</body>
</html>
