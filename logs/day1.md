# Day 1 作業ログ ― Flutter環境構築 + カメラ機能実装

## 日付
2026-02-12

## 完了タスク

### 1. Flutterプロジェクト作成
- `flutter create --org com.marumiworks snap_english` で `app/snap_english/` にプロジェクト生成
- Flutter 3.38.5 / Dart 3.10.4 で作成

### 2. 依存パッケージ追加
- image_picker: ^1.0.7（カメラ・ギャラリー）
- flutter_riverpod: ^2.5.1（状態管理）
- dio: ^5.4.1（HTTP通信 - Day 2用）
- sqflite: ^2.3.2（ローカルDB - Day 3用）
- path_provider: ^2.1.2（ファイルパス管理）
- path: ^1.9.0（パスユーティリティ）

### 3. iOS権限設定
- Info.plist にカメラ・フォトライブラリのUsageDescription追加

### 4. フォルダ構成整備
作成したファイル:
```
lib/
├── main.dart              （書き換え: ProviderScope + SnapEnglishApp）
├── app.dart               （MaterialApp設定）
├── config/
│   ├── theme.dart         （ブルー系テーマ）
│   └── constants.dart     （アプリ名・無料回数制限）
├── models/
│   ├── phrase.dart        （フレーズモデル・スタブ）
│   └── scan_result.dart   （スキャン結果モデル・スタブ）
├── services/
│   └── camera_service.dart（image_pickerラッパー）
├── screens/
│   ├── home_screen.dart   （撮影ボタン + 残り回数モック）
│   └── result_screen.dart （画像表示 + AI分析中プレースホルダー）
└── widgets/
    └── camera_preview.dart（スタブ）
```

### 5. 実装内容
- **main.dart**: ProviderScopeでアプリ全体をラップ
- **home_screen.dart**: 中央に大きなカメラボタン、タップでモーダル（カメラ/ギャラリー選択）、残り回数モック表示
- **result_screen.dart**: 撮影画像の表示、AI分析中プレースホルダー、「もう一度撮影」ボタン
- **camera_service.dart**: image_pickerのtakePhoto()/pickFromGallery()
- **theme.dart**: ブルー系(#2196F3)プライマリカラー、ホワイト基調

### 6. 動作確認
- `flutter analyze`: No issues found
- `flutter build ios --simulator`: ビルド成功
- `flutter test`: All tests passed
- iPhone 17シミュレータでアプリ起動確認

## 次のステップ（Day 2）
- OpenAI Vision API連携
- 撮影画像 → Base64変換 → API送信
- レスポンスパース（3フレーズ抽出）
- result_screen.dartをスタブからAPI結果表示に更新
