package com.smartlocker.controller;

import com.smartlocker.service.AiAssistantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * AI 客服控制器
 *
 * - GET  /assistant            客服对话页（公开，取件用户无需登录）
 * - POST /assistant/chat       智能客服对话（公开）
 * - POST /assistant/notice/{id} 生成取件通知（后台，需登录）
 */
@Controller
@RequestMapping("/assistant")
public class AiAssistantController {

    @Autowired
    private AiAssistantService aiAssistantService;

    /**
     * 客服对话页
     */
    @GetMapping
    public String page() {
        return "assistant";
    }

    /**
     * 智能客服对话
     */
    @PostMapping("/chat")
    @ResponseBody
    public Map<String, Object> chat(@RequestParam(required = false) String phone,
                                    @RequestParam(required = false) String question) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (phone == null || phone.trim().isEmpty()) {
                result.put("success", false);
                result.put("answer", "请先输入您的手机号，以便我为您查询快递。");
                return result;
            }
            String answer = aiAssistantService.chat(phone.trim(), question);
            result.put("success", true);
            result.put("answer", answer);
        } catch (Exception e) {
            result.put("success", false);
            result.put("answer", "系统暂时无法处理您的请求，请稍后再试。");
        }
        return result;
    }

    /**
     * 生成取件通知文案
     */
    @PostMapping("/notice/{id}")
    @ResponseBody
    public Map<String, Object> notice(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        try {
            String notice = aiAssistantService.generateNotice(id);
            result.put("success", true);
            result.put("notice", notice);
        } catch (Exception e) {
            result.put("success", false);
            result.put("notice", "生成通知失败：" + e.getMessage());
        }
        return result;
    }
}
