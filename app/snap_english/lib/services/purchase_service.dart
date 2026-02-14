import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCatを使ったサブスクリプション課金サービス
class PurchaseService {
  static const _apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'appl_PLACEHOLDER', // RevenueCatダッシュボードで取得後に差し替え
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

    try {
      final config = PurchasesConfiguration(_apiKey);
      await Purchases.configure(config);
      _initialized = true;
    } catch (e) {
      // 初期化失敗時は無料モードとして動作
      // ignore: avoid_print
      print('RevenueCat初期化エラー: $e');
    }
  }

  /// プレミアム判定
  Future<bool> isPremium() async {
    if (!_initialized) return false;

    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 利用可能なオファリング取得
  Future<Offerings?> getOfferings() async {
    if (!_initialized) return null;

    try {
      return await Purchases.getOfferings();
    } catch (e) {
      return null;
    }
  }

  /// 購入実行
  Future<bool> purchase(Package package) async {
    if (!_initialized) return false;

    try {
      final result = await Purchases.purchasePackage(package);
      return result.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      // ユーザーキャンセルやエラー
      return false;
    }
  }

  /// 購入復元
  Future<bool> restore() async {
    if (!_initialized) return false;

    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }
}
