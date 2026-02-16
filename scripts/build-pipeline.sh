#!/bin/bash
# ============================================================
# SnapEnglish iOS ビルド → App Store アップロード 自動パイプライン
# Cowork VM から中継サーバー経由で実行
#
# 使い方:
#   bash scripts/build-pipeline.sh <ngrok-url>
#   例: bash scripts/build-pipeline.sh https://xxxx.ngrok-free.app
# ============================================================

set -e

RELAY_URL="${1}"
TOKEN="snap2026"
HEADERS=(-H "Authorization: Bearer ${TOKEN}" -H "ngrok-skip-browser-warning: true" -H "Content-Type: application/json")

# --- ユーティリティ ---
log()  { echo -e "\n=== $1 ==="; }
fail() { echo -e "\n[FAIL] $1"; exit 1; }

wait_job() {
  local job_id="$1"
  local label="$2"
  local max_wait="${3:-600}"  # デフォルト10分
  local elapsed=0

  echo "  ジョブ ${job_id} を監視中 (最大${max_wait}秒)..."
  while [ $elapsed -lt $max_wait ]; do
    sleep 10
    elapsed=$((elapsed + 10))
    local result
    result=$(curl -s -X GET "${RELAY_URL}/api/jobs/${job_id}" \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "ngrok-skip-browser-warning: true" 2>/dev/null)

    local status
    status=$(echo "$result" | python3 -c "import sys,json; print(json.load(sys.stdin).get('status','unknown'))" 2>/dev/null || echo "unknown")

    if [ "$status" = "completed" ] || [ "$status" = "succeeded" ]; then
      echo "  ✓ ${label} 完了 (${elapsed}秒)"
      echo "$result"
      return 0
    elif [ "$status" = "failed" ] || [ "$status" = "error" ]; then
      echo "  ✗ ${label} 失敗"
      echo "$result" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('error',''), d.get('stderr',''))" 2>/dev/null
      return 1
    fi
    echo "    ... ${elapsed}秒経過 (status: ${status})"
  done
  fail "${label} タイムアウト (${max_wait}秒)"
}

execute_command() {
  local cmd_id="$1"
  local params="$2"
  local label="$3"
  local timeout="${4:-600}"

  log "${label}"
  local body
  if [ -n "$params" ]; then
    body="{\"id\":\"${cmd_id}\",\"params\":${params},\"async\":true}"
  else
    body="{\"id\":\"${cmd_id}\",\"async\":true}"
  fi

  local response
  response=$(curl -s -X POST "${RELAY_URL}/api/execute" "${HEADERS[@]}" -d "$body" 2>/dev/null)
  local job_id
  job_id=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('jobId',''))" 2>/dev/null)

  if [ -z "$job_id" ]; then
    echo "  レスポンス: $response"
    fail "${label}: ジョブIDを取得できませんでした"
  fi

  echo "  ジョブ開始: ${job_id}"
  wait_job "$job_id" "$label" "$timeout"
}

# --- 引数チェック ---
if [ -z "$RELAY_URL" ]; then
  echo "使い方: bash scripts/build-pipeline.sh <ngrok-url>"
  echo "例:     bash scripts/build-pipeline.sh https://xxxx.ngrok-free.app"
  exit 1
fi

# --- Step 0: 接続確認 ---
log "Step 0: 中継サーバー接続確認"
COMMANDS=$(curl -s -X GET "${RELAY_URL}/api/commands" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "ngrok-skip-browser-warning: true" 2>/dev/null)

if echo "$COMMANDS" | python3 -c "import sys,json; cmds=json.load(sys.stdin); print(len(cmds),'コマンド利用可能')" 2>/dev/null; then
  echo "  ✓ 接続OK"
else
  fail "中継サーバーに接続できません: ${RELAY_URL}"
fi

# --- Step 1: Flutter Build ---
execute_command "flutter_build_ios_release" "" "Step 1: Flutter Build iOS Release" 300

# --- Step 2: Xcode Release Pipeline ---
PIPELINE_PARAMS='{
  "workspace": "ios/Runner.xcworkspace",
  "scheme": "Runner",
  "exportOptionsPlist": "ios/ExportOptions.plist",
  "apiKey": "P7PDD4P69G",
  "apiIssuer": "e359cd97-a6d4-4ef9-bcb3-24336fda0e74"
}'
execute_command "xcode_release_pipeline" "$PIPELINE_PARAMS" "Step 2: Xcode Archive + Export + Upload" 600

# --- 完了 ---
log "パイプライン完了"
echo "App Store Connect でビルドの処理状況を確認してください。"
echo "https://appstoreconnect.apple.com/apps/6759194623"
