import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/phrase.dart';
import '../services/database_service.dart';

class PhraseCard extends StatefulWidget {
  final Phrase phrase;
  final int index;
  final void Function(bool isFavorite)? onFavoriteToggled;

  const PhraseCard({
    super.key,
    required this.phrase,
    required this.index,
    this.onFavoriteToggled,
  });

  @override
  State<PhraseCard> createState() => _PhraseCardState();
}

class _PhraseCardState extends State<PhraseCard> with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.phrase.isFavorite;
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(PhraseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phrase.isFavorite != oldWidget.phrase.isFavorite) {
      _isFavorite = widget.phrase.isFavorite;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    final phrase = widget.phrase;
    if (phrase.id == null) return; // DB未保存のフレーズは操作不可

    final db = DatabaseService.instance;
    final newState = await db.toggleFavorite(phrase.id!);

    setState(() => _isFavorite = newState);
    _animController.forward(from: 0);
    widget.onFavoriteToggled?.call(newState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 上段: 難易度バッジ + お気に入りボタン
            Row(
              children: [
                _buildDifficultyBadge(),
                const Spacer(),
                // お気に入りボタン（アニメーション付き）
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red.shade400 : AppTheme.textSecondary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 英語フレーズ
            Text(
              widget.phrase.english,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            // 日本語訳
            Text(
              widget.phrase.japanese,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary.withValues(alpha: 0.85),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge() {
    Color badgeColor;
    switch (widget.phrase.difficulty) {
      case 'beginner':
        badgeColor = const Color(0xFF4CAF50); // 緑
        break;
      case 'intermediate':
        badgeColor = const Color(0xFFFFC107); // 黄
        break;
      case 'advanced':
        badgeColor = const Color(0xFFF44336); // 赤
        break;
      default:
        badgeColor = const Color(0xFF4CAF50);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.phrase.difficultyLabel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }
}
