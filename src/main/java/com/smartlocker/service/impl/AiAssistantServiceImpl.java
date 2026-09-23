package com.smartlocker.service.impl;

import com.smartlocker.ai.ZhipuAiClient;
import com.smartlocker.dao.AiChatLogDao;
import com.smartlocker.dao.PackageDao;
import com.smartlocker.dto.PackageDetail;
import com.smartlocker.entity.AiChatLog;
import com.smartlocker.service.AiAssistantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * AI 客服 Service 实现类
 *
 * 核心设计（对应 ai-design.md）：
 * 1. 确定性检索：先用 SQL 按手机号查快递，作为唯一事实源，不依赖模型记忆
 * 2. 规则 vs 模型：查数据用 SQL（规则），组织话术用 LLM（模型）
 * 3. 防幻觉：System Prompt 明确「只基于给定数据回答，没有就说没有」
 * 4. 降级兜底：模型失败/未配置 Key → 模板话术，客服链路不断
 * 5. 成本控制：上下文只注入该手机号的最近快递，max_tokens 受限
 * 6. Bad Case：每轮对话落库 ai_chat_log，记录来源与转人工信号，供复盘
 */
@Service
public class AiAssistantServiceImpl implements AiAssistantService {

    @Autowired
    private PackageDao packageDao;

    @Autowired
    private ZhipuAiClient zhipuAiClient;

    @Autowired
    private AiChatLogDao aiChatLogDao;

    private static final String CHAT_SYSTEM_PROMPT =
            "你是一名智能快递柜的客服助手。请严格基于下面「快递数据」中提供的信息回答用户问题，" +
            "不要编造任何数据中没有的内容。如果数据中没有用户询问的快递，请明确告知「没有找到相关快递」。" +
            "回答要简洁、友好、使用中文。";

    private static final String NOTICE_SYSTEM_PROMPT =
            "你是一名智能快递柜的客服助手。请基于下面的快递数据，生成一条温馨、简洁的取件通知短信文案，" +
            "需包含快递单号、柜机位置、柜格编号和取件提醒。直接输出文案正文，不要添加任何解释或标题。";

    @Override
    public String chat(String phone, String question) {
        String source = "model";
        String answer = null;

        // 1. 确定性检索（规则先行）
        List<PackageDetail> packages = packageDao.selectPackageDetailsByPhone(phone);
        String context = buildPackageContext(packages);

        // 2. 模型生成
        if (zhipuAiClient.isConfigured()) {
            try {
                answer = zhipuAiClient.chatText(CHAT_SYSTEM_PROMPT,
                        "用户问题：" + (question == null ? "" : question)
                                + "\n\n快递数据：\n" + context);
            } catch (Exception e) {
                answer = null;
            }
        }

        // 3. 降级兜底：模型失败或未配置 Key → 模板话术
        if (answer == null || answer.trim().isEmpty()) {
            answer = buildTemplateAnswer(phone, packages);
            source = "template";
        }

        // 4. 记录对话日志（脱敏），识别转人工信号
        saveLog(phone, question, answer, source, isTransferRequest(question));

        return answer;
    }

    @Override
    public String generateNotice(Long packageId) {
        PackageDetail pkg = packageDao.selectPackageDetailById(packageId);
        if (pkg == null) {
            return "未找到该快递，无法生成通知。";
        }

        String context = buildSinglePackageContext(pkg);

        String notice = null;
        if (zhipuAiClient.isConfigured()) {
            try {
                notice = zhipuAiClient.chatText(NOTICE_SYSTEM_PROMPT, context);
            } catch (Exception e) {
                notice = null;
            }
        }
        if (notice == null || notice.trim().isEmpty()) {
            notice = buildTemplateNotice(pkg);
        }
        return notice;
    }

    // ==================== 上下文构建 ====================

    private String buildPackageContext(List<PackageDetail> packages) {
        if (packages == null || packages.isEmpty()) {
            return "（无快递记录）";
        }
        StringBuilder sb = new StringBuilder();
        for (PackageDetail p : packages) {
            sb.append("- ").append(buildSinglePackageContext(p)).append("\n");
        }
        return sb.toString();
    }

    private String buildSinglePackageContext(PackageDetail p) {
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String putIn = p.getPutInTime() != null ? fmt.format(p.getPutInTime()) : "未知";
        String locker = p.getLockerName() != null ? p.getLockerName() : "未知";
        String location = p.getLockerLocation() != null ? p.getLockerLocation() : "";
        String box = p.getBoxNumber() != null ? p.getBoxNumber() : "未分配";
        return String.format("快递单号：%s；收件人：%s；状态：%s；柜机：%s（%s）；柜格：%s；存入时间：%s",
                p.getPackageNo(), p.getReceiverName(), p.getStatusDesc(),
                locker, location, box, putIn);
    }

    // ==================== 降级模板 ====================

    private String buildTemplateAnswer(String phone, List<PackageDetail> packages) {
        if (packages == null || packages.isEmpty()) {
            return "您好，未查询到手机号 " + maskPhone(phone) + " 对应的快递记录，请确认手机号是否正确。";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("您好，为您查询到 ").append(packages.size()).append(" 个快递：\n");
        for (PackageDetail p : packages) {
            sb.append("· 快递单号 ").append(p.getPackageNo())
              .append("，状态：").append(p.getStatusDesc());
            if (p.getLockerName() != null) {
                sb.append("，取件地址：").append(p.getLockerName());
                if (p.getBoxNumber() != null) {
                    sb.append(" ").append(p.getBoxNumber()).append(" 柜");
                }
            }
            sb.append("。\n");
        }
        sb.append("如有疑问，可输入「转人工」联系人工客服。");
        return sb.toString();
    }

    private String buildTemplateNotice(PackageDetail p) {
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String putIn = p.getPutInTime() != null ? fmt.format(p.getPutInTime()) : "";
        StringBuilder sb = new StringBuilder();
        sb.append("【智能快递柜】您好 ").append(p.getReceiverName()).append("，");
        sb.append("您的快递 ").append(p.getPackageNo()).append(" 已存入 ");
        sb.append(p.getLockerName() != null ? p.getLockerName() : "快递柜");
        if (p.getBoxNumber() != null) {
            sb.append(" ").append(p.getBoxNumber()).append(" 柜");
        }
        sb.append("，请凭取件码及时取件");
        if (!putIn.isEmpty()) {
            sb.append("（存入时间 ").append(putIn).append("）");
        }
        sb.append("。");
        return sb.toString();
    }

    // ==================== 日志与工具 ====================

    private void saveLog(String phone, String question, String answer, String source, boolean transferred) {
        try {
            AiChatLog log = new AiChatLog();
            log.setPhone(maskPhone(phone));
            log.setQuestion(question);
            log.setAnswer(answer);
            log.setAnswerSource(source);
            log.setIsTransferred(transferred ? 1 : 0);
            log.setCreateTime(new Date());
            aiChatLogDao.insert(log);
        } catch (Exception e) {
            // 日志写入失败不影响主流程
        }
    }

    /**
     * 手机号脱敏：保留前3位与后4位，中间打码
     */
    private String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) {
            return phone;
        }
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }

    /**
     * 是否包含转人工信号
     */
    private boolean isTransferRequest(String question) {
        if (question == null) {
            return false;
        }
        String q = question.trim();
        return q.contains("人工") || q.contains("投诉") || q.contains("客服") || q.contains("反馈");
    }
}
