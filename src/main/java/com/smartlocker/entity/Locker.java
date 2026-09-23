package com.smartlocker.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 快递柜实体类
 * 对应数据库表：t_locker
 */
public class Locker implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;              // 快递柜ID
    private String lockerName;    // 快递柜名称
    private String location;      // 位置
    private String address;       // 详细地址
    private String description;   // 描述
    private Integer status;       // 状态：1-正常，0-禁用
    private Integer repairStatus; // 故障状态：0-无故障 1-待维修 2-维修中 3-已维修
    private Date repairTime;      // 维修时间
    private String repairDesc;    // 故障描述
    private Long operatorId;      // 维修人员ID
    private Date createTime;      // 创建时间
    private Date updateTime;      // 更新时间

    // Getter和Setter方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLockerName() {
        return lockerName;
    }

    public void setLockerName(String lockerName) {
        this.lockerName = lockerName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getRepairStatus() {
        return repairStatus;
    }

    public void setRepairStatus(Integer repairStatus) {
        this.repairStatus = repairStatus;
    }

    public Date getRepairTime() {
        return repairTime;
    }

    public void setRepairTime(Date repairTime) {
        this.repairTime = repairTime;
    }

    public String getRepairDesc() {
        return repairDesc;
    }

    public void setRepairDesc(String repairDesc) {
        this.repairDesc = repairDesc;
    }

    public Long getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(Long operatorId) {
        this.operatorId = operatorId;
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