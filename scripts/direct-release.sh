#!/bin/bash
# ============================================================
# SnapEnglish: Mac上で直接実行する App Store リリースパイプライン
# Archive → Export → Upload を -allowProvisioningUpdates 付きで実行
#
# 使い方（Mac側で実行）:
#   bash ~/Projects/ai-director-project/scripts/direct-release.sh
# ============================================================

set -e

PROJECT_DIR="/Users/yuyafujita/Projects/ai-director-project/app/snap_english"
WORKSPACE="${PROJECT_DIR}/ios/Runner.xcworkspace"
SCHEME="Runner"
EXPORT_PLIST="${PROJECT_DIR}/ios/ExportOptions.plist"
ARCHIVE_PATH="${PROJECT_DIR}/build/Runner.xcarchive"
EXPORT_PATH="${PROJECT_DIR}/build/ipa"
API_KEY="P7PDD4P69G"
API_ISSUER="e359cd97-a6d4-4ef9-bcb3-24336fda0e74"

log() { echo -e "\n=== $1 ==="; }

# --- Step 1: Flutter Build ---
log "Step 1: Flutter Build iOS Release"
cd "$PROJECT_DIR"
flutter build ios --release
echo "✓ Flutter ビルド完了"

# --- Step 2: Xcode Archive ---
log "Step 2: Xcode Archive"
xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -archivePath "$ARCHIVE_PATH" \
  -destination "generic/platform=iOS" \
  -allowProvisioningUpdates \
  | tail -5
echo "✓ Archive 完了: $ARCHIVE_PATH"

# --- Step 3: Export IPA ---
log "Step 3: Export IPA"
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist "$EXPORT_PLIST" \
  -exportPath "$EXPORT_PATH" \
  -allowProvisioningUpdates \
  | tail -5
echo "✓ IPA Export 完了: $EXPORT_PATH"

# --- Step 4: Upload to App Store Connect ---
log "Step 4: App Store Connect にアップロード"
IPA_FILE=$(find "$EXPORT_PATH" -name "*.ipa" | head -1)
if [ -z "$IPA_FILE" ]; then
  echo "✗ IPAファイルが見つかりません"
  exit 1
fi
echo "  IPA: $IPA_FILE"

xcrun notarytool submit "$IPA_FILE" \
  --key-id "$API_KEY" \
  --issuer "$API_ISSUER" \
  --key ~/AuthKey_${API_KEY}.p8 \
  --wait 2>/dev/null || true

# altool でアップロード（notarytoolが使えない場合）
xcrun altool --upload-app \
  -f "$IPA_FILE" \
  -t ios \
  --apiKey "$API_KEY" \
  --apiIssuer "$API_ISSUER" \
  2>&1 | tail -10

log "完了"
echo "App Store Connect でビルドの処理状況を確認してください:"
echo "https://appstoreconnect.apple.com/apps/6759194623"
