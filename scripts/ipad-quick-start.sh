#!/bin/bash
# ============================================================
# iPad Screenshots Quick Start
# One-command setup and execution
# ============================================================

set -e

PROJECT_DIR="${HOME}/Projects/ai-director-project"
SCRIPTS_DIR="${PROJECT_DIR}/scripts"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ============================================================
# Display Menu
# ============================================================

show_menu() {
  clear
  echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║   SnapEnglish iPad Screenshots Menu   ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
  echo ""
  echo "1) Start screenshot capture process"
  echo "2) Validate existing screenshots"
  echo "3) List all screenshots"
  echo "4) Open screenshots in Finder"
  echo "5) Delete all screenshots"
  echo "6) View documentation"
  echo "7) View capture log"
  echo "8) Exit"
  echo ""
}

# ============================================================
# Menu Actions
# ============================================================

start_capture() {
  echo -e "${YELLOW}Starting screenshot capture...${NC}"
  echo ""
  bash "$SCRIPTS_DIR/ipad-screenshots.sh"
}

validate() {
  echo -e "${YELLOW}Validating screenshots...${NC}"
  echo ""
  bash "$SCRIPTS_DIR/ipad-screenshot-utils.sh" validate
}

list_screenshots() {
  echo -e "${YELLOW}Listing screenshots...${NC}"
  echo ""
  bash "$SCRIPTS_DIR/ipad-screenshot-utils.sh" list
}

open_folder() {
  echo -e "${YELLOW}Opening screenshot folder...${NC}"
  echo ""
  bash "$SCRIPTS_DIR/ipad-screenshot-utils.sh" open
}

delete_screenshots() {
  echo -e "${YELLOW}Deleting screenshots...${NC}"
  echo ""
  bash "$SCRIPTS_DIR/ipad-screenshot-utils.sh" clean
}

view_docs() {
  echo -e "${YELLOW}Opening documentation...${NC}"
  echo ""
  if [ "$(uname)" == "Darwin" ]; then
    open "$PROJECT_DIR/docs/IPAD_SCREENSHOTS_GUIDE.md"
  else
    cat "$PROJECT_DIR/docs/IPAD_SCREENSHOTS_GUIDE.md" | less
  fi
}

view_log() {
  echo -e "${YELLOW}Screenshot capture log:${NC}"
  echo ""
  if [ -f "$PROJECT_DIR/logs/ipad-screenshots.log" ]; then
    tail -50 "$PROJECT_DIR/logs/ipad-screenshots.log"
  else
    echo "No log file found yet"
  fi
  echo ""
  read -p "Press Enter to continue..."
}

# ============================================================
# Main Loop
# ============================================================

while true; do
  show_menu

  read -p "Select option (1-8): " choice

  case $choice in
    1)
      start_capture
      ;;
    2)
      validate
      echo ""
      read -p "Press Enter to continue..."
      ;;
    3)
      list_screenshots
      echo ""
      read -p "Press Enter to continue..."
      ;;
    4)
      open_folder
      read -p "Press Enter to continue..."
      ;;
    5)
      delete_screenshots
      read -p "Press Enter to continue..."
      ;;
    6)
      view_docs
      ;;
    7)
      view_log
      ;;
    8)
      echo -e "${GREEN}Goodbye!${NC}"
      exit 0
      ;;
    *)
      echo -e "${YELLOW}Invalid option. Please try again.${NC}"
      sleep 2
      ;;
  esac
done
