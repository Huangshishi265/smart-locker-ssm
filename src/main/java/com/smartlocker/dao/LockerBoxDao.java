package com.smartlocker.dao;

import com.smartlocker.entity.LockerBox;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 快递柜柜格DAO接口
 */
public interface LockerBoxDao {

    /**
     * 根据快递柜ID查询所有柜格
     */
    List<LockerBox> selectByLockerId(@Param("lockerId") Long lockerId);

    /**
     * 根据ID查询柜格
     */
    LockerBox selectById(@Param("id") Long id);

    /**
     * 查询可用的柜格（空闲状态）
     */
    List<LockerBox> selectAvailableBoxes(@Param("lockerId") Long lockerId,
                                         @Param("boxSize") Integer boxSize);

    /**
     * 插入柜格
     */
    int insert(LockerBox lockerBox);

    /**
     * 批量插入柜格
     */
    int batchInsert(@Param("boxes") List<LockerBox> boxes);

    /**
     * 更新柜格状态
     */
    int updateStatus(@Param("id") Long id, @Param("status") Integer status,
                     @Param("deliveryId") Long deliveryId);

    /**
     * 删除柜格
     */
    int deleteById(@Param("id") Long id);

    /**
     * 根据快递柜ID删除所有柜格
     */
    int deleteByLockerId(@Param("lockerId") Long lockerId);

    /**
     * 统计快递柜的柜格数量
     */
    int countByLockerId(@Param("lockerId") Long lockerId);

    /**
     * 统计快递柜的可用柜格数量
     */
    int countAvailableByLockerId(@Param("lockerId") Long lockerId);
}
