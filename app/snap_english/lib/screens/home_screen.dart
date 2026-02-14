import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/theme.dart';
import '../services/camera_service.dart';
import '../services/usage_service.dart';
import 'result_screen.dart';
import 'paywall_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _remainingScans = AppConstants.dailyFreeLimit;
  bool _isPremium = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshUsageInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// アプリがフォアグラウンドに戻ったとき回数を再取得
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshUsageInfo();
    }
  }

  Future<void> _refreshUsageInfo() async {
    final usageService = UsageService();
    final remaining = await usageService.remainingScans();
    final premium = await usageService.isPremiumUser();

    if (mounted) {
      setState(() {
        _remainingScans = remaining;
        _isPremium = premium;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (!_isPremium)
            IconButton(
              icon: const Icon(Icons.star_rounded, color: Colors.amber),
              tooltip: 'プレミアム',
              onPressed: () => _openPaywall(),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // 撮影ボタン
            Center(
              child: GestureDetector(
                onTap: () => _handleScanTap(),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: _canScan
                        ? AppTheme.primaryColor
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_canScan
                                ? AppTheme.primaryColor
                                : Colors.grey)
                            .withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    _canScan ? Icons.camera_alt : Icons.lock,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // メッセージ（制限到達かどうかで変わる）
            if (_canScan)
              const Text(
                '撮影して英語フレーズを学ぼう',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              )
            else
              Column(
                children: [
                  const Text(
                    '今日の無料回数を使い切りました',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _openPaywall(),
                    icon: const Icon(Icons.star_rounded, size: 20),
                    label: const Text('プレミアムにアップグレード'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '明日また3回使えます',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            const Spacer(flex: 2),
            // 残り回数表示
            _buildUsageIndicator(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// 撮影可能かどうか
  bool get _canScan => _isPremium || _remainingScans > 0;

  /// 残り回数表示ウィジェット
  Widget _buildUsageIndicator() {
    if (_isLoading) {
      return const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_isPremium) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            SizedBox(width: 8),
            Text(
              'Premium — 撮影回数 無制限',
              style: TextStyle(
                fontSize: 14,
                color: Colors.amber,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // 無料ユーザー
    final usedCount = AppConstants.dailyFreeLimit - _remainingScans;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: _remainingScans > 0
            ? AppTheme.primaryLight.withValues(alpha: 0.3)
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera,
                color: _remainingScans > 0
                    ? AppTheme.primaryColor
                    : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '今日の残り回数: $_remainingScans/${AppConstants.dailyFreeLimit}回',
                style: TextStyle(
                  fontSize: 14,
                  color: _remainingScans > 0
                      ? AppTheme.primaryDark
                      : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // プログレスバー
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usedCount / AppConstants.dailyFreeLimit,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _remainingScans > 0
                    ? AppTheme.primaryColor
                    : Colors.red,
              ),
              minHeight: 6,
            ),
          ),
          if (_remainingScans > 0 && _remainingScans < AppConstants.dailyFreeLimit) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _openPaywall(),
              child: const Text(
                '⭐ もっと使いたい？ → プレミアムプラン',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 撮影ボタンタップ処理
  void _handleScanTap() {
    if (_canScan) {
      _showImageSourceModal(context);
    } else {
      _openPaywall();
    }
  }

  /// Paywall画面を開く
  Future<void> _openPaywall() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const PaywallScreen()),
    );

    // 購入成功時は回数情報をリフレッシュ
    if (result == true) {
      _refreshUsageInfo();
    }
  }

  void _showImageSourceModal(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '画像を選択',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                title: const Text('カメラで撮影'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _takePhoto(parentContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppTheme.primaryColor),
                title: const Text('ギャラリーから選択'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickFromGallery(parentContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto(BuildContext context) async {
    final cameraService = CameraService();
    final image = await cameraService.takePhoto();
    if (image != null && context.mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imagePath: image.path),
        ),
      );
      // 結果画面から戻ったら回数をリフレッシュ
      _refreshUsageInfo();
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final cameraService = CameraService();
    final image = await cameraService.pickFromGallery();
    if (image != null && context.mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imagePath: image.path),
        ),
      );
      // 結果画面から戻ったら回数をリフレッシュ
      _refreshUsageInfo();
    }
  }
}
