package com.smartlocker.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * AI 客服对话日志实体类
 * 对应数据库表：ai_chat_log
 * 用于记录每轮对话，支撑 Bad Case 复盘与产品迭代
 */
public class AiChatLog implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;             // 日志ID
    private String phone;        // 查询手机号（脱敏后存储）
    private String question;     // 用户问题
    private String answer;       // AI回答内容
    private String answerSource; // 回答来源：model-模型生成 template-模板降级 rule-规则
    private Integer isTransferred; // 是否转人工：0-否 1-是
    private Date createTime;     // 创建时间

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }

    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }

    public String getAnswerSource() { return answerSource; }
    public void setAnswerSource(String answerSource) { this.answerSource = answerSource; }

    public Integer getIsTransferred() { return isTransferred; }
    public void setIsTransferred(Integer isTransferred) { this.isTransferred = isTransferred; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}
