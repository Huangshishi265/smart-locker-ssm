package com.smartlocker.service;

import com.smartlocker.entity.LockerBox;

import java.util.List;

/**
 * 快递柜柜格Service接口
 */
public interface LockerBoxService {

    /**
     * 根据快递柜ID查询所有柜格
     */
    List<LockerBox> getBoxesByLockerId(Long lockerId);

    /**
     * 根据ID查询柜格
     */
    LockerBox getBoxById(Long id);

    /**
     * 查询可用的柜格（空闲状态）
     */
    List<LockerBox> getAvailableBoxes(Long lockerId, Integer boxSize);

    /**
     * 分配柜格（智能分配策略）
     * @param lockerId 快递柜ID
     * @param boxSize 所需柜格大小
     * @return 分配的柜格，如果没有可用柜格则返回null
     */
    LockerBox allocateBox(Long lockerId, Integer boxSize);

    /**
     * 释放柜格
     */
    void releaseBox(Long boxId);

    /**
     * 创建柜格
     */
    void createBox(LockerBox lockerBox);

    /**
     * 批量创建柜格（用于初始化快递柜）
     */
    void batchCreateBoxes(Long lockerId, Integer smallCount, Integer mediumCount, Integer largeCount);

    /**
     * 删除柜格
     */
    void deleteBox(Long id);

    /**
     * 根据快递柜ID删除所有柜格
     */
    void deleteBoxesByLockerId(Long lockerId);
}
