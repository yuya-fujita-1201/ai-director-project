# AI監督プロジェクト ― コンテキスト引き継ぎドキュメント
# 最終更新: 2026-02-14 Day 4コード作成完了（Cowork）― CLIビルド・RevenueCat設定待ち

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
- 有料（月額380円）：無制限 + お気に入り保存

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
| ②.5 | コード0行でアプリを作る「道具」の使い方 ― Claude Desktop × Cowork 実践ガイド | 無料 | ✅ **公開済み**（articles/03_tool_guide.md）スクショ後日追加予定 |
| ③ | AIの指示通りに進めたら3日目にアプリが動いた。自分は何も理解していない | 無料 | ✅ **初稿完了**（articles/04_app_working.md）Day 4部分は追記予定 |
| ④ | App Storeの申請まで全部AIにやらせた ― 審査提出までの72時間 | ¥500 | 未着手 |
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

---

## 🔜 次のアクション（優先順）

### Day 4残りタスク（Claude Code CLIで実施）
1. **ビルド確認**
   - `flutter pub get`（新パッケージインストール）
   - `flutter analyze`
   - `flutter build ios --simulator`
   - iPhoneシミュレータで動作確認
   - Git コミット + プッシュ

### 手動タスク（Yuya実施）
2. **RevenueCat設定**（Day 4で実装したコードを動かすために必要）
   - App Store Connect: サブスクリプション商品作成（snap_english_monthly_380、¥380/月）
   - RevenueCat: プロジェクト作成 + iOS設定 + APIキー取得
   - Xcode: In-App Purchaseケイパビリティ有効化
   - 利用規約・プライバシーポリシーのURL用意
3. **見出し画像アップロード**
   - 記事①: `assets/header_day0.png` をNoteで設定
   - 記事②: `assets/header_day1-2.png` をNoteで設定
   - 記事②.5: `assets/header_day2-5.png` をNoteで設定
4. **記事②.5用スクショ撮影**（docs/screenshot_guide_article3.md 参照。後日追加）
5. **X投稿 Day 1-3**（Draftsからスクショ添付して手動投稿）

### 記事作業（Cowork）
6. **記事③を完成させる**（articles/04_app_working.md をDay 4実装後に追記・仕上げ）
7. **記事③用 見出し画像を生成**（docs/header_image_template.md 参照）

### 後日TODO
- [ ] 記事①にClaude会話スクショを1-2枚追記
- [ ] 番外編（Noteの始め方ガイド）下書き作成
- [ ] 番外編（AIにNote投稿を自動化させてみた）※docs/article_ideas_memo.md 参照

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
