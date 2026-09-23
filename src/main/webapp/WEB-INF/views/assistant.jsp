<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能客服 - 智能快递柜系统</title>
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
            max-width: 700px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            height: calc(100vh - 40px);
            overflow: hidden;
        }
        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .chat-header .avatar {
            width: 44px;
            height: 44px;
            background: rgba(255,255,255,0.25);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        .chat-header h2 { font-size: 20px; font-weight: 600; }
        .chat-header p { font-size: 12px; opacity: 0.85; }
        .chat-body {
            flex: 1;
            overflow-y: auto;
            padding: 20px 25px;
            background: #f8f9fa;
        }
        .message {
            margin-bottom: 16px;
            display: flex;
            flex-direction: column;
        }
        .message .bubble {
            max-width: 80%;
            padding: 12px 16px;
            border-radius: 16px;
            line-height: 1.6;
            font-size: 14px;
            white-space: pre-wrap;
            word-break: break-word;
        }
        .message.bot { align-items: flex-start; }
        .message.bot .bubble {
            background: white;
            color: #333;
            border-bottom-left-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .message.user { align-items: flex-end; }
        .message.user .bubble {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-bottom-right-radius: 4px;
        }
        .chat-footer {
            padding: 15px 20px;
            background: white;
            border-top: 1px solid #e9ecef;
        }
        .input-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }
        .input-row input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
        }
        .input-row input:focus { border-color: #667eea; }
        .input-row button {
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }
        .input-row button:disabled { opacity: 0.6; cursor: not-allowed; }
        .quick-hints { display: flex; gap: 8px; flex-wrap: wrap; }
        .quick-hint {
            padding: 6px 12px;
            background: #f1f3f5;
            border: 1px solid #e9ecef;
            border-radius: 20px;
            font-size: 12px;
            color: #495057;
            cursor: pointer;
        }
        .quick-hint:hover { background: #e9ecef; }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: white;
            text-decoration: none;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="chat-header">
            <div class="avatar">🤖</div>
            <div>
                <h2>智能快递柜客服</h2>
                <p>输入手机号即可查询快递状态</p>
            </div>
        </div>

        <div class="chat-body" id="chatBody">
            <div class="message bot">
                <div class="bubble">您好，我是智能客服。请输入您的手机号，我可以帮您查询快递是否到柜、在哪个柜格，或为您生成取件通知。✨</div>
            </div>
        </div>

        <div class="chat-footer">
            <div class="input-row">
                <input type="text" id="phoneInput" placeholder="请输入收件人手机号" maxlength="11">
                <button id="sendBtn" onclick="sendMessage()">发送</button>
            </div>
            <div class="input-row">
                <input type="text" id="questionInput" placeholder="请输入问题（如：我的快递到了吗？）" onkeydown="if(event.key==='Enter')sendMessage()">
            </div>
            <div class="quick-hints">
                <span class="quick-hint" onclick="setQuestion('我的快递到了吗？')">我的快递到了吗？</span>
                <span class="quick-hint" onclick="setQuestion('我的快递在哪个柜？')">在哪个柜？</span>
                <span class="quick-hint" onclick="setQuestion('帮我生成取件通知')">生成取件通知</span>
            </div>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/" class="back-link">← 返回首页</a>

    <script>
        function appendMessage(role, text) {
            var body = document.getElementById('chatBody');
            var div = document.createElement('div');
            div.className = 'message ' + (role === 'user' ? 'user' : 'bot');
            var bubble = document.createElement('div');
            bubble.className = 'bubble';
            bubble.textContent = text;
            div.appendChild(bubble);
            body.appendChild(div);
            body.scrollTop = body.scrollHeight;
        }

        function setQuestion(q) {
            document.getElementById('questionInput').value = q;
            document.getElementById('phoneInput').focus();
        }

        function sendMessage() {
            var phone = document.getElementById('phoneInput').value.trim();
            var question = document.getElementById('questionInput').value.trim();
            if (!phone) {
                appendMessage('bot', '请先输入您的手机号，我才能为您查询哦。');
                document.getElementById('phoneInput').focus();
                return;
            }
            if (!question) {
                question = '请帮我查询快递';
            }
            appendMessage('user', (question + '（' + phone + '）'));

            var btn = document.getElementById('sendBtn');
            btn.disabled = true;

            var formData = new URLSearchParams();
            formData.append('phone', phone);
            formData.append('question', question);

            fetch('${pageContext.request.contextPath}/assistant/chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body: formData
            })
            .then(function(resp) { return resp.json(); })
            .then(function(data) {
                appendMessage('bot', data.answer || '抱歉，暂时无法处理您的请求。');
            })
            .catch(function() {
                appendMessage('bot', '网络异常，请稍后再试。');
            })
            .finally(function() {
                btn.disabled = false;
            });
        }
    </script>
</body>
</html>
