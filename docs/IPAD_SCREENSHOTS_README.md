# iPad Screenshots - Quick Reference

## What's Included

Three shell scripts have been created to automate iPad screenshot capture for App Store submission:

### 1. **ipad-screenshots.sh** - Main Capture Script
The core script that handles the complete screenshot capture workflow.

**What it does:**
- Auto-detects or creates an iPad Pro simulator
- Boots the simulator
- Builds the Flutter app for iOS simulator
- Installs and launches the app
- Guides you through capturing 5 screenshots interactively
- Saves screenshots to `assets/screenshots/ipad/`

**Run it:**
```bash
bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
```

**Output:** 5 PNG screenshots at iPad Pro resolution
- `home_screen_ipad.png`
- `result_screen_ipad.png`
- `favorites_screen_ipad.png`
- `history_screen_ipad.png`
- `premium_paywall_ipad.png`

### 2. **ipad-screenshot-utils.sh** - Utility Script
Provides helper functions for managing and validating screenshots.

**Available commands:**
```bash
# Validate App Store compliance
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh validate

# List all screenshots with details
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh list

# Open screenshot folder in Finder
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh open

# Delete all screenshots (with confirmation)
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh clean

# Show screenshot directory path
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh dir
```

### 3. **ipad-quick-start.sh** - Interactive Menu
User-friendly menu-driven interface for all screenshot operations.

**Run it:**
```bash
bash ~/Projects/ai-director-project/scripts/ipad-quick-start.sh
```

**Menu options:**
1. Start screenshot capture
2. Validate screenshots
3. List screenshots
4. Open in Finder
5. Delete screenshots
6. View documentation
7. View capture log
8. Exit

---

## Quick Start (5 Minutes)

### Minimum Steps

```bash
# 1. Run the main capture script
bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh

# 2. Follow on-screen prompts to navigate app screens
# 3. Press Enter to capture each screenshot

# 4. Verify results
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh list

# 5. Validate for App Store
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh validate
```

### Using the Menu Interface

```bash
bash ~/Projects/ai-director-project/scripts/ipad-quick-start.sh
```

Then select option 1 from the menu.

---

## System Requirements

**macOS:**
- macOS 10.15 or later (Catalina+)
- Apple Silicon (M1/M2) or Intel Mac

**Development Tools:**
- Xcode 12+ with iOS SDK
- Flutter 3.0+ installed
- ImageMagick (optional, for validation)

**Installation:**
```bash
# Install ImageMagick for screenshot validation
brew install imagemagick
```

---

## How the Scripts Work

### Script Flow Diagram

```
ipad-screenshots.sh
├── Validate project directory
├── Find or create iPad Pro simulator
│   └── Uses xcrun simctl to list/create devices
├── Boot simulator
│   └── Waits 15 seconds for full boot
├── Build Flutter app
│   └── flutter build ios --simulator
├── Find and install app bundle
│   └── xcrun simctl install
├── Launch app
│   └── xcrun simctl launch
├── Wait for app to load (8 seconds)
└── Interactive screenshot loop
    ├── Prompt user to navigate to screen
    ├── Wait for user to press Enter
    ├── Capture screenshot
    │   └── xcrun simctl io <device> screenshot
    ├── Display file info
    └── Repeat for 5 screens
└── Summary and cleanup
    └── Offer to shutdown simulator

ipad-screenshot-utils.sh
├── validate - Check dimensions against App Store specs
├── list - Display all screenshots with metadata
├── clean - Delete screenshots with confirmation
├── dir - Return screenshot directory path
└── open - Open in Finder (macOS only)
```

---

## Screenshot Specifications

### App Store Requirements

**Valid iPad Pro Sizes:**
- 2064 × 2752 px (portrait)
- 2732 × 2064 px (landscape)
- 2048 × 2732 px (portrait alternative)
- 2732 × 2048 px (landscape alternative)

**File Format:**
- PNG (recommended)
- Maximum 50 MB per file
- RGB or RGBA color space

### What to Capture

Each screenshot should show:

1. **Home Screen** - Initial app state with main UI
2. **Result Screen** - After taking a photo, showing generated phrases
3. **Favorites Screen** - Saved/bookmarked items
4. **History/Learning Screen** - Previous captures and learning record
5. **Premium Screen** - Subscription/paywall offer

---

## Interactive Workflow

When you run `ipad-screenshots.sh`, the script:

1. **Auto-Setup Phase** (automatic)
   - Creates simulator if needed
   - Builds and installs app
   - Launches app
   - Waits for UI to render

2. **Interactive Capture Phase** (guided)
   ```
   Step 1 of 5
   Navigate to: Home Screen
   Will save as: home_screen_ipad.png

   [Ready?] Press Enter to continue...
   ```
   You navigate the app to the desired screen, then press Enter.
   The script captures and saves the screenshot automatically.

3. **Summary Phase** (automatic)
   - Shows all captured screenshots
   - Offers to shutdown simulator
   - Provides file paths and sizes

---

## Verification & Validation

### Check Captured Screenshots

```bash
# Quick list with dimensions
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh list

# Example output:
# Filename                      Dimensions      Size
# home_screen_ipad.png         2732 x 2048     2.3M
# result_screen_ipad.png       2732 x 2048     2.8M
# favorites_screen_ipad.png    2732 x 2048     2.1M
# history_screen_ipad.png      2732 x 2048     2.6M
# premium_paywall_ipad.png     2732 x 2048     3.1M
```

### Validate for App Store

