# iPad Screenshots Capture Guide

## Overview

The iPad screenshot scripts automate the process of capturing screenshots from the SnapEnglish Flutter app running on an iPad Pro simulator. These screenshots are optimized for App Store submission.

## Files

- **`scripts/ipad-screenshots.sh`** - Main script to capture screenshots
- **`scripts/ipad-screenshot-utils.sh`** - Utility script for managing screenshots
- **`assets/screenshots/ipad/`** - Output directory for captured screenshots

## Requirements

### System Requirements
- macOS (Mac OS X 10.10+)
- Xcode with iOS SDK installed
- Flutter SDK installed and in PATH
- ImageMagick (for screenshot validation)

### Installation

```bash
# Install ImageMagick (for screenshot validation utilities)
brew install imagemagick
```

## Quick Start

### 1. Capture Screenshots

Run the main capture script:

```bash
bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
```

This script will:
1. Find or create an iPad Pro simulator
2. Boot the simulator
3. Build the Flutter app
4. Install and launch the app
5. Guide you through capturing 5 screenshots interactively

### 2. Manage Screenshots

Use the utility script to validate and manage your screenshots:

```bash
# List all captured screenshots
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh list

# Validate App Store compliance
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh validate

# Open screenshots in Finder
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh open

# Clean up all screenshots (with confirmation)
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh clean
```

## Detailed Workflow

### Step 1: Start the Capture Script

```bash
bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
```

**What happens:**
- Script validates project directory structure
- Searches for existing iPad Pro simulators
- Creates new simulator if needed (iPad Pro 12.9-inch)
- Boots the simulator (takes ~15 seconds)
- Builds Flutter app in simulator mode
- Installs app on simulator
- Launches the app and waits for it to load

### Step 2: Interactive Screenshot Capture

The script guides you through 5 screenshots:

#### 1. **Home Screen** (home_screen_ipad.png)
   - This is captured automatically after app launch
   - Shows the initial/default state with "Take Photo" button
   - Press Enter when ready

#### 2. **Result Screen** (result_screen_ipad.png)
   - Navigate to this screen after taking a photo in the app
   - Shows the 3 generated English phrases
   - Shows any action buttons (favorite, copy, etc.)
   - Press Enter when the screen is visible

#### 3. **Favorites Screen** (favorites_screen_ipad.png)
   - Navigate to the Favorites tab
   - Shows saved favorite phrases
   - Press Enter to capture

#### 4. **History/Learning Screen** (history_screen_ipad.png)
   - Navigate to the History or Learning Record screen
   - Shows previously captured items
   - Press Enter to capture

#### 5. **Premium/Paywall Screen** (premium_paywall_ipad.png)
   - Navigate to the Premium or Settings screen showing subscription offer
   - Shows pricing and subscription details
   - Press Enter to capture

### Step 3: Validation

After capture completes, validate the screenshots:

```bash
bash ~/Projects/ai-director-project/scripts/ipad-screenshot-utils.sh validate
```

**Valid iPad App Store screenshot sizes:**
- 2064 × 2752 px
- 2732 × 2064 px
- 2048 × 2732 px
- 2732 × 2048 px

The script checks that your screenshots match these dimensions.

## Troubleshooting

### Issue: Simulator Not Found

```
[✗] No iPad Pro simulator found
```

**Solution:** The script will attempt to create one automatically using the latest iOS SDK. If this fails:

```bash
# Manually create an iPad Pro simulator
xcrun simctl create "iPad Pro SnapEnglish" "iPad Pro (12.9-inch) (6th generation)" "iOS16.5"

# Or check available device types
xcrun simctl list devicetypes | grep iPad
```

### Issue: Build Failed

```
[✗] Failed to build Flutter app
```

**Solution:**
```bash
# Clean build cache
cd ~/Projects/ai-director-project/app/snap_english
flutter clean
flutter pub get

# Try again
bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
```

### Issue: App Not Launching

```
[✗] Failed to launch app on simulator
```

**Solution:**
```bash
# Verify the bundle ID
cd ~/Projects/ai-director-project/app/snap_english/build/ios/iphonesimulator/Runner.app
cat Info.plist | grep -A2 CFBundleIdentifier

# Launch manually
xcrun simctl launch <device-uuid> com.marumiworks.snapEnglish
```

### Issue: Screenshot Not Saved

```
[✗] Failed to capture screenshot
```

