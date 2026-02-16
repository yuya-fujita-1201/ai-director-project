#!/bin/bash
# ============================================================
# Download iPad screenshots from relay download API in one command
# ============================================================

set -euo pipefail

RELAY_URL="${1:-${RELAY_URL:-}}"
RELAY_TOKEN="${2:-${RELAY_TOKEN:-}}"
OUTPUT_DIR="${3:-${IPAD_SCREENSHOT_OUTPUT_DIR:-/Users/yuyafujita/Projects/ai-director-project/assets/screenshots/ipad}}"
SOURCE_DIR="${4:-${IPAD_SCREENSHOT_SOURCE_DIR:-/Users/yuyafujita/Projects/ai-director-project/assets/screenshots/ipad}}"

if [[ -z "$RELAY_URL" || -z "$RELAY_TOKEN" ]]; then
  echo "Usage:"
  echo "  bash $(basename "$0") <RELAY_URL> <RELAY_TOKEN> [OUTPUT_DIR] [SOURCE_DIR]"
  echo ""
  echo "Example:"
  echo "  RELAY_URL='https://example.ngrok-free.app' RELAY_TOKEN='snap2026' \\"
  echo "  bash $(basename "$0") \"\$RELAY_URL\" \"\$RELAY_TOKEN\" \"/tmp/ipad-screenshots\""
  exit 1
fi

mkdir -p "$OUTPUT_DIR"
mkdir -p "$(dirname "$OUTPUT_DIR")"

log() {
  echo "[download] $1"
}

urlencode() {
  local raw="$1"
if command -v python3 >/dev/null 2>&1; then
    python3 - "$raw" <<'PY'
import sys
from urllib.parse import quote
print(quote(sys.argv[1], safe=''))
PY
  else
    echo "$raw"
  fi
}

declare -a FILES=(
  "home_screen_ipad.png"
  "result_screen_ipad.png"
  "favorites_screen_ipad.png"
  "history_screen_ipad.png"
  "premium_paywall_ipad.png"
)

log "Downloading iPad screenshots from relay..."
for file_name in "${FILES[@]}"; do
  remote_path="${SOURCE_DIR}/${file_name}"
  encoded_path="$(urlencode "$remote_path")"
  output_file="${OUTPUT_DIR}/${file_name}"

  log "  -> ${file_name}"
  if curl -L -f -sS \
    --retry 2 \
    --connect-timeout 20 \
    -H "Authorization: Bearer ${RELAY_TOKEN}" \
    "${RELAY_URL%/}/api/files/download?path=${encoded_path}" \
    -o "$output_file"; then
    log "     saved: $output_file"
  else
    echo "     failed: $file_name"
  fi
done

log "Done. Files in $OUTPUT_DIR:"
ls -lh "$OUTPUT_DIR"/*.png 2>/dev/null || true
