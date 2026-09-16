# VpsCT 安装与使用指南

VpsCT 是面向个人与小团队的自托管 VPS 管理面板，可集中查看多台服务器状态与流量、下发服务配置，并按配额与有效期分享资源。

程序与发行包请使用项目官方 Release 下载与更新。

---

## 一、环境要求

- 控制端：Debian / Ubuntu，systemd，amd64 或 arm64
- 被管 VPS：常见 Linux 发行版即可
- 建议准备已解析到控制端的域名（用于 HTTPS）

---

## 二、安装控制端

### 自动 HTTPS（推荐）

域名已解析、80/443 可用时：

```bash
curl -fLsS --proto '=https' --proto-redir '=https' \
  https://github.com/YongshengWin/VpsCT/releases/latest/download/install.sh \
  -o install-vpsct.sh && \
sudo bash install-vpsct.sh --domain panel.example.com
```

将域名换成你的。若使用 Cloudflare 橙云，加密模式请选 **完全（严格）**，避免 Flexible 导致重定向循环。

### 已有反代或其他端口

入口转发到 `127.0.0.1:8080` 后：

```bash
curl -fLsS --proto '=https' --proto-redir '=https' \
  https://github.com/YongshengWin/VpsCT/releases/latest/download/install.sh \
  -o install-vpsct.sh && \
sudo bash install-vpsct.sh --site-url https://panel.example.com:8443 --no-proxy
```

标准 443 时可去掉端口号。

也可使用本仓库脚本：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gitdajun/VpsCT-guide/main/scripts/install-panel.sh) 你的域名
```

---

## 三、初始化管理员

在控制端执行：

```bash
sudo cat /opt/ctlvps/data/setup-token
```

浏览器打开面板，用令牌创建管理员账号（用后失效）。

---

## 四、接入 VPS

1. 面板中「服务器」→ 添加，填写名称、地址、流量配额
2. 在详情页生成 agent 安装命令
3. 在目标机以 root 执行该命令
4. 面板中确认状态为「在线」

agent 主动连控制端，被管机器一般不必额外开放管理端口。控制端本机也可装 agent。

---

## 五、常用能力

| 功能 | 说明 |
|------|------|
| 监控 | CPU / 内存 / 磁盘 / 网络 |
| 流量 | 入站出站、配额、周期与通知 |
| 配置下发 | 面板保存，agent 在 VPS 应用 |
| 模板与订阅 | 模板生成订阅链接 |
| 分享 | 按配额与有效期独立分享 |
| 安全 | 两步验证、审计日志 |

---

## 六、更新与备份

更新控制端：

```bash
curl -fLsS --proto '=https' --proto-redir '=https' \
  https://github.com/YongshengWin/VpsCT/releases/latest/download/install.sh \
  -o install-vpsct.sh && \
sudo bash install-vpsct.sh --update --auto-rollback
```

也可在「设置 → 系统」中网页升级。agent 可随心跳同步，或在服务器详情中手动检查/升级/重下发配置。

数据目录默认 `/opt/ctlvps/data`，迁移前请停服并完整备份。

---

## 七、卸载

```bash
sudo bash /opt/ctlvps/uninstall.sh --controller --dry-run   # 预览
sudo bash /opt/ctlvps/uninstall.sh --controller --yes
sudo bash /opt/ctlvps/uninstall.sh --agent --yes
sudo bash /opt/ctlvps/uninstall.sh --all --yes
```

加 `--purge` 会删除数据与备份。网页端也可在设置中卸载（需密码与确认）。

---

## 八、说明

- 请仅用于合法的服务器管理
- 使用风险自负

## License

MIT License
