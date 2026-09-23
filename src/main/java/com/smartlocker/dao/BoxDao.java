package com.smartlocker.dao;

import com.smartlocker.dto.BoxDetail;
import com.smartlocker.entity.Box;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 储物格DAO接口
 */
public interface BoxDao {

    /**
     * 查询所有储物格
     */
    List<Box> selectAll();

    /**
     * 根据ID查询储物格
     */
    Box selectById(@Param("id") Long id);

    /**
     * 根据快递柜ID查询储物格
     */
    List<Box> selectByLockerId(@Param("lockerId") Long lockerId);

    /**
     * 查询可用的储物格（指定快递柜和尺寸）
     */
    List<Box> selectAvailableByLockerIdAndSize(@Param("lockerId") Long lockerId, @Param("boxSize") String boxSize);

    /**
     * 查询所有可用的储物格（状态为空闲，返回详细信息）
     */
    List<BoxDetail> selectAvailableBoxes();

    /**
     * 插入储物格
     */
    int insert(Box box);

    /**
     * 更新储物格
     */
    int update(Box box);

    /**
     * 删除储物格
     */
    int deleteById(@Param("id") Long id);

    /**
     * 查询储物格详细信息（多表关联查询：t_box, t_locker, t_package）
     */
    List<BoxDetail> selectBoxDetails();

    /**
     * 根据ID查询储物格详细信息
     */
    BoxDetail selectBoxDetailById(@Param("id") Long id);

    /**
     * 统计快递柜的储物格状态
     */
    java.util.Map<String, Object> selectBoxStats(@Param("lockerId") Long lockerId);
}