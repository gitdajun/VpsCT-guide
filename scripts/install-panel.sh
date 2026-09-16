#!/bin/bash
# VpsCT 控制端安装辅助脚本

set -e

if [ -z "$1" ]; then
  echo "用法: $0 <面板域名>"
  echo "示例: $0 panel.example.com"
  exit 1
fi

DOMAIN="$1"

echo "=============================================="
echo " VpsCT 控制端安装"
echo " 域名: $DOMAIN"
echo "=============================================="
echo ""

curl -fLsS --proto '=https' --proto-redir '=https' \
  https://github.com/YongshengWin/VpsCT/releases/latest/download/install.sh \
  -o /tmp/install-vpsct.sh

sudo bash /tmp/install-vpsct.sh --domain "$DOMAIN"

echo ""
echo "完成后获取初始化令牌："
echo "  sudo cat /opt/ctlvps/data/setup-token"
