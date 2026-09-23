-- ============================================
-- 演示数据脚本（在 database-init.sql 之后执行）
-- 作用：把「最小种子数据」扩充成一套有真实感的演示数据，
--       覆盖多个快递柜、多个用户、多种快递状态、多种 AI 问答样本，
--       让截图 / 录屏 / 面试演示更有说服力。
--
-- 注意：
--   1. 本脚本用「显式 ID」，必须在 database-init.sql 刚跑完、
--      表刚重建好（自增从 1 开始）之后执行一次。
--   2. 所有用户密码均为 123456 的 MD5。
-- ============================================

USE smart_locker;

-- ============================================
-- 1. 补充普通用户（密码均 = 123456 的 MD5）
-- ============================================
INSERT INTO t_user (id, username, password, real_name, phone, email, address, avatar, role, status) VALUES
(3, 'wangxm', 'e10adc3949ba59abbe56e057f20f883e', '王小明', '13812345678', 'wangxm@example.com', '1号楼 302',  NULL, 2, 1),
(4, 'lixh',   'e10adc3949ba59abbe56e057f20f883e', '李晓红', '13912345678', 'lixh@example.com',   '2号楼 508',  NULL, 2, 1),
(5, 'zhangw', 'e10adc3949ba59abbe56e057f20f883e', '张伟',   '13712345678', 'zhangw@example.com', '3号楼 1102', NULL, 2, 1),
(6, 'liuf',   'e10adc3949ba59abbe56e057f20f883e', '刘芳',   '13612345678', 'liuf@example.com',   '1号楼 201',  NULL, 2, 1);

-- ============================================
-- 2. 给 2号楼、3号楼快递柜补柜格（初始化脚本只给了 1号楼）
-- ============================================
INSERT INTO t_box (id, locker_id, box_number, box_size, status) VALUES
(11, 2, 'A1', 'SMALL',  1), (12, 2, 'A2', 'SMALL',  1), (13, 2, 'A3', 'SMALL', 1),
(14, 2, 'B1', 'MEDIUM', 1), (15, 2, 'B2', 'MEDIUM', 1), (16, 2, 'B3', 'MEDIUM', 1),
(17, 2, 'C1', 'LARGE',  1),
(18, 3, 'A1', 'SMALL',  1), (19, 3, 'A2', 'SMALL', 1),
(20, 3, 'B1', 'MEDIUM', 1), (21, 3, 'B2', 'MEDIUM', 1);

-- ============================================
-- 3. 快递数据（覆盖 待取件 / 已取件 / 已取消，跨三个快递柜）
--    receiver_phone 是关键：AI 客服就是按手机号查这些数据来回答的
-- ============================================
INSERT INTO t_package (id, package_no, sender_name, sender_phone, receiver_id, receiver_name, receiver_phone, locker_id, box_id, status, put_in_time, take_out_time) VALUES
(3,  'SF1234567891', '京东商城',  '13800001111', 3, '王小明', '13812345678', 1, 1,  1, NOW() - INTERVAL 2 HOUR,    NULL),
(4,  'YT9876543211', '天猫超市',  '13800001112', 4, '李晓红', '13912345678', 1, 2,  1, NOW() - INTERVAL 3 HOUR,    NULL),
(5,  'ZT1111222233', '顺丰速运',  '13800001113', 5, '张伟',   '13712345678', 2, 11, 1, NOW() - INTERVAL 1 HOUR,    NULL),
(6,  'SF1234567892', '小米商城',  '13800001114', 3, '王小明', '13812345678', 2, 14, 1, NOW() - INTERVAL 5 HOUR,    NULL),
(7,  'JD5555666677', '京东物流',  '13800001115', 6, '刘芳',   '13612345678', 3, 18, 1, NOW() - INTERVAL 30 MINUTE, NULL),
(8,  'YT9876543212', '当当网',    '13800001116', 3, '王小明', '13812345678', 1, NULL, 2, NOW() - INTERVAL 2 DAY,   NOW() - INTERVAL 1 DAY),
(9,  'SF1234567893', '淘宝卖家',  '13800001117', 6, '刘芳',   '13612345678', 1, NULL, 2, NOW() - INTERVAL 3 DAY,   NOW() - INTERVAL 2 DAY),
(10, 'YT9876543213', '唯品会',    '13800001118', 4, '李晓红', '13912345678', NULL, NULL, 0, NOW() - INTERVAL 4 DAY,   NULL),
(11, 'SF1234567894', '网易严选',  '13800001119', 6, '刘芳',   '13612345678', 1, 7,  1, NOW() - INTERVAL 45 MINUTE, NULL),
(12, 'ZT2222333344', '拼多多',    '13800001120', 5, '张伟',   '13712345678', 2, 15, 1, NOW() - INTERVAL 20 MINUTE, NULL);

-- 把被「待取件」快递占用的柜格状态置为占用
UPDATE t_box SET status = 2 WHERE id IN (1, 2, 7, 11, 14, 15, 18);

-- ============================================
-- 4. AI 客服对话日志样本（支撑「转人工率 / 模型可用率 / Bad Case」讲述）
--    phone 已按代码规则脱敏：保留前 3 后 4，中间 ****
-- ============================================
INSERT INTO ai_chat_log (phone, question, answer, answer_source, is_transferred) VALUES
('138****5678', '我的快递到了吗', '您好，您有 2 个快递待取件：一个在 1号楼大厅快递柜 A1 柜格，一个在 2号楼西侧快递柜 B1 柜格，请尽快取件。', 'model', 0),
('139****5678', '快递在哪个柜子', '您的快递在 1号楼大厅快递柜 A2 柜格，目前状态为待取件。', 'model', 0),
('137****5678', '我的快递到了吗', '您好，您有 2 个快递待取件：分别位于 2号楼西侧快递柜 A1、B2 柜格。', 'model', 0),
('136****5678', '帮我转人工', '抱歉，我暂时无法直接为您转接人工，请稍后在「意见反馈」留言，客服会尽快联系您。', 'template', 1),
('135****1111', '投诉', '已为您记录投诉信息，客服将在一个工作日内与您联系。', 'template', 1);

-- ============================================
-- 完成
-- ============================================
SELECT '演示数据已就绪！' AS message;
SELECT COUNT(*) AS user_count    FROM t_user;
SELECT COUNT(*) AS locker_count  FROM t_locker;
SELECT COUNT(*) AS box_count     FROM t_box;
SELECT COUNT(*) AS package_count FROM t_package;
SELECT COUNT(*) AS chat_log_count FROM ai_chat_log;
