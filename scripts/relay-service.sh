#!/bin/bash
# ============================================================
# cowork-codex-relay サービス管理スクリプト
# LaunchAgent のインストール・起動・停止・ステータス確認をワンコマンドで
#
# 使い方:
#   bash scripts/relay-service.sh install   # 初回セットアップ
#   bash scripts/relay-service.sh start     # 起動
#   bash scripts/relay-service.sh stop      # 停止
#   bash scripts/relay-service.sh restart   # 再起動
#   bash scripts/relay-service.sh status    # ステータス確認
#   bash scripts/relay-service.sh logs      # ログ表示
#   bash scripts/relay-service.sh url       # 現在のngrok URL表示
#   bash scripts/relay-service.sh uninstall # アンインストール
# ============================================================

set -euo pipefail

LABEL="com.marumiworks.cowork-relay"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_SRC="${SCRIPT_DIR}/com.marumiworks.cowork-relay.plist"
PLIST_DST="$HOME/Library/LaunchAgents/${LABEL}.plist"
RELAY_DIR="/Users/yuyafujita/Projects/cowork-codex-relay"
LOG_DIR="$HOME/Library/Logs/cowork-codex-relay"
NGROK_URL_FILE="${RELAY_DIR}/.ngrok_url"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

cmd_install() {
  echo "=== リレーサーバー LaunchAgent インストール ==="

  # .env 存在チェック
  if [ ! -f "${RELAY_DIR}/.env" ]; then
    echo -e "${RED}[ERROR]${NC} ${RELAY_DIR}/.env が見つかりません。"
    echo "先にセットアップを実行: bash scripts/relay-setup.sh"
    exit 1
  fi

  # ログディレクトリ作成
  mkdir -p "${LOG_DIR}"

  # デーモンスクリプトに実行権限付与
  chmod +x "${SCRIPT_DIR}/relay-daemon.sh"

  # plist コピー
  mkdir -p "$HOME/Library/LaunchAgents"
  cp "${PLIST_SRC}" "${PLIST_DST}"
  echo -e "${GREEN}✓${NC} plist をインストール: ${PLIST_DST}"

  # LaunchAgent 登録 & 起動
  launchctl load "${PLIST_DST}" 2>/dev/null || true
  echo -e "${GREEN}✓${NC} LaunchAgent を登録しました"
  echo ""
  echo "リレーサーバーがバックグラウンドで起動しました。"
  echo "以降は Mac ログイン時に自動起動、クラッシュ時に自動再起動します。"
  echo ""
  echo "管理コマンド:"
  echo "  bash scripts/relay-service.sh status   # ステータス確認"
  echo "  bash scripts/relay-service.sh url      # ngrok URL 確認"
  echo "  bash scripts/relay-service.sh logs     # ログ表示"
  echo "  bash scripts/relay-service.sh restart   # 再起動"
}

cmd_uninstall() {
  echo "=== リレーサーバー LaunchAgent アンインストール ==="
  if [ -f "${PLIST_DST}" ]; then
    launchctl unload "${PLIST_DST}" 2>/dev/null || true
    rm -f "${PLIST_DST}"
    echo -e "${GREEN}✓${NC} LaunchAgent を削除しました"
  else
    echo "LaunchAgent は登録されていません"
  fi
}

cmd_start() {
  if [ ! -f "${PLIST_DST}" ]; then
    echo -e "${RED}[ERROR]${NC} 先に install を実行してください"
    exit 1
  fi
  launchctl load "${PLIST_DST}" 2>/dev/null || true
  launchctl start "${LABEL}" 2>/dev/null || true
  echo -e "${GREEN}✓${NC} リレーサーバーを起動しました"
  sleep 3
  cmd_status
}

cmd_stop() {
  launchctl stop "${LABEL}" 2>/dev/null || true
  launchctl unload "${PLIST_DST}" 2>/dev/null || true
  echo -e "${YELLOW}■${NC} リレーサーバーを停止しました"
}

cmd_restart() {
  echo "リレーサーバーを再起動中..."
  cmd_stop
  sleep 2
  cmd_start
}

cmd_status() {
  echo "=== リレーサーバー ステータス ==="

  # LaunchAgent 登録状態
  if launchctl list "${LABEL}" &>/dev/null; then
    local pid
    pid=$(launchctl list "${LABEL}" 2>/dev/null | awk 'NR==2{print $1}' || echo "-")
    local exit_code
    exit_code=$(launchctl list "${LABEL}" 2>/dev/null | awk 'NR==2{print $2}' || echo "-")

    if [ "$pid" != "-" ] && [ "$pid" != "0" ] && [ -n "$pid" ]; then
      echo -e "  状態: ${GREEN}実行中${NC} (PID: ${pid})"
    else
      echo -e "  状態: ${RED}停止${NC} (終了コード: ${exit_code})"
    fi
  else
    echo -e "  状態: ${RED}未登録${NC}"
    echo "  → bash scripts/relay-service.sh install で登録"
    return
  fi

  # ngrok URL
  if [ -f "${NGROK_URL_FILE}" ]; then
    echo -e "  ngrok: ${GREEN}$(cat "${NGROK_URL_FILE}")${NC}"
  else
    echo -e "  ngrok: ${YELLOW}URL未検出（起動直後は数秒待ってください）${NC}"
  fi

  # ログの最終行
  if [ -f "${LOG_DIR}/relay.log" ]; then
    echo "  最終ログ: $(tail -1 "${LOG_DIR}/relay.log")"
  fi
}

cmd_logs() {
  if [ -f "${LOG_DIR}/relay.log" ]; then
    echo "=== 直近30行 ==="
    tail -30 "${LOG_DIR}/relay.log"
    echo ""
    echo "リアルタイム表示: tail -f ${LOG_DIR}/relay.log"
  else
    echo "ログファイルがまだありません"
  fi
}

cmd_url() {
  if [ -f "${NGROK_URL_FILE}" ]; then
    cat "${NGROK_URL_FILE}"
  else
    echo "ngrok URL が見つかりません。サーバーが起動していない可能性があります。"
    echo "  bash scripts/relay-service.sh status で確認してください。"
    exit 1
  fi
}

# --- メインルーティング ---
case "${1:-help}" in
  install)   cmd_install ;;
  uninstall) cmd_uninstall ;;
  start)     cmd_start ;;
  stop)      cmd_stop ;;
  restart)   cmd_restart ;;
  status)    cmd_status ;;
  logs)      cmd_logs ;;
  url)       cmd_url ;;
  *)
    echo "使い方: bash scripts/relay-service.sh <command>"
    echo ""
    echo "コマンド:"
    echo "  install    LaunchAgent をインストール（初回のみ）"
    echo "  start      起動"
    echo "  stop       停止"
    echo "  restart    再起動"
    echo "  status     ステータス確認"
    echo "  logs       ログ表示"
    echo "  url        現在の ngrok URL 表示"
    echo "  uninstall  LaunchAgent を削除"
    ;;
esac
