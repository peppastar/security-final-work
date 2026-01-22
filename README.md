# security-final-work
# 容器化Web安全纵深防御系统
本项目基于 Docker + Suricata IDS + Nginx 构建，实现对Web攻击（如SQL注入、XSS、RCE）的实时检测与自动封禁，是一套轻量级的容器云安全防御实验环境。

## 环境依赖
- Docker（版本 ≥ 20.10）
- Docker Compose（版本 ≥ 2.0）
- PowerShell（Windows）/ Bash（Linux/macOS）

## 快速部署
### 1. 进入项目目录
```bash
cd security-final-work
```

### 2. 启动容器服务
使用`docker-compose`一键启动所有组件：
```bash
docker-compose up -d
```
执行后会自动创建并运行：
- `web-target`：Nginx Web服务容器（映射80/443端口）
- `suricata-ids`：Suricata IDS容器（监听`security-net`网络流量）

### 3. 启动自动封禁脚本
在PowerShell中执行：
```powershell
.\block_attack.ps1
```
脚本启动后会显示绿色启动提示，表明系统已就绪，等待攻击检测。

## 攻击测试
### 测试1：SQL注入攻击（Union Select）
在新的PowerShell窗口执行攻击命令：
```powershell
curl "http://localhost/?id=1 union select 1,2,3" -UseBasicParsing
```
观察封禁脚本窗口：
- 弹出红色攻击告警，显示攻击源IP
- 随后显示绿色封禁提示，提示“IP已被永久封禁”
- 刷新浏览器访问`http://localhost`，页面无法访问（验证封禁生效）

### 测试2：XSS跨站脚本攻击
重启封禁脚本（清空历史封禁），执行攻击命令：
```powershell
curl "http://localhost/?payload=<script>alert(1)</script>" -UseBasicParsing
```
同样会触发告警与封禁，页面无法访问。


---
需要我帮你把这份README优化成**更适合课设提交的格式**吗？比如增加实验目的、实验原理等模块。
