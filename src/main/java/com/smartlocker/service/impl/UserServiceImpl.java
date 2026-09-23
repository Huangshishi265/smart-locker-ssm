package com.smartlocker.service.impl;

import com.smartlocker.dao.UserDao;
import com.smartlocker.entity.User;
import com.smartlocker.exception.BusinessException;
import com.smartlocker.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 用户Service实现类
 * 体现IOC（依赖注入）和事务管理（AOP）
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired  // IOC：通过依赖注入获取UserDao实例
    private UserDao userDao;

    @Override
    public List<User> getAllUsers() {
        return userDao.selectAll();
    }

    @Override
    public User getUserById(Long id) {
        if (id == null) {
            throw new BusinessException("用户ID不能为空");
        }
        User user = userDao.selectById(id);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        return user;
    }

    @Override
    @Transactional  // AOP：事务管理，自动开启、提交、回滚事务
    public void createUser(User user) {
        // 业务逻辑验证
        if (user == null) {
            throw new BusinessException("用户信息不能为空");
        }
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new BusinessException("用户名不能为空");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new BusinessException("密码不能为空");
        }

        // 检查用户名是否已存在
        User existUser = userDao.selectByUsername(user.getUsername());
        if (existUser != null) {
            throw new BusinessException("用户名已存在");
        }

        // 密码 MD5 加密存储（登录校验用 md5(password) 比对，必须一致，否则新用户无法登录）
        user.setPassword(md5(user.getPassword()));

        // 设置默认角色（表单未传时默认普通用户，避免 role 为 NULL 触发非空约束）
        if (user.getRole() == null) {
            user.setRole(2);
        }

        // 设置默认状态
        if (user.getStatus() == null) {
            user.setStatus(1);
        }

        // 调用DAO层
        userDao.insert(user);
    }

    @Override
    @Transactional  // AOP：事务管理
    public void updateUser(User user) {
        // 业务逻辑验证
        if (user == null || user.getId() == null) {
            throw new BusinessException("用户ID不能为空");
        }

        // 检查用户是否存在
        User existUser = userDao.selectById(user.getId());
        if (existUser == null) {
            throw new BusinessException("用户不存在");
        }

        // 如果修改用户名，检查新用户名是否已存在
        if (user.getUsername() != null && !user.getUsername().equals(existUser.getUsername())) {
            User duplicateUser = userDao.selectByUsername(user.getUsername());
            if (duplicateUser != null) {
                throw new BusinessException("用户名已存在");
            }
        }

        // 密码：留空则不修改，否则 MD5 加密后再存
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            user.setPassword(md5(user.getPassword()));
        } else {
            user.setPassword(null); // 空密码 → 不更新密码字段
        }

        // 角色未传时保持原角色
        if (user.getRole() == null) {
            user.setRole(existUser.getRole());
        }

        // 调用DAO层
        userDao.update(user);
    }

    @Override
    @Transactional  // AOP：事务管理
    public void deleteUser(Long id) {
        // 业务逻辑验证
        if (id == null) {
            throw new BusinessException("用户ID不能为空");
        }

        // 检查用户是否存在
        User user = userDao.selectById(id);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 调用DAO层
        userDao.deleteById(id);
    }

    @Override
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            throw new BusinessException("用户名和密码不能为空");
        }

        User user = userDao.selectByUsername(username.trim());
        if (user == null) {
            throw new BusinessException("用户名或密码错误");
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new BusinessException("账号已被禁用");
        }
        if (!md5(password).equals(user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }
        return user;
    }

    /**
     * MD5 加密（与初始化脚本中的密码存储方式保持一致）
     */
    private String md5(String input) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new BusinessException("密码加密失败");
        }
    }
}
