#!/bin/bash
# ============================================================
# cowork-codex-relay デーモン起動スクリプト
# LaunchAgent から呼ばれる。手動実行も可。
#
# 機能:
#   - 依存コマンド存在チェック（node / ngrok / npm）
#   - .env から環境変数を読み込み
#   - ngrok トンネル付きでリレーサーバーを起動
#   - ログを ~/Library/Logs/cowork-codex-relay/ に出力（ローテーション付き）
#   - 起動時に ngrok URL をファイルに保存
#   - 連続失敗時のバックオフ（10s → 30s → 60s → 停止）
#
# 安全装置:
#   - 連続5回失敗で自動停止（無限再起動ループ防止）
#   - ログ 10MB 超でローテーション（ディスク肥大化防止）
#   - nice で低優先度実行（Mac の体感影響を軽減）
# ============================================================

set -euo pipefail

RELAY_DIR="/Users/yuyafujita/Projects/cowork-codex-relay"
ENV_FILE="${RELAY_DIR}/.env"
LOG_DIR="$HOME/Library/Logs/cowork-codex-relay"
NGROK_URL_FILE="${RELAY_DIR}/.ngrok_url"
PID_FILE="${RELAY_DIR}/.relay.pid"
FAIL_COUNT_FILE="${RELAY_DIR}/.relay_fail_count"
MAX_LOG_BYTES=$((10 * 1024 * 1024))  # 10MB
MAX_CONSECUTIVE_FAILS=5

# --- ログディレクトリ ---
mkdir -p "${LOG_DIR}"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_DIR}/relay.log"
}

# --- ログローテーション ---
rotate_log() {
  local logfile="$1"
  if [ -f "$logfile" ]; then
    local size
    size=$(stat -f%z "$logfile" 2>/dev/null || stat -c%s "$logfile" 2>/dev/null || echo 0)
    if [ "$size" -gt "$MAX_LOG_BYTES" ]; then
      mv "$logfile" "${logfile}.1"
      # .2 以降は削除（最大1世代保持）
      rm -f "${logfile}.2"
      log "ログローテーション実行: $(basename "$logfile") (${size} bytes)"
    fi
  fi
}

rotate_all_logs() {
  rotate_log "${LOG_DIR}/relay.log"
  rotate_log "${LOG_DIR}/stdout.log"
  rotate_log "${LOG_DIR}/stderr.log"
}

# --- 連続失敗カウント管理 ---
get_fail_count() {
  if [ -f "${FAIL_COUNT_FILE}" ]; then
    cat "${FAIL_COUNT_FILE}" 2>/dev/null || echo 0
  else
    echo 0
  fi
}

increment_fail_count() {
  local count
  count=$(get_fail_count)
  count=$((count + 1))
  echo "$count" > "${FAIL_COUNT_FILE}"
  echo "$count"
}

reset_fail_count() {
  echo 0 > "${FAIL_COUNT_FILE}"
}

# --- 依存コマンドチェック ---
check_dependency() {
  local cmd="$1"
  local label="$2"
  if ! command -v "$cmd" &>/dev/null; then
    # PATHにhomebrew等を含めて再チェック
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
    if ! command -v "$cmd" &>/dev/null; then
      log "[ERROR] ${label} (${cmd}) が見つかりません。PATH: $PATH"
      return 1
    fi
  fi
  log "  ✓ ${label}: $(command -v "$cmd")"
  return 0
}

log "=== 起動前チェック ==="

# 依存チェック
DEPS_OK=true
for dep_pair in "node:Node.js" "npm:npm" "ngrok:ngrok"; do
  cmd="${dep_pair%%:*}"
  label="${dep_pair##*:}"
  if ! check_dependency "$cmd" "$label"; then
    DEPS_OK=false
  fi
done

if [ "$DEPS_OK" != "true" ]; then
  log "[FATAL] 必須コマンドが見つかりません。起動を中止します。"
  count=$(increment_fail_count)
  log "  連続失敗: ${count}/${MAX_CONSECUTIVE_FAILS}"
  # 依存エラーは修正されるまで再起動しても無駄なので即停止
  exit 1
fi

# --- .env チェック ---
if [ ! -f "${ENV_FILE}" ]; then
  log "[ERROR] ${ENV_FILE} が見つかりません。relay-setup.sh を先に実行してください。"
  increment_fail_count > /dev/null
  exit 1
