#!/bin/bash
# ============================================================
# cowork-codex-relay 初回セットアップスクリプト
# Mac側で1回だけ実行すれば、以降は relay-start.sh で起動できる
# ============================================================

RELAY_DIR="/Users/yuyafujita/Projects/cowork-codex-relay"
ENV_FILE="${RELAY_DIR}/.env"

echo "=== cowork-codex-relay セットアップ ==="

# ngrok トークン入力
if [ -z "$1" ]; then
  read -p "ngrok Authtoken を入力: " NGROK_TOKEN
else
  NGROK_TOKEN="$1"
fi

if [ -z "$NGROK_TOKEN" ]; then
  echo "[error] ngrok Authtoken が空です。"
  exit 1
fi

# .env ファイル作成
cat > "${ENV_FILE}" << EOF
# cowork-codex-relay 設定
RELAY_TOKEN=snap2026
RELAY_HOST=0.0.0.0
RELAY_PORT=8787
RELAY_WORKDIR=/Users/yuyafujita/Projects/ai-director-project/app/snap_english
NGROK_AUTHTOKEN=${NGROK_TOKEN}
EOF

echo "✓ ${ENV_FILE} を作成しました"
echo ""
echo "以降の起動は以下の1コマンドでOK:"
echo "  bash ~/Projects/ai-director-project/scripts/relay-start.sh"
