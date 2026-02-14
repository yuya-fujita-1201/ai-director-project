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

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  int _remainingScans = AppConstants.dailyFreeLimit;
  bool _isPremium = false;
  bool _isLoading = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _refreshUsageInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    super.dispose();
  }

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
        title: const Text(AppConstants.appName),
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
            // 撮影ボタン（パルスアニメーション付き）
            Center(
              child: GestureDetector(
                onTap: () => _handleScanTap(),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _canScan ? _pulseAnimation.value : 1.0,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: _canScan
                          ? const LinearGradient(
                              colors: [AppTheme.primaryColor, AppTheme.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: _canScan ? null : Colors.grey.shade400,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_canScan
                                  ? AppTheme.primaryColor
                                  : Colors.grey)
                              .withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      _canScan ? Icons.camera_alt_rounded : Icons.lock_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // メッセージ
            if (_canScan)
              Text(
                '撮影して英語フレーズを学ぼう',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
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
                      backgroundColor: AppTheme.warning,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
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

  bool get _canScan => _isPremium || _remainingScans > 0;

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
          gradient: LinearGradient(
            colors: [
              AppTheme.warning.withValues(alpha: 0.15),
              AppTheme.warning.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_rounded, color: AppTheme.warning, size: 20),
            const SizedBox(width: 8),
            Text(
              'Premium — 撮影回数 無制限',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final usedCount = AppConstants.dailyFreeLimit - _remainingScans;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: _remainingScans > 0
            ? AppTheme.primaryLight.withValues(alpha: 0.4)
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_rounded,
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
          if (_remainingScans > 0 &&
              _remainingScans < AppConstants.dailyFreeLimit) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _openPaywall(),
              child: Text(
                'もっと使いたい？ → プレミアムプラン',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleScanTap() {
    if (_canScan) {
      _showImageSourceModal(context);
    } else {
      _openPaywall();
    }
  }

  Future<void> _openPaywall() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const PaywallScreen()),
    );

    if (result == true) {
      _refreshUsageInfo();
    }
  }

  void _showImageSourceModal(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '画像を選択',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: AppTheme.primaryColor),
                ),
                title: const Text('カメラで撮影',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('身の回りのモノを撮影'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _takePhoto(parentContext);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: AppTheme.primaryColor),
                ),
                title: const Text('ギャラリーから選択',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('保存済みの写真を使う'),
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
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imagePath: image.path),
        ),
      );
      _refreshUsageInfo();
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final cameraService = CameraService();
    final image = await cameraService.pickFromGallery();
    if (image != null && context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imagePath: image.path),
        ),
      );
      _refreshUsageInfo();
    }
  }
}
