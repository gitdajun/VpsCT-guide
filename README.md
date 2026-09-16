# VpsCT 中文安装与使用指南

**VpsCT** 是面向个人和小团队的自托管服务器管理面板。  
可集中管理多台 VPS 的状态、流量、服务配置，并按流量配额和有效期分享服务器资源。

> **原项目**：https://github.com/YongshengWin/VpsCT  
> 本仓库仅为中文整理与安装指南，代码与发行包请使用原项目官方 Release。  
> 原项目采用 MIT 许可证。

---

## 一、系统要求

- 控制端：Debian / Ubuntu，systemd，Linux amd64 或 arm64
- 被管理 VPS：同样支持 Debian / Ubuntu 等常见发行版
- 需要一个已解析到控制端的域名（推荐开启 HTTPS）

---

## 二、安装控制端（面板）

### 方式 1：自动配置 HTTPS（推荐）

准备好域名（已解析到服务器），确保 80、443 端口空闲且公网可访问，然后执行：

```bash
curl -fLsS --proto '=https' --proto-redir '=https' \
  https://github.com/YongshengWin/VpsCT/releases/latest/download/install.sh \
  -o install-vpsct.sh && \
sudo bash install-vpsct.sh --domain panel.example.com
```

将 `panel.example.com` 替换为你的实际域名。

**Cloudflare 用户注意**：  
若开启橙云，请使用 **完全（严格）/ Full (strict)** 加密模式，不要用「灵活 / Flexible」，否则会出现重定向循环。

### 方式 2：使用已有 HTTPS 入口或其他端口

先把反向代理转发到本机 `127.0.0.1:8080`，再执行（以 8443 为例）：

```bash
curl -fLsS --proto '=https' --proto-redir '=https' \
  https://github.com/YongshengWin/VpsCT/releases/latest/download/install.sh \
  -o install-vpsct.sh && \
sudo bash install-vpsct.sh --site-url https://panel.example.com:8443 --no-proxy
```

使用标准 443 端口时去掉 `:8443` 即可。

---

## 三、创建管理员账户

安装完成后，在**控制端服务器**执行：

```bash
sudo cat /opt/ctlvps/data/setup-token
```

访问面板域名，输入令牌并设置管理员账号。初始化完成后令牌会自动失效。

---

## 四、接入被管理的 VPS

1. 登录面板 → 「服务器」→「添加服务器」，填写名称、地址和流量配额
2. 在服务器详情中生成 **agent 安装命令**
3. 到目标 VPS 上以 **root** 执行生成的命令
4. 返回面板，确认服务器显示「在线」

> agent 主动连接控制端，被管理 VPS **无需额外开放管理端口**。

控制端本身也可以安装 agent，把本机也纳入管理。

---

## 五、日常管理功能

| 功能 | 说明 |
|------|------|
| 状态监控 | CPU、内存、磁盘、实时网络速率 |
| 流量统计 | 入站 + 出站，支持配额、周期重置、通知 |
| 服务部署 | 通过面板下发配置，由 agent 在 VPS 上应用 |
| 模板与订阅 | 维护配置模板，生成订阅链接 |
| 资源分享 | 按流量配额、有效期分享给他人，独立凭据与用量统计 |
| 安全 | 两步验证、操作审计、连接日志 |

---

## 六、更新与维护

### 更新控制端

```bash
curl -fLsS --proto '=https' --proto-redir '=https' \
  https://github.com/YongshengWin/VpsCT/releases/latest/download/install.sh \
  -o install-vpsct.sh && \
sudo bash install-vpsct.sh --update --auto-rollback
```

更新前会自动停服备份，保留账户、配置和分享记录。

也可在面板 **设置 → 系统 → 控制端维护** 进行网页升级。

### 同步 agent

新版 agent 会随心跳自动同步。也可在服务器详情中手动：

- 检查 agent 更新
- 升级 agent
- 重新下发配置

### 备份

控制端默认定时备份主数据库（保留 7 份）。完整迁移前请停止服务并备份整个数据目录 `/opt/ctlvps/data`。

---

## 七、卸载

```bash
# 预览（不实际删除）
sudo bash /opt/ctlvps/uninstall.sh --controller --dry-run

# 卸载控制端
sudo bash /opt/ctlvps/uninstall.sh --controller --yes

# 卸载 agent
sudo bash /opt/ctlvps/uninstall.sh --agent --yes

# 卸载本机两端
sudo bash /opt/ctlvps/uninstall.sh --all --yes
```

默认保留配置和数据；加 `--purge` 会永久删除数据与备份。

也可在面板网页中完成卸载（需管理员密码 + 两步验证确认）。

---

## 八、相关文档（原项目）

| 内容 | 链接 |
|------|------|
| 安装、升级与恢复 | [operations.md](https://github.com/YongshengWin/VpsCT/blob/main/docs/operations.md) |
| 共享代理与流量计量 | [shared-proxy-accounting.md](https://github.com/YongshengWin/VpsCT/blob/main/docs/shared-proxy-accounting.md) |
| 隐私说明 | [privacy.md](https://github.com/YongshengWin/VpsCT/blob/main/docs/privacy.md) |
| 变更记录 | [CHANGELOG.md](https://github.com/YongshengWin/VpsCT/blob/main/CHANGELOG.md) |
| 安全设计 | [security-design.md](https://github.com/YongshengWin/VpsCT/blob/main/docs/security-design.md) |
| 贡献指南 | [CONTRIBUTING.md](https://github.com/YongshengWin/VpsCT/blob/main/CONTRIBUTING.md) |

---

## 九、免责声明

- 本仓库仅做中文整理，所有程序、发行包、更新均来自原项目官方 Release。
- 请遵守当地法律法规，仅将面板用于合法的服务器管理用途。
- 使用风险自负，与本仓库维护者无关。

---

## License

原项目采用 [MIT License](https://github.com/YongshengWin/VpsCT/blob/main/LICENSE)。  
本指南内容同样以 MIT 方式公开。
