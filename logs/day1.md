# Day 1 作業ログ ― 2026-02-11
# 環境構築 + カメラ機能

---

## 目標
- Flutter環境構築 + プロジェクト作成
- カメラ撮影 → 画像表示の基本フロー実装
- iOSシミュレータで動作確認

---

## タイムライン

| 時刻 | 作業内容 | 担当 | ステータス |
|---|---|---|---|
| -- | アプリ設計書（app_spec.md）作成 | Cowork | ✅ 完了 |
| -- | 開発手順書（day1_dev_guide.md）作成 | Cowork | ✅ 完了 |
| -- | Flutterプロジェクト作成（flutter create） | Claude Code CLI | ✅ 完了 |
| -- | 依存パッケージ追加 + iOS権限設定 | Claude Code CLI | ✅ 完了 |
| -- | フォルダ構成 + 全ソースコード実装 | Claude Code CLI | ✅ 完了 |
| -- | カメラ機能実装（image_picker） | Claude Code CLI | ✅ 完了 |
| -- | ホーム画面 + 結果画面（スタブ）実装 | Claude Code CLI | ✅ 完了 |
| -- | flutter analyze → No issues found | Claude Code CLI | ✅ 完了 |
| -- | flutter build ios --simulator → ビルド成功 | Claude Code CLI | ✅ 完了 |
| -- | flutter test → All tests passed | Claude Code CLI | ✅ 完了 |
| -- | iPhone 17シミュレータで動作確認 | Claude Code CLI | ✅ 完了 |
| -- | Git コミット | Claude Code CLI | ⬜ 未実施 |
| -- | Day 1完了のX投稿 | 本人 | ⬜ 未実施 |

---

## 使ったツール

| ツール | 用途 |
|---|---|
| Cowork（Claude Desktop） | ドキュメント作成、作業ログ記録、X投稿文作成 |
| Claude Code CLI | Flutter開発、ビルド、テスト、動作確認 |
| Xcode Simulator（iPhone 17） | iOS動作確認 |

---

## 実装した内容

### プロジェクト構成
- `flutter create --org com.marumiworks snap_english`
- 配置先: `app/snap_english/`

### 追加パッケージ
- image_picker ^1.0.7（カメラ・ギャラリー）
- flutter_riverpod ^2.5.1（状態管理）
- dio ^5.4.1（HTTP通信 / Day 2用）
- sqflite ^2.3.2（ローカルDB / Day 3用）
- path_provider ^2.1.2（ファイルパス）
- path ^1.9.0（パスユーティリティ）

### 実装ファイル一覧
| ファイル | 内容 |
|---|---|
| `lib/main.dart` | ProviderScopeでラップ |
| `lib/app.dart` | MaterialApp設定 |
| `lib/config/theme.dart` | ブルー系テーマ (#2196F3) |
| `lib/config/constants.dart` | アプリ名・無料回数定数 |
| `lib/models/phrase.dart` | フレーズモデル（スタブ） |
| `lib/models/scan_result.dart` | スキャン結果モデル（スタブ） |
| `lib/services/camera_service.dart` | image_pickerのカメラ/ギャラリー機能 |
| `lib/screens/home_screen.dart` | 撮影ボタン + 残り回数モック表示 |
| `lib/screens/result_screen.dart` | 画像表示 + AI分析中プレースホルダー |
| `lib/widgets/camera_preview.dart` | カメラプレビュー（スタブ） |

### iOS権限
- NSCameraUsageDescription（カメラ使用許可）
- NSPhotoLibraryUsageDescription（フォトライブラリ使用許可）

---

## 品質チェック結果

| チェック項目 | 結果 |
|---|---|
| `flutter analyze` | ✅ No issues found |
| `flutter build ios --simulator` | ✅ ビルド成功 |
| `flutter test` | ✅ All tests passed |
| シミュレータ起動確認 | ✅ iPhone 17で動作確認済み |

---

## 発生した問題・解決策

（特に報告なし → 開発がスムーズに完了）

---

## 成果物

- [x] `docs/app_spec.md` ― アプリ設計書
- [x] `docs/day1_dev_guide.md` ― Day 1開発手順書
- [x] `app/snap_english/` ― Flutterプロジェクト（全ソースコード）
- [x] カメラ/ギャラリーから画像取得 → 結果画面に表示の動作確認
- [x] `articles/02_setup.md` ― 記事② 構成案
- [x] `x_posts/daily_posts.md` ― Day 1 X投稿文

---

## 振り返り

- **開発はエラーなしで完了**。flutter analyze / build / test すべてクリア
- Day 1のスコープ（環境構築 + カメラ基本機能）は予定通り達成
- Day 2のAI API連携に向けて、結果画面のスタブが用意できている
- 記事②用の素材（スクショ）を開発中に撮影していれば記事が書ける

---

## 記事②用の素材メモ

記事「ターミナルって何？からスタートして…」で使えそうなポイント:

- Claude Codeに「開発環境を作って」と頼んだ瞬間のスクショ
- flutter create の実行ログ
- シミュレータで初めてアプリが動いた画面のスクショ ★最重要
- カメラ機能が動いた瞬間のスクショ
- flutter analyze の "No issues found" のスクショ（一発合格の証拠）
- エラーが出て→AIに聞いて→解決した過程（今回は特になし）
