#!/bin/bash
# ============================================================
# cowork-codex-relay に -allowProvisioningUpdates を追加するパッチ
# Mac側で実行: bash ~/Projects/ai-director-project/scripts/relay-patch-provisioning.sh
# ============================================================

SERVER="/Users/yuyafujita/Projects/cowork-codex-relay/src/server.js"

if [ ! -f "$SERVER" ]; then
  echo "[error] $SERVER が見つかりません"
  exit 1
fi

# バックアップ
cp "$SERVER" "${SERVER}.bak2"
echo "バックアップ: ${SERVER}.bak2"

# exportArchive コマンドに -allowProvisioningUpdates を追加
# 既存の exportArchive 行を検索して修正
if grep -q "allowProvisioningUpdates" "$SERVER"; then
  echo "✓ -allowProvisioningUpdates は既に含まれています"
else
  # xcodebuild -exportArchive の行に -allowProvisioningUpdates を追加
  sed -i '' 's/\-exportArchive/\-exportArchive -allowProvisioningUpdates/g' "$SERVER"
  echo "✓ -exportArchive に -allowProvisioningUpdates を追加しました"
fi

# xcodebuild archive の行にも -allowProvisioningUpdates を追加
if grep -q "archive.*allowProvisioningUpdates" "$SERVER"; then
  echo "✓ archive にも -allowProvisioningUpdates は既に含まれています"
else
  # "xcodebuild archive" or "xcodebuild", "archive" のパターンを探す
  sed -i '' 's/xcodebuild archive/xcodebuild archive -allowProvisioningUpdates/g' "$SERVER"
  sed -i '' "s/'-archive'/'-archive', '-allowProvisioningUpdates'/g" "$SERVER"
  sed -i '' "s/\"archive\"/\"archive\", \"-allowProvisioningUpdates\"/g" "$SERVER"
  echo "✓ archive にも -allowProvisioningUpdates を追加しました"
fi

echo ""
echo "パッチ適用完了。中継サーバーを再起動してください:"
echo "  Ctrl+C で停止 → bash ~/Projects/ai-director-project/scripts/relay-start.sh"

echo ""
echo "--- 変更内容の確認 ---"
grep -n "allowProvisioningUpdates\|exportArchive\|xcodebuild.*archive" "$SERVER" | head -20
