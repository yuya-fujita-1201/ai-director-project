# AI監督プロジェクト ― Claude Code 設定

## プロジェクト概要
Claude Opus 4.6が企画・設計・実装判断を全て行い、人間はチャット指示のみでiOSアプリ「SnapEnglish」を1週間で開発・リリースする。過程をNote記事シリーズとして公開しマネタイズする。

## アプリ: SnapEnglish
- カメラで撮影 → AIが英語フレーズ3つ生成
- 技術スタック: Flutter/Dart, Firebase, AI Vision API, RevenueCat
- 無料: 1日3回 / 有料: 月額400円で無制限（当初380円予定→Apple標準価格帯に合わせ400円）
- Flutterプロジェクト配置先: `app/snap_english/`

## 開発ルール
1. コードは全てClaude Codeが書く（人間はコードを書かない）
2. 日本語でのチャット指示に従って実装する
3. 変更はこまめにgit commitする（日本語コミットメッセージ）
4. エラーが出たら自分で診断・修正を試みる
5. 作業ログを `logs/dayN.md` に記録する（下記ポリシー参照）

## ログ記録ポリシー
別セッションや別チャットからでもプロジェクト状況を正確に把握できるよう、以下を徹底する。

### いつ記録するか
- タスク完了時（コード実装、X投稿、Note公開、ビルド成功など）
- セッション終了前（途中であっても現在地を記録）

### 何を記録するか
1. **`logs/dayN.md`**: 該当タスクのチェックボックスを `[x]` に更新し、実施日時と手段を併記する
   - 例: `- [x] X投稿 Day 3（2026-02-14 Coworkから即時投稿済み／パターンA）`
2. **`CONTEXT.md`の「現在のステータス」**: 最新の進捗に更新する
3. **`CLAUDE.md`の「現在のステータス」**: CONTEXT.mdと同期させる

### 記録の原則
- **別セッションが読んでも状況がわかる**ことを最優先にする
- ファイルに書かれていないことは「やっていない」と見なされる前提で記録する
- 口頭（チャット）でのやり取りだけで完結させず、必ずファイルに残す

## フォルダ構成
```
├── app/snap_english/    # Flutterアプリ本体（Day 1に作成）
├── docs/                # 企画・設計ドキュメント
├── articles/            # Note記事原稿
├── x_posts/             # X投稿下書き
├── assets/              # アプリ素材（アイコン、スクショ）
├── logs/                # Day別作業ログ
├── revenue/             # 収益データ
├── CONTEXT.md           # 詳細なプロジェクトコンテキスト
└── CLAUDE.md            # このファイル
```

## 1週間スケジュール
- Day 1: 環境構築 + カメラ機能
- Day 2: AI API連携（画像→フレーズ生成）
- Day 3: UI仕上げ + お気に入り保存
- Day 4: 課金実装 + 回数制限
- Day 5: デザイン調整 + オンボーディング
- Day 6: App Store素材作成
- Day 7: 最終テスト + 審査提出

## 現在のステータス
- Day 0〜4 コード準備完了（Coworkで作成済み）
- Day 4: ビルドエラー修正・analyzeクリア・シミュレータ起動確認（2026-02-15 Claude Code CLI）
- Day 5: デザイン調整 + オンボーディング 実装完了（2026-02-15 Claude Code CLI）
  - テーマ・カラーをティール系に統一
  - オンボーディング画面（3ページスワイプ式）実装
  - フレーズカードUI洗練・ホーム画面アニメーション追加
  - アプリアイコン生成・スプラッシュスクリーン設定
- Day 4: 課金実装（RevenueCat + 回数制限 + Paywall UI）コード作成済み
- Day 4: RevenueCat & App Store Connect 設定完了（Coworkブラウザ経由 2026-02-14）
- X投稿: Day 3 投稿済み（2026-02-14）、Day 4 予約投稿済み（2026-02-15 20:00）
- Note記事③: Day3-4分投稿済み（2026-02-14 23:54） https://note.com/marumi_works/n/nd865836ad26e
- Note見出し画像: 全4記事設定完了（Day 0/1-2/Extra=手動、Day 3-4=Chrome拡張経由 2026-02-15）
- マガジン: 「AI監督プロジェクト ― 1週間アプリ開発記」作成・4記事登録済み（2026-02-15）
  - URL: https://note.com/marumi_works/m/mee0723eb1d8c
