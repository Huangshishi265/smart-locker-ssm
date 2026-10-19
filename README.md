# 智能快递柜管理系统（Smart Locker SSM）

基于 **SSM（Spring + SpringMVC + MyBatis）** 框架的智能快递柜管理系统，覆盖快递入库、柜格自动分配、用户取件、故障报修与维修追踪的完整存取闭环，并接入 **智谱 GLM 大模型**实现 AI 智能客服与取件通知文案生成。

> 说明：本项目所有功能均可实际运行，首页统计数字全部来自数据库实时计算，AI 客服在模型不可用时自动降级为模板话术。**AI 产品设计决策详见 [docs/ai-design.md](docs/ai-design.md)**。

## 功能特性

- **快递存取闭环**：快递入库自动分配空闲柜格 → 用户取件释放柜格，状态可追溯（待取件 / 已取件 / 已取消）
- **智能柜格管理**：小 / 中 / 大三种规格柜格自动初始化与分配，实时统计空闲 / 占用 / 禁用数量
- **故障报修追踪**：报修 → 维修 → 完成全流程记录，故障状态与维修人员可追踪
- **登录与权限**：登录拦截器统一鉴权，管理员 / 普通用户角色区分
- **AI 智能客服**：输入手机号即可查询快递状态，模型失败自动降级为模板话术
- **取件通知文案**：一键生成温馨取件通知，可直接用于短信推送
- **真实数据看板**：首页统计全部来自数据库实时计算，无假数据

## 技术栈

| 层 | 技术 |
|---|---|
| 核心框架 | Spring + SpringMVC + MyBatis |
| 数据库连接池 | Druid |
| 数据库 | MySQL 8.0 |
| 前端 | JSP + HTML / CSS / JS（原生 fetch） |
| AI 能力 | 智谱 BigModel（GLM-4-Flash），Hutool HTTP 客户端 |
| 日志 | Logback + AOP 操作日志 |

## 项目结构

```
src/main/java/com/smartlocker/
├── controller/    # 控制层（User / Locker / Box / Package / AiAssistant）
├── service/       # 业务层（接口 + impl 实现）
├── dao/           # 数据访问层（MyBatis Mapper 接口）
├── entity/        # 实体类（含 AiChatLog）
├── dto/           # 数据传输对象（BoxDetail / PackageDetail）
├── ai/            # AI 客户端（ZhipuAiClient，超时 / 降级封装）
├── interceptor/   # 登录拦截器
├── aspect/        # AOP 切面（操作日志）
├── exception/     # 全局异常处理
└── util/          # 工具类

src/main/resources/
├── mapper/        # MyBatis Mapper XML
├── sql/           # 数据库初始化脚本（database-init.sql）
└── config/        # Spring / MyBatis / JDBC / AI 配置
```

## 快速开始

1. **建库**：执行 `src/main/resources/sql/database-init.sql` 初始化数据库
2. **配置数据库**：修改 `src/main/resources/config/jdbc.properties`，把 `jdbc.password` 改成你自己的 MySQL 密码（仓库中已脱敏为占位符 `your_db_password`）
3. **配置 AI（可选）**：修改 `src/main/resources/config/ai.properties`，把 `ai.zhipu.api-key` 换成你在 https://open.bigmodel.cn 申请的 API Key（永久免费）。**不配置也不影响运行**——AI 客服会自动降级为模板话术
4. **运行**：用 IDEA 配置 Tomcat 运行，或打成 war 包部署到 Tomcat（JDK 1.8 / Tomcat 9）

### 默认账号

| 账号 | 密码 | 角色 |
|---|---|---|
| admin | 123456 | 管理员 |
| test | 123456 | 普通用户 |

### 演示数据

初始化脚本内置 2 个待取件快递，收件人手机号为 `13800000001`、`13900000002`，可在 AI 客服页面输入这两个手机号体验查询。

## AI 产品设计说明

| 维度 | 决策 |
|---|---|
| 数据 | 快递是结构化数据，用 **SQL 确定性检索**（按手机号查快递）而非 RAG；状态码转中文、时间格式化、手机号脱敏后再进模型 |
| 模型 | 选 `glm-4-flash`：免费、国内直连、文本问答/文案够用 |
| 交互 | 痛点=取件用户重复问"到了吗/在哪/码多少"；链路=输入手机号→检索→生成回答，通知=一键生成文案 |
| 工程 | 降成本=上下文只注入该手机号最近快递 + max_tokens 受限；兜底=模型失败降级模板话术，客服链路不断 |
| 运营 | 每轮对话落库 `ai_chat_log`（脱敏 + 回答来源 + 转人工信号），转人工率为核心指标，Bad Case 复盘调 prompt |
| 规则 vs 模型 | **不用 Agent / 工具调用**：查数据用 SQL（规则），组织话术用 LLM（模型）；防幻觉靠"只基于给定数据回答，没有就说没有" |

完整 7 维度设计文档见 **[docs/ai-design.md](docs/ai-design.md)**。

## 说明

本项目为《Java EE 开发技术》课程设计实践项目，用于学习 SSM 框架的整合与分层开发，并在此基础上实践 AI 产品的设计闭环。
