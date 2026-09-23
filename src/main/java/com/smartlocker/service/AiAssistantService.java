package com.smartlocker.service;

/**
 * AI 客服 Service 接口
 */
public interface AiAssistantService {

    /**
     * 智能客服对话
     *
     * @param phone    收件人手机号（用于确定性检索快递）
     * @param question 用户问题
     * @return 回答文本（模型失败时降级为模板话术）
     */
    String chat(String phone, String question);

    /**
     * 生成取件通知文案
     *
     * @param packageId 快递ID
     * @return 通知文案
     */
    String generateNotice(Long packageId);
}