- Skill作成: app-store-connect-browser, revenuecat-browser, note-posting-browser, note-header-upload, note-header-image-gen
- Day 6: App Store素材作成完了（2026-02-15 Cowork）
  - App Store説明文（日本語・英語）→ docs/appstore_metadata.md
  - キーワード設定（日本語・英語）→ docs/appstore_metadata.md
  - プライバシーポリシー・利用規約 HTML → docs/privacy_policy.html, docs/terms_of_service.html
  - スクリーンショットモックアップ5枚 → assets/screenshots/
  - チェックリスト・手順書 → docs/day6_checklist.md
- Day 7: 最終レビュー & バグ修正完了（2026-02-15 Cowork）
  - 全Dartファイル網羅レビュー（CRITICAL 3件、HIGH 4件、MEDIUM 7件、LOW 9件検出）
  - paywall URLをexample.com→GitHub Pages URLに修正
  - DB初期化エラーハンドリング追加
  - Image.file errorBuilder追加
  - DioException全タイプカバー
  - テストチェックリスト → docs/day7_test_checklist.md
  - 審査提出手順書 → docs/day7_test_checklist.md
  - Note記事⑤下書き → articles/05_final_release.md
- 完了: Cloudflare Pages デプロイ完了（2026-02-15 Cowork）
  - https://marumi-works.com/snapenglish/privacy
  - https://marumi-works.com/snapenglish/terms
  - GitHub Actions + wrangler-action で自動デプロイ設定済み
- Day 7+: 中継サーバー（cowork-codex-relay）経由ビルド作業開始（2026-02-16 Cowork）
  - ngrokトンネル経由でVM→Mac通信確立
  - flutter build ios --release 成功（28.2MB）
  - xcode_release_pipeline: Archive成功 / **Export失敗**（Distribution Provisioning Profile未作成）
  - ios/ExportOptions.plist 作成済み（app-store-connect, teamID=5CMYP437MX）
  - .env.example 作成済み
- **ブロッカー解消** → ビルドパイプライン成功（2026-02-17 Cowork）
  - Provisioning Profile作成 + In-App Purchase追加（Yuya）
  - relay server `-allowProvisioningUpdates` パッチ（Codex）
  - **App Store Connect アップロード成功**: v1.0.0 (1) 処理中 → 審査提出待ち
- 自動化スクリプト作成（2026-02-17 Cowork）: scripts/relay-setup.sh, relay-start.sh, build-pipeline.sh
- **App Store 審査提出完了**（2026-02-17 02:28 JST Cowork ブラウザ自動化）
  - メタデータ全入力、データプライバシー設定・公開、価格$0.00、ビルド選択、iPadスクショアップロード
  - ステータス: 「審査待ち」（最大48時間）
- 待ち: 審査結果（メール通知）
- 待ち: Note記事⑤投稿（Yuya手動）
- 完了: 見出し画像 全4記事設定済み（2026-02-15）
- 完了: マガジン見出し画像設定済み（2026-02-15 Chrome拡張経由）
- 全Day（0-7+）のCowork側タスク完了

## 中継サーバー（cowork-codex-relay）
- 場所: `/Users/yuyafujita/Projects/cowork-codex-relay/`
- **自動起動**: macOS LaunchAgent 登録済み（Mac ログイン時に自動起動、クラッシュ時に自動再起動）
  - 管理: `bash scripts/relay-service.sh {status|restart|stop|logs|url}`
  - 安全装置: 連続5回失敗で停止、ログ10MBローテ、依存チェック、バックオフ
  - ngrok URL 自動保存: `/Users/yuyafujita/Projects/cowork-codex-relay/.ngrok_url`
- 手動起動（LaunchAgent 未設定時）: `bash scripts/relay-start.sh`
- ngrok経由でCowork VMからアクセス（直接IP接続は不可）
- ヘッダー: `Authorization: Bearer snap2026` + `ngrok-skip-browser-warning: true`
- 利用可能コマンド: flutter_analyze, flutter_test, flutter_build_ios_release, xcode_archive, xcode_archive_to_ipa, xcode_release_pipeline, xcrun_upload_app

## RevenueCat & App Store Connect 設定値
- RevenueCat テスト APIキー: `test_VKTpEiMZTHJslwzfWhhdFxkmXTf`
- Product ID: `snap_english_monthly_380`
- Entitlement: `premium`
- 価格: ¥400/月（¥380はApple標準価格帯になく変更）
- App Store Connect App ID: `6759194623`
- Bundle ID: `com.marumiworks.snapEnglish`
- P8 Key ID: `P7PDD4P69G`
- Issuer ID: `e359cd97-a6d4-4ef9-bcb3-24336fda0e74`
- ※詳細は `logs/day4.md` 参照

## コミットメッセージ規則
- `Day1: 環境構築完了` のようにDay番号を先頭につける
- 日本語で簡潔に
