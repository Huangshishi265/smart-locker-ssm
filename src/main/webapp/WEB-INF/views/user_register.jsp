<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 智能快递柜管理系统</title>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px 0;
        }
        .register-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 50px 40px;
            max-width: 600px;
            width: 100%;
        }
        .register-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .register-header h2 {
            color: #333;
            font-weight: 700;
            margin-bottom: 10px;
            font-size: 28px;
        }
        .register-header p {
            color: #666;
            font-size: 14px;
        }
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s ease;
            width: 100%;
            box-sizing: border-box;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-size: 16px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
            width: 100%;
            cursor: pointer;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
        .btn-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .btn-link:hover {
            text-decoration: underline;
        }
        .required {
            color: #dc3545;
        }
        .text-center {
            text-align: center;
        }
        .text-muted {
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h2>📦 智能快递柜管理系统</h2>
            <p>用户注册</p>
        </div>

        <form action="${pageContext.request.contextPath}/users" method="post" id="registerForm">
            <div class="form-group">
                <label for="username" class="form-label">
                    用户名 <span class="required">*</span>
                </label>
                <input type="text" class="form-control" id="username" name="username" required
                       placeholder="请输入用户名" minlength="3" maxlength="20">
                <div class="form-text">用户名长度 3-20 个字符</div>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">
                    密码 <span class="required">*</span>
                </label>
                <input type="password" class="form-control" id="password" name="password" required
                       placeholder="请输入密码" minlength="6" maxlength="20">
                <div class="form-text">密码长度至少 6 个字符</div>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label">
                    确认密码 <span class="required">*</span>
                </label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required
                       placeholder="请再次输入密码">
            </div>

            <div class="form-group">
                <label for="realName" class="form-label">
                    真实姓名 <span class="required">*</span>
                </label>
                <input type="text" class="form-control" id="realName" name="realName" required
                       placeholder="请输入真实姓名" maxlength="20">
            </div>

            <div class="form-group">
                <label for="phone" class="form-label">
                    手机号码 <span class="required">*</span>
                </label>
                <input type="tel" class="form-control" id="phone" name="phone" required
                       placeholder="请输入手机号码" pattern="1[3-9]\d{9}">
                <div class="form-text">请输入11位手机号码</div>
            </div>

            <div class="form-group">
                <label for="email" class="form-label">
                    电子邮箱
                </label>
                <input type="email" class="form-control" id="email" name="email"
                       placeholder="请输入电子邮箱">
            </div>

            <div class="form-group">
                <label for="address" class="form-label">
                    地址
                </label>
                <input type="text" class="form-control" id="address" name="address"
                       placeholder="请输入地址" maxlength="100">
            </div>

            <button type="submit" class="btn-primary" style="margin-bottom: 20px;">
                🚀 立即注册
            </button>

            <div class="text-center">
                <span class="text-muted">已有账号？</span>
                <a href="${pageContext.request.contextPath}/" class="btn-link">立即登录</a>
            </div>
        </form>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('两次输入的密码不一致！');
                return false;
            }

            const phone = document.getElementById('phone').value;
            if (!/^1[3-9]\d{9}$/.test(phone)) {
                e.preventDefault();
                alert('请输入正确的手机号码！');
                return false;
            }
        });
    </script>
</body>
</html>
