package com.smartlocker.dao;

import com.smartlocker.entity.AiChatLog;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * AI 客服对话日志 DAO 接口
 */
public interface AiChatLogDao {

    /**
     * 插入一条对话日志
     */
    int insert(AiChatLog log);

    /**
     * 查询最近 N 条对话日志（用于复盘 Bad Case）
     */
    List<AiChatLog> selectRecent(@Param("limit") int limit);
}
