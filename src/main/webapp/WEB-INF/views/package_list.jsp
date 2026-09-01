<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>快递管理 - 智能快递柜系统</title>
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

        .header h1 {
            font-size: 28px;
            color: #333;
        }

        .header a {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 25px;
            border-radius: 10px;
            text-decoration: none;
            transition: transform 0.3s;
        }

        .header a:hover {
            transform: translateY(-2px);
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            background: #f8f9fa;
            color: #333;
            font-weight: bold;
            padding: 15px;
            text-align: left;
            border-bottom: 3px solid #667eea;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            color: #555;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-1 {
            background: #fff3cd;
            color: #856404;
        }

        .status-2 {
            background: #d4edda;
            color: #155724;
        }

        .status-0 {
            background: #f8d7da;
            color: #721c24;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            margin-right: 5px;
            transition: all 0.3s;
        }

        .btn-edit {
            background: #ffc107;
            color: #333;
        }

        .btn-edit:hover {
            background: #e0a800;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
        }

        .btn-add {
            background: #28a745;
            color: white;
            padding: 12px 25px;
        }

        .btn-add:hover {
            background: #218838;
        }

        .actions {
            display: flex;
            gap: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📦 快递管理</h1>
            <a href="${pageContext.request.contextPath}/" class="btn">返回首页</a>
        </div>

        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/packages/add" class="btn btn-add">+ 新增快递</a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>快递单号</th>
                        <th>寄件人</th>
                        <th>收件人</th>
                        <th>快递柜</th>
                        <th>储物格</th>
                        <th>状态</th>
                        <th>存入时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${packages}" var="pkg">
                        <tr>
                            <td>${pkg.id}</td>
                            <td>${pkg.packageNo}</td>
                            <td>
                                ${pkg.senderName}<br>
                                <small style="color: #999;">${pkg.senderPhone}</small>
                            </td>
                            <td>
                                ${pkg.receiverName}<br>
                                <small style="color: #999;">${pkg.receiverPhone}</small>
                            </td>
                            <td>
                                ${pkg.lockerName}<br>
                                <small style="color: #999;">${pkg.lockerLocation}</small>
                            </td>
                            <td>${pkg.boxNumber} (${pkg.boxSize})</td>
                            <td>
                                <span class="status-badge status-${pkg.status}">
                                    ${pkg.statusDesc}
                                </span>
                            </td>
                            <td>
                                <fmt:formatDate value="${pkg.putInTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/packages/edit/${pkg.id}" class="btn btn-edit">编辑</a>
                                <a href="${pageContext.request.contextPath}/packages/delete/${pkg.id}" class="btn btn-delete"
                                   onclick="return confirm('确定要删除快递 ${pkg.packageNo} 吗？')">删除</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