```bash
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh validate

# Output:
# ✓ home_screen_ipad.png: 2732x2048 (2.3M) ✓
# ✓ result_screen_ipad.png: 2732x2048 (2.8M) ✓
# ✓ All screenshots are valid App Store sizes!
```

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Simulator not found | Script creates one automatically using latest iOS |
| Build fails | Run `flutter clean && flutter pub get` in app directory |
| App won't launch | Check bundle ID matches `com.marumiworks.snapEnglish` |
| Screenshot is black | Wait longer after screen navigation (increase sleep in script) |
| Permission denied | Make sure script is executable: `chmod +x *.sh` |

### Debug Mode

Run script with verbose output:
```bash
bash -x ~/Projects/ai-director-project/scripts/ipad-screenshots.sh 2>&1 | tee debug.log
```

### Check System Setup

```bash
# Verify Xcode
xcode-select -p

# Check Flutter
flutter doctor

# List available iOS runtimes
xcrun simctl list runtimes

# List available device types
xcrun simctl list devicetypes | grep iPad
```

---

## Integration with App Store Connect

### Uploading Screenshots

1. Log in to App Store Connect
2. Navigate to your app (SnapEnglish)
3. Go to **App Preview and Screenshots**
4. Select **iPad Pro (2nd generation)** or later
5. Drag and drop the 5 screenshots in order:
   - Home Screen
   - Result Screen
   - Favorites Screen
   - History Screen
   - Premium Screen
6. Add promotional text if desired
7. Save and continue

### Localization

To provide localized screenshots:

1. Capture screenshots with app in target language
2. Save to separate folder: `assets/screenshots/ipad/[language]/`
3. Upload to each language version in App Store Connect

---

## Advanced Usage

### Custom Simulator

To use a different iPad model, edit the script:

```bash
# In ipad-screenshots.sh, change the grep pattern:
# Original:
IPAD_DEVICE=$(xcrun simctl list devices available | grep -E "iPad Pro \(13-inch|iPad Pro \(12\.9" | ...)

# For iPad Air:
IPAD_DEVICE=$(xcrun simctl list devices available | grep "iPad Air" | ...)

# For iPad mini:
IPAD_DEVICE=$(xcrun simctl list devices available | grep "iPad mini" | ...)
```

### Batch Capture

Run multiple times with different app states:

```bash
#!/bin/bash
# Capture screenshots in different app configurations

for config in light dark default; do
  echo "Capturing for: $config"

  # Could inject app configuration changes here
  # For example, API_CONFIG=$config flutter build ios --simulator

  bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh

  # Move screenshots to config-specific folder
  mkdir -p assets/screenshots/ipad/$config
  mv assets/screenshots/ipad/*.png assets/screenshots/ipad/$config/

  sleep 60
done
```

### Automated Navigation

For fully automated capture without manual navigation, see the full guide:

```bash
cat ~/Projects/ai-director-project/docs/IPAD_SCREENSHOTS_GUIDE.md
```

---

## File Locations

```
~/Projects/ai-director-project/
├── scripts/
│   ├── ipad-screenshots.sh          ← Main capture script
│   ├── ipad-screenshot-utils.sh     ← Utility functions
│   ├── ipad-quick-start.sh          ← Interactive menu
│   └── ...
├── docs/
│   ├── IPAD_SCREENSHOTS_GUIDE.md    ← Detailed documentation
│   └── IPAD_SCREENSHOTS_README.md   ← This file
├── assets/
│   └── screenshots/
│       └── ipad/                    ← Output directory
│           ├── home_screen_ipad.png
│           ├── result_screen_ipad.png
│           ├── favorites_screen_ipad.png
│           ├── history_screen_ipad.png
│           └── premium_paywall_ipad.png
└── logs/
    ├── ipad-screenshots.log
    └── ipad-screenshot-utils.log
```

---

## Performance Notes

- **Build time:** 2-5 minutes first time, 30 seconds on cache hit
- **Simulator boot:** ~15 seconds
- **App install:** ~10 seconds
- **App launch:** ~8 seconds
- **Total automated time:** ~5-10 minutes per run
- **Interactive capture:** 30 seconds per screenshot (user-dependent)

---

## Support & Help

### Get More Information

```bash
# Read the full guide
less ~/Projects/ai-director-project/docs/IPAD_SCREENSHOTS_GUIDE.md

# View capture log
tail -f ~/Projects/ai-director-project/logs/ipad-screenshots.log

# Check script syntax
bash -n ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
```

### Useful Commands

```bash
# List all simulators
xcrun simctl list devices

# List specific iPad simulators
xcrun simctl list devices available | grep iPad

# Boot a specific simulator
xcrun simctl boot <device-uuid>

# Get simulator UUID
xcrun simctl list | grep "iPad Pro.*Booted" | grep -oE '\([A-F0-9-]*\)'

# Manual screenshot capture
xcrun simctl io <uuid> screenshot ~/Desktop/test.png
```

---

## Next Steps

1. **Capture screenshots:**
   ```bash
   bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
   ```

2. **Validate them:**
   ```bash
   bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh validate
   ```

3. **Upload to App Store Connect:**
   - Log in to App Store Connect
   - Go to your app's App Preview and Screenshots section
   - Upload the 5 screenshots in order

4. **Submit for review:**
   - Complete app submission form
   - Add any required metadata
   - Submit for review

---

**Version:** 1.0
**Created:** February 2026
**Tested on:** macOS 13+, Xcode 14+, Flutter 3.10+
**Status:** Production Ready
