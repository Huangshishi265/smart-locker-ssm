package com.smartlocker.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * 储物格详细信息DTO
 * 用于多表关联查询，关联快递柜、快递信息
 */
public class BoxDetail implements Serializable {

    private static final long serialVersionUID = 1L;

    // 储物格基本信息
    private Long id;
    private Long lockerId;
    private String boxNumber;
    private String boxSize;
    private Integer status;
    private String statusDesc;  // 状态描述：空闲/占用/禁用

    // 快递柜信息
    private String lockerName;
    private String lockerLocation;

    // 关联的快递信息
    private Long packageId;
    private String packageNo;
    private String receiverName;

    // 时间信息
    private Date createTime;
    private Date updateTime;

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

    public String getStatusDesc() {
        return statusDesc;
    }

    public void setStatusDesc(String statusDesc) {
        this.statusDesc = statusDesc;
    }

    public String getLockerName() {
        return lockerName;
    }

    public void setLockerName(String lockerName) {
        this.lockerName = lockerName;
    }

    public String getLockerLocation() {
        return lockerLocation;
    }

    public void setLockerLocation(String lockerLocation) {
        this.lockerLocation = lockerLocation;
    }

    public Long getPackageId() {
        return packageId;
    }

    public void setPackageId(Long packageId) {
        this.packageId = packageId;
    }

    public String getPackageNo() {
        return packageNo;
    }

    public void setPackageNo(String packageNo) {
        this.packageNo = packageNo;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
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
