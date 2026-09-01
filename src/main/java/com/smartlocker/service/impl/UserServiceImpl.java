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
}
