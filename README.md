# 智能快递柜管理系统（Smart Locker SSM）

基于 **SSM（Spring + SpringMVC + MyBatis）** 框架的校园智能快递柜管理系统，提供快递自动化存取、储物柜调度与多角色权限管理，支撑日均数百笔存取操作。

## 功能特性

- **快递管理**：快递入库、取出、查询，覆盖完整存取流程
- **储物调度**：储物柜（Locker）与储物格（Box）的分配、释放与状态流转
- **多角色 RBAC**：管理员 / 普通用户权限隔离，越权访问拦截
- **统一异常处理**：全局异常拦截 + 业务异常封装
- **操作日志**：AOP 切面记录关键操作，便于审计

## 技术栈

| 层 | 技术 |
|---|---|
| 核心框架 | Spring + SpringMVC + MyBatis |
| 数据库连接池 | Druid |
| 数据库 | MySQL 8.0 |
| 前端 | JSP + HTML / CSS / JS |
| 日志 | Logback |

## 项目结构

```
src/main/java/com/smartlocker/
├── controller/   # 控制层（User / Locker / Box / Package）
├── service/      # 业务层（接口 + impl 实现）
├── dao/          # 数据访问层（MyBatis Mapper 接口）
├── entity/       # 实体类
├── dto/          # 数据传输对象（BoxDetail / PackageDetail）
├── aspect/       # AOP 切面（操作日志 LogAspect）
├── exception/    # 异常处理（BusinessException / GlobalExceptionHandler）
└── util/         # 工具类（统一返回结果 Result）

src/main/resources/
├── mapper/       # MyBatis Mapper XML
├── sql/          # 数据库初始化脚本
└── config/       # Spring / MyBatis / 日志配置
```

## 快速开始

1. **建库**：执行 `src/main/resources/sql/database-init.sql` 初始化数据库
2. **配置**：修改 `src/main/resources/database.properties`，把 `jdbc.password` 改成你自己的 MySQL 密码（仓库中已脱敏为占位符 `your_db_password`）
3. **运行**：用 IDEA 配置 Tomcat 运行，或打成 war 包部署到 Tomcat

## 测试情况

- 编写 **86 条**标准化测试用例，核心业务覆盖率 **95%+**
- 覆盖正常流程、异常操作、权限越权等 **22 类**场景
- 通过 Postman 校验 32 个后端 REST 接口，SQL 查询核验核心业务数据

## 说明

本项目为课程设计实践项目，用于学习 SSM 框架的整合与分层开发。
