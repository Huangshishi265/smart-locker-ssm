package com.smartlocker.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 快递实体类
 * 对应数据库表：t_package
 */
public class Package implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;              // 快递ID
    private String packageNo;     // 快递单号
    private String senderName;    // 寄件人姓名
    private String senderPhone;   // 寄件人电话
    private Long receiverId;      // 收件人ID
    private String receiverName;  // 收件人姓名
    private String receiverPhone; // 收件人电话
    private Long lockerId;       // 快递柜ID
    private Long boxId;          // 储物格ID
    private Integer status;      // 状态：1-待取件，2-已取件，0-已取消
    private Date putInTime;      // 存入时间
    private Date takeOutTime;    // 取出时间
    private Date createTime;     // 创建时间
    private Date updateTime;     // 更新时间

    // Getter和Setter方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPackageNo() {
        return packageNo;
    }

    public void setPackageNo(String packageNo) {
        this.packageNo = packageNo;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getSenderPhone() {
        return senderPhone;
    }

    public void setSenderPhone(String senderPhone) {
        this.senderPhone = senderPhone;
    }

    public Long getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(Long receiverId) {
        this.receiverId = receiverId;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public Long getLockerId() {
        return lockerId;
    }

    public void setLockerId(Long lockerId) {
        this.lockerId = lockerId;
    }

    public Long getBoxId() {
        return boxId;
    }

    public void setBoxId(Long boxId) {
        this.boxId = boxId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getPutInTime() {
        return putInTime;
    }

    public void setPutInTime(Date putInTime) {
        this.putInTime = putInTime;
    }

    public Date getTakeOutTime() {
        return takeOutTime;
    }

    public void setTakeOutTime(Date takeOutTime) {
        this.takeOutTime = takeOutTime;
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
