#!/bin/bash
# ============================================================
# iPad Pro Screenshots Capture Script
# Non-interactive (AUTO_MODE=1) and interactive (AUTO_MODE=0) modes.
# Auto mode now supports automatic tab navigation and best-effort taps.
# ============================================================

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

PROJECT_DIR="${HOME}/Projects/ai-director-project"
APP_DIR="${PROJECT_DIR}/app/snap_english"
SCREENSHOTS_DIR="${PROJECT_DIR}/assets/screenshots/ipad"
LOG_FILE="${PROJECT_DIR}/logs/ipad-screenshots.log"
WORK_DIR="${APP_DIR}/build/ios/iphonesimulator"
DEFAULT_BUNDLE_ID="com.marumiworks.snapEnglish"

AUTO_MODE="${AUTO_MODE:-0}"
if [[ ! -t 0 ]]; then
  AUTO_MODE=1
fi

AUTO_SHOT_WAIT_SECONDS="${AUTO_SHOT_WAIT_SECONDS:-8}"
POST_SHOT_WAIT_SECONDS="${POST_SHOT_WAIT_SECONDS:-2}"
TAB_NAVIGATION_WAIT_SECONDS="${TAB_NAVIGATION_WAIT_SECONDS:-2}"
KEEP_SIMULATOR="${KEEP_SIMULATOR:-0}"
PREPARE_HISTORY="${PREPARE_HISTORY:-1}"
AUTO_TAP_TIMEOUT_SECONDS="${AUTO_TAP_TIMEOUT_SECONDS:-2}"
HISTORY_SEED="${HISTORY_SEED:-1}"

TAB_Y_RATIO=0.966
CAMERA_X_RATIO=0.500
CAMERA_Y_RATIO=0.525
TOPBAR_BACK_X_RATIO=0.065
TOPBAR_BACK_Y_RATIO=0.063
PAYWALL_ICON_X_RATIO=0.940
PAYWALL_ICON_Y_RATIO=0.063
HISTORY_FIRST_CARD_X_RATIO=0.500
HISTORY_FIRST_CARD_Y_RATIO=0.330
RESULT_TO_HISTORY_BACK_Y_RATIO=0.061

mkdir -p "$SCREENSHOTS_DIR" "$(dirname "$LOG_FILE")"

# ============================================================
# Colors
# ============================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================
# Helpers
# ============================================================

log() {
  echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
  echo -e "${GREEN}[OK]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
  echo -e "${RED}[NG]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
  echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

prompt_continue() {
  echo ""
  if [[ "$AUTO_MODE" -eq 1 ]]; then
    return
  fi
  read -r -p "Press Enter to capture now..." -n 1 -r
  echo
  echo ""
}

read_bundle_id() {
  local plist="$1"
  local bundle_id=""

  bundle_id="$(plutil -extract CFBundleIdentifier raw "$plist" 2>/dev/null || true)"
  if [ -z "$bundle_id" ]; then
    bundle_id="$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$plist" 2>/dev/null || true)"
  fi
  if [ -z "$bundle_id" ]; then
    bundle_id="$DEFAULT_BUNDLE_ID"
  fi

  printf "%s\n" "$bundle_id"
}

get_simulator_front_window_geometry() {
  local geom
  geom="$(osascript <<'OS'
tell application "System Events"
  tell process "Simulator"
    set frontWin to front window
    set p to position of frontWin
    set s to size of frontWin
    return item 1 of p & "," & item 2 of p & "," & item 1 of s & "," & item 2 of s
  end tell
end tell
OS
)"
  echo "$geom"
}

tap_screen_point() {
  local ratio_x="$1"
  local ratio_y="$2"
  local geometry
  local win_x win_y win_w win_h
  local x y

  geometry="$(get_simulator_front_window_geometry || true)"
  if [ -z "$geometry" ]; then
    warning "Could not get Simulator window geometry. Skipping tap."
    return 1
  fi

  IFS=',' read -r win_x win_y win_w win_h <<< "$geometry"
  if [ -z "$win_x" ] || [ -z "$win_y" ] || [ -z "$win_w" ] || [ -z "$win_h" ]; then
    warning "Invalid simulator geometry: $geometry"
    return 1
  fi

  x="$(awk -v w="$win_x" -v ww="$win_w" -v rx="$ratio_x" 'BEGIN { printf "%.0f", w + (ww * rx) }')"
  y="$(awk -v h="$win_y" -v wh="$win_h" -v ry="$ratio_y" 'BEGIN { printf "%.0f", h + (wh * ry) }')"

  log "Tap @ (${x}, ${y})"
  if ! osascript <<OS
tell application "System Events"
  click at {$x, $y}
end tell
OS
  then
    warning "tap failed at ${x},${y}"
    return 1
  fi
}

