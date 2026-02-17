# AI監督プロジェクト ― コンテキスト引き継ぎドキュメント
# 最終更新: 2026-02-18 夜 Cowork — SEO改善完了＋note-seo-optimizerスキル作成・審査結果待ち継続

---

## 📌 プロジェクト概要

### プロジェクト名
**AI監督プロジェクト ― 1週間チャレンジ**

### コンセプト
Claude Opus 4.6に企画・設計・実装判断を全て委ね、筆者はチャット指示のみでiOSアプリを1週間で開発・リリースし、その過程をNote記事シリーズとして公開してマネタイズする。

### ターゲット読者
- AI初心者（ChatGPTは触ったことがある程度）
- プログラミング未経験〜挫折経験あり
- 副業に興味がある30〜40代会社員
- Macユーザー

### 筆者ペルソナ（記事上）
- IT企業勤務だがプログラミングは実質未経験と見せる
- 実態はSalesforce開発者だがFlutter/Dart実務経験なし（これは事実）
- 「開発初心者でもAIでここまでできる」が記事の主張

### Noteアカウント
- URL: https://note.com/marumi_works
- アカウント名: marumiさん

---

## 🛠 開発するアプリ

### アプリ名
**SnapEnglish（AI英語フレーズカメラ）**

### 機能
- カメラで身の回りのモノを撮影
- AIが画像認識して関連する英語フレーズを3つ生成
- お気に入り保存・履歴一覧

### 収益モデル
- 無料：1日3回まで
- 有料（月額400円）：無制限 + お気に入り保存（当初380円予定→Apple標準価格帯に合わせ400円）

### 技術スタック
- Flutter/Dart
- Firebase（認証・DB）
- AI API（Claude Vision or OpenAI Vision）
- RevenueCat（課金管理）
- iOS App Store

### なぜこの企画か（AI監督の判断理由）
1. 「AIが企画したAI活用アプリをAIで実装する」入れ子構造が記事映えする
2. 英語学習市場は日本App Storeでトップカテゴリ
3. API連携の過程が技術記事のネタとして豊富
4. Flutter + Firebase + AI API = 筆者のスキルセット（Claude Code依存前提）にフィット

---

## 📅 1週間スケジュール

| Day | タスク | 対応記事 |
|---|---|---|
| Day 0（前日） | 企画記事公開 | 記事① |
| Day 1 | 環境構築 + カメラ機能 | 記事② |
| Day 2 | AI API連携（画像→フレーズ生成） | 記事② |
| Day 3 | UI仕上げ + お気に入り保存 | 記事③ |
| Day 4 | 課金実装 + 回数制限 | 記事③ |
| Day 5 | デザイン調整 + オンボーディング | 記事④ |
| Day 6 | App Storeスクショ・説明文・アイコン | 記事④ |
| Day 7 | 最終テスト + 審査提出 | 記事④ |
| Day 14〜 | 収益データ収集 | 記事⑤ |

---

## ✍️ Note記事シリーズ構成

| # | タイトル | 有料/無料 | ステータス |
|---|---|---|---|
| ① | Claude Opus 4.6がリリースされたので、全部AIに任せて1週間でiOSアプリを作ってみることにした | 無料 | ✅ **公開済み** https://note.com/marumi_works/n/n00a946fe68da |
| ② | ターミナルって何？からスタートして、Claudeに聞いたら2時間で開発環境ができた | 無料 | ✅ **公開済み** https://note.com/marumi_works/n/ne17c13515413 |
| ②.5 | コード0行でアプリを作る「道具」の使い方 ― Claude Desktop × Cowork 実践ガイド | 無料 | ✅ **公開済み** https://note.com/marumi_works/n/n3a6e38b5ce12 |
| ③ | AIの指示通りに進めたら3日目にアプリが動いた。自分は何も理解していない | 無料 | ✅ **公開済み** https://note.com/marumi_works/n/nd865836ad26e |
| ④ | App Storeの申請まで全部AIにやらせた ― 審査提出までの72時間 | ¥500 | ✅ **公開済み** https://note.com/marumi_works/n/n20169aa6db36 |
| ⑤ | 1週間チャレンジの全結果を公開する ― DL数・売上・Note記事の収益も | ¥980 | 未着手 |
| 番外 | AIに聞きながらNoteアカウントを作って初投稿するまで ― 完全初心者ガイド | 無料 | 未着手 |

