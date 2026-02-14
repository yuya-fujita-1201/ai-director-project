import '../config/constants.dart';
import 'database_service.dart';
import 'purchase_service.dart';

/// 無料ユーザーの1日3回制限を管理するサービス
class UsageService {
  // シングルトン
  static final UsageService _instance = UsageService._();
  factory UsageService() => _instance;
  UsageService._();

  /// 撮影可能か判定
  Future<bool> canScan() async {
    final isPremium = await PurchaseService().isPremium();
    if (isPremium) return true;

    final count = await DatabaseService.instance.getTodayScanCount();
    return count < AppConstants.dailyFreeLimit;
  }

  /// 残り回数を取得（プレミアムの場合は -1 = 無制限）
  Future<int> remainingScans() async {
    final isPremium = await PurchaseService().isPremium();
    if (isPremium) return -1; // 無制限

    final count = await DatabaseService.instance.getTodayScanCount();
    return (AppConstants.dailyFreeLimit - count).clamp(0, AppConstants.dailyFreeLimit);
  }

  /// 今日の使用回数を取得
  Future<int> todayUsedCount() async {
    return await DatabaseService.instance.getTodayScanCount();
  }

  /// プレミアムか判定
  Future<bool> isPremiumUser() async {
    return await PurchaseService().isPremium();
  }
}
