/// 英語フレーズモデル
class Phrase {
  final String english;
  final String japanese;
  final String difficulty; // beginner / intermediate / advanced
  final DateTime createdAt;

  Phrase({
    required this.english,
    required this.japanese,
    required this.difficulty,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// JSONからPhraseを生成（APIが返す様々なキー名に対応）
  factory Phrase.fromJson(Map<String, dynamic> json) {
    // 英語フレーズ: 複数のキー名候補を試す
    final english = _findValue(json, [
      'english',
      'english_phrase',
      'phrase',
      'en',
      'sentence',
      'expression',
    ]);

    // 日本語訳: 複数のキー名候補を試す
    final japanese = _findValue(json, [
      'japanese',
      'japanese_translation',
      'translation',
      'ja',
      'meaning',
      'japanese_meaning',
    ]);

    // 難易度
    final difficulty = _findValue(json, [
      'difficulty',
      'level',
      'difficulty_level',
    ]);

    return Phrase(
      english: english,
      japanese: japanese,
      difficulty: difficulty.isNotEmpty ? difficulty : 'beginner',
    );
  }

  /// 候補キーリストから最初に見つかった値を返す
  static String _findValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key) && json[key] != null) {
        return json[key].toString();
      }
    }
    return '';
  }

  /// PhraseをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'english': english,
      'japanese': japanese,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 難易度の日本語表示
  String get difficultyLabel {
    switch (difficulty) {
      case 'beginner':
        return '初級';
      case 'intermediate':
        return '中級';
      case 'advanced':
        return '上級';
      default:
        return '初級';
    }
  }
}
