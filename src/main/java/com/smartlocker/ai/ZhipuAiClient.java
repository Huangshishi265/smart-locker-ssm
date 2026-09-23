package com.smartlocker.ai;

import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 智谱 BigModel（GLM）HTTP 客户端
 *
 * 产品决策：
 * - 仅封装文本对话（chat/completions），模型选 glm-4-flash（免费、国内直连、OpenAI 兼容）
 * - 失败/超时/未配置 Key 时返回 null，由调用方降级到模板话术，保证客服链路不断
 */
@Component
public class ZhipuAiClient {

    @Value("${ai.zhipu.base-url}")
    private String baseUrl;

    @Value("${ai.zhipu.api-key}")
    private String apiKey;

    @Value("${ai.zhipu.model}")
    private String model;

    @Value("${ai.zhipu.timeout-ms}")
    private int timeoutMs;

    @Value("${ai.zhipu.max-tokens}")
    private int maxTokens;

    /**
     * 是否已配置可用 API Key
     */
    public boolean isConfigured() {
        return apiKey != null && !apiKey.trim().isEmpty()
                && !"your_zhipu_api_key".equals(apiKey.trim());
    }

    /**
     * 文本对话
     *
     * @return 模型回复内容；失败时返回 null（由调用方降级）
     */
    public String chatText(String systemPrompt, String userContent) {
        if (!isConfigured()) {
            return null;
        }

        JSONObject body = new JSONObject();
        body.set("model", model);
        body.set("temperature", 0.3);
        body.set("max_tokens", maxTokens);

        JSONArray messages = new JSONArray();
        JSONObject sysMsg = new JSONObject();
        sysMsg.set("role", "system");
        sysMsg.set("content", systemPrompt);
        JSONObject userMsg = new JSONObject();
        userMsg.set("role", "user");
        userMsg.set("content", userContent);
        messages.add(sysMsg);
        messages.add(userMsg);
        body.set("messages", messages);

        try {
            HttpResponse resp = HttpRequest.post(baseUrl + "/chat/completions")
                    .header("Authorization", "Bearer " + apiKey.trim())
                    .header("Content-Type", "application/json")
                    .body(body.toString())
                    .timeout(timeoutMs)
                    .execute();

            if (resp.getStatus() != 200) {
                return null;
            }

            JSONObject json = JSONUtil.parseObj(resp.body());
            return json.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getStr("content");
        } catch (Exception e) {
            // 网络异常/超时/解析失败 → 返回 null，由调用方降级
            return null;
        }
    }
}
