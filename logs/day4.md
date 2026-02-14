# Day 4 作業ログ
**日付:** 2026-02-14
**担当:** Cowork（コード作成）

---

## 目標
- RevenueCat + purchases_flutter で月額サブスクリプション（¥380）を実装
- 無料ユーザーの1日3回制限を実装
- プレミアム判定ロジック + 課金画面UIを作成

---

## 完了タスク

### パッケージ追加
- [x] `pubspec.yaml` に `purchases_flutter: ^8.0.0` 追加
- [x] `pubspec.yaml` に `shared_preferences: ^2.2.2` 追加
- [x] `pubspec.yaml` に `url_launcher: ^6.2.4` 追加

### コード実装（新規ファイル）
- [x] `lib/services/purchase_service.dart` ― RevenueCat課金サービス
  - シングルトンパターン
  - SDK初期化（`--dart-define=REVENUECAT_API_KEY=xxx` で渡す設計）
  - プレミアム判定（entitlement: `premium`）
  - オファリング取得・購入実行・購入復元
  - CustomerInfoストリーム（状態変更監視）
  - 初期化失敗時は無料モードとしてフォールバック

- [x] `lib/services/usage_service.dart` ― 使用回数制限サービス
  - シングルトンパターン
  - `canScan()`: プレミアム or 残り回数ありで撮影可能判定
  - `remainingScans()`: 残り回数取得（プレミアム時は-1=無制限）
  - `todayUsedCount()`: 今日の使用回数
  - `isPremiumUser()`: プレミアム判定ラッパー

- [x] `lib/screens/paywall_screen.dart` ― 課金画面UI（約320行）
  - グラデーション付きプレミアムアイコン
  - 3つのメリット表示（無制限撮影・お気に入り無制限・広告なし）
  - RevenueCatオファリングからの動的価格表示
  - 購入ボタン + ローディングインジケータ
  - 「購入を復元する」ボタン（Apple審査必須）
  - 利用規約・プライバシーポリシーリンク（Apple審査必須）
  - サブスクリプション自動更新の説明文（Apple審査必須）
  - エラー時の再読み込みUI

### コード実装（更新ファイル）
- [x] `lib/services/database_service.dart` ― getTodayScanCount() メソッド追加
  - 今日のスキャン回数をSQLiteからカウント
  - 日付範囲（当日0:00〜23:59）で検索

- [x] `lib/screens/home_screen.dart` ― 大幅更新（StatelessWidget → StatefulWidget）
  - `WidgetsBindingObserver` でアプリ復帰時に回数リフレッシュ
  - 残り回数のリアルタイム表示（プログレスバー付き）
  - プレミアムユーザー: ⭐ Premium — 撮影回数 無制限
  - 無料ユーザー: 残り N/3 回（今日）+ プログレスバー
  - 制限到達時: ロックアイコン + アップグレード誘導ボタン
  - AppBarに⭐プレミアムボタン追加
  - 撮影後の回数自動リフレッシュ
  - 「もっと使いたい？→プレミアムプラン」リンク

- [x] `lib/main.dart` ― PurchaseService.init() 追加

---

## 技術メモ

### RevenueCat APIキーの扱い
- コードにハードコードしない
- `--dart-define=REVENUECAT_API_KEY=appl_xxxx` でビルド時に渡す
- デフォルト値は `appl_PLACEHOLDER`（開発用）
- `.env` ファイルではなく `String.fromEnvironment` で読み取り

### Apple審査必須要件（PaywallScreenに実装済み）
1. 「購入を復元する」ボタン ✅
2. 利用規約リンク ✅
3. プライバシーポリシーリンク ✅
4. サブスクリプションの価格・期間・自動更新の説明 ✅

### Day 4で追加されたコード量（概算）
- purchase_service.dart: ~90行
- usage_service.dart: ~45行
- paywall_screen.dart: ~320行
- home_screen.dart: ~280行（既存163行→367行、大幅更新）
- database_service.dart: +15行（getTodayScanCount追加）
- main.dart: +2行
- **新規コード合計: 約455行**
- **更新コード変更: 約300行**

