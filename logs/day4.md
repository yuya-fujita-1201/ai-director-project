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

## 未完了・次回タスク

### 手動タスク（Yuya実施が必要）
- [ ] App Store Connect: サブスクリプション商品作成（snap_english_monthly_380、¥380/月）
- [ ] RevenueCat: プロジェクト作成 + iOS設定 + APIキー取得
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

## 所感
Day 4のコードはCowork側で全て準備できた。RevenueCat SDKの初期化〜購入〜復元の全フローと、無料3回制限のUI/ロジック、Paywall画面を実装した。Apple審査必須の要件（復元ボタン、利用規約リンク、サブスクリプション説明文）も全て含めた。手動でのRevenueCat設定とApp Store Connect設定が完了すれば、Claude Code CLIでビルド・テストして完了となる。