wait_for_render() {
  local sec="$1"
  log "Wait ${sec}s ..."
  sleep "$sec"
}

take_screenshot() {
  local device_udid="$1"
  local out_file="$2"

  if xcrun simctl io "$device_udid" screenshot "$out_file" 2>&1 | tee -a "$LOG_FILE"; then
    success "Screenshot saved: $out_file"
    if [ -f "$out_file" ]; then
      local file_size
      local dim
      file_size="$(ls -lh "$out_file" | awk '{print $5}')"
      dim="$(identify "$out_file" 2>/dev/null | grep -oE "[0-9]+ x [0-9]+" | head -1 || true)"
      if [ -n "$dim" ]; then
        success "  Size: $file_size | Dimensions: $dim"
      fi
    fi
    return 0
  fi

  error "Failed to capture: $out_file"
  return 1
}

tap_bottom_tab() {
  local tab_index="$1"
  local ratio_x
  case "$tab_index" in
    0) ratio_x=0.167 ;;
    1) ratio_x=0.500 ;;
    2) ratio_x=0.833 ;;
    *)
      warning "Unknown tab index: $tab_index"
      return 1
      ;;
  esac

  tap_screen_point "$ratio_x" "$TAB_Y_RATIO"
  wait_for_render "$TAB_NAVIGATION_WAIT_SECONDS"
}

tap_paywall_icon() {
  tap_screen_point "$PAYWALL_ICON_X_RATIO" "$PAYWALL_ICON_Y_RATIO"
  wait_for_render "$TAB_NAVIGATION_WAIT_SECONDS"
}

tap_history_first_card() {
  tap_screen_point "$HISTORY_FIRST_CARD_X_RATIO" "$HISTORY_FIRST_CARD_Y_RATIO"
  wait_for_render "$TAB_NAVIGATION_WAIT_SECONDS"
}

tap_back() {
  tap_screen_point "$TOPBAR_BACK_X_RATIO" "$TOPBAR_BACK_Y_RATIO"
  wait_for_render "$TAB_NAVIGATION_WAIT_SECONDS"
}

prepare_seed_history_data() {
  if [[ "$HISTORY_SEED" != "1" ]]; then
    return 1
  fi
  if ! command -v sqlite3 >/dev/null; then
    warning "sqlite3 is not installed. Skip fake history seeding."
    return 1
  fi

  log "Preparing seed history/favorite data in simulator app container..."
  local app_container
  app_container="$(xcrun simctl get_app_container "$IPAD_DEVICE" "$BUNDLE_ID" data 2>/dev/null || true)"
  if [ -z "$app_container" ]; then
    warning "Cannot resolve app container; skip history seed."
    return 1
  fi

  local db_path image_path
  db_path="${app_container}/Documents/snap_english.db"
  mkdir -p "${app_container}/Documents/images"
  image_path="${app_container}/Documents/images/screenshot_seed.png"
  cp "$APP_DIR/assets/icon/app_icon_foreground.png" "$image_path"

  # Ensure schema
  sqlite3 "$db_path" <<SQL
CREATE TABLE IF NOT EXISTS scan_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  image_path TEXT NOT NULL,
  scanned_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS phrases (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  scan_id INTEGER NOT NULL,
  english TEXT NOT NULL,
  japanese TEXT NOT NULL,
  difficulty TEXT NOT NULL DEFAULT 'beginner',
  is_favorite INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  FOREIGN KEY (scan_id) REFERENCES scan_history (id)
);
SQL

  local scan_count
  scan_count="$(sqlite3 "$db_path" "SELECT COUNT(*) FROM scan_history;" 2>/dev/null || echo 0)"
  if [ "${scan_count:-0}" -ge 1 ]; then
    log "History already exists in DB. Keep existing data."
    return 0
  fi

  local now_iso
  now_iso="$(date -u +'%Y-%m-%dT%H:%M:%S.000Z')"

  local scan_id
  scan_id="$(sqlite3 "$db_path" "INSERT INTO scan_history (image_path, scanned_at) VALUES ('$image_path', '$now_iso'); SELECT last_insert_rowid();")"
  sqlite3 "$db_path" "INSERT INTO phrases (scan_id, english, japanese, difficulty, is_favorite, created_at) VALUES ($scan_id, 'Good morning', 'おはよう', 'beginner', 1, '$now_iso');"
  sqlite3 "$db_path" "INSERT INTO phrases (scan_id, english, japanese, difficulty, is_favorite, created_at) VALUES ($scan_id, 'How are you?', 'ごきげんいかが？', 'intermediate', 1, '$now_iso');"
  success "Seed history+favorites created (scan_id=${scan_id})"
}

