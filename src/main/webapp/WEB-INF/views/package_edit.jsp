<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty pkg ? '新增快递' : '编辑快递'} - 智能快递柜管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #f5f7fa;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 40px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .header h1 {
            font-size: 28px;
            font-weight: bold;
        }

        .content {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            font-size: 16px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
        }

        .btn {
            padding: 12px 40px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .btn-cancel {
            background: #dc3545;
            color: white;
        }

        .btn-cancel:hover {
            background: #c82333;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${empty pkg ? '新增快递' : '编辑快递'}</h1>
        </div>

        <div class="content">
            <form action="${empty pkg ? pageContext.request.contextPath + '/packages/save' : pageContext.request.contextPath + '/packages/save'}" method="post">
                <c:if test="${not empty pkg}">
                    <input type="hidden" name="id" value="${pkg.id}">
                </c:if>

                <div class="form-group">
                    <label for="packageNo">快递单号 *</label>
                    <input type="text" id="packageNo" name="packageNo" value="${pkg.packageNo}" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="senderName">寄件人姓名 *</label>
                        <input type="text" id="senderName" name="senderName" value="${pkg.senderName}" required>
                    </div>
                    <div class="form-group">
                        <label for="senderPhone">寄件人电话 *</label>
                        <input type="text" id="senderPhone" name="senderPhone" value="${pkg.senderPhone}" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="receiverName">收件人姓名 *</label>
                        <input type="text" id="receiverName" name="receiverName" value="${pkg.receiverName}" required>
                    </div>
                    <div class="form-group">
                        <label for="receiverPhone">收件人电话 *</label>
                        <input type="text" id="receiverPhone" name="receiverPhone" value="${pkg.receiverPhone}" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="lockerId">快递柜 *</label>
                        <select id="lockerId" name="lockerId" required>
                            <option value="">请选择快递柜</option>
                            <c:forEach items="${lockers}" var="locker">
                                <option value="${locker.id}" ${pkg.lockerId == locker.id ? 'selected' : ''}>${locker.lockerName} - ${locker.location}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="boxId">储物格 *</label>
                        <select id="boxId" name="boxId" required>
                            <option value="">请选择储物格</option>
                            <c:forEach items="${boxes}" var="box">
                                <c:if test="${box.status == 1}">
                                    <option value="${box.id}" ${pkg.boxId == box.id ? 'selected' : ''}>${box.boxNumber} - ${box.boxSize}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="status">状态 *</label>
                    <select id="status" name="status" required>
                        <option value="1" ${pkg.status == 1 ? 'selected' : ''}>待取件</option>
                        <option value="2" ${pkg.status == 2 ? 'selected' : ''}>已取件</option>
                        <option value="0" ${pkg.status == 0 ? 'selected' : ''}>已取消</option>
                    </select>
                </div>

                <div class="buttons">
                    <button type="submit" class="btn btn-primary">保存</button>
                    <a href="${pageContext.request.contextPath}/packages" class="btn btn-cancel">取消</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>