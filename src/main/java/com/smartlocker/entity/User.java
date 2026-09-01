package com.smartlocker.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 用户实体类
 * 对应数据库表：t_user
 */
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;              // 用户ID
    private String username;      // 用户名
    private String password;      // 密码
    private String realName;      // 真实姓名
    private String phone;         // 手机号
    private String email;         // 邮箱
    private String address;       // 地址
    private String avatar;        // 头像路径
    private Integer status;       // 状态：1-正常，0-禁用
    private Date createTime;     // 创建时间
    private Date updateTime;      // 更新时间

    // Getter和Setter方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}