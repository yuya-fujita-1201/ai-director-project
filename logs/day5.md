# Day 5 作業ログ
**日付:** 2026-02-15
**担当:** Claude Code CLI

---

## 目標
- アプリテーマ・カラーをティール系に統一
- オンボーディング画面（初回起動時3ページスワイプ式）を実装
- フレーズカードUI洗練・アニメーション追加
- アプリアイコン仮デザイン・スプラッシュスクリーン設定

---

## 完了タスク

### テーマ・カラー統一
- [x] `lib/config/theme.dart` 全面刷新（2026-02-15 Claude Code CLI）
  - ブランドカラーをティール系（#0097A7）に変更
  - primaryColor / primaryDark / primaryLight / accent / background / surface / textPrimary / textSecondary / success / warning を定義
  - ThemeData に appBarTheme / elevatedButtonTheme / outlinedButtonTheme / bottomNavigationBarTheme / cardTheme を一括設定
  - 全画面で一貫したカラーパレットを使用

### オンボーディング画面
- [x] `lib/screens/onboarding_screen.dart` 新規作成（約220行）
  - 3ページスワイプ式チュートリアル
  - ページ1: 「撮って」— カメラアイコン + 説明
  - ページ2: 「学んで」— AIフレーズ生成アイコン + 説明
  - ページ3: 「続けて」— 学習習慣アイコン + 説明
  - ページインジケーター（アニメーション付き幅変化ドット）
  - スキップボタン / 次へボタン / 始めるボタン
  - shared_preferences で初回表示フラグ管理

### app.dart 更新
- [x] `lib/app.dart` 更新 — 初回起動判定ルーティング
  - `_InitialScreen` ウィジェット追加（スプラッシュ的表示）
  - shared_preferences で `onboarding_completed` フラグをチェック
  - 初回 → オンボーディング画面、2回目以降 → ホーム画面
  - Named routes (`/home`, `/onboarding`) 設定

### ホーム画面 UI改善
- [x] `lib/screens/home_screen.dart` 大幅更新
  - 撮影ボタンにパルスアニメーション追加（2秒周期で微妙に拡大縮小）
  - ボタンにグラデーション適用（primaryColor → accent）
  - 画像選択ボトムシートにハンドルバー・アイコン背景・サブタイトル追加
  - 全体のカラーをティール系に統一

### フレーズカード洗練
- [x] `lib/widgets/phrase_card.dart` 改善
  - フレーズ番号バッジ追加（丸囲み数字）
  - 難易度バッジにアイコン追加（初級:笑顔、中級:上昇、上級:炎）
  - 日本語訳を背景付きコンテナに変更（翻訳アイコン付き）
  - ボーダー・シャドウをティール系に統一

### MainScreen 簡素化
- [x] `lib/screens/main_screen.dart` 更新
  - BottomNavigationBar のスタイルをテーマで一括管理に移行
  - 不要なインラインスタイル削除

### アプリアイコン
- [x] `assets/icon/app_icon.png` 作成（1024x1024 — ティール背景 + カメラ + ABC吹き出し）
- [x] `assets/icon/app_icon_foreground.png` 作成（Android Adaptive Icons用）
- [x] `flutter_launcher_icons` で iOS / Android 全サイズ自動生成
  - `remove_alpha_ios: true` で App Store 対応

### スプラッシュスクリーン
- [x] `ios/Runner/Base.lproj/LaunchScreen.storyboard` 更新
  - 背景色をティール（#0097A7）に変更

---

## 技術メモ

### パッケージ追加（Day 5）
- `flutter_launcher_icons: ^0.14.3`（dev_dependencies）

### コード変更量（概算）
- theme.dart: 40行 → 90行（全面刷新）
- onboarding_screen.dart: ~220行（新規）
- app.dart: 19行 → 99行（ルーティング追加）
- home_screen.dart: 367行 → 416行（アニメーション・UI改善）
- phrase_card.dart: 165行 → 223行（洗練）
- main_screen.dart: 78行 → 54行（テーマ移行で簡素化）
- **新規コード: ~220行**
- **変更コード: ~200行**

### 累計コード量
- Day 1: 5,929行
- Day 2: 606行
- Day 3: ~1,270行
- Day 4: ~755行
- Day 5: ~420行
- **総計: ~8,980行**

---

## ビルド確認結果
- [x] `flutter pub get` — 成功（flutter_launcher_icons追加）
- [x] `flutter analyze` — No issues found
- [x] `flutter build ios --simulator` — 成功
- [x] Git コミット + プッシュ

---

## 所感
Day 5ではアプリのデザインを本格的に仕上げた。ティール系のブランドカラーで統一し、オンボーディング画面で初回ユーザーの導入フローを作成。フレーズカードには番号・難易度アイコン・翻訳表示を追加し、ホーム画面の撮影ボタンにはパルスアニメーションを付けてインタラクティブ感を高めた。アプリアイコンとスプラッシュスクリーンもティール色で統一し、ブランドの一貫性を確保した。
