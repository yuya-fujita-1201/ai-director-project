/// 英語フレーズモデル（Day 2でAI APIレスポンスから生成）
class Phrase {
  final String english;
  final String japanese;
  final String difficulty; // 初級 / 中級 / 上級

  Phrase({
    required this.english,
    required this.japanese,
    required this.difficulty,
  });
}
