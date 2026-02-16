import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/phrase.dart';

class AiService {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o-mini';

  final Dio _dio = Dio();

  /// 画像ファイルからAIで英語フレーズを生成
  Future<List<Phrase>> generatePhrases(String imagePath) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'sk-your-api-key-here') {
      throw AiServiceException('APIキーが設定されていません。.envファイルにOPENAI_API_KEYを設定してください。');
    }

    // 画像をBase64エンコード
    final base64Image = await _encodeImage(imagePath);

    // API呼び出し
    try {
      final response = await _dio.post(
        _apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content':
                  'あなたは英語学習アシスタントです。ユーザーが送った画像に写っているモノや場面に関連する、実用的な英語フレーズを3つ生成してください。各フレーズには日本語訳と難易度（beginner/intermediate/advanced）を付けてください。JSON形式で返してください。',
            },
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image',
                    'detail': 'low',
                  },
                },
                {
                  'type': 'text',
                  'text': 'この画像に関連する英語フレーズを3つ教えてください。',
                },
              ],
            },
          ],
          'response_format': {'type': 'json_object'},
          'max_tokens': 1000,
        },
      );

      // レスポンスをパース
      return _parseResponse(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AiServiceException('APIキーが無効です。正しいAPIキーを設定してください。');
      } else if (e.response?.statusCode == 429) {
        throw AiServiceException('API呼び出し回数の上限に達しました。しばらく待ってから再試行してください。');
      } else if (e.response?.statusCode == 500 || e.response?.statusCode == 503) {
        throw AiServiceException('AIサーバーが一時的に利用できません。しばらく待ってから再試行してください。');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw AiServiceException('接続がタイムアウトしました。ネットワーク接続を確認してください。');
      } else if (e.type == DioExceptionType.connectionError) {
        throw AiServiceException('ネットワークに接続できません。インターネット接続を確認してください。');
      } else if (e.type == DioExceptionType.badCertificate) {
        throw AiServiceException('セキュリティ接続エラーが発生しました。ネットワーク設定を確認してください。');
      } else if (e.type == DioExceptionType.cancel) {
        throw AiServiceException('リクエストがキャンセルされました。');
      } else {
        throw AiServiceException('通信エラーが発生しました。ネットワーク接続を確認してもう一度お試しください。');
      }
    } catch (e) {
      if (e is AiServiceException) rethrow;
      throw AiServiceException('予期しないエラーが発生しました: $e');
    }
  }

  /// 画像をBase64にエンコード（必要に応じてリサイズ）
  Future<String> _encodeImage(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw AiServiceException('画像ファイルが見つかりません。');
    }

    final bytes = await file.readAsBytes();

    // 画像サイズチェック（5MB以上の場合は警告）
    if (bytes.length > 5 * 1024 * 1024) {
      throw AiServiceException('画像ファイルが大きすぎます。小さい画像を使用してください。');
    }

    return base64Encode(bytes);
  }

  /// APIレスポンスをパースしてPhraseリストに変換
  List<Phrase> _parseResponse(Map<String, dynamic> responseData) {
    try {
      final content = responseData['choices'][0]['message']['content'] as String;
      final jsonData = json.decode(content) as Map<String, dynamic>;

      // "phrases" キーが無い場合、他のキーを探す
      List<dynamic> phrasesList;
      if (jsonData.containsKey('phrases')) {
        phrasesList = jsonData['phrases'] as List<dynamic>;
      } else {
        // 最初に見つかったListを使う
        final listEntry = jsonData.entries.firstWhere(
          (e) => e.value is List,
          orElse: () => throw Exception('No list found in response'),
        );
        phrasesList = listEntry.value as List<dynamic>;
      }

      return phrasesList
          .map((p) => Phrase.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw AiServiceException('AIの応答を解析できませんでした。もう一度お試しください。');
    }
  }
}

/// AIサービス固有のエラー
class AiServiceException implements Exception {
  final String message;
  AiServiceException(this.message);

  @override
  String toString() => message;
}
