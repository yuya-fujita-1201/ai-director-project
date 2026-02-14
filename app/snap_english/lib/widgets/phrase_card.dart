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

class _PhraseCardState extends State<PhraseCard>
    with SingleTickerProviderStateMixin {
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
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
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
    if (phrase.id == null) return;

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
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 上段: 番号 + 難易度バッジ + お気に入りボタン
            Row(
              children: [
                // フレーズ番号
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildDifficultyBadge(),
                const Spacer(),
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite
                          ? Colors.red.shade400
                          : AppTheme.textSecondary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 8),
            // 日本語訳（背景付き）
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.translate_rounded,
                    size: 16,
                    color: AppTheme.textSecondary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.phrase.japanese,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge() {
    Color badgeColor;
    IconData badgeIcon;
    switch (widget.phrase.difficulty) {
      case 'beginner':
        badgeColor = AppTheme.success;
        badgeIcon = Icons.sentiment_satisfied_rounded;
        break;
      case 'intermediate':
        badgeColor = AppTheme.warning;
        badgeIcon = Icons.trending_up_rounded;
        break;
      case 'advanced':
        badgeColor = const Color(0xFFF44336);
        badgeIcon = Icons.local_fire_department_rounded;
        break;
      default:
        badgeColor = AppTheme.success;
        badgeIcon = Icons.sentiment_satisfied_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            widget.phrase.difficultyLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