### 累計コード量
- Day 1: 5,929行
- Day 2: 606行
- Day 3: ~1,270行
- Day 4: ~755行（新規+変更）
- **総計: ~8,560行**

---

## RevenueCat & App Store Connect 設定完了（2026-02-14 Coworkブラウザ操作）

### 設定値一覧
| 項目 | 値 |
|---|---|
| App Store Connect App ID | 6759194623 |
| App Store 名 | SnapEnglish AI |
| Bundle ID | com.marumiworks.snapEnglish |
| SKU | snap_english |
| Team ID | 5CMYP437MX |
| P8 Key ID | P7PDD4P69G |
| Issuer ID | e359cd97-a6d4-4ef9-bcb3-24336fda0e74 |
| RevenueCat テスト APIキー | test_VKTpEiMZTHJslwzfWhhdFxkmXTf |
| RevenueCat Entitlement | premium |
| RevenueCat Offering | default |
| Subscription Group | SnapEnglish Premium (ID: 21934117) |
| Subscription Apple ID | 6759194719 |
| Product ID | snap_english_monthly_380 |
| 価格 | ¥400/月（USD $1.99）※¥380はApple標準価格帯になく¥400に変更 |
| ローカリゼーション(ja) | 表示名: プレミアムプラン / 説明: 無制限スキャン＆フレーズ生成 |

### 完了した手動設定
- [x] RevenueCat: プロジェクト「SnapEnglish」作成（2026-02-14 Coworkブラウザ経由）
- [x] RevenueCat: Entitlement「premium」作成
- [x] RevenueCat: Offering「default」+ Package「Monthly ($rc_monthly)」作成
- [x] RevenueCat: テストAPIキー取得（test_VKTp...）
- [x] App Store Connect: In-App Purchase P8キー生成（P7PDD4P69G）
- [x] P8キーをRevenueCatにアップロード（Issuer ID + Key ID設定）
- [x] Apple Developer: Bundle ID登録（com.marumiworks.snapEnglish）
- [x] App Store Connect: アプリ「SnapEnglish AI」登録（ID: 6759194623）
- [x] App Store Connect: サブスクリプショングループ「SnapEnglish Premium」作成
- [x] App Store Connect: サブスクリプション商品作成（snap_english_monthly_380、¥400/月）
- [x] App Store Connect: 日本語ローカリゼーション追加
- [x] RevenueCat: Product Catalogに商品追加（snap_english_monthly_380）
- [x] RevenueCat: Entitlement「premium」を商品に紐付け
- [x] RevenueCat: Offering「default」→ Monthly Package に商品を紐付け

### 未完了・次回タスク
- [ ] Xcode: In-App Purchaseケイパビリティ有効化
- [ ] 利用規約・プライバシーポリシーのURL用意（example.comを実URLに差し替え）

### Claude Code CLIで実施が必要
- [ ] `flutter pub get`（新パッケージインストール）
- [ ] `flutter analyze` 実行
- [ ] `flutter build ios --simulator` 実行
- [ ] iPhoneシミュレータで動作確認
- [ ] Git コミット + プッシュ

### テスト確認項目
- [ ] 1回目〜3回目: 正常に撮影可能
- [ ] 3回撮影後: 制限画面が表示される
- [ ] 日付が変わると回数リセット
- [ ] 課金画面が正しく表示される
- [ ] 購入復元が動作する（Sandbox）

---

## 記事・SNS
- [x] Note記事③（Day 3-4分）投稿済み（2026-02-14 23:54）
  - URL: https://note.com/marumi_works/n/nd865836ad26e
  - タイトル: 「AIの指示通りに進めたら3日目にアプリが動いた。自分は何も理解していない」
  - HTMLペースト方式で書式を正確に反映（ProseMirrorエディタ対応）
  - ハッシュタグ: #AI #アプリ開発 #iOS #個人開発 #Claude
  - 見出し画像: `assets/header_day3-4.png` 作成済み（手動アップロード待ち）
