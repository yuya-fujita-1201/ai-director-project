#!/bin/bash
# ============================================================
# iPad Screenshot Full Flow
# Executes relay capture command, waits for completion, then downloads 5 files.
# ============================================================

set -euo pipefail

RELAY_URL="${RELAY_URL:-${1:-}}"
RELAY_TOKEN="${RELAY_TOKEN:-${2:-}}"
OUTPUT_DIR="${3:-${IPAD_SCREENSHOT_OUTPUT_DIR:-/tmp/ipad-screenshots}}"
SOURCE_DIR="${4:-${IPAD_SCREENSHOT_SOURCE_DIR:-/Users/yuyafujita/Projects/ai-director-project/assets/screenshots/ipad}}"
POLL_INTERVAL="${POLL_INTERVAL:-2}"
MAX_POLLS="${MAX_POLLS:-900}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CAPTURE_COMMAND_ID="${CAPTURE_COMMAND_ID:-ipad_screenshot_capture}"

if [[ -z "$RELAY_URL" || -z "$RELAY_TOKEN" ]]; then
  echo "Usage:"
  echo "  RELAY_URL=https://<your-relay> RELAY_TOKEN=<token> bash $(basename "$0")"
  echo "or"
  echo "  bash $(basename "$0") <RELAY_URL> <RELAY_TOKEN> [OUTPUT_DIR] [SOURCE_DIR]"
  echo ""
  echo "Optional env:"
  echo "  POLL_INTERVAL (default: 2 seconds)"
  echo "  MAX_POLLS (default: 900)"
  echo "  IPAD_SCREENSHOT_SOURCE_DIR (default: /Users/yuyafujita/Projects/ai-director-project/assets/screenshots/ipad)"
  echo "  IPAD_SCREENSHOT_OUTPUT_DIR (default: /tmp/ipad-screenshots)"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

log() {
  echo "[fullflow] $1"
}

json_value() {
  local json="$1"
  local key="$2"
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$json" "$key" <<'PY'
import sys
import json
payload = sys.argv[1]
key = sys.argv[2]
try:
    data = json.loads(payload)
except Exception:
    print("")
    raise SystemExit(1)
print(data.get(key, ""))
PY
  else
    echo ""
  fi
}

capture_payload() {
  cat <<JSON
{
  "id": "${CAPTURE_COMMAND_ID}",
  "params": {
    "scriptPath": "/Users/yuyafujita/Projects/ai-director-project/scripts/ipad-screenshots.sh"
  },
  "async": true
}
JSON
}

log "Start iPad screenshot capture..."
RESPONSE="$(curl -sS -X POST "${RELAY_URL%/}/api/execute" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${RELAY_TOKEN}" \
  -d "$(capture_payload)")"

if ! echo "$RESPONSE" | grep -q '"ok": true'; then
  echo "[fullflow] failed to start capture: $RESPONSE"
  exit 1
fi

JOB_ID="$(json_value "$RESPONSE" jobId)"
if [[ -z "$JOB_ID" ]]; then
  echo "[fullflow] no jobId returned: $RESPONSE"
  exit 1
fi

log "Capture started. Job ID: $JOB_ID"

poll_count=0
while true; do
  poll_count=$((poll_count + 1))
  if (( poll_count > MAX_POLLS )); then
    echo "[fullflow] timeout while waiting for capture job."
    exit 1
  fi

  JOB_RESPONSE="$(curl -sS -X GET "${RELAY_URL%/}/api/jobs/${JOB_ID}" \
    -H "Authorization: Bearer ${RELAY_TOKEN}")"
  STATUS="$(json_value "$JOB_RESPONSE" status)"

  if [[ "$STATUS" == "succeeded" ]]; then
    log "Capture completed: $JOB_ID"
    break
  fi
  if [[ "$STATUS" == "failed" ]]; then
    echo "[fullflow] capture failed: $JOB_RESPONSE"
    exit 1
  fi

  if [[ -z "$STATUS" ]]; then
    echo "[fullflow] unexpected job response: $JOB_RESPONSE"
    exit 1
  fi

  log "Waiting... status=${STATUS}"
  sleep "$POLL_INTERVAL"
done

log "Downloading 5 screenshot images..."
bash "${SCRIPT_DIR}/download-ipad-screenshots.sh" \
  "$RELAY_URL" \
  "$RELAY_TOKEN" \
  "$OUTPUT_DIR" \
  "$SOURCE_DIR"

log "Done. Files:"
ls -lh "$OUTPUT_DIR"/*.png 2>/dev/null || true
