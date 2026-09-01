<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty box ? '新增储物格' : '编辑储物格'} - 智能快递柜管理系统</title>
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
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 30px 40px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(17, 153, 142, 0.3);
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
            border-color: #11998e;
            box-shadow: 0 0 0 3px rgba(17, 153, 142, 0.1);
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
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(17, 153, 142, 0.4);
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
            <h1>${empty box ? '新增储物格' : '编辑储物格'}</h1>
        </div>

        <div class="content">
            <form action="${empty box ? pageContext.request.contextPath + '/boxes/save' : pageContext.request.contextPath + '/boxes/save'}" method="post">
                <c:if test="${not empty box}">
                    <input type="hidden" name="id" value="${box.id}">
                </c:if>

                <div class="form-row">
                    <div class="form-group">
                        <label for="boxNumber">储物格编号 *</label>
                        <input type="text" id="boxNumber" name="boxNumber" value="${box.boxNumber}" required>
                    </div>
                    <div class="form-group">
                        <label for="boxSize">储物格大小 *</label>
                        <select id="boxSize" name="boxSize" required>
                            <option value="SMALL" ${box.boxSize == 'SMALL' ? 'selected' : ''}>小型</option>
                            <option value="MEDIUM" ${box.boxSize == 'MEDIUM' ? 'selected' : ''}>中型</option>
                            <option value="LARGE" ${box.boxSize == 'LARGE' ? 'selected' : ''}>大型</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="lockerId">快递柜 *</label>
                    <select id="lockerId" name="lockerId" required>
                        <option value="">请选择快递柜</option>
                        <c:forEach items="${lockers}" var="locker">
                            <option value="${locker.id}" ${box.lockerId == locker.id ? 'selected' : ''}>${locker.lockerName} - ${locker.location}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="status">状态 *</label>
                    <select id="status" name="status" required>
                        <option value="1" ${box.status == 1 ? 'selected' : ''}>空闲</option>
                        <option value="2" ${box.status == 2 ? 'selected' : ''}>占用</option>
                        <option value="0" ${box.status == 0 ? 'selected' : ''}>禁用</option>
                    </select>
                </div>

                <div class="buttons">
                    <button type="submit" class="btn btn-primary">保存</button>
                    <a href="${pageContext.request.contextPath}/boxes" class="btn btn-cancel">取消</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>