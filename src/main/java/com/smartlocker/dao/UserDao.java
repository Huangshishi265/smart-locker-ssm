package com.smartlocker.dao;

import com.smartlocker.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户DAO接口
 */
public interface UserDao {

    /**
     * 查询所有用户
     */
    List<User> selectAll();

    /**
     * 根据ID查询用户
     */
    User selectById(@Param("id") Long id);

    /**
     * 根据用户名查询用户
     */
    User selectByUsername(@Param("username") String username);

    /**
     * 插入用户
     */
    int insert(User user);

    /**
     * 更新用户
     */
    int update(User user);

    /**
     * 删除用户
     */
    int deleteById(@Param("id") Long id);
}
