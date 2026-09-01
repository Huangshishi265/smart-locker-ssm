-- ============================================
-- 智能快递柜管理系统 - 数据库优化脚本
-- 版本：1.0
-- 日期：2025
-- 描述：创建和优化快递柜相关表结构
-- ============================================

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- 1. 创建快递柜表（t_locker）
-- ============================================
CREATE TABLE IF NOT EXISTS `t_locker` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '快递柜ID',
    `locker_name` VARCHAR(100) NOT NULL COMMENT '快递柜名称',
    `location` VARCHAR(100) NOT NULL COMMENT '位置（简短）',
    `address` VARCHAR(255) DEFAULT NULL COMMENT '详细地址',
    `description` TEXT COMMENT '描述',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
    `locker_status` TINYINT NOT NULL DEFAULT 1 COMMENT '柜子状态：1-正常 2-故障 3-维护中 4-已停用',
    `total_boxes` INT NOT NULL DEFAULT 0 COMMENT '总柜格数',
    `available_boxes` INT NOT NULL DEFAULT 0 COMMENT '可用柜格数',
    `repair_status` TINYINT NOT NULL DEFAULT 0 COMMENT '故障状态：0-无故障 1-待维修 2-维修中 3-已维修',
    `repair_time` DATETIME DEFAULT NULL COMMENT '维修时间',
    `repair_desc` TEXT COMMENT '故障描述',
    `operator_id` BIGINT DEFAULT NULL COMMENT '维修人员ID',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`),
    KEY `idx_locker_status` (`locker_status`),
    KEY `idx_repair_status` (`repair_status`),
    KEY `idx_location` (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='快递柜表';

-- ============================================
-- 2. 创建快递柜柜格表（t_locker_box）
-- ============================================
CREATE TABLE IF NOT EXISTS `t_locker_box` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '柜格ID',
    `locker_id` BIGINT NOT NULL COMMENT '所属快递柜ID',
    `box_code` VARCHAR(10) NOT NULL COMMENT '柜格编号（如A1、A2）',
    `box_size` TINYINT NOT NULL COMMENT '柜格大小：1-小 2-中 3-大',
    `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态：0-空闲 1-占用 2-故障',
    `delivery_id` BIGINT DEFAULT NULL COMMENT '关联快递ID（占用时）',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_locker_box_code` (`locker_id`, `box_code`),
    KEY `idx_locker_id` (`locker_id`),
    KEY `idx_status` (`status`),
    KEY `idx_box_size` (`box_size`),
    KEY `idx_delivery_id` (`delivery_id`),
    CONSTRAINT `fk_locker_box_locker` FOREIGN KEY (`locker_id`) REFERENCES `t_locker` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='快递柜柜格表';

-- ============================================
-- 3. 创建快递表（t_package）
-- ============================================
CREATE TABLE IF NOT EXISTS `t_package` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '快递ID',
    `package_no` VARCHAR(50) NOT NULL COMMENT '快递单号',
    `sender_id` BIGINT NOT NULL COMMENT '寄件人ID',
    `receiver_id` BIGINT DEFAULT NULL COMMENT '收件人ID',
    `sender_name` VARCHAR(50) NOT NULL COMMENT '寄件人姓名',
    `sender_phone` VARCHAR(20) NOT NULL COMMENT '寄件人电话',
    `sender_address` VARCHAR(255) NOT NULL COMMENT '寄件人地址',
    `receiver_name` VARCHAR(50) NOT NULL COMMENT '收件人姓名',
    `receiver_phone` VARCHAR(20) NOT NULL COMMENT '收件人电话',
    `receiver_address` VARCHAR(255) NOT NULL COMMENT '收件人地址',
    `package_type` VARCHAR(50) DEFAULT NULL COMMENT '快递类型',
    `package_size` TINYINT DEFAULT NULL COMMENT '快递大小：1-小 2-中 3-大',
    `locker_id` BIGINT DEFAULT NULL COMMENT '快递柜ID',
    `box_id` BIGINT DEFAULT NULL COMMENT '柜格ID',
    `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态：0-待寄件 1-运输中 2-已入库 3-待取件 4-已取件 5-异常',
    `pickup_code` VARCHAR(10) DEFAULT NULL COMMENT '取件码',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_package_no` (`package_no`),
    KEY `idx_sender_id` (`sender_id`),
    KEY `idx_receiver_id` (`receiver_id`),
    KEY `idx_locker_id` (`locker_id`),
    KEY `idx_box_id` (`box_id`),
    KEY `idx_status` (`status`),
    KEY `idx_pickup_code` (`pickup_code`),
    CONSTRAINT `fk_package_locker` FOREIGN KEY (`locker_id`) REFERENCES `t_locker` (`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_package_box` FOREIGN KEY (`box_id`) REFERENCES `t_locker_box` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='快递表';

-- ============================================
-- 4. 创建用户表（t_user）
-- ============================================
CREATE TABLE IF NOT EXISTS `t_user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码（加密）',
    `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `role` TINYINT NOT NULL DEFAULT 2 COMMENT '角色：1-管理员 2-用户',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-禁用',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_phone` (`phone`),
    KEY `idx_email` (`email`),
    KEY `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================
-- 5. 创建柜格表（t_box）
-- ============================================
CREATE TABLE IF NOT EXISTS `t_box` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '柜格ID',
    `box_name` VARCHAR(50) NOT NULL COMMENT '柜格名称',
    `location` VARCHAR(100) DEFAULT NULL COMMENT '位置',
    `description` TEXT COMMENT '描述',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-禁用',
    `box_size` TINYINT DEFAULT NULL COMMENT '柜格大小：1-小 2-中 3-大',
    `total_capacity` INT NOT NULL DEFAULT 0 COMMENT '总容量',
    `used_capacity` INT NOT NULL DEFAULT 0 COMMENT '已用容量',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`),
    KEY `idx_location` (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='柜格表';

-- ============================================
-- 6. 插入测试数据
-- ============================================

-- 插入管理员用户
INSERT INTO `t_user` (`username`, `password`, `real_name`, `phone`, `email`, `role`, `status`)
VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', '13800138000', 'admin@smartlocker.com', 1, 1),
('test', 'e10adc3949ba59abbe56e057f20f883e', '测试用户', '13900139000', 'test@smartlocker.com', 2, 1)
ON DUPLICATE KEY UPDATE `update_time`=NOW();

-- 插入快递柜数据
INSERT INTO `t_locker` (`locker_name`, `location`, `address`, `description`, `status`, `locker_status`, `total_boxes`, `available_boxes`, `repair_status`)
VALUES
('1号楼大厅快递柜', '1号楼大厅', '北京市朝阳区XX路XX号1号楼大厅', '位于1号楼大厅，交通便利', 1, 1, 18, 18, 0),
('2号楼西侧快递柜', '2号楼西侧', '北京市朝阳区XX路XX号2号楼西侧', '位于2号楼西侧，靠近电梯', 1, 1, 12, 12, 0),
('3号楼南门快递柜', '3号楼南门', '北京市朝阳区XX路XX号3号楼南门', '位于3号楼南门，方便快递员投递', 1, 1, 15, 15, 0)
ON DUPLICATE KEY UPDATE `update_time`=NOW();

-- 插入柜格数据（1号楼大厅快递柜）
INSERT INTO `t_locker_box` (`locker_id`, `box_code`, `box_size`, `status`)
VALUES
(1, 'A1', 1, 0), (1, 'A2', 1, 0), (1, 'A3', 1, 0), (1, 'A4', 1, 0), (1, 'A5', 1, 0),
(1, 'A6', 1, 0), (1, 'A7', 1, 0), (1, 'A8', 1, 0), (1, 'A9', 1, 0), (1, 'A10', 1, 0),
(1, 'B1', 2, 0), (1, 'B2', 2, 0), (1, 'B3', 2, 0), (1, 'B4', 2, 0), (1, 'B5', 2, 0),
(1, 'C1', 3, 0), (1, 'C2', 3, 0), (1, 'C3', 3, 0)
ON DUPLICATE KEY UPDATE `update_time`=NOW();

-- 插入柜格数据（2号楼西侧快递柜）
INSERT INTO `t_locker_box` (`locker_id`, `box_code`, `box_size`, `status`)
VALUES
(2, 'A1', 1, 0), (2, 'A2', 1, 0), (2, 'A3', 1, 0), (2, 'A4', 1, 0), (2, 'A5', 1, 0),
(2, 'A6', 1, 0), (2, 'A7', 1, 0), (2, 'B1', 2, 0), (2, 'B2', 2, 0), (2, 'B3', 2, 0),
(2, 'B4', 2, 0), (2, 'B5', 2, 0)
ON DUPLICATE KEY UPDATE `update_time`=NOW();

-- 插入柜格数据（3号楼南门快递柜）
INSERT INTO `t_locker_box` (`locker_id`, `box_code`, `box_size`, `status`)
VALUES
(3, 'A1', 1, 0), (3, 'A2', 1, 0), (3, 'A3', 1, 0), (3, 'A4', 1, 0), (3, 'A5', 1, 0),
(3, 'A6', 1, 0), (3, 'A7', 1, 0), (3, 'A8', 1, 0), (3, 'A9', 1, 0), (3, 'B1', 2, 0),
(3, 'B2', 2, 0), (3, 'B3', 2, 0), (3, 'B4', 2, 0), (3, 'C1', 3, 0), (3, 'C2', 3, 0)
ON DUPLICATE KEY UPDATE `update_time`=NOW();

-- 插入测试快递数据
INSERT INTO `t_package` (`package_no`, `sender_id`, `receiver_id`, `sender_name`, `sender_phone`, `sender_address`,
                          `receiver_name`, `receiver_phone`, `receiver_address`, `package_type`, `package_size`,
                          `locker_id`, `box_id`, `status`, `pickup_code`)
VALUES
('SF123456789', 1, 2, '张三', '13800138001', '北京市朝阳区A路A号', '李四', '13900139001', '北京市朝阳区B路B号', '文件', 1, 1, 1, 3, '123456'),
('YT987654321', 2, 1, '王五', '13800138002', '北京市朝阳区C路C号', '赵六', '13900139002', '北京市朝阳区D路D号', '包裹', 2, 1, 6, 3, '654321')
ON DUPLICATE KEY UPDATE `update_time`=NOW();

-- ============================================
-- 7. 创建视图（用于数据统计）
-- ============================================

-- 快递柜统计视图
CREATE OR REPLACE VIEW `v_locker_stats` AS
SELECT
    l.id,
    l.locker_name,
    l.location,
    l.total_boxes,
    l.available_boxes,
    (l.total_boxes - l.available_boxes) as used_boxes,
    COUNT(DISTINCT CASE WHEN lb.status = 2 THEN lb.id END) as broken_boxes,
    COUNT(DISTINCT CASE WHEN p.id IS NOT NULL THEN p.id END) as package_count
FROM t_locker l
LEFT JOIN t_locker_box lb ON l.id = lb.locker_id
LEFT JOIN t_package p ON lb.id = p.box_id
GROUP BY l.id, l.locker_name, l.location, l.total_boxes, l.available_boxes;

-- ============================================
-- 8. 创建存储过程（用于柜格自动分配）
-- ============================================

DELIMITER $$

-- 自动分配柜格存储过程
CREATE OR REPLACE PROCEDURE `sp_allocate_box`(
    IN p_locker_id BIGINT,
    IN p_box_size TINYINT,
    IN p_delivery_id BIGINT,
    OUT p_box_id BIGINT,
    OUT p_result INT
)
BEGIN
    DECLARE v_available_count INT;
    DECLARE v_box_id BIGINT;

    -- 结果码：0-成功 1-无可用柜格 2-快递柜不存在
    SET p_result = 0;
    SET p_box_id = NULL;

    -- 检查快递柜是否存在
    SELECT COUNT(*) INTO v_available_count
    FROM t_locker
    WHERE id = p_locker_id;

    IF v_available_count = 0 THEN
        SET p_result = 2;
    ELSE
        -- 尝试分配相同大小的柜格
        SELECT id INTO v_box_id
        FROM t_locker_box
        WHERE locker_id = p_locker_id AND status = 0 AND box_size = p_box_size
        LIMIT 1;

        -- 如果没有相同大小的，尝试更大的柜格
        IF v_box_id IS NULL AND p_box_size < 3 THEN
            SELECT id INTO v_box_id
            FROM t_locker_box
            WHERE locker_id = p_locker_id AND status = 0 AND box_size > p_box_size
            ORDER BY box_size ASC
            LIMIT 1;
        END IF;

        IF v_box_id IS NULL THEN
            SET p_result = 1;
        ELSE
            -- 更新柜格状态
            UPDATE t_locker_box
            SET status = 1, delivery_id = p_delivery_id, update_time = NOW()
            WHERE id = v_box_id;

            -- 更新快递柜可用柜格数
            UPDATE t_locker
            SET available_boxes = available_boxes - 1, update_time = NOW()
            WHERE id = p_locker_id;

            SET p_box_id = v_box_id;
        END IF;
    END IF;
END$$

-- 释放柜格存储过程
CREATE OR REPLACE PROCEDURE `sp_release_box`(
    IN p_box_id BIGINT,
    IN p_locker_id BIGINT,
    OUT p_result INT
)
BEGIN
    DECLARE v_status INT;

    -- 结果码：0-成功 1-柜格不存在 2-柜格未被占用
    SET p_result = 0;

    -- 检查柜格是否存在及状态
    SELECT status INTO v_status
    FROM t_locker_box
    WHERE id = p_box_id;

    IF v_status IS NULL THEN
        SET p_result = 1;
    ELSEIF v_status != 1 THEN
        SET p_result = 2;
    ELSE
        -- 更新柜格状态
        UPDATE t_locker_box
        SET status = 0, delivery_id = NULL, update_time = NOW()
        WHERE id = p_box_id;

        -- 更新快递柜可用柜格数
        UPDATE t_locker
        SET available_boxes = available_boxes + 1, update_time = NOW()
        WHERE id = p_locker_id;
    END IF;
END$$

DELIMITER ;

-- ============================================
-- 9. 创建触发器（用于自动更新统计）
-- ============================================

DELIMITER $$

-- 柜格状态变更时自动更新快递柜可用柜格数
CREATE OR REPLACE TRIGGER `tr_box_status_update`
AFTER UPDATE ON `t_locker_box`
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        IF NEW.status = 0 THEN
            -- 变为空闲
            UPDATE t_locker
            SET available_boxes = available_boxes + 1, update_time = NOW()
            WHERE id = NEW.locker_id;
        ELSEIF NEW.status = 1 THEN
            -- 变为占用
            UPDATE t_locker
            SET available_boxes = available_boxes - 1, update_time = NOW()
            WHERE id = NEW.locker_id;
        END IF;
    END IF;
END$$

DELIMITER ;

-- ============================================
-- 10. 优化表结构（索引优化）
-- ============================================

-- 为快递表添加复合索引
ALTER TABLE `t_package` ADD INDEX `idx_locker_box_status` (`locker_id`, `box_id`, `status`);

-- 为柜格表添加复合索引
ALTER TABLE `t_locker_box` ADD INDEX `idx_locker_size_status` (`locker_id`, `box_size`, `status`);

-- ============================================
-- 11. 数据清理（可选）
-- ============================================

-- 清理超过30天的已取件快递（示例）
-- DELETE FROM t_package WHERE status = 4 AND update_time < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- ============================================
-- 完成
-- ============================================
SET FOREIGN_KEY_CHECKS = 1;

-- 验证数据
SELECT '数据库优化完成！' AS message;
SELECT COUNT(*) AS locker_count FROM t_locker;
SELECT COUNT(*) AS box_count FROM t_locker_box;
SELECT COUNT(*) AS package_count FROM t_package;
SELECT COUNT(*) AS user_count FROM t_user;