**Solution:**
- Ensure simulator is still running: `xcrun simctl list devices`
- Try restarting simulator: `xcrun simctl shutdown <uuid> && xcrun simctl boot <uuid>`
- Wait longer between app actions (increase sleep values in script)

## Advanced Usage

### Custom Simulator Device

To use a different iPad model:

```bash
# Edit the script and modify the IPAD_DEVICE search:
# Change: grep -E "iPad Pro \(13-inch|iPad Pro \(12\.9"
# To: grep "iPad Air" (for iPad Air, for example)
```

### Auto-Navigation (Advanced)

For fully automated screenshot capture with in-app navigation (requires custom testing):

1. Build a test configuration that pre-populates the app state
2. Use Flutter's integration_test package to automate screen navigation
3. Modify the script to use `flutter drive --target=test_driver/main.dart`

### Batch Processing

To capture screenshots multiple times:

```bash
#!/bin/bash
for i in {1..3}; do
  echo "Run $i of 3"
  bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
  sleep 30
done
```

## App Store Submission

### Screenshots Directory Structure

```
assets/screenshots/ipad/
├── home_screen_ipad.png
├── result_screen_ipad.png
├── favorites_screen_ipad.png
├── history_screen_ipad.png
└── premium_paywall_ipad.png
```

### Uploading to App Store Connect

1. Navigate to your app in App Store Connect
2. Go to **App Preview and Screenshots**
3. Select iPad Pro (2nd Generation) or later
4. Upload the 5 iPad screenshots in order:
   - Home Screen
   - Result Screen
   - Favorites Screen
   - History Screen
   - Premium Screen
5. Add promotional text for each screenshot if desired
6. Save and proceed with submission

### Screenshot Best Practices

- **Minimal UI:** Hide status bar and tab bar if possible
- **Content:** Show meaningful app content, not empty states
- **Text:** Use large, readable fonts
- **Localization:** Provide screenshots in target languages if needed
- **Consistency:** Use consistent color schemes and layouts
- **Focus:** Show one feature per screenshot

## Log Files

All operations are logged to:
```
~/Projects/ai-director-project/logs/ipad-screenshots.log
~/Projects/ai-director-project/logs/ipad-screenshot-utils.log
```

View logs:
```bash
tail -f ~/Projects/ai-director-project/logs/ipad-screenshots.log
```

## Environment Variables

You can customize script behavior with environment variables:

```bash
# Change output directory
SCREENSHOTS_DIR=/custom/path bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh

# Change project root
PROJECT_DIR=/custom/project bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
```

## Cleanup

To remove the simulator after capturing screenshots:

```bash
# The script will ask at the end if you want to keep it running
# To manually shutdown:
xcrun simctl shutdown <device-uuid>

# To delete the simulator:
xcrun simctl delete <device-uuid>
```

## Useful Commands Reference

```bash
# List all simulators
xcrun simctl list devices

# Boot specific simulator
xcrun simctl boot <uuid>

# Shutdown simulator
xcrun simctl shutdown <uuid>

# Delete simulator
xcrun simctl delete <uuid>

# Install app
xcrun simctl install <uuid> <path-to-app-bundle>

# Launch app
xcrun simctl launch <uuid> <bundle-id>

# Capture screenshot
xcrun simctl io <uuid> screenshot <output-file>

# Get app info
xcrun simctl appinfo <uuid> <bundle-id>
```

## Support & Debugging

For detailed debugging:

1. Enable verbose output:
   ```bash
   bash -x ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
   ```

2. Check Xcode installation:
   ```bash
   xcode-select -p
   sudo xcode-select --reset
   ```

3. Check Flutter setup:
   ```bash
   flutter doctor -v
   ```

4. Check iOS simulator availability:
   ```bash
   xcrun simctl list runtimes
   xcrun simctl list devicetypes
   ```

## Automating Across Multiple Simulators

To capture screenshots on different iPad models:

```bash
#!/bin/bash
for model in "iPad Pro (12.9-inch)" "iPad Pro (11-inch)" "iPad Air"; do
  IPAD_MODEL="$model" bash ~/Projects/ai-director-project/scripts/ipad-screenshots.sh
done
```

## Notes

- Screenshots are saved with iPad-specific naming convention
- All operations are logged for audit trail
- Script is idempotent - can be run multiple times safely
- Built app cache is reused if unchanged
- Simulator state is preserved between runs unless explicitly shutdown

---

**Last Updated:** February 2026
**Tested On:** macOS 13+, Xcode 14+, Flutter 3.10+
