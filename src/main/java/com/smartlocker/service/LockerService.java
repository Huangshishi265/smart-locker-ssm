package com.smartlocker.service;

import com.smartlocker.entity.Box;
import com.smartlocker.entity.Locker;

import java.util.List;
import java.util.Map;

/**
 * 快递柜Service接口
 */
public interface LockerService {

    /**
     * 查询所有快递柜
     */
    List<Locker> getAllLockers();

    /**
     * 根据ID查询快递柜
     */
    Locker getLockerById(Long id);

    /**
     * 创建快递柜（包含初始化柜格）
     */
    void createLocker(Locker locker, Integer smallCount, Integer mediumCount, Integer largeCount);

    /**
     * 创建快递柜（不含柜格初始化）
     */
    void createLocker(Locker locker);

    /**
     * 更新快递柜
     */
    void updateLocker(Locker locker);

    /**
     * 更新快递柜状态
     */
    void updateLockerStatus(Long id, Integer status);

    /**
     * 删除快递柜
     */
    void deleteLocker(Long id);

    /**
     * 统计快递柜数量
     */
    Map<String, Integer> getLockerStats();

    /**
     * 根据条件查询快递柜
     */
    List<Locker> getLockersByCondition(String lockerName, String location,
                                       Integer status, Integer lockerStatus, Integer repairStatus);

    /**
     * 查询故障快递柜列表
     */
    List<Locker> getBrokenLockers();

    /**
     * 查询快递柜的柜格列表
     */
    List<Box> getLockerBoxes(Long lockerId);

    /**
     * 查询快递柜柜格统计信息
     */
    Map<String, Object> getBoxStats(Long lockerId);

    /**
     * 提交故障报修
     */
    void submitRepair(Long id, String repairDesc, Long operatorId);

    /**
     * 完成故障维修
     */
    void completeRepair(Long id, Long operatorId);
}