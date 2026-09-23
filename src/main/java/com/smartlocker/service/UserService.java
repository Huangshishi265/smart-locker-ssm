package com.smartlocker.service;

import com.smartlocker.entity.User;

import java.util.List;

/**
 * 用户Service接口
 */
public interface UserService {

    /**
     * 查询所有用户
     */
    List<User> getAllUsers();

    /**
     * 根据ID查询用户
     */
    User getUserById(Long id);

    /**
     * 创建用户
     */
    void createUser(User user);

    /**
     * 更新用户
     */
    void updateUser(User user);

    /**
     * 删除用户
     */
    void deleteUser(Long id);

    /**
     * 用户登录（校验用户名密码）
     */
    User login(String username, String password);
}
