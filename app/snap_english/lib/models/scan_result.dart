import 'phrase.dart';

/// スキャン結果モデル（Day 2以降で拡充）
class ScanResult {
  final String imagePath;
  final List<Phrase> phrases;
  final DateTime scannedAt;

  ScanResult({
    required this.imagePath,
    required this.phrases,
    required this.scannedAt,
  });
}
