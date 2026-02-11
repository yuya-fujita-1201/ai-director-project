# Day 2 作業ログ ― AI API連携（画像 → 英語フレーズ生成）

## 日付
2026-02-12

## 完了タスク

### 1. 環境変数設定
- flutter_dotenv: ^5.1.0 をpubspec.yamlに追加
- .env ファイル作成（OPENAI_API_KEY プレースホルダー）
- .gitignore に .env を追加
- pubspec.yaml の assets に .env を登録

### 2. AIサービス実装 (lib/services/ai_service.dart)
- OpenAI Vision API (gpt-4o-mini) 呼び出しサービス
- 画像ファイル → Base64エンコード → API送信
- システムプロンプトで英語フレーズ3つをJSON形式で生成指示
- response_format: json_object で安定したJSON返却
- detail: "low" でトークン節約
- エラーハンドリング:
  - APIキー未設定チェック
  - 401（無効なキー）/ 429（レートリミット）
  - 接続タイムアウト / ネットワークエラー
  - レスポンスパースエラー
  - 画像ファイルサイズ制限（5MB）

### 3. Phraseモデル更新 (lib/models/phrase.dart)
- fromJson / toJson コンストラクタ追加
- createdAt フィールド追加
- difficultyLabel ゲッター（beginner→初級 等）

### 4. フレーズカードウィジェット (lib/widgets/phrase_card.dart)
- 英語フレーズ（大きめフォント）
- 日本語訳（小さめフォント）
- 難易度バッジ（色分け: 緑=初級, 黄=中級, 赤=上級）
- お気に入りハートボタン（Day 3で実装、今はスタブ）

### 5. 結果画面更新 (lib/screens/result_screen.dart)
- StatefulWidget に変更（API呼び出しの状態管理）
- 画面遷移時にAI APIを自動呼び出し
- 3つの状態表示:
  - ローディング中: CircularProgressIndicator + テキスト
  - エラー: エラーメッセージ + リトライボタン
  - 成功: フレーズカード3枚のListView
- 撮影画像をコンパクト表示（高さ200px）

### 6. main.dart更新
- dotenv.load() でアプリ起動時に.env読み込み

## 動作確認
- `flutter analyze`: No issues found
- `flutter build ios --simulator`: ビルド成功
- `flutter test`: All tests passed

## フロー
ホーム画面 → 撮影ボタン → カメラ/ギャラリー選択 → 画像取得 → 結果画面遷移 → AI API自動呼び出し → ローディング表示 → フレーズ3枚カード表示

## APIキー設定方法（手動）
```bash
echo "OPENAI_API_KEY=sk-あなたのキー" > app/snap_english/.env
```

## 次のステップ（Day 3）
- SQLiteセットアップ
- お気に入り保存/削除機能
- 撮影履歴の保存/表示
- タブバーナビゲーション