### 有料化戦略
- 記事①②③ + 番外編 → 無料（集客・拡散用）
- 記事④ → ¥500（実用的手順）
- 記事⑤ → ¥980（結果が気になる層）
- マガジン「AI監督プロジェクト 完全版」→ ¥1,480

---

## 🧰 使用ツールチェーン

| ツール | 役割 | 記事上の呼び方 |
|---|---|---|
| Claude.ai（Opus 4.6） | 企画・戦略・記事執筆 | 「参謀」 |
| Cowork（Claude Desktop） | ファイル管理・ドキュメント作成 | 「事務員」 |
| Claude in Chrome | ブラウザ操作（Note投稿、App Store） | 「手足」 |
| Claude Code CLI | コーディング・ビルド・テスト | 「エンジニア」 |
| Google Antigravity | コードエディタ（Claude Code CLI呼び出し） | （記事では省略可） |

---

## 💰 収益目標

### 短期（1ヶ月）
- Note有料記事購入：合計50件以上（≒ 月5〜10万円）
- Note記事合計PV：5,000以上
- Xフォロワー：500人以上
- アプリDL：500以上

### 中期（3ヶ月）
- Note + アプリ合計：月10〜20万円

---

## 📝 意思決定ログ

### 決定事項
1. マネタイズ手段として「Note × X × iOSアプリ」の3層構造を採用
2. 「逆転の発想」：AIに企画を出させ→実行→記事化のループ
3. プロジェクト名「AI監督プロジェクト」に決定
4. AI監督がSnapEnglish（企画C）を選択
5. 開発期間を2週間→1週間に短縮
6. 記事数は5本+番外編を維持（1週間の密度を見せる）
7. 記事のトーン：AI超初心者向け、開発未経験者ペルソナ
8. Claude Opus 4.6リリースをフックに読者を引き込む構成
9. 「4つのClaude」を参謀・事務員・手足・エンジニアとキャラクター化
10. エディタはGoogle Antigravityを使用（Claude Code CLI呼び出し）
11. Note記事①を2/11深夜に公開（Day 0）
12. X告知投稿は2/11朝7-8時に実施予定

### 未決定事項
- アプリのデザインテーマ・カラー（Day 5で調整予定）

