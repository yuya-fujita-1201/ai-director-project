#!/bin/bash
# ============================================================
# cowork-codex-relay ワンコマンド起動スクリプト
# 使い方: bash ~/Projects/ai-director-project/scripts/relay-start.sh
# ============================================================

RELAY_DIR="/Users/yuyafujita/Projects/cowork-codex-relay"
ENV_FILE="${RELAY_DIR}/.env"

# .env 存在チェック
if [ ! -f "${ENV_FILE}" ]; then
  echo "[error] ${ENV_FILE} が見つかりません。"
  echo "先にセットアップを実行してください:"
  echo "  bash ~/Projects/ai-director-project/scripts/relay-setup.sh"
  exit 1
fi

# .env 読み込み
set -a
source "${ENV_FILE}"
set +a

echo "=== cowork-codex-relay 起動 ==="
echo "  WORKDIR: ${RELAY_WORKDIR}"
echo "  PORT:    ${RELAY_PORT:-8787}"
echo "  ngrok:   トンネル自動接続中..."
echo ""

cd "${RELAY_DIR}"
npm run start:tunnel
