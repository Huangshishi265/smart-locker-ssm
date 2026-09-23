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

        .btn-take {
            background: #17a2b8;
            color: white;
        }

        .btn-take:hover {
            background: #138496;
        }

        .btn-notice {
            background: #6f42c1;
            color: white;
        }

        .btn-notice:hover {
            background: #5a32a3;
        }

        .modal-mask {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }

        .modal-box {
            background: white;
            border-radius: 16px;
            padding: 30px;
            max-width: 520px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .modal-box h3 {
            margin-bottom: 15px;
            color: #333;
        }

        .modal-box textarea {
            width: 100%;
            min-height: 180px;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 12px;
            font-size: 14px;
            line-height: 1.6;
            resize: vertical;
            font-family: inherit;
        }

        .modal-box .modal-actions {
            margin-top: 15px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .actions {
            display: flex;
            gap: 5px;
        }

        .alert {
            padding: 12px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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

        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

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
                                <c:if test="${pkg.status == 1}">
                                    <a href="${pageContext.request.contextPath}/packages/take/${pkg.id}" class="btn btn-take"
                                       onclick="return confirm('确认取件 ${pkg.packageNo} 吗？')">取件</a>
                                    <button type="button" class="btn btn-notice" onclick="generateNotice(${pkg.id})">生成通知</button>
                                </c:if>
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

    <!-- 取件通知弹窗 -->
    <div class="modal-mask" id="noticeModal">
        <div class="modal-box">
            <h3>📋 取件通知文案</h3>
            <textarea id="noticeContent" readonly></textarea>
            <div class="modal-actions">
                <button class="btn btn-edit" onclick="copyNotice()">复制</button>
                <button class="btn btn-delete" onclick="closeNotice()">关闭</button>
            </div>
        </div>
    </div>

    <script>
        var noticeText = '';

        function generateNotice(id) {
            fetch('${pageContext.request.contextPath}/assistant/notice/' + id, { method: 'POST' })
                .then(function(resp) { return resp.json(); })
                .then(function(data) {
                    noticeText = data.notice || '生成失败';
                    document.getElementById('noticeContent').value = noticeText;
                    document.getElementById('noticeModal').style.display = 'flex';
                })
                .catch(function() {
                    noticeText = '网络异常，请稍后再试。';
                    document.getElementById('noticeContent').value = noticeText;
                    document.getElementById('noticeModal').style.display = 'flex';
                });
        }

        function closeNotice() {
            document.getElementById('noticeModal').style.display = 'none';
        }

        function copyNotice() {
            var textarea = document.getElementById('noticeContent');
            textarea.select();
            document.execCommand('copy');
            alert('已复制到剪贴板');
        }
    </script>
</body>
</html>
