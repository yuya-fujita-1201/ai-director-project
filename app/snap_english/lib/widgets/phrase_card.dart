import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/phrase.dart';

class PhraseCard extends StatelessWidget {
  final Phrase phrase;
  final int index;

  const PhraseCard({
    super.key,
    required this.phrase,
    required this.index,
  });

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
                // お気に入りボタン（Day 3で実装、今はスタブ）
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  color: AppTheme.textSecondary,
                  onPressed: () {
                    // Day 3で実装
                  },
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 英語フレーズ
            Text(
              phrase.english,
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
              phrase.japanese,
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
    switch (phrase.difficulty) {
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
        phrase.difficultyLabel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }
}
