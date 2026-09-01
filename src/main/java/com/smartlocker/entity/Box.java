package com.smartlocker.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 储物格实体类
 * 对应数据库表：t_box
 */
public class Box implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;              // 储物格ID
    private Long lockerId;       // 快递柜ID
    private String boxNumber;    // 储物格编号
    private String boxSize;      // 储物格大小：SMALL-小型，MEDIUM-中型，LARGE-大型
    private Integer status;      // 状态：1-空闲，2-占用，0-禁用
    private Date createTime;     // 创建时间
    private Date updateTime;     // 更新时间

    // Getter和Setter方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getLockerId() {
        return lockerId;
    }

    public void setLockerId(Long lockerId) {
        this.lockerId = lockerId;
    }

    public String getBoxNumber() {
        return boxNumber;
    }

    public void setBoxNumber(String boxNumber) {
        this.boxNumber = boxNumber;
    }

    public String getBoxSize() {
        return boxSize;
    }

    public void setBoxSize(String boxSize) {
        this.boxSize = boxSize;
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
