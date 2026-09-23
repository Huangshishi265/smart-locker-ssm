-- ============================================
-- 智能快递柜管理系统 - 数据库初始化脚本
-- 版本：2.0
-- 说明：表结构与 Java 实体 / MyBatis Mapper 完全对齐
--       （此前脚本与代码不一致，已废弃 t_locker_box 等旧结构）
-- ============================================


USE smart_locker;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- 0. 清理旧表（按外键依赖逆序删除）
-- ============================================
DROP TABLE IF EXISTS `t_package`;
DROP TABLE IF EXISTS `t_box`;
DROP TABLE IF EXISTS `t_locker_box`;   -- 旧版柜格表，已废弃（统一为 t_box）
DROP TABLE IF EXISTS `t_user`;
DROP TABLE IF EXISTS `t_locker`;
DROP TABLE IF EXISTS `ai_chat_log`;

-- ============================================
-- 1. 用户表（t_user）
-- ============================================
CREATE TABLE `t_user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码（MD5加密）',
    `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `address` VARCHAR(255) DEFAULT NULL COMMENT '地址',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像路径',
    `role` TINYINT NOT NULL DEFAULT 2 COMMENT '角色：1-管理员 2-普通用户',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-禁用',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_phone` (`phone`),
    KEY `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================
-- 2. 快递柜表（t_locker）
-- ============================================
CREATE TABLE `t_locker` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '快递柜ID',
    `locker_name` VARCHAR(100) NOT NULL COMMENT '快递柜名称',
    `location` VARCHAR(100) NOT NULL COMMENT '位置（简短）',
    `address` VARCHAR(255) DEFAULT NULL COMMENT '详细地址',
    `description` TEXT COMMENT '描述',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-禁用',
    `repair_status` TINYINT NOT NULL DEFAULT 0 COMMENT '故障状态：0-无故障 1-待维修 2-维修中 3-已维修',
    `repair_time` DATETIME DEFAULT NULL COMMENT '维修时间',
    `repair_desc` TEXT COMMENT '故障描述',
    `operator_id` BIGINT DEFAULT NULL COMMENT '维修人员ID',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`),
    KEY `idx_repair_status` (`repair_status`),
    KEY `idx_location` (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='快递柜表';

-- ============================================
-- 3. 柜格表（t_box）
-- ============================================
CREATE TABLE `t_box` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '柜格ID',
    `locker_id` BIGINT NOT NULL COMMENT '所属快递柜ID',
    `box_number` VARCHAR(10) NOT NULL COMMENT '柜格编号（如 A1、B2、C3）',
    `box_size` VARCHAR(10) NOT NULL COMMENT '柜格大小：SMALL-小 MEDIUM-中 LARGE-大',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-空闲 2-占用 0-禁用',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_locker_box_number` (`locker_id`, `box_number`),
    KEY `idx_locker_id` (`locker_id`),
    KEY `idx_status` (`status`),
    CONSTRAINT `fk_box_locker` FOREIGN KEY (`locker_id`) REFERENCES `t_locker` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='柜格表';

-- ============================================
-- 4. 快递表（t_package）
-- ============================================
CREATE TABLE `t_package` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '快递ID',
    `package_no` VARCHAR(50) NOT NULL COMMENT '快递单号',
    `sender_name` VARCHAR(50) NOT NULL COMMENT '寄件人姓名',
    `sender_phone` VARCHAR(20) DEFAULT NULL COMMENT '寄件人电话',
    `receiver_id` BIGINT DEFAULT NULL COMMENT '收件人ID',
    `receiver_name` VARCHAR(50) DEFAULT NULL COMMENT '收件人姓名',
    `receiver_phone` VARCHAR(20) DEFAULT NULL COMMENT '收件人电话',
    `locker_id` BIGINT DEFAULT NULL COMMENT '快递柜ID',
    `box_id` BIGINT DEFAULT NULL COMMENT '柜格ID',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-待取件 2-已取件 0-已取消',
    `put_in_time` DATETIME DEFAULT NULL COMMENT '存入时间',
    `take_out_time` DATETIME DEFAULT NULL COMMENT '取出时间',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_package_no` (`package_no`),
    KEY `idx_receiver_id` (`receiver_id`),
    KEY `idx_receiver_phone` (`receiver_phone`),
    KEY `idx_locker_id` (`locker_id`),
    KEY `idx_box_id` (`box_id`),
    KEY `idx_status` (`status`),
    CONSTRAINT `fk_package_locker` FOREIGN KEY (`locker_id`) REFERENCES `t_locker` (`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_package_box` FOREIGN KEY (`box_id`) REFERENCES `t_box` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='快递表';

-- ============================================
-- 5. AI 客服对话日志表（ai_chat_log）
-- 用于记录每轮客服对话，支撑 Bad Case 复盘与产品迭代
-- ============================================
CREATE TABLE `ai_chat_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '查询手机号（脱敏后存储）',
    `question` VARCHAR(500) DEFAULT NULL COMMENT '用户问题',
    `answer` TEXT COMMENT 'AI回答内容',
    `answer_source` VARCHAR(20) NOT NULL DEFAULT 'model' COMMENT '回答来源：model-模型生成 template-模板降级 rule-规则',
    `is_transferred` TINYINT NOT NULL DEFAULT 0 COMMENT '是否转人工：0-否 1-是',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_phone` (`phone`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI客服对话日志表';

-- ============================================
-- 6. 种子数据
-- ============================================

-- 用户（密码均为 123456 的 MD5）
INSERT INTO `t_user` (`username`, `password`, `real_name`, `phone`, `email`, `address`, `avatar`, `role`, `status`) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', '13800138000', 'admin@smartlocker.com', '北京市朝阳区', NULL, 1, 1),
('test',  'e10adc3949ba59abbe56e057f20f883e', '测试用户',   '13900139000', 'test@smartlocker.com',  '北京市海淀区', NULL, 2, 1);

-- 快递柜
INSERT INTO `t_locker` (`locker_name`, `location`, `address`, `description`, `status`, `repair_status`) VALUES
('1号楼大厅快递柜', '1号楼大厅', '1号楼大厅东侧', '位于1号楼大厅，交通便利', 1, 0),
('2号楼西侧快递柜', '2号楼西侧', '2号楼西侧电梯口', '位于2号楼西侧，靠近电梯', 1, 0),
('3号楼南门快递柜', '3号楼南门', '3号楼南门外', '位于3号楼南门，方便投递', 1, 0);

-- 柜格（1号楼大厅快递柜：小4 / 中4 / 大2，编号 A/B/C 系列）
INSERT INTO `t_box` (`locker_id`, `box_number`, `box_size`, `status`) VALUES
(1, 'A1', 'SMALL',  1), (1, 'A2', 'SMALL',  1), (1, 'A3', 'SMALL',  1), (1, 'A4', 'SMALL',  1),
(1, 'B1', 'MEDIUM', 1), (1, 'B2', 'MEDIUM', 1), (1, 'B3', 'MEDIUM', 1), (1, 'B4', 'MEDIUM', 1),
(1, 'C1', 'LARGE',  1), (1, 'C2', 'LARGE',  1);

-- 快递（待取件，收件人手机号供 AI 客服查询演示）
INSERT INTO `t_package` (`package_no`, `sender_name`, `sender_phone`, `receiver_id`, `receiver_name`, `receiver_phone`, `locker_id`, `box_id`, `status`, `put_in_time`) VALUES
('SF1234567890', '张三', '13800138001', 2, '李四', '13800000001', 1, 5, 1, NOW()),
('YT9876543210', '王五', '13800138002', 2, '赵六', '13900000002', 1, 6, 1, NOW());

-- 将已被待取件快递占用的柜格（B1、B2）状态置为「占用」
UPDATE `t_box` b
JOIN `t_package` p ON p.box_id = b.id
SET b.status = 2
WHERE p.status = 1;

-- ============================================
-- 完成
-- ============================================
SET FOREIGN_KEY_CHECKS = 1;

-- 验证数据
SELECT '数据库初始化完成！' AS message;
SELECT COUNT(*) AS user_count FROM t_user;
SELECT COUNT(*) AS locker_count FROM t_locker;
SELECT COUNT(*) AS box_count FROM t_box;
SELECT COUNT(*) AS package_count FROM t_package;
USE smart_locker;
SELECT id, username, password, role, status FROM t_user;