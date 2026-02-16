#!/bin/bash
# cowork-codex-relay server.js の構文エラーを修正するパッチスクリプト
# 使い方: bash ~/Projects/ai-director-project/cowork-relay-patch.sh

SERVER="/Users/yuyafujita/Projects/cowork-codex-relay/src/server.js"

if [ ! -f "$SERVER" ]; then
  echo "ERROR: $SERVER が見つかりません"
  exit 1
fi

# バックアップ
cp "$SERVER" "${SERVER}.bak"

# Fix 1: validateParams - throw new Error`...` → throw new Error(`...`)
sed -i '' "s/throw new Error\`Missing required param: \${name}\`)/throw new Error(\`Missing required param: \${name}\`)/" "$SERVER"

# Fix 2: buildCommandPayload - throw new Error`...` → throw new Error(`...`)
sed -i '' "s/throw new Error\`Unknown command id: \${id}\`)/throw new Error(\`Unknown command id: \${id}\`)/" "$SERVER"

# Fix 3: console.log`...` → console.log(`...`)
sed -i '' "s/console\.log\`\[relay\] listening on http:\/\/\${HOST}:\${PORT}\`)/console.log(\`[relay] listening on http:\/\/\${HOST}:\${PORT}\`)/" "$SERVER"

echo "✅ 修正完了: $SERVER"
echo "バックアップ: ${SERVER}.bak"
echo ""
echo "起動コマンド:"
echo "  cd /Users/yuyafujita/Projects/cowork-codex-relay"
echo "  RELAY_TOKEN=snap2026 RELAY_WORKDIR=/Users/yuyafujita/Projects/ai-director-project/app/snap_english npm start"
