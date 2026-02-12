import 'phrase.dart';

/// スキャン結果モデル（Day 3: id追加、DB連携対応）
class ScanResult {
  final int? id;
  final String imagePath;
  final List<Phrase> phrases;
  final DateTime scannedAt;

  ScanResult({
    this.id,
    required this.imagePath,
    required this.phrases,
    required this.scannedAt,
  });

  /// 先頭フレーズのプレビュー文字列
  String get previewPhrase {
    if (phrases.isEmpty) return '';
    return phrases.first.english;
  }

  /// フレーズ数
  int get phraseCount => phrases.length;
}
