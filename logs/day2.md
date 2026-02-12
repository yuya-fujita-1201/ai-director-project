# Day 2 作業ログ ― 2026-02-11（深夜）
# AI API連携（画像 → 英語フレーズ生成）

---

## 目標
- OpenAI Vision API連携
- 撮影画像 → 英語フレーズ3つ生成のフロー完成
- 結果画面にフレーズカード表示

---

## タイムライン

| 時刻 | 作業内容 | 担当 | ステータス |
|---|---|---|---|
| -- | Day 2 開発手順書作成 | Cowork | ✅ 完了 |
| -- | OpenAI APIキー取得（Coworkブラウザ経由） | Cowork + 本人 | ✅ 完了 |
| -- | AI Service実装（ai_service.dart） | Claude Code CLI | ✅ 完了 |
| -- | Phraseモデル更新 | Claude Code CLI | ✅ 完了 |
| -- | 結果画面をフレーズカード表示に更新 | Claude Code CLI | ✅ 完了 |
| -- | ホーム→撮影→API→結果のフロー完成 | Claude Code CLI | ✅ 完了 |
| -- | JSONパースのバグ修正（キー名フォールバック） | Claude Code CLI | ✅ 完了 |
| -- | 渓流の画像でフレーズ生成の動作確認 | Claude Code CLI | ✅ 完了 |
| -- | Git コミット（91345e2） | Claude Code CLI | ✅ 完了 |
| -- | リモートプッシュ（claude/nervous-haibt） | Claude Code CLI | ✅ 完了 |
| -- | Day 2完了のX投稿 | 本人 | ⬜ 未実施 |

---

## 使ったツール

| ツール | 用途 |
|---|---|
| Cowork（Claude Desktop） | 手順書作成、作業ログ記録、APIキー取得支援 |
| Claude in Chrome | OpenAI Platformでのキー作成 |
| Claude Code CLI | API連携実装、ビルド、テスト |
| OpenAI Platform | APIキー取得（SnapEnglishキー作成） |

---

## 発生した問題・解決策

### 問題: APIレスポンスのJSONキー名が不一致
- **症状**: OpenAI Vision APIが返すJSONのキー名が想定と微妙に異なるケースがあった
- **原因**: APIのレスポンス形式が呼び出しごとに若干揺れる
- **解決策**: 複数のキー名候補でフォールバックする処理を追加
- **記事ネタ**: ★ AIの返すJSONは常に同じフォーマットとは限らない、という実践的な学び

---

## 実装した内容

### 変更ファイル（10ファイル、+606行）

| ファイル | 内容 |
|---|---|
| `pubspec.yaml` | flutter_dotenv追加 |
| `.env` | OpenAI APIキー設定（.gitignore済み） |
| `.gitignore` | .env追加 |
| `lib/services/ai_service.dart` | OpenAI Vision API呼び出し（新規） |
| `lib/models/phrase.dart` | fromJson/toJson、難易度対応（更新） |
| `lib/screens/result_screen.dart` | フレーズカード表示（更新） |
| その他 | 関連ファイルの調整 |

### 動作確認結果
- 渓流の画像で英語フレーズ3つ生成に成功:
  - 🟢 初級: "The sound of the flowing water is so calming."（流れる水の音はとても落ち着きます）
  - 🟡 中級: "The rocks are covered in vibrant green moss."（岩は鮮やかな緑の苔で覆われています）
  - 🔴 上級: （スクロールで表示）
- 難易度バッジの色分け: 緑/黄/赤で表示

---

## 品質チェック結果

| チェック項目 | 結果 |
|---|---|
| 画像→API→フレーズ表示フロー | ✅ 正常動作 |
| 難易度バッジ表示 | ✅ 色分け正常 |
| .env のgitignore | ✅ コミットされていない |
| Git コミット | ✅ 91345e2 |
| リモートプッシュ | ✅ claude/nervous-haibt |

---

## 成果物

