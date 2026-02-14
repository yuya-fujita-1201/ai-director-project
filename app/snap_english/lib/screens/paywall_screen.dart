import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../services/purchase_service.dart';

/// プレミアムプラン課金画面
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isLoading = true;
  bool _isPurchasing = false;
  Offerings? _offerings;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final offerings = await PurchaseService().getOfferings();

    if (mounted) {
      setState(() {
        _offerings = offerings;
        _isLoading = false;
        if (offerings == null || offerings.current == null) {
          _errorMessage = 'プランの読み込みに失敗しました';
        }
      });
    }
  }

  Future<void> _handlePurchase(Package package) async {
    setState(() => _isPurchasing = true);

    final success = await PurchaseService().purchase(package);

    if (mounted) {
      setState(() => _isPurchasing = false);

      if (success) {
        // 購入成功
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('プレミアムプランに登録しました！'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // trueを返して購入成功を伝える
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('購入がキャンセルされました'),
          ),
        );
      }
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isPurchasing = true);

    final success = await PurchaseService().restore();

    if (mounted) {
      setState(() => _isPurchasing = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('購入を復元しました！'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('復元する購入情報が見つかりませんでした'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('プレミアムプラン'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // アイコン
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          // タイトル
          const Text(
            'SnapEnglish Premium',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'もっと英語を学ぼう',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          // メリット一覧
          _buildFeatureItem(
            Icons.all_inclusive,
            '撮影回数 無制限',
            '1日何回でも撮影できます',
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.favorite,
            'お気に入り無制限保存',
            '気に入ったフレーズをいくらでも保存',
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.block,
            '広告なし',
            '集中して学習できます',
          ),
          const SizedBox(height: 40),
          // 価格表示 & 購入ボタン
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loadOfferings,
              child: const Text('再読み込み'),
            ),
          ] else ...[
            _buildPurchaseCard(),
          ],
          const SizedBox(height: 24),
          // 購入を復元
          TextButton(
            onPressed: _isPurchasing ? null : _handleRestore,
            child: const Text(
              '購入を復元する',
              style: TextStyle(
                color: AppTheme.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 注意事項
          const Text(
            'いつでもキャンセル可能です',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // 利用規約・プライバシーポリシー
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _openUrl('https://example.com/terms'),
                child: const Text(
                  '利用規約',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text(
                ' / ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              TextButton(
                onPressed: () => _openUrl('https://example.com/privacy'),
                child: const Text(
                  'プライバシーポリシー',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // サブスクリプション説明（Apple審査必須）
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '月額サブスクリプションは自動更新されます。'
              '購入確認時にiTunesアカウントに請求されます。'
              'サブスクリプションは現在の期間が終了する24時間前までに'
              '自動更新をオフにしない限り自動的に更新されます。'
              '設定アプリのサブスクリプション管理から解約できます。',
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseCard() {
    final monthlyPackage = _offerings?.current?.monthly;
    final priceString = monthlyPackage?.storeProduct.priceString ?? '¥400';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '月額 $priceString',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '/ 月',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isPurchasing || monthlyPackage == null
                  ? null
                  : () => _handlePurchase(monthlyPackage),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 0,
              ),
              child: _isPurchasing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'プレミアムに登録する',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
