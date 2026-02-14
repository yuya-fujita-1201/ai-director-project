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
- 待ち: Claude Code CLIでflutter pub get / analyze / build
- 待ち: Xcode In-App Purchase capability有効化 + ToS/Privacy URL用意
- 完了: 見出し画像 全4記事設定済み（2026-02-15）
- 完了: マガジン見出し画像設定済み（2026-02-15 Chrome拡張経由）
- 次: Day 6 - App Store素材作成

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
