import 'dart:io';
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/phrase.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';
import '../widgets/phrase_card.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  final List<Phrase>? preloadedPhrases; // 履歴から開いた場合

  const ResultScreen({
    super.key,
    required this.imagePath,
    this.preloadedPhrases,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final AiService _aiService = AiService();
  final DatabaseService _db = DatabaseService.instance;

  List<Phrase>? _phrases;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedPhrases != null) {
      // 履歴から開いた場合はDB済みフレーズを表示
      _phrases = widget.preloadedPhrases;
      _isLoading = false;
    } else {
      _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _phrases = null;
    });

    try {
      final phrases = await _aiService.generatePhrases(widget.imagePath);
      if (mounted) {
        setState(() {
          _phrases = phrases;
          _isLoading = false;
        });
        // DB保存
        await _saveToDB(phrases);
      }
    } on AiServiceException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '予期しないエラーが発生しました。';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveToDB(List<Phrase> phrases) async {
    try {
      final scanId = await _db.saveScanResult(widget.imagePath, phrases);
      // DB保存後、IDを持つフレーズで更新
      final history = await _db.getAllScanHistory();
      final saved = history.firstWhere(
        (h) => h.id == scanId,
        orElse: () => history.first,
      );
      if (mounted) {
        setState(() {
          _phrases = saved.phrases;
        });
      }
    } catch (_) {
      // DB保存失敗は無視（表示は継続）
    }
  }

  void _onFavoriteToggled(int index, bool isFavorite) {
    if (_phrases == null) return;
    setState(() {
      _phrases![index] = _phrases![index].copyWith(isFavorite: isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分析結果'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 撮影画像表示（コンパクトに）
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // フレーズ表示エリア
            Expanded(
              child: _buildContent(),
            ),
            // もう一度撮影ボタン
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    'もう一度撮影',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    // ローディング中
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'AI分析中...',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '英語フレーズを生成しています',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    // エラー表示
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _analyzeImage,
                icon: const Icon(Icons.refresh),
                label: const Text('リトライ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // フレーズカード表示
    if (_phrases != null && _phrases!.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        itemCount: _phrases!.length,
        itemBuilder: (context, index) {
          return PhraseCard(
            phrase: _phrases![index],
            index: index,
            onFavoriteToggled: (isFavorite) => _onFavoriteToggled(index, isFavorite),
          );
        },
      );
    }

    // フレーズが空の場合
    return const Center(
      child: Text(
        'フレーズを生成できませんでした。',
        style: TextStyle(
          fontSize: 15,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
}