capture_with_navigation_sequence() {
  log "Starting auto navigation + capture sequence..."

  # 1. Home
  log "[1/5] Home"
  take_screenshot "$IPAD_DEVICE" "${SCREENSHOTS_DIR}/home_screen_ipad.png"
  wait_for_render "$AUTO_SHOT_WAIT_SECONDS"

  # 2. History (tab)
  log "[2/5] History"
  tap_bottom_tab 1
  take_screenshot "$IPAD_DEVICE" "${SCREENSHOTS_DIR}/history_screen_ipad.png"
  wait_for_render "$AUTO_SHOT_WAIT_SECONDS"

  # 3. Result (history first card)
  log "[3/5] Result"
  local had_seed=0
  if prepare_seed_history_data; then
    had_seed=1
  fi
  if [[ "$had_seed" -eq 1 ]]; then
    tap_history_first_card || warning "Could not tap history card."
    wait_for_render "$AUTO_SHOT_WAIT_SECONDS"
    take_screenshot "$IPAD_DEVICE" "${SCREENSHOTS_DIR}/result_screen_ipad.png"
    tap_back || warning "Could not tap back."
    wait_for_render "$TAB_NAVIGATION_WAIT_SECONDS"
  else
    warning "History seed skipped; result capture fallback: re-use History view."
    take_screenshot "$IPAD_DEVICE" "${SCREENSHOTS_DIR}/result_screen_ipad.png"
  fi
  wait_for_render "$POST_SHOT_WAIT_SECONDS"

  # 4. Favorites (tab)
  log "[4/5] Favorites"
  tap_bottom_tab 2
  take_screenshot "$IPAD_DEVICE" "${SCREENSHOTS_DIR}/favorites_screen_ipad.png"
  wait_for_render "$AUTO_SHOT_WAIT_SECONDS"

  # 5. Paywall
  log "[5/5] Paywall"
  tap_bottom_tab 0
  tap_paywall_icon
  take_screenshot "$IPAD_DEVICE" "${SCREENSHOTS_DIR}/premium_paywall_ipad.png"
  wait_for_render "$POST_SHOT_WAIT_SECONDS"
}

capture_interactive() {
  # Define screenshot sequence
  declare -a SCREENS=(
    "Home Screen|home_screen_ipad.png"
    "Result Screen (after taking photo)|result_screen_ipad.png"
    "Favorites Screen|favorites_screen_ipad.png"
    "Learning History Screen|history_screen_ipad.png"
    "Premium/Paywall Screen|premium_paywall_ipad.png"
  )

  log ""
  log "========================================"
  log "Screenshot Capture - Interactive Mode"
  log "========================================"
  log "Press Enter after each screen is ready."

  local SCREENSHOT_NUM=1
  local screen_info
  local screen_name filename
  for screen_info in "${SCREENS[@]}"; do
    IFS='|' read -r screen_name filename <<< "$screen_info"
    echo ""
    echo -e "${YELLOW}Step ${SCREENSHOT_NUM}/${#SCREENS[@]}${NC}"
    echo "Navigate to: ${BLUE}${screen_name}${NC}"
    echo "Will save as: ${BLUE}${filename}${NC}"

    prompt_continue
    local screenshot_path="${SCREENSHOTS_DIR}/${filename}"
    take_screenshot "$IPAD_DEVICE" "$screenshot_path"
    sleep "$POST_SHOT_WAIT_SECONDS"

    SCREENSHOT_NUM=$((SCREENSHOT_NUM + 1))
  done
}

# ============================================================
# Start
# ============================================================

log "Starting iPad Screenshots Capture Process"

if [ ! -d "$APP_DIR" ]; then
  error "Flutter app directory not found: $APP_DIR"
  exit 1
fi

success "Found Flutter app at: $APP_DIR"

# ============================================================
# Find iPad Pro simulator
# ============================================================

