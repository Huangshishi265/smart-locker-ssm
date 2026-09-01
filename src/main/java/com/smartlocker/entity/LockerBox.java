package com.smartlocker.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 快递柜柜格实体类
 * 对应数据库表：t_locker_box
 */
public class LockerBox implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;              // 柜格ID
    private Long lockerId;        // 所属快递柜ID
    private String boxCode;       // 柜格编号（如A1、A2）
    private Integer boxSize;      // 柜格大小：1-小 2-中 3-大
    private Integer status;       // 状态：0-空闲 1-占用 2-故障
    private Long deliveryId;      // 关联快递ID（占用时）
    private Date createTime;      // 创建时间
    private Date updateTime;      // 更新时间

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

    public String getBoxCode() {
        return boxCode;
    }

    public void setBoxCode(String boxCode) {
        this.boxCode = boxCode;
    }

    public Integer getBoxSize() {
        return boxSize;
    }

    public void setBoxSize(Integer boxSize) {
        this.boxSize = boxSize;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Long getDeliveryId() {
        return deliveryId;
    }

    public void setDeliveryId(Long deliveryId) {
        this.deliveryId = deliveryId;
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
