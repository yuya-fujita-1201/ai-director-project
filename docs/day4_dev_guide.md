# Day 4 開発手順書 ― 課金実装 + 回数制限

## 目標
- RevenueCat + purchases_flutter で月額サブスクリプション（¥380）を実装
- 無料ユーザーの1日3回制限を実装
- プレミアム判定ロジック + 課金画面UIを作成

---

## 前提条件

### App Store Connect（手動作業）
1. ✅ 有料アプリ配信契約（Paid Applications Agreement）が締結済み
2. ✅ 税務・銀行情報の登録済み
3. サブスクリプション商品の作成:
   - Monetization → Subscriptions → 「サブスクリプショングループ」作成
   - グループ名: `snap_english_premium`
   - 商品ID: `snap_english_monthly_380`
   - 期間: 1ヶ月
   - 価格: ¥380

### RevenueCat ダッシュボード
1. プロジェクト作成（SnapEnglish）
2. iOSアプリ追加（Bundle ID + App-Specific Shared Secret）
3. Products に `snap_english_monthly_380` を追加
4. Entitlements に `premium` を作成 → 商品を紐付け
5. Offerings の `default` にパッケージ追加（Monthly）
6. APIキーを取得（iOS Public API Key）

---

## 実装ステップ

### Step 1: パッケージ追加

```yaml
# pubspec.yaml に追加
dependencies:
  purchases_flutter: ^8.0.0
```

```bash
cd app/snap_english && flutter pub get
```

### Step 2: iOS設定

Xcode で In-App Purchase ケイパビリティを有効化:
- `ios/Runner.xcodeproj` → Signing & Capabilities → + Capability → In-App Purchase

iOS deployment target が 13.0以上であること確認。

### Step 3: RevenueCat サービス実装

**新規ファイル: `lib/services/purchase_service.dart`**

```dart
import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
  static const _apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'appl_XXXXXXXXX', // 開発用デフォルト
  );

  static const entitlementId = 'premium';

  // シングルトン
  static final PurchaseService _instance = PurchaseService._();
  factory PurchaseService() => _instance;
  PurchaseService._();

  bool _initialized = false;

  /// SDK初期化（main.dartで呼ぶ）
  Future<void> init() async {
    if (_initialized) return;

    final config = PurchasesConfiguration(_apiKey);
    await Purchases.configure(config);
    _initialized = true;
  }

  /// プレミアム判定
  Future<bool> isPremium() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 利用可能なオファリング取得
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      return null;
    }
  }

  /// 購入実行
  Future<bool> purchase(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      return result.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 購入復元
  Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }
}
```

### Step 4: 使用回数制限ロジック

**DatabaseService に追加（既存メソッドを活用）**

`getTodayScanCount()` は Day 3 で実装済み。以下の定数とヘルパーを追加:

```dart
// lib/services/usage_service.dart（新規）
import 'package:snap_english/services/database_service.dart';
import 'package:snap_english/services/purchase_service.dart';

class UsageService {
  static const int freeLimit = 3;

  static final UsageService _instance = UsageService._();
  factory UsageService() => _instance;
  UsageService._();

  /// 撮影可能か判定
  Future<bool> canScan() async {
    final isPremium = await PurchaseService().isPremium();
    if (isPremium) return true;

    final count = await DatabaseService().getTodayScanCount();
    return count < freeLimit;
  }

  /// 残り回数を取得（プレミアムの場合は -1 = 無制限）
  Future<int> remainingScans() async {
    final isPremium = await PurchaseService().isPremium();
    if (isPremium) return -1;

    final count = await DatabaseService().getTodayScanCount();
    return (freeLimit - count).clamp(0, freeLimit);
  }
}
```

### Step 5: 課金画面UI

**新規ファイル: `lib/screens/paywall_screen.dart`**

レイアウト:
```
┌─────────────────────────────────────┐
│       SnapEnglish Premium           │
│                                     │
│  ✅ 撮影回数 無制限                  │
│  ✅ お気に入り無制限保存              │
│  ✅ 広告なし                         │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  月額 ¥380                   │    │
│  │  [購入する]                   │    │
│  └─────────────────────────────┘    │
│                                     │
│  購入を復元する                      │
│                                     │
│  ※ いつでもキャンセル可能             │
│  利用規約 / プライバシーポリシー       │
└─────────────────────────────────────┘
```

特徴:
- 明確な価値訴求（3つのメリット）
- 価格の明示
- 復元ボタン（Apple審査必須）
- 利用規約リンク（Apple審査必須）
- ローディングインジケータ（購入中）

### Step 6: ホーム画面への制限UI統合

HomeScreen の撮影ボタン周りに残り回数表示を追加:

```
残り 2/3 回（今日）
  [📷 撮影する]

⭐ もっと使いたい？ → プレミアムプラン
```

制限到達時:
```
今日の無料回数を使い切りました

  [⭐ プレミアムにアップグレード]

  明日また3回使えます
```

### Step 7: main.dart 更新

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PurchaseService().init();  // ← 追加
  runApp(const SnapEnglishApp());
}
```

---

## テスト項目

### 回数制限
- [ ] 1回目〜3回目: 正常に撮影可能
- [ ] 3回撮影後: 制限画面が表示される
- [ ] 日付が変わると回数リセット

### 課金フロー
- [ ] 課金画面が正しく表示される
- [ ] オファリングが正しく読み込まれる
- [ ] Sandboxで購入フローが動作する
- [ ] 購入後にプレミアム判定がtrueになる
- [ ] 購入復元が動作する

### エッジケース
- [ ] ネットワークオフラインでの挙動
- [ ] RevenueCat初期化失敗時（無料として動作）
- [ ] アプリ再起動後のプレミアム状態維持

---

## コミット計画

```
Day4: RevenueCat SDK + PurchaseService実装
Day4: 使用回数制限ロジック追加
Day4: 課金画面UI + ホーム画面の制限表示
Day4: テスト + バグ修正
```

---

## ⚠️ 注意事項

1. **APIキーの管理**: `--dart-define=REVENUECAT_API_KEY=xxx` でビルド時に渡す。コードにハードコードしない。
2. **Sandbox テスト**: App Store Connect でサンドボックステスターを作成すること。
3. **Apple審査要件**:
   - 「購入を復元する」ボタンは必須
   - 利用規約・プライバシーポリシーのリンクは必須
   - サブスクリプションの価格・期間・自動更新の説明は必須
4. **RevenueCat無料枠**: 月$2,500 MRRまで無料（初期は十分）
