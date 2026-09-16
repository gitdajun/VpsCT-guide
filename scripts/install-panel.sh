#!/bin/bash
# VpsCT 控制端一键安装辅助脚本
# 实际下载并执行官方 install.sh

set -e

if [ -z "$1" ]; then
  echo "用法:"
  echo "  $0 <你的面板域名>"
  echo "示例:"
  echo "  $0 panel.example.com"
  exit 1
fi

DOMAIN="$1"

echo "=============================================="
echo " VpsCT 控制端安装"
echo " 域名: $DOMAIN"
echo " 原项目: https://github.com/YongshengWin/VpsCT"
echo "=============================================="
echo ""

curl -fLsS --proto '=https' --proto-redir '=https' \
  https://github.com/YongshengWin/VpsCT/releases/latest/download/install.sh \
  -o /tmp/install-vpsct.sh

sudo bash /tmp/install-vpsct.sh --domain "$DOMAIN"

echo ""
echo "安装完成后请执行以下命令获取初始化令牌："
echo "  sudo cat /opt/ctlvps/data/setup-token"
