#!/bin/bash
# ============================================================
# AI監督プロジェクト ― Git ブランチ & ワークツリー クリーンアップ
#
# Mac のターミナルで直接実行してください:
#   cd ~/Projects/ai-director-project
#   bash scripts/cleanup_branches.sh
# ============================================================

set -e
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

echo "=== AI監督プロジェクト: Git クリーンアップ ==="
echo "リポジトリ: $REPO_DIR"
echo ""

# --- Step 0: ロックファイル削除 ---
echo "[Step 0] ロックファイルを削除..."
find .git -name "*.lock" -delete 2>/dev/null || true
find .git -name "*.lock.bak" -delete 2>/dev/null || true
echo "  ✓ ロックファイル削除完了"
echo ""

# --- Step 1: ワークツリーの整理 ---
echo "[Step 1] 不要ワークツリーを削除..."
echo "  現在のワークツリー:"
git worktree list

# .worktrees/ 内のtaskワークツリーを物理削除
if [ -d ".worktrees" ]; then
    echo "  .worktrees/ フォルダを削除中..."
    rm -rf .worktrees/
    echo "  ✓ .worktrees/ 削除完了"
fi

# .claude/worktrees/ 内のワークツリーを物理削除
if [ -d ".claude/worktrees" ]; then
    echo "  .claude/worktrees/ フォルダを削除中..."
    rm -rf .claude/worktrees/
    echo "  ✓ .claude/worktrees/ 削除完了"
fi

# git worktree prune で参照を整理
git worktree prune -v
echo "  ✓ ワークツリー整理完了"
echo ""

# --- Step 2: 不要ブランチ削除 ---
echo "[Step 2] 不要ブランチを削除..."

# task/* ブランチを全削除
for branch in $(git branch --list 'task/*'); do
    echo "  削除: $branch"
    git branch -D "$branch" 2>/dev/null || echo "    (スキップ)"
done

# claude/nervous-haibt (PRマージ済み)
if git branch --list claude/nervous-haibt | grep -q .; then
    echo "  削除: claude/nervous-haibt (PRマージ済み)"
    git branch -D claude/nervous-haibt
fi

echo "  ✓ 不要ブランチ削除完了"
echo ""

# --- Step 3: distracted-roentgen を main にマージ ---
echo "[Step 3] claude/distracted-roentgen を main にマージ..."

if git branch --list claude/distracted-roentgen | grep -q .; then
    # 現在のブランチを確認
    CURRENT=$(git branch --show-current)

    if [ "$CURRENT" != "main" ]; then
        echo "  main ブランチに切り替え..."
        git checkout main
    fi

    # mainをpull
    echo "  main を最新に更新..."
    git pull origin main

    # マージ
    echo "  Day 3 (distracted-roentgen) をマージ..."
    git merge claude/distracted-roentgen -m "Day3: UI仕上げ + お気に入り・履歴機能をmainに統合"

    # マージ後にブランチ削除
    echo "  claude/distracted-roentgen ブランチを削除..."
    git branch -d claude/distracted-roentgen

    # プッシュ
    echo "  origin/main にプッシュ..."
    git push origin main

    echo "  ✓ マージ + プッシュ完了"
else
    echo "  (claude/distracted-roentgen ブランチが見つかりません - スキップ)"
fi
echo ""

# --- Step 4: リモートの不要ブランチ削除 ---
echo "[Step 4] リモートの不要ブランチを確認..."
echo "  リモートブランチ一覧:"
git branch -r
echo ""
echo "  ※ リモートブランチの削除が必要な場合は手動で実行してください:"
echo "    git push origin --delete claude/nervous-haibt"
echo ""

# --- Step 5: 空プレースホルダーファイルの削除 ---
echo "[Step 5] 空プレースホルダーファイルを削除..."
for f in articles/02_environment.md articles/03_implementation.md articles/04_release.md articles/05_revenue_report.md articles/extra_note_guide.md; do
    if [ -f "$f" ] && [ ! -s "$f" ]; then
        echo "  削除: $f (空ファイル)"
        git rm "$f"
    fi
done
echo ""

# コミット (空ファイル削除分)
if git diff --cached --quiet 2>/dev/null; then
    echo "  (削除するファイルなし)"
else
    git commit -m "整理: 空プレースホルダーファイルを削除"
    git push origin main
    echo "  ✓ 空ファイル削除をコミット + プッシュ"
fi
echo ""

# --- 完了 ---
echo "=== クリーンアップ完了 ==="
echo ""
echo "最終状態:"
git branch -a
echo ""
git worktree list
echo ""
echo "最新コミット:"
git log --oneline -5
