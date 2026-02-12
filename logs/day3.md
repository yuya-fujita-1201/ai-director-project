# Day 3 作業ログ ― UI仕上げ + お気に入り保存

## 日付
2026-02-12

## 目標
- 3タブナビゲーション（ホーム / 履歴 / お気に入り）
- SQLiteによるデータ永続化
- お気に入り機能（ハートアニメーション + スワイプ削除）
- 撮影履歴一覧（サムネイル + フレーズプレビュー）

## 作業内容

### 1. 新規ファイル作成（4ファイル）

| ファイル | 説明 |
|---|---|
| `lib/services/database_service.dart` | SQLiteでお気に入り・履歴を永続化するサービス。scan_historyテーブルとphrasesテーブル（外部キー連携）。画像のアプリ内コピー、お気に入りトグル、CRUD操作を提供 |
| `lib/screens/main_screen.dart` | BottomNavigationBarによる3タブ（撮影/履歴/お気に入り）。IndexedStackで画面状態を保持 |
| `lib/screens/favorites_screen.dart` | お気に入りフレーズ一覧。Dismissibleでスワイプ削除、RefreshIndicatorでプルダウンリフレッシュ、元に戻すSnackBar |
| `lib/screens/history_screen.dart` | 撮影履歴一覧。サムネイル画像 + フレーズプレビュー + 日時表示。タップで詳細画面、長押しで削除 |

### 2. 既存ファイル更新（6ファイル）

| ファイル | 変更内容 |
|---|---|
| `lib/models/phrase.dart` | `id`（DB主キー）と`isFavorite`フィールド追加、`copyWith()`メソッド追加 |
| `lib/models/scan_result.dart` | `id`フィールド追加、`previewPhrase`と`phraseCount`ゲッター追加 |
| `lib/screens/result_screen.dart` | DB保存連携、`preloadedPhrases`引数追加（履歴から開く場合）、お気に入りコールバック |
| `lib/widgets/phrase_card.dart` | StatefulWidget化、ハートアニメーション（ScaleTransition）、DatabaseService連携 |
| `lib/app.dart` | HomeScreen → MainScreen に変更 |
| `pubspec.yaml` | `intl`と`share_plus`パッケージ追加 |

### 3. ビルド結果
- `flutter analyze` → No issues found!
- `flutter build ios --no-codesign` → 成功（16.1MB）

## 技術メモ
- SQLiteテーブル設計: `scan_history`（1）→ `phrases`（多）の1対多リレーション
- 画像はアプリのドキュメントディレクトリに自動コピー（元ファイルが消えても安全）
- お気に入りボタンは`AnimationController` + `TweenSequence`でぷるんとバウンスするアニメーション
- `IndexedStack`で3タブの状態を保持（切り替え時に再構築されない）

## 次のアクション（Day 4）
1. RevenueCat連携（課金機能）
2. 1日3回の回数制限実装
3. 課金UIの作成