### 決定済み追加事項
13. AI APIはOpenAI Vision APIを採用（Day 2で実装完了）
14. 記事②.5としてツール解説編を追加（シリーズ読者＋検索流入の両狙い）
15. Note画像アップロード・X画像添付は手動で実施（自動化に制約あり）
16. Day 3コードはCowork側で事前作成し、Claude Code CLIで統合する方式を採用
17. 更新ファイルは `_updated.dart` として作成（既存ファイルとの競合回避）→ Day 3マージで統合完了・削除済み
18. Note見出し画像はグリッド線なしのダークテック風テンプレートで統一（docs/header_image_template.md）
19. Note画像アップロードは手動実施（VM↔Mac間のファイル転送制約のため）
20. Gitブランチ整理完了: task/*, nervous-haibt, distracted-roentgen → mainに統合・削除（2026-02-12）
21. 記事②.5はスクショなしで先行公開（後日追加予定、撮影指示はdocs/screenshot_guide_article3.md）

---

## 📂 プロジェクトフォルダ構成

場所: `~/Projects/ai-director-project/`

```
ai-director-project/
├── CONTEXT.md              ← このファイル
├── README.md
├── docs/
│   ├── project_plan.md     ✅ 配置済み
│   ├── folder_structure_setup.md  ✅ 配置済み
│   ├── chrome_note_prompt.md  ✅ 配置済み
│   ├── app_spec.md         ✅ 作成済み
│   ├── day1_dev_guide.md   ✅ 作成済み
│   ├── day3_dev_guide.md   ✅ 作成済み
│   ├── day4_dev_guide.md   ✅ 作成済み
│   ├── header_image_template.md  ✅ 作成済み（見出し画像テンプレ仕様）
│   ├── api_selection.md    （未作成）
│   └── revenue_model.md    （未作成）
├── articles/
│   ├── 01_planning.md      ✅ 配置済み（公開済み記事と同内容）
│   ├── 02_setup.md         ✅ 構成案作成済み
│   ├── 03_tool_guide.md    ✅ 執筆完了（ツール解説編）
│   ├── 04〜05, extra       （未作成）
│   └── images/             ✅ note/（7枚）x/（2枚）撮影済み
├── x_posts/
│   ├── daily_posts.md      ✅ Day 0-3投稿下書き
│   └── buzz_posts.md
│   ├── 04_app_working.md   ✅ 初稿完了（記事③ Day 3-4）
├── assets/
│   ├── header_day0.png     ✅ 見出し画像（記事①）
│   ├── header_day1-2.png   ✅ 見出し画像（記事②）
│   ├── header_day2-5.png   ✅ 見出し画像（記事②.5）
│   ├── header_day3-4_v3.png ✅ 見出し画像（記事③ v3 中央フォーカス）
│   ├── header_magazine.png ✅ マガジン見出し画像
├── logs/                   ✅ day1-3作業ログ
├── revenue/                （収益データ）
└── app/snap_english/        ✅ Flutter プロジェクト（mainブランチに統合済み）
    └── lib/
        ├── services/database_service.dart  ✅ Day 3新規
        ├── screens/main_screen.dart        ✅ Day 3新規
        ├── screens/favorites_screen.dart   ✅ Day 3新規
        └── screens/history_screen.dart     ✅ Day 3新規
```

---

## ✅ 完了タスク（Day 0）

- [x] プロジェクト企画（コンセプト・ターゲット・収益モデル）
- [x] アプリ企画選定（SnapEnglish）
- [x] 1週間スケジュール策定
- [x] 記事シリーズ構成（5本+番外編）
- [x] 記事①執筆・文体調整・最終版完成
- [x] フォルダ構成整備（Antigravity用）
- [x] コンテキスト引き継ぎドキュメント作成
- [x] サムネイル画像作成（HTML）
- [x] Note記事①公開 → https://note.com/marumi_works/n/n00a946fe68da
- [x] X告知投稿文を3パターン作成
- [x] X告知投稿（Day 0告知）

## ✅ 完了タスク（Day 1）

- [x] アプリ設計書作成（docs/app_spec.md）
- [x] Day 1開発手順書作成（docs/day1_dev_guide.md）
- [x] Day 1作業ログ テンプレート作成（logs/day1.md）
- [x] Day 1 X投稿文 下書き（x_posts/daily_posts.md に追記）
- [x] 記事② 下書き構成作成（articles/02_setup.md）
- [x] Flutter プロジェクト作成（app/snap_english/）
- [x] 依存パッケージ追加（image_picker, riverpod, dio, sqflite 等）
- [x] iOS権限設定（カメラ・フォトライブラリ）
- [x] カメラ機能実装（image_picker）
- [x] ホーム画面 + 結果画面（スタブ）実装
- [x] flutter analyze / build / test すべてクリア
- [x] iPhone 17シミュレータで動作確認
- [x] Git コミット（9597d55）+ リモートプッシュ

## ✅ 完了タスク（Day 2）

- [x] Day 2開発手順書作成（docs/day2_dev_guide.md）
- [x] OpenAI APIキー取得（SnapEnglishキー、Coworkブラウザ経由）
- [x] AI Service実装（lib/services/ai_service.dart）
- [x] Phraseモデル更新（fromJson/toJson + フォールバック）
- [x] 結果画面更新（フレーズカード + 難易度バッジ）
- [x] 画像→API→フレーズ表示のフルフロー完成
- [x] JSONパースのバグ修正（キー名フォールバック対応）
- [x] 渓流画像でフレーズ生成の動作確認
- [x] Git コミット（91345e2）+ リモートプッシュ（claude/nervous-haibt）
- [x] Day 1 X投稿 下書き保存済み（Xアプリ内Drafts）

## ✅ 完了タスク（Day 2 後半：コンテンツ制作）

- [x] 記事② 本文執筆（articles/02_setup.md 4,041文字）
- [x] 記事② Note公開（https://note.com/marumi_works/n/ne17c13515413）2日連続投稿達成
- [x] X Day 1投稿 下書き保存（Claude in Chrome）
- [x] X Day 2投稿 下書き保存（Claude in Chrome）
- [x] シミュレータスクショ9枚撮影（Claude Code CLI）+ git push（4be0b45）
- [x] 記事③ ツール解説編 執筆（articles/03_tool_guide.md）
- [x] 記事③用スクショ撮影指示 作成（docs/screenshot_guide_article3.md）
- [x] 記事ネタメモ作成（docs/article_ideas_memo.md）
- [x] 作業ログ更新

## ✅ 完了タスク（Day 3：UI仕上げ + お気に入り保存 ― Coworkコード作成）

- [x] Day 3開発手順書作成（docs/day3_dev_guide.md）
- [x] SQLiteデータベースサービス実装（lib/services/database_service.dart）
- [x] タブバーナビゲーション実装（lib/screens/main_screen.dart）
- [x] お気に入り画面実装（lib/screens/favorites_screen.dart）
- [x] 撮影履歴画面実装（lib/screens/history_screen.dart）
- [x] Phraseモデル拡張（lib/models/phrase_updated.dart ← DB対応）
- [x] ScanResultモデル拡張（lib/models/scan_result_updated.dart）
- [x] 結果画面更新（lib/screens/result_screen_updated.dart ← DB保存対応）
- [x] フレーズカード更新（lib/widgets/phrase_card_updated.dart ← お気に入りアニメーション）
- [x] App更新（lib/app_updated.dart ← MainScreen対応）
- [x] Day 3 X投稿 下書き（x_posts/daily_posts.md に追記）
- [x] Day 3作業ログ記録（logs/day3.md）
- [x] CONTEXT.md更新

## ✅ 完了タスク（Day 4：課金実装 + 回数制限 ― Coworkコード作成）

- [x] pubspec.yaml に purchases_flutter / shared_preferences / url_launcher 追加
- [x] PurchaseService実装（lib/services/purchase_service.dart）― RevenueCat SDK連携
- [x] UsageService実装（lib/services/usage_service.dart）― 回数制限ロジック
- [x] DatabaseServiceにgetTodayScanCount()追加 ― 今日のスキャン回数取得
- [x] PaywallScreen実装（lib/screens/paywall_screen.dart）― 課金画面UI
- [x] HomeScreen大幅更新（StatefulWidget化、残り回数表示、制限到達UI、Paywall誘導）
- [x] main.dart更新（PurchaseService.init()追加）
- [x] Day 4作業ログ記録（logs/day4.md）
- [x] CONTEXT.md / CLAUDE.md更新

## ✅ 完了タスク（Day 4 後半：RevenueCat & App Store Connect 設定 ― Coworkブラウザ操作）

- [x] RevenueCat: プロジェクト「SnapEnglish」作成
- [x] RevenueCat: Entitlement「premium」作成
- [x] RevenueCat: Offering「default」+ Package「Monthly ($rc_monthly)」作成
- [x] RevenueCat: テストAPIキー取得（test_VKTpEiMZTHJslwzfWhhdFxkmXTf）
- [x] App Store Connect: In-App Purchase P8キー生成（P7PDD4P69G）
- [x] P8キーをRevenueCatにアップロード
- [x] Apple Developer: Bundle ID登録（com.marumiworks.snapEnglish）
- [x] App Store Connect: アプリ「SnapEnglish AI」登録（ID: 6759194623）
- [x] App Store Connect: サブスクリプション商品作成（snap_english_monthly_380、¥400/月）
- [x] App Store Connect: 日本語ローカリゼーション追加（プレミアムプラン/無制限スキャン＆フレーズ生成）
- [x] RevenueCat: Product Catalogに商品追加 + Entitlement紐付け + Offering紐付け
- [x] 設定値をlogs/day4.md・CLAUDE.md・CONTEXT.mdに記録

### ⚙️ RevenueCat & App Store Connect 設定値
| 項目 | 値 |
|---|---|
| RevenueCat テスト APIキー | `test_VKTpEiMZTHJslwzfWhhdFxkmXTf` |
| Product ID | `snap_english_monthly_380` |
| Entitlement | `premium` |
| 価格 | ¥400/月（USD $1.99）※¥380はApple標準価格帯外のため変更 |
| App Store Connect App ID | `6759194623` |
| App Store名 | SnapEnglish AI |
| Bundle ID | `com.marumiworks.snapEnglish` |
| SKU | `snap_english` |
| Team ID | `5CMYP437MX` |
| P8 Key ID | `P7PDD4P69G` |
| Issuer ID | `e359cd97-a6d4-4ef9-bcb3-24336fda0e74` |
  
## ✅ 完了タスク（Day 5：デザイン調整 + オンボーディング ― Claude Code CLI実装）

- [x] テーマ・カラーをティール系（#0097A7）に統一（lib/config/theme.dart 全面刷新）
- [x] オンボーディング画面実装（lib/screens/onboarding_screen.dart 新規 ~220行）
- [x] app.dart更新 — 初回起動判定ルーティング + スプラッシュ画面
- [x] ホーム画面UI改善（パルスアニメーション・グラデーション・ボトムシート改善）
- [x] フレーズカード洗練（番号バッジ・難易度アイコン・翻訳表示改善）
- [x] MainScreen簡素化（テーマ一括管理に移行）
- [x] アプリアイコン生成（flutter_launcher_icons で iOS/Android 全サイズ）
- [x] スプラッシュスクリーン設定（LaunchScreen.storyboard 背景色変更）
- [x] flutter analyze — No issues found
- [x] flutter build ios --simulator — 成功
- [x] Day 5作業ログ記録（logs/day5.md）
- [x] CONTEXT.md / CLAUDE.md更新

---

## ✅ 完了タスク（Day 6：App Store素材作成 ― Cowork）

- [x] App Store説明文 作成（日本語・英語）（2026-02-15 Cowork）→ `docs/appstore_metadata.md`
- [x] キーワード設定（日本語10語・英語10語）→ `docs/appstore_metadata.md`
- [x] プライバシーポリシー HTML作成 → `docs/privacy_policy.html`
- [x] 利用規約 HTML作成 → `docs/terms_of_service.html`
- [x] スクリーンショットモックアップ 5枚生成（1290x2796px）→ `assets/screenshots/`
- [x] App Store Connect入力チェックリスト作成 → `docs/day6_checklist.md`
- [x] Day 6作業ログ記録（logs/day6.md）
- [x] CONTEXT.md / CLAUDE.md更新

---

## ✅ 完了タスク（Day 7+：中継サーバー経由ビルド）

### 2026-02-16 Cowork
- [x] cowork-codex-relay サーバー接続確立（ngrok経由）
- [x] flutter build ios --release — 成功（28.2MB, 17.9秒）
- [x] xcode_release_pipeline — Archive成功 / Export失敗（Provisioning Profile不足）
- [x] ios/ExportOptions.plist 作成
- [x] .env.example 作成

### 2026-02-17 Yuya + Codex + Cowork
- [x] Provisioning Profile 作成（Yuya: Xcode Release自動署名ON）
- [x] In-App Purchase ケイパビリティ追加（Yuya: Xcode手動）
- [x] Codex: relay server に `-allowProvisioningUpdates` パッチ適用 + ランチャー作成
- [x] Cowork: 自動化スクリプト作成（relay-setup.sh / relay-start.sh / build-pipeline.sh）
- [x] **ビルドパイプライン成功: Archive → Export → App Store Connect アップロード完了**
  - v1.0.0 (1) が App Store Connect で「処理中」

---

## ✅ 完了タスク（Day 7+：App Store 審査提出 ― Cowork ブラウザ自動化）

### 2026-02-17 Cowork（Chrome MCP自動操作）
- [x] App Store Connect メタデータ全入力（説明文・キーワード・スクショ・年齢制限・プライバシーポリシー等）
- [x] データプライバシー設定（写真・購入履歴）+ 公開
- [x] 価格設定（$0.00 無料）
- [x] コンテンツ配信権設定（いいえ）
- [x] ビルド選択（v1.0.0 build 1）
- [x] iPadシミュレータスクショ撮影（relay経由）+ アップロード
- [x] **App Store 審査提出完了**（2026-02-17 02:28 JST）
  - ステータス: 「審査待ち」（最大48時間）

---

## 🔜 次のアクション（優先順）

1. **審査結果を待つ**（最大48時間、メール通知あり）
2. **審査でリジェクトされた場合** → 指摘内容に対応して再提出

### 中継サーバー（自動起動済み）

macOS LaunchAgent に登録済み。Mac ログイン時に自動起動するため、手動起動は不要。

```bash
# Mac側: ステータス確認
bash ~/Projects/ai-director-project/scripts/relay-service.sh status

# Mac側: ngrok URL 確認
bash ~/Projects/ai-director-project/scripts/relay-service.sh url

# Mac側: 再起動が必要な場合
bash ~/Projects/ai-director-project/scripts/relay-service.sh restart

# Mac側: 初回セットアップ（未実施の場合のみ）
bash ~/Projects/ai-director-project/scripts/relay-setup.sh <ngrokトークン>
bash ~/Projects/ai-director-project/scripts/relay-service.sh install

# Cowork側: ビルド全自動
bash scripts/build-pipeline.sh <ngrok-url>
```

安全装置: 連続5回失敗で自動停止、ログ10MBローテ、依存チェック、バックオフ再起動。
詳細: `.claude/skills/relay-file-transfer/` スキル参照。

### Git
- [x] 全変更コミット（6d32471: 51ファイル +4,667行）＋ push origin main（2026-02-17 Cowork）
- [x] ブランチ統合: claude/recursing-goldstine, claude/nervous-haibt → mainにマージ済み確認・削除完了
- [x] mainブランチのみのクリーン状態

### その他TODO
- [ ] App Store審査結果待ち（最大48時間 → 2/19頃まで）
- [x] Note記事④ 執筆完了 + 書き直し（2026-02-18 Cowork）→ articles/06_appstore_submission.md ¥500
  - 書き直し: 無料=Day5-7ストーリー完結、有料=実践ガイド（プロンプト設計・ツール使い分け・スキルファイル・チェックリスト）
  - noteエディタで本文差し替え＆有料境界移動完了（2026-02-18 Chrome MCP）
- [x] Note記事⑤ 下書き更新（2026-02-18 Cowork）→ articles/05_final_release.md ¥980
  - テンプレート形式、数値は審査通過・データ蓄積後に記入
- [x] Note記事④ noteに投稿（2026-02-18 Cowork Chrome MCP）
  - URL: https://note.com/marumi_works/n/n20169aa6db36
  - マガジン「AI監督プロジェクト」追加済み
- [ ] Note記事⑤ 数値記入＆投稿（審査通過・データ蓄積後）
- [ ] 記事②.5用スクショ撮影（docs/screenshot_guide_article3.md 参照）
- [ ] X投稿 Day 1-3（Draftsからスクショ添付して手動投稿）
- [x] X投稿 Day 6 予約投稿（2026-02-17 20:00 JST）
- [x] X投稿 Day 7 予約投稿（2026-02-18 20:00 JST）
- [ ] 記事①にClaude会話スクショを1-2枚追記
- [ ] 番外編（Noteの始め方ガイド）下書き作成
- [ ] 番外編（AIにNote投稿を自動化させてみた）※docs/article_ideas_memo.md 参照
- [ ] リレーサーバー LaunchAgent 初回install（Mac側で実行）
- [x] SEO改善: 全5記事ハッシュタグ統一＋内部リンク追加（2026-02-18 Cowork Chrome MCP）
  - 計画: docs/seo_improvement_plan.md / 共通3タグ＋記事別2タグ / シリーズ相互リンクブロック
- [x] note-seo-optimizerスキル作成（2026-02-18 Cowork）→ .skills/note-seo-optimizer/SKILL.md

---

## ⚠️ 新しいチャットを始めるときの指示テンプレート

```
以下のコンテキストドキュメントを読み込んでください。
これは「AI監督プロジェクト」の進行状況をまとめたものです。
前回のチャットからの続きとして、このドキュメントの内容を前提に会話を進めてください。

[ここにこのドキュメントの内容を貼り付け]

前回までの到達点：[ここに最新の状況を記入]
今回やりたいこと：[ここに今回の目的を記入]
```