log "Finding iPad Pro simulator..."
IPAD_DEVICE="$(xcrun simctl list devices available | grep -E "iPad Pro \\(13-inch|iPad Pro \\(12\\.9" | head -1 | sed 's/.*(\\([A-F0-9-]*\\)).*/\\1/' | xargs || true)"

if [ -z "$IPAD_DEVICE" ]; then
  warning "No iPad Pro simulator found. Attempting to create one..."
  RUNTIME="$(xcrun simctl list runtimes | grep "iOS" | tail -1 | awk '{print $NF}' || true)"
  if [ -z "$RUNTIME" ]; then
    error "No iOS runtime found. Please install Xcode."
    exit 1
  fi

  log "Creating iPad Pro 12.9-inch simulator with runtime $RUNTIME..."
  IPAD_DEVICE="$(xcrun simctl create "iPad Pro 12.9 (SnapEnglish)" "iPad Pro (12.9-inch) (6th generation)" "$RUNTIME" | xargs || true)"
  if [ -z "$IPAD_DEVICE" ]; then
    error "Failed to create iPad simulator"
    exit 1
  fi
  success "Created iPad simulator: $IPAD_DEVICE"
else
  success "Found iPad Pro simulator: $IPAD_DEVICE"
fi

# ============================================================
# Boot simulator
# ============================================================

log "Checking simulator state..."
if xcrun simctl list devices | grep -q "${IPAD_DEVICE}.*Booted"; then
  success "Simulator already booted"
else
  log "Booting iPad simulator..."
  xcrun simctl boot "$IPAD_DEVICE"
  log "Waiting for simulator boot (15 seconds)..."
  sleep 15
  success "Simulator booted"
fi

# ============================================================
# Build Flutter app (simulator debug)
# ============================================================

log "Building Flutter app for simulator (debug)..."
cd "$APP_DIR"
if ! flutter build ios --simulator --debug 2>&1 | tee -a "$LOG_FILE"; then
  error "flutter build ios --simulator --debug failed"
  exit 1
fi
success "Flutter app built successfully"

# ============================================================
# Find and install app bundle
# ============================================================

log "Locating built app bundle..."
APP_BUNDLE=""
if [ -d "${WORK_DIR}/Runner.app" ]; then
  APP_BUNDLE="${WORK_DIR}/Runner.app"
else
  APP_BUNDLE="$(find "$WORK_DIR" -type d -name "*.app" -print -quit 2>/dev/null || true)"
fi

if [ -z "$APP_BUNDLE" ] || [ ! -d "$APP_BUNDLE" ]; then
  warning "App bundle not found in $WORK_DIR, searching full build directory..."
  APP_BUNDLE="$(find "$APP_DIR/build" -type d -name "*.app" -print -quit 2>/dev/null || true)"
fi

if [ -z "$APP_BUNDLE" ] || [ ! -d "$APP_BUNDLE" ]; then
  error "Could not find built app bundle"
  exit 1
fi

success "Found app bundle: $APP_BUNDLE"

log "Installing app on simulator..."
if ! xcrun simctl install "$IPAD_DEVICE" "$APP_BUNDLE" 2>&1 | tee -a "$LOG_FILE"; then
  error "Failed to install app on simulator"
  exit 1
fi
success "App installed successfully"

# ============================================================
# Read bundle ID and launch
# ============================================================

log "Reading bundle ID from built app..."
BUNDLE_ID="$(read_bundle_id "$APP_BUNDLE/Info.plist")"
log "Using bundle ID: $BUNDLE_ID"

log "Launching app on simulator..."
xcrun simctl launch "$IPAD_DEVICE" "$BUNDLE_ID"
log "Waiting for app to render (8 seconds)..."
sleep 8
success "App should now be visible"

if [[ "$AUTO_MODE" -eq 1 ]]; then
  log "Non-interactive / auto-navigation mode."
  capture_with_navigation_sequence
else
  capture_interactive
fi

# ============================================================
# Summary
# ============================================================

log ""
log "========================================"
log "Screenshot Capture Complete!"
log "========================================"
log ""
log "Captured screenshots:"
ls -lh "$SCREENSHOTS_DIR"/*.png 2>/dev/null | awk '{print "  " $9 " (" $5 ")"' || true
success "All screenshots saved to: $SCREENSHOTS_DIR"
log "Log file: $LOG_FILE"

# ============================================================
# Cleanup
# ============================================================

if [[ "$AUTO_MODE" -eq 0 ]]; then
  read -r -p "Keep simulator running? (y/n): " -n 1
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    KEEP_SIMULATOR=0
  else
    KEEP_SIMULATOR=1
  fi
fi

if [[ "$KEEP_SIMULATOR" -eq 0 ]]; then
  log "Shutting down simulator..."
  xcrun simctl shutdown "$IPAD_DEVICE"
  success "Simulator shut down"
fi

log "Done!"
