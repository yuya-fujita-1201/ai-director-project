#!/bin/bash
# ============================================================
# iPad Screenshot Utilities
# Helper functions for managing and validating screenshots
# ============================================================

set -e

# Configuration
PROJECT_DIR="${HOME}/Projects/ai-director-project"
SCREENSHOTS_DIR="${PROJECT_DIR}/assets/screenshots/ipad"
LOG_FILE="${PROJECT_DIR}/logs/ipad-screenshot-utils.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================
# Helper Functions
# ============================================================

log() {
  echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
  echo -e "${GREEN}[✓]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
  echo -e "${RED}[✗]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
  echo -e "${YELLOW}[!]${NC} $1" | tee -a "$LOG_FILE"
}

# ============================================================
# Validate Screenshots
# ============================================================

validate_screenshots() {
  log "Validating iPad screenshots..."

  if [ ! -d "$SCREENSHOTS_DIR" ]; then
    error "Screenshot directory not found: $SCREENSHOTS_DIR"
    return 1
  fi

  # App Store required sizes for iPad
  VALID_WIDTHS=(2064 2732 2048)
  VALID_HEIGHTS=(2752 2064 2732)

  PNG_COUNT=$(find "$SCREENSHOTS_DIR" -maxdepth 1 -name "*.png" -type f | wc -l)

  if [ "$PNG_COUNT" -eq 0 ]; then
    warning "No screenshots found in $SCREENSHOTS_DIR"
    return 1
  fi

  success "Found $PNG_COUNT screenshot(s)"
  echo ""

  local all_valid=true

  while IFS= read -r file; do
    filename=$(basename "$file")
    dims=$(identify "$file" 2>/dev/null | grep -oE "[0-9]+ x [0-9]+" | head -1)

    if [ -z "$dims" ]; then
      error "Could not read dimensions: $filename"
      all_valid=false
      continue
    fi

    width=$(echo "$dims" | cut -d' ' -f1)
    height=$(echo "$dims" | cut -d' ' -f3)
    size=$(du -h "$file" | cut -f1)

    # Check if dimensions match App Store requirements
    is_valid=false
    for valid_w in "${VALID_WIDTHS[@]}"; do
      for valid_h in "${VALID_HEIGHTS[@]}"; do
        if [ "$width" -eq "$valid_w" ] && [ "$height" -eq "$valid_h" ]; then
          is_valid=true
          break 2
        fi
      done
    done

    if [ "$is_valid" = true ]; then
      success "$filename: ${width}x${height} (${size}) ✓"
    else
      warning "$filename: ${width}x${height} (${size}) ⚠ Not standard iPad size"
      all_valid=false
    fi
  done < <(find "$SCREENSHOTS_DIR" -maxdepth 1 -name "*.png" -type f | sort)

  echo ""
  if [ "$all_valid" = true ]; then
    success "All screenshots are valid App Store sizes!"
    return 0
  else
    warning "Some screenshots may need resizing for App Store submission"
    return 1
  fi
}

# ============================================================
# List Screenshots
# ============================================================

list_screenshots() {
  log "iPad Screenshots:"
  echo ""

  if [ ! -d "$SCREENSHOTS_DIR" ]; then
    error "Screenshot directory not found: $SCREENSHOTS_DIR"
    return 1
  fi

  if [ -z "$(find "$SCREENSHOTS_DIR" -maxdepth 1 -name "*.png" -type f)" ]; then
    warning "No screenshots found"
    return 0
  fi

  printf "%-40s %-15s %s\n" "Filename" "Dimensions" "Size"
  printf "%s\n" "$(printf '=%.0s' {1..70})"

  while IFS= read -r file; do
    filename=$(basename "$file")
    dims=$(identify "$file" 2>/dev/null | grep -oE "[0-9]+ x [0-9]+" | head -1)
    size=$(du -h "$file" | cut -f1)

    printf "%-40s %-15s %s\n" "$filename" "$dims" "$size"
  done < <(find "$SCREENSHOTS_DIR" -maxdepth 1 -name "*.png" -type f | sort)

  echo ""
  success "Total: $(find "$SCREENSHOTS_DIR" -maxdepth 1 -name "*.png" -type f | wc -l) screenshot(s)"
}

# ============================================================
# Clean Screenshots
# ============================================================

clean_screenshots() {
  if [ ! -d "$SCREENSHOTS_DIR" ]; then
    warning "No screenshots directory to clean"
    return 0
  fi

  PNG_COUNT=$(find "$SCREENSHOTS_DIR" -maxdepth 1 -name "*.png" -type f | wc -l)

  if [ "$PNG_COUNT" -eq 0 ]; then
    warning "No screenshots to clean"
    return 0
  fi

  echo "Found $PNG_COUNT screenshots in $SCREENSHOTS_DIR"
  read -p "Delete all iPad screenshots? (y/N): " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    find "$SCREENSHOTS_DIR" -maxdepth 1 -name "*.png" -type f -delete
    success "Screenshots deleted"
  else
    log "Cleanup cancelled"
  fi
}

# ============================================================
# Get Screenshot Directory
# ============================================================

show_directory() {
  echo "$SCREENSHOTS_DIR"
}

# ============================================================
# Open in Finder/Editor
# ============================================================

open_directory() {
  if [ ! -d "$SCREENSHOTS_DIR" ]; then
    error "Screenshot directory not found"
    return 1
  fi

  if [ "$(uname)" == "Darwin" ]; then
    open "$SCREENSHOTS_DIR"
    success "Opened in Finder: $SCREENSHOTS_DIR"
  else
    error "Not on macOS"
    return 1
  fi
}

# ============================================================
# Main
# ============================================================

COMMAND="${1:-help}"

case "$COMMAND" in
  validate)
    validate_screenshots
    ;;
  list)
    list_screenshots
    ;;
  clean)
    clean_screenshots
    ;;
  dir)
    show_directory
    ;;
  open)
    open_directory
    ;;
  *)
    cat << 'EOF'
iPad Screenshot Utilities

Usage:
  ./ipad-screenshot-utils.sh <command>

Commands:
  validate    - Validate screenshot dimensions for App Store
  list        - List all iPad screenshots
  clean       - Delete all iPad screenshots (with confirmation)
  dir         - Show screenshot directory path
  open        - Open screenshot directory in Finder (macOS only)
  help        - Show this help message

Examples:
  ./ipad-screenshot-utils.sh list
  ./ipad-screenshot-utils.sh validate
  ./ipad-screenshot-utils.sh open
EOF
    ;;
esac