- [x] X投稿 Day 3 投稿済み（2026-02-14 パターンA）
- [x] X投稿 Day 4 予約投稿済み（2026-02-15 20:00 JST予約／パターンA）
- [x] マガジン宣伝ポスト 予約投稿済み（2026-02-15 12:00 JST予約／マガジンURL付き）
- [x] 見出し画像 Day 3-4用作成（2026-02-15 Cowork Pillow生成 1280x670px）
  - ファイル: `assets/header_day3-4.png` → v2で大きな中央テキストに改善
  - 生成スクリプト: `gen_header_day3-4.py`（デュアルフォント対応: Latin+CJK）
- [x] 見出し画像 Day 3-4 Noteにアップロード完了（2026-02-15 Chrome拡張経由）
  - Chrome拡張（URL to File Input）+ tmpfiles.org経由でCORS回避
  - v2画像（中央フォーカス・大きなテキスト）をセット・保存済み

## マガジン整理（2026-02-15 Coworkブラウザ操作）
- [x] 記事③をマガジン「はじめてのAIツール入門シリーズ」から削除
  - JS操作: `.o-magazineArrangeNotesItem__bodyDelete` の `<i>` 要素を `.click()` で削除
- [x] 新マガジン「AI監督プロジェクト ― 1週間アプリ開発記」作成
  - URL: https://note.com/marumi_works/m/mee0723eb1d8c
  - 説明: Claude Opus 4.6がすべてを企画・設計・実装する。人間はチャットで指示するだけ。
  - 設定: 無料、リスト(小)、公開
- [x] 全4記事を新マガジンに登録
  - Day 0: Claude Opus 4.6がリリースされたので...（n00a946fe68da）
  - Day 1-2: ターミナルって何？からスタートして...（ne17c13515413）
  - Extra: コード0行でアプリを作る「道具」の使い方...（n3a6e38b5ce12）
  - Day 3-4: AIの指示通りに進めたら3日目に...（nd865836ad26e）

## マガジン見出し画像（2026-02-15 Cowork Pillow + Chrome拡張）
- [x] マガジン見出し画像生成（`assets/header_magazine.png` 1280x670px）
  - 生成スクリプト: `gen_header_magazine.py`
  - デザイン: ダーク背景グラデーション、「AI監督プロジェクト」(72px グラデーション)、「1週間アプリ開発記」(52px)、Day進捗ドット
- [x] マガジン見出し画像 Noteアップロード完了（2026-02-15 Chrome拡張経由）
  - tmpfiles.org経由 → Chrome拡張でfile input注入 → クロップモーダル保存 → 更新ボタン
  - マガジン編集ページではlabel.click()ではなくfileInput.click()が必要（重要な技術的発見）

## Skill作成
- [x] app-store-connect-browser（`.skills/`配下）
- [x] revenuecat-browser（`.skills/`配下）
- [x] note-posting-browser（`.skills/`配下）― Note投稿の自動化ノウハウ
- [x] note-header-upload（`.skills/`配下）― Chrome拡張経由の見出し画像アップロード
- [x] note-header-image-gen（`.skills/`配下）― Pillow見出し画像生成ノウハウ

## 所感
Day 4のコードはCowork側で全て準備できた。RevenueCat SDKの初期化〜購入〜復元の全フローと、無料3回制限のUI/ロジック、Paywall画面を実装した。Apple審査必須の要件（復元ボタン、利用規約リンク、サブスクリプション説明文）も全て含めた。手動でのRevenueCat設定とApp Store Connect設定が完了すれば、Claude Code CLIでビルド・テストして完了となる。

Note記事③も投稿完了。HTMLペースト方式でMarkdownの書式（見出し、太字、引用）が正しく反映されることを確認。この手順をnote-posting-browserスキルとして記録した。