fi

# --- 連続失敗チェック ---
FAIL_COUNT=$(get_fail_count)
if [ "$FAIL_COUNT" -ge "$MAX_CONSECUTIVE_FAILS" ]; then
  log "[FATAL] 連続${FAIL_COUNT}回失敗しています。自動再起動を停止します。"
  log "  手動で問題を修正後、以下を実行:"
  log "    echo 0 > ${FAIL_COUNT_FILE}"
  log "    bash scripts/relay-service.sh restart"
  # exit 0 で終了すると KeepAlive が再起動しないようにする
  # ただし KeepAlive=true の場合は再起動されるので、
  # SuccessfulExit条件と組み合わせが必要
  sleep 300  # 5分間スリープしてから終了（再起動間隔を広げる）
  exit 1
fi

if [ "$FAIL_COUNT" -gt 0 ]; then
  # バックオフ: 失敗回数に応じて待機（10s, 30s, 60s, 120s）
  BACKOFF_SECS=$((10 * (2 ** (FAIL_COUNT - 1))))
  [ "$BACKOFF_SECS" -gt 120 ] && BACKOFF_SECS=120
  log "前回失敗 (${FAIL_COUNT}回目) → ${BACKOFF_SECS}秒待機してから起動..."
  sleep "$BACKOFF_SECS"
fi

# --- 既存プロセスの停止 ---
if [ -f "${PID_FILE}" ]; then
  OLD_PID=$(cat "${PID_FILE}" 2>/dev/null || true)
  if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
    log "既存プロセス (PID: ${OLD_PID}) を停止中..."
    kill "$OLD_PID" 2>/dev/null || true
    sleep 2
    kill -9 "$OLD_PID" 2>/dev/null || true
  fi
  rm -f "${PID_FILE}"
fi

# --- ログローテーション ---
rotate_all_logs

# --- .env 読み込み ---
set -a
source "${ENV_FILE}"
set +a

log "=== cowork-codex-relay デーモン起動 ==="
log "  WORKDIR: ${RELAY_WORKDIR:-未設定}"
log "  PORT:    ${RELAY_PORT:-8787}"
log "  PID:     $$"

# --- PIDファイル作成 ---
echo $$ > "${PID_FILE}"

# --- クリーンアップ ---
cleanup() {
  local exit_code=$?
  log "シャットダウン (exit code: ${exit_code})..."
  rm -f "${PID_FILE}" "${NGROK_URL_FILE}"
  # 子プロセスも停止
  kill 0 2>/dev/null || true

  # 正常終了（30秒以上動いていた）なら失敗カウントリセット
  local now
  now=$(date +%s)
  if [ -n "${START_TIME:-}" ] && [ $((now - START_TIME)) -ge 30 ]; then
    reset_fail_count
  else
    increment_fail_count > /dev/null
    log "  短時間で終了 → 連続失敗カウント: $(get_fail_count)/${MAX_CONSECUTIVE_FAILS}"
  fi

  exit "$exit_code"
}
trap cleanup SIGINT SIGTERM EXIT

START_TIME=$(date +%s)

# --- サーバー起動（nice で低優先度） ---
cd "${RELAY_DIR}"

# 起動成功を検知したらカウントリセット
# npm run start:tunnel のログをファイルにも出力
nice -n 10 npm run start:tunnel 2>&1 | while IFS= read -r line; do
  echo "$line"
  echo "[$(date '+%H:%M:%S')] $line" >> "${LOG_DIR}/relay.log"

  # "listening on" を検知 → 起動成功とみなしてカウントリセット
  if echo "$line" | grep -qi "listening on"; then
    reset_fail_count
  fi

  # ngrok URL を検出して保存
  if echo "$line" | grep -q "ngrok-free.app\|ngrok.io"; then
    DETECTED_URL=$(echo "$line" | grep -oE 'https://[a-zA-Z0-9._-]+\.ngrok-free\.app' || true)
    if [ -n "$DETECTED_URL" ]; then
      echo "$DETECTED_URL" > "${NGROK_URL_FILE}"
      log "ngrok URL 検出: ${DETECTED_URL}"
    fi
  fi
done
