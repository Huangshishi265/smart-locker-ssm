<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty user ? '新增用户' : '编辑用户'} - 智能快递柜管理系统</title>
    <style>
        body {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px;
        }
        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 800px;
            margin: 0 auto;
        }
        .form-header {
            margin-bottom: 30px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 15px;
        }
        .form-header h3 {
            color: #333;
            font-weight: bold;
            margin: 0;
        }
        .form-label {
            font-weight: 600;
            color: #333;
            display: block;
            margin-bottom: 8px;
        }
        .form-control {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 10px 15px;
            transition: all 0.3s ease;
            width: 100%;
            font-size: 14px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 10px 25px;
            font-weight: 600;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            border-radius: 8px;
            padding: 10px 25px;
            font-weight: 600;
            background: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .required {
            color: #dc3545;
        }
        .avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #667eea;
            background: #f0f0f0;
            display: block;
            margin-bottom: 10px;
        }
        .avatar-placeholder {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h3>${empty user ? '➕ 新增用户' : '✏️ 编辑用户'}</h3>
        </div>

        <form action="${pageContext.request.contextPath}${empty user ? '/users' : '/users/update/'}${user.id}"
              method="post" id="userForm">
            <input type="hidden" name="id" value="${user.id}">

            <div class="form-row">
                <div class="form-group">
                    <label for="username" class="form-label">
                        用户名 <span class="required">*</span>
                    </label>
                    <input type="text" class="form-control" id="username" name="username"
                           value="${user.username}" required
                           ${not empty user ? 'readonly' : ''}
                           placeholder="请输入用户名" minlength="3" maxlength="20">
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">
                        密码 <c:if test="${empty user}"><span class="required">*</span></c:if>
                    </label>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="${empty user ? '请输入密码' : '留空则不修改密码'}"
                           ${empty user ? 'required' : ''}>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="realName" class="form-label">
                        真实姓名 <span class="required">*</span>
                    </label>
                    <input type="text" class="form-control" id="realName" name="realName"
                           value="${user.realName}" required
                           placeholder="请输入真实姓名" maxlength="20">
                </div>
                <div class="form-group">
                    <label for="phone" class="form-label">
                        手机号码 <span class="required">*</span>
                    </label>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           value="${user.phone}" required
                           placeholder="请输入手机号码" pattern="1[3-9]\d{9}">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email" class="form-label">
                        电子邮箱
                    </label>
                    <input type="email" class="form-control" id="email" name="email"
                           value="${user.email}"
                           placeholder="请输入电子邮箱">
                </div>
                <div class="form-group">
                    <label for="address" class="form-label">
                        地址
                    </label>
                    <input type="text" class="form-control" id="address" name="address"
                           value="${user.address}"
                           placeholder="请输入地址" maxlength="100">
                </div>
            </div>

            <!-- 头像上传 -->
            <div class="form-group">
                <label class="form-label">用户头像</label>
                <div style="display: flex; align-items: center; gap: 20px;">
                    <div>
                        <c:choose>
                            <c:when test="${not empty user.avatar}">
                                <img src="${pageContext.request.contextPath}${user.avatar}" alt="${user.realName}" class="avatar-preview" id="avatarPreview">
                            </c:when>
                            <c:otherwise>
                                <div class="avatar-placeholder" id="avatarPlaceholder">用</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <input type="file" id="avatarFile" name="avatarFile" accept="image/*"
                               style="display: none;" onchange="previewAvatar(this)">
                        <button type="button" class="btn btn-primary" onclick="document.getElementById('avatarFile').click()">
                            📷 上传头像
                        </button>
                        <input type="hidden" name="existingAvatar" value="${user.avatar}">
                        <p style="margin-top: 10px; color: #6c757d; font-size: 14px;">
                            支持上传 JPG、PNG 格式图片，建议尺寸 200x200
                        </p>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">角色</label>
                <div>
                    <label style="margin-right: 20px;">
                        <input type="radio" name="role" value="1"
                               ${not empty user && user.role == 1 ? 'checked' : ''}> 管理员
                    </label>
                    <label>
                        <input type="radio" name="role" value="2"
                               ${empty user || user.role == 2 ? 'checked' : ''}> 普通用户
                    </label>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">状态</label>
                <div>
                    <label style="margin-right: 20px;">
                        <input type="radio" name="status" value="1"
                               ${empty user || user.status == 1 ? 'checked' : ''}> 启用
                    </label>
                    <label>
                        <input type="radio" name="status" value="0"
                               ${not empty user && user.status == 0 ? 'checked' : ''}> 禁用
                    </label>
                </div>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">
                    返回列表
                </a>
                <button type="submit" class="btn btn-primary">
                    ${empty user ? '💾 保存' : '✏️ 更新'}
                </button>
            </div>
        </form>
    </div>
    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var preview = document.getElementById('avatarPreview');
                    var placeholder = document.getElementById('avatarPlaceholder');

                    if (preview) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    } else {
                        var img = document.createElement('img');
                        img.id = 'avatarPreview';
                        img.className = 'avatar-preview';
                        img.src = e.target.result;
                        img.style.display = 'block';
                        placeholder.parentNode.replaceChild(img, placeholder);
                    }
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>