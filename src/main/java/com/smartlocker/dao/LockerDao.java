package com.smartlocker.dao;

import com.smartlocker.entity.Locker;
import com.smartlocker.entity.LockerBox;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 快递柜DAO接口
 */
public interface LockerDao {

    /**
     * 查询所有快递柜
     */
    List<Locker> selectAll();

    /**
     * 多条件查询快递柜
     */
    List<Locker> selectByCondition(@Param("lockerName") String lockerName,
                                   @Param("location") String location,
                                   @Param("status") Integer status,
                                   @Param("lockerStatus") Integer lockerStatus,
                                   @Param("repairStatus") Integer repairStatus);

    /**
     * 根据ID查询快递柜
     */
    Locker selectById(@Param("id") Long id);

    /**
     * 插入快递柜
     */
    int insert(Locker locker);

    /**
     * 更新快递柜
     */
    int update(Locker locker);

    /**
     * 更新快递柜状态
     */
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    /**
     * 删除快递柜
     */
    int deleteById(@Param("id") Long id);

    /**
     * 统计各状态的快递柜数量
     */
    int countByStatus(@Param("status") Integer status);

    /**
     * 查询快递柜柜格统计信息
     */
    Map<String, Object> selectBoxStats(@Param("lockerId") Long lockerId);  // ✅ 新增
}