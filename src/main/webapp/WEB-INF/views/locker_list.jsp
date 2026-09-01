<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty locker ? '新增快递柜' : '编辑快递柜'} - 智能快递柜管理系统</title>
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
            max-width: 900px;
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
        .form-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
        }
        .form-section h4 {
            color: #667eea;
            margin-bottom: 20px;
            font-weight: 600;
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
            width: 100%;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
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
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
            color: white;
        }
        .required {
            color: #dc3545;
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
        .text-muted {
            color: #6c757d !important;
        }
    </style>
</head>
<body>
    <div class="container main-container">
        <!-- 标题 -->
        <h1 class="header-title">
            <c:choose>
                <c:when test="${not empty locker.id}">
                    编辑快递柜
                </c:when>
                <c:otherwise>
                    新增快递柜
                </c:otherwise>
            </c:choose>
        </h1>

        <!-- 消息提示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>

        <!-- 表单 -->
        <form action="${pageContext.request.contextPath}<c:choose><c:when test="${not empty locker.id}">/lockers/update/${locker.id}</c:when><c:otherwise>/lockers</c:otherwise></c:choose>" method="post" style="margin:0;padding:0;">

            <!-- 基本信息 -->
            <div class="form-section">
                <h4>基本信息</h4>
                <div class="form-group">
                    <label class="form-label">
                        快递柜名称 <span class="required">*</span>
                    </label>
                    <input type="text" class="form-control" name="lockerName"
                           value="${not empty locker ? locker.lockerName : ''}" required
                           placeholder="请输入快递柜名称">
                </div>

                <div class="form-group">
                    <label class="form-label">
                        位置 <span class="required">*</span>
                    </label>
                    <input type="text" class="form-control" name="location"
                           value="${not empty locker ? locker.location : ''}" required
                           placeholder="请输入位置（如：1号楼大厅）">
                </div>

                <div class="form-group">
                    <label class="form-label">描述</label>
                    <textarea class="form-control" name="description"
                              placeholder="请输入描述信息">${not empty locker ? locker.description : ''}</textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">状态</label>
                    <select class="form-control" name="status" required>
                        <option value="1" ${empty locker || locker.status == 1 ? 'selected' : ''}>正常</option>
                        <option value="0" ${not empty locker && locker.status == 0 ? 'selected' : ''}>禁用</option>
                    </select>
                </div>
            </div>

            <!-- 操作按钮 -->
            <div style="display: flex; gap: 15px; justify-content: center;">
                <button type="submit" class="btn btn-primary">
                    ${not empty locker ? '更新' : '保存'}
                </button>
                <a href="${pageContext.request.contextPath}/lockers" class="btn btn-secondary">
                    取消
                </a>
            </div>
        </form>
    </div>
</body>
</html>