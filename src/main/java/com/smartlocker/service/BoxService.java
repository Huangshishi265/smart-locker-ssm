package com.smartlocker.service;

import com.smartlocker.dto.BoxDetail;
import com.smartlocker.entity.Box;

import java.util.List;

/**
 * 储物格Service接口
 */
public interface BoxService {

    /**
     * 查询所有储物格
     */
    List<Box> getAllBoxes();

    /**
     * 查询储物格详细信息（多表关联）
     */
    List<BoxDetail> getBoxDetails();

    /**
     * 查询可用的储物格（状态为空闲）
     */
    List<BoxDetail> getAvailableBoxes();

    /**
     * 根据ID查询储物格
     */
    Box getBoxById(Long id);

    /**
     * 创建储物格
     */
    void createBox(Box box);

    /**
     * 更新储物格
     */
    void updateBox(Box box);

    /**
     * 删除储物格
     */
    void deleteBox(Long id);

    /**
     * 查询快递柜储物格统计信息
     */
    java.util.Map<String, Object> getBoxStats(Long lockerId);
}