- [x] `docs/day2_dev_guide.md` ― Day 2開発手順書
- [x] `lib/services/ai_service.dart` ― AI APIサービス
- [x] `lib/models/phrase.dart` ― 更新版（fromJson/toJsonフォールバック付き）
- [x] `lib/screens/result_screen.dart` ― フレーズカード表示
- [x] 撮影 → AI → フレーズ表示の動作確認 ✅
- [x] OpenAI APIキー「SnapEnglish」取得済み

---

## 振り返り

- **Day 1-2を1日（深夜含む）で完了**。予定の2日分を前倒し
- 核心機能「撮影→AIフレーズ生成」がDay 2で動いた → 記事②のハイライト
- JSONパースの不一致問題は、AI APIを使う実アプリならではの課題 → 記事ネタとして良い
- 既にクレジットが残っているOpenAIアカウントがあったのでスムーズだった
- Day 3（UI仕上げ + お気に入り保存）に進む準備は整っている

---

## 記事②用の素材メモ

- 渓流画像から英語フレーズが生成された結果画面 ★最重要
- 難易度バッジ（緑/黄/赤）の色分け表示
- JSONパースエラー → 修正の過程（「AIは完璧じゃない」ネタ）
- 「自分はコードを1行も書いていないのに、AIが英語を返してくる」体験

---

## Day 2 後半：コンテンツ制作（深夜〜AM3:00）

### 記事制作
| 作業内容 | 担当 | ステータス |
|---|---|---|
| 記事② 本文執筆（articles/02_setup.md） | Cowork | ✅ 完了 |
| 記事② Note公開（手動ハッシュタグ整理含む） | Cowork（Claude in Chrome） | ✅ 完了 |
| 記事③ ツール解説編 執筆（articles/03_tool_guide.md） | Cowork | ✅ 完了 |
| 記事③用スクショ撮影指示 作成 | Cowork | ✅ 完了 |
| 記事②への画像アップロード試行 | Cowork（Claude in Chrome） | ⬜ 断念（手動で実施予定） |
| X Day 1投稿 下書き保存 | Cowork（Claude in Chrome） | ✅ 完了 |
| X Day 2投稿 下書き保存 | Cowork（Claude in Chrome） | ✅ 完了 |

### スクショ撮影
| 作業内容 | 担当 | ステータス |
|---|---|---|
| シミュレータスクショ（Note用7枚 + X用2枚）撮影指示 作成 | Cowork | ✅ 完了 |
| Claude Code CLIで撮影実行（9枚） | Claude Code CLI + 本人 | ✅ 完了 |
| git commit & push（4be0b45） | Claude Code CLI | ✅ 完了 |
| 記事③用スクショ（デスクトップアプリ6枚）撮影 | Claude Code CLI | ⬜ 未実施（手動で撮影予定） |

### 公開済みコンテンツ
- **Note記事①**: https://note.com/marumi_works/n/n00a946fe68da（Day 0公開）
- **Note記事②**: https://note.com/marumi_works/n/ne17c13515413（Day 2深夜公開、2日連続投稿達成）
- **X下書き**: Day 1投稿、Day 2投稿（スクショ添付して手動投稿待ち）

---

## 技術的な知見（記事ネタ候補）

### Cowork × Claude in Chrome の連携
- Note投稿をCoworkから指示→Claude in Chromeが自動操作で実現
- ProseMirror（Noteのエディタ）への文字入力は `document.execCommand('insertText')` で解決
- ハッシュタグ設定、公開設定まで自動化できた
- **画像アップロードだけは自動化に失敗**（ファイルアクセスの壁）

### X投稿の自動化
- X.comのcompose画面をClaude in Chromeで操作→テキスト入力→下書き保存まで自動化
- 画像添付は手動が必要（ファイルアクセスの制約）

### screencaptureによるスクショ自動化
- `xcrun simctl io booted screenshot` でシミュレータ画面を自動キャプチャ
- Claude Code CLIに指示するだけで9枚一括撮影できた
- デスクトップアプリのスクショは `screencapture -w` で可能だが、ウィンドウ選択が必要
