-- 修复 t_package 表的 receiver_id 字段约束
-- 问题：receiver_id 字段设置为 NOT NULL，导致无法保存没有收件人的快递
-- 解决方案：将 receiver_id 字段修改为允许 NULL

USE smart_locker;

-- 修改 receiver_id 字段，允许为 NULL
ALTER TABLE t_package MODIFY COLUMN receiver_id BIGINT NULL;

-- 验证修改
DESC t_package;
