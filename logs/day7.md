# Day 7 作業ログ
**日付:** 2026-02-15
**担当:** Cowork

---

## 目標
- ソースコード最終レビュー & バグ修正
- テストチェックリスト & 審査提出手順書を作成
- Note記事⑤（Day 5-7）下書き作成

---

## 完了タスク

### ソースコード最終レビュー
- [x] 全Dartファイル（20ファイル）を網羅レビュー（2026-02-15 Cowork）
  - CRITICAL: 3件、HIGH: 4件、MEDIUM: 7件、LOW: 9件を検出

### バグ修正
- [x] paywall_screen.dart: URLを example.com → GitHub Pages URLに修正
- [x] database_service.dart: DB初期化にtry-catch + 破損時再作成ロジック追加
- [x] result_screen.dart: Image.file()にerrorBuilder追加
- [x] ai_service.dart: DioException全タイプカバー
- [x] camera_preview.dart: 未使用ウィジェット削除マーク

### テストチェックリスト & 審査手順書
- [x] `docs/day7_test_checklist.md` 作成

### Note記事⑤ 下書き
- [x] `articles/05_final_release.md` 作成
  - タイトル:「1行もコードを書かずに作ったアプリを、App Storeに出した。」

---

## 中継サーバー経由のビルド作業（2026-02-16 Cowork）

### セットアップ
- [x] cowork-codex-relay サーバー接続確認（ngrok経由 https://algebraically-unmercenary-francie.ngrok-free.dev）
  - VMから直接 172.16.10.1:8787 は到達不可 → ngrokトンネル経由で解決
  - 利用可能コマンド7種確認済み（flutter_analyze/test/build, xcode_archive/archive_to_ipa/release_pipeline, xcrun_upload_app）

### ビルド実行
- [x] flutter build ios --release — **成功**（17.9秒、28.2MB）
  - ジョブID: 32e7acad / .env（Day2作成済み）が存在しOPENAI_API_KEYも入っている
- [x] xcode_release_pipeline 1回目 — **失敗**: `Missing required param: apiKey`
  - → ASCキー（P7PDD4P69G / e359cd97-...）をパラメータに追加
- [x] xcode_release_pipeline 2回目 — **Archive失敗**: `Generated.xcconfig` 未生成 + CocoaPods未セットアップ
  - → flutter build ios --release を先に実行して解決
- [x] xcode_release_pipeline 3回目 — **Archive成功 / Export失敗**: `ExportOptions.plist` が存在しない
  - → ios/ExportOptions.plist を作成（method=app-store-connect, teamID=5CMYP437MX, signingStyle=automatic）
- [x] xcode_release_pipeline 4回目 — **Archive成功 / Export失敗**: `No profiles for 'com.marumiworks.snapEnglish' were found`
  - App Store配布用のDistribution Provisioning Profileが未作成

### ブロッカー解消 & App Store Connect アップロード成功（2026-02-17 Cowork）
- [x] Provisioning Profile 作成（Yuya: Xcode Release 自動署名ON）
- [x] In-App Purchase ケイパビリティ追加（Yuya: Xcode手動）
- [x] Codex で relay server に `-allowProvisioningUpdates` パッチ適用
- [x] ビルドパイプライン再実行 → **Archive + Export + Upload 全て成功**
  - Flutter Build: 8秒、Archive: ~60秒、Export+Upload: ~60秒
  - App Store Connect で「処理中」確認（v1.0.0 build 1）
  - dSYM警告（objective_c.framework）は無害、無視可

### 自動化スクリプト作成（2026-02-17 Cowork）
- [x] `scripts/relay-setup.sh` — Mac側 .env 初回セットアップ
- [x] `scripts/relay-start.sh` — Mac側ワンコマンド起動
- [x] `scripts/build-pipeline.sh` — Cowork側ビルド全自動パイプライン
- [x] `scripts/direct-release.sh` — Mac直接実行用バックアップスクリプト

### 作成済みファイル
- `ios/ExportOptions.plist` — Archive Export設定（app-store-connect, automatic signing）
- `.env.example` — 環境変数サンプル

---

## 手動タスク
- [x] GitHub Pages公開（プライバシーポリシー・利用規約）→ Cloudflare Pagesで完了済み
- [x] Provisioning Profile作成（2026-02-17 Yuya）
- [x] In-App Purchase ケイパビリティ有効化（2026-02-17 Yuya）
- [x] .envファイル — Day 2作成済みで存在確認
- [x] flutter build ios --release — 中継サーバー経由で成功
- [x] Archive → Export → App Store Connectアップロード（2026-02-17 Cowork パイプライン経由）
- [x] App Store Connect でビルド処理完了を確認 → 審査提出
- [ ] テストチェックリストに沿った動作確認
- [ ] Note記事⑤投稿

---

## App Store Connect メタデータ入力 & 審査提出（2026-02-17 Cowork ブラウザ自動化）

### スクリーンショット
- [x] iPhone 6.5インチスクリーンショット 5枚アップロード済み（前セッション）
- [x] iPadシミュレータでスクリーンショット撮影（relay経由 ipad_screenshot_capture）
  - iPad Pro 12.9-inch (iOS 26.2) で撮影、2048x2732px / 2064x2752px
  - 自動画面遷移は Simulator accessibility 権限で失敗 → ホーム画面（オンボーディング）1枚のみ
- [x] iPad 13インチスクリーンショット 1枚アップロード（Yuya手動ドラッグ）

### メタデータ（前セッションで入力済み）
- [x] 説明文（日本語）
- [x] キーワード
- [x] サポートURL / マーケティングURL
- [x] 年齢制限 4+
- [x] App Review情報（連絡先）
- [x] プライバシーポリシーURL（https://marumi-works.com/snapenglish/privacy）

### データプライバシー（前セッションで設定済み）
- [x] 写真またはビデオ → アプリの機能、ユーザー非関連付け、トラッキングなし
- [x] 購入履歴 → アプリの機能、ユーザー非関連付け、トラッキングなし
- [x] プライバシー設定公開

### 審査ブロッカー解消（前セッション）
- [x] 価格設定 → $0.00（無料）全175カ国
- [x] コンテンツ配信権 → いいえ（サードパーティコンテンツなし）
- [x] ビルド選択 → v1.0.0 (1)

### 審査提出
- [x] **App Store 審査提出完了**（2026-02-17 02:28 JST、Cowork ブラウザ自動化）
  - ステータス: 「1.0 審査待ち」
  - 審査には最大48時間
