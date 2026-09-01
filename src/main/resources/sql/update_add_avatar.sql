-- 为用户表添加头像字段
ALTER TABLE t_user ADD COLUMN avatar VARCHAR(255) DEFAULT NULL COMMENT '头像路径' AFTER address;

-- 更新现有记录，设置默认头像
UPDATE t_user SET avatar = '/static/images/default-avatar.png' WHERE avatar IS NULL;