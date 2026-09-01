<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty pkg ? '新增快递' : '编辑快递'} - 智能快递柜系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .form-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 50px;
            max-width: 600px;
            width: 100%;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
            font-size: 14px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }

        .form-group small {
            display: block;
            margin-top: 5px;
            color: #999;
            font-size: 12px;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-save {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        .btn-cancel:hover {
            background: #5a6268;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="header">
            <h1>${empty pkg ? '新增快递' : '编辑快递'}</h1>
        </div>

        <form action="${pageContext.request.contextPath}/packages/save" method="post">
            <c:if test="${not empty pkg}">
                <input type="hidden" name="id" value="${pkg.id}">
            </c:if>

            <div class="form-group">
                <label for="packageNo">快递单号 *</label>
                <input type="text" id="packageNo" name="packageNo"
                       value="${not empty pkg ? pkg.packageNo : ''}" required>
                <small>请输入快递单号，如：SF1234567890</small>
            </div>

            <div class="form-group">
                <label for="senderName">寄件人姓名 *</label>
                <input type="text" id="senderName" name="senderName"
                       value="${not empty pkg ? pkg.senderName : ''}" required>
            </div>

            <div class="form-group">
                <label for="senderPhone">寄件人电话 *</label>
                <input type="text" id="senderPhone" name="senderPhone"
                       value="${not empty pkg ? pkg.senderPhone : ''}" required>
            </div>

            <div class="form-group">
                <label for="receiverName">收件人姓名 *</label>
                <input type="text" id="receiverName" name="receiverName"
                       value="${not empty pkg ? pkg.receiverName : ''}" required>
            </div>

            <div class="form-group">
                <label for="receiverPhone">收件人电话 *</label>
                <input type="text" id="receiverPhone" name="receiverPhone"
                       value="${not empty pkg ? pkg.receiverPhone : ''}" required>
            </div>

            <div class="form-group">
                <label for="lockerId">快递柜 *</label>
                <select id="lockerId" name="lockerId" required>
                    <option value="">请选择快递柜</option>
                    <c:forEach items="${lockers}" var="locker">
                        <option value="${locker.id}"
                                ${not empty pkg && pkg.lockerId != null && pkg.lockerId == locker.id ? 'selected' : ''}>
                            ${locker.lockerName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="boxId">储物格 *</label>
                <select id="boxId" name="boxId" required>
                    <option value="">请选择储物格</option>
                    <c:forEach items="${boxes}" var="box">
                        <c:if test="${box.status == 1}">
                            <option value="${box.id}"
                                    ${not empty pkg && pkg.boxId != null && pkg.boxId == box.id ? 'selected' : ''}>
                                ${box.boxNumber} - ${box.boxSize}
                            </option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="status">状态 *</label>
                <select id="status" name="status" required>
                    <option value="1" ${empty pkg || pkg.status == 1 ? 'selected' : ''}>待取件</option>
                    <option value="2" ${not empty pkg && pkg.status == 2 ? 'selected' : ''}>已取件</option>
                    <option value="0" ${not empty pkg && pkg.status == 0 ? 'selected' : ''}>已取消</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-save">保存</button>
                <a href="${pageContext.request.contextPath}/packages" class="btn btn-cancel" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">取消</a>
            </div>
        </form>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/packages">← 返回列表</a>
        </div>
    </div>
</body>
</html>
