# AI監督プロジェクト ― Claude Code 設定

## プロジェクト概要
Claude Opus 4.6が企画・設計・実装判断を全て行い、人間はチャット指示のみでiOSアプリ「SnapEnglish」を1週間で開発・リリースする。過程をNote記事シリーズとして公開しマネタイズする。

## アプリ: SnapEnglish
- カメラで撮影 → AIが英語フレーズ3つ生成
- 技術スタック: Flutter/Dart, Firebase, AI Vision API, RevenueCat
- 無料: 1日3回 / 有料: 月額380円で無制限
- Flutterプロジェクト配置先: `app/snap_english/`

## 開発ルール
1. コードは全てClaude Codeが書く（人間はコードを書かない）
2. 日本語でのチャット指示に従って実装する
3. 変更はこまめにgit commitする（日本語コミットメッセージ）
4. エラーが出たら自分で診断・修正を試みる
5. 作業ログを `logs/dayN.md` に記録する

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
- Day 0 完了（記事①公開済み）
- 次: Day 1 - Flutter環境構築 + カメラ機能実装

## コミットメッセージ規則
- `Day1: 環境構築完了` のようにDay番号を先頭につける
- 日本語で簡潔に
