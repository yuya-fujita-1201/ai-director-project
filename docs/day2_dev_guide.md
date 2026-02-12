# Day 2 開発手順書 ― Claude Code CLI用
# AI API連携（画像 → 英語フレーズ生成）

---

## 概要

Day 1で実装したカメラ機能に、AI画像認識を接続する。
目標: **撮影した画像をAIに送ると、英語フレーズが3つ返ってくる状態**

---

## ステップ0: APIキーの取得（事前準備）

### OpenAI APIキーの取得手順

1. https://platform.openai.com にアクセス
2. アカウント作成 or ログイン
3. 左メニュー「API keys」→「Create new secret key」
4. キーをコピーして安全な場所に保存（`sk-...` で始まる文字列）
5. 「Billing」→ クレジットを追加（$5で十分。Day 2-7の全API呼び出しで$1-2程度）

### 注意
- APIキーは絶対にGitにコミットしない
- .env ファイルで管理し、.gitignore に追加する

---

## ステップ1: 環境変数の設定

`app/snap_english/` に `.env` ファイルを作成:

```
OPENAI_API_KEY=sk-ここにAPIキーを貼る
```

`.gitignore` に追加:
```
.env
```

flutter_dotenv パッケージを追加:
```yaml
# pubspec.yaml に追加
dependencies:
  flutter_dotenv: ^5.1.0
```

---

## ステップ2: AI サービスの実装

### 2-1. lib/services/ai_service.dart

OpenAI Vision API (GPT-4o-mini) を呼び出すサービスクラスを作成:

**機能:**
- 画像ファイルを受け取る
- Base64にエンコード
- OpenAI Chat Completions APIに送信（model: gpt-4o-mini）
- プロンプトで「この画像に関連する英語フレーズを3つ生成して」と指示
- レスポンスをパースして Phrase モデルのリストを返す

**APIリクエスト形式:**
```json
{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "system",
      "content": "あなたは英語学習アシスタントです。ユーザーが送った画像に写っているモノや場面に関連する、実用的な英語フレーズを3つ生成してください。各フレーズには日本語訳と難易度（beginner/intermediate/advanced）を付けてください。JSON形式で返してください。"
    },
    {
      "role": "user",
      "content": [
        {
          "type": "image_url",
          "image_url": {
            "url": "data:image/jpeg;base64,{base64_image}",
            "detail": "low"
          }
        },
        {
          "type": "text",
          "text": "この画像に関連する英語フレーズを3つ教えてください。"
        }
      ]
    }
  ],
  "response_format": { "type": "json_object" }
}
```

**期待するレスポンスJSON:**
```json
{
  "phrases": [
    {
      "english": "Could I have a cup of coffee, please?",
      "japanese": "コーヒーを一杯いただけますか？",
      "difficulty": "beginner"
    },
    {
      "english": "I'd like to try your house blend.",
      "japanese": "おすすめのブレンドを試してみたいです。",
      "difficulty": "intermediate"
    },
    {
      "english": "Do you have any single-origin options available?",
      "japanese": "シングルオリジンのコーヒーはありますか？",
      "difficulty": "advanced"
    }
  ]
}
```

---

## ステップ3: Phrase モデルの更新

`lib/models/phrase.dart` を更新:

```dart
class Phrase {
  final String english;    // 英語フレーズ
  final String japanese;   // 日本語訳
  final String difficulty; // beginner / intermediate / advanced
  final DateTime createdAt;

  // fromJson コンストラクタ
  // toJson メソッド
}
```

---

## ステップ4: 結果画面の更新

`lib/screens/result_screen.dart` を更新:

**変更前（Day 1 スタブ）:**
- 画像表示 + 「AI分析中...」テキスト

**変更後:**
- 画像表示
- ローディングインジケーター（API呼び出し中）
- 3つのフレーズカード表示
  - 英語フレーズ（大きめフォント）
  - 日本語訳（小さめフォント）
  - 難易度バッジ（色分け: 緑=beginner, 黄=intermediate, 赤=advanced）
  - お気に入りハートボタン（Day 3で実装、今はスタブ）
- エラー時のリトライボタン
- 「もう一度撮影」ボタン

---

## ステップ5: ホーム画面からの結合

`lib/screens/home_screen.dart` を更新:

フロー:
1. ユーザーが撮影ボタンをタップ
2. カメラ or ギャラリーから画像取得
3. result_screen に遷移
4. result_screen で自動的にAI APIを呼び出し
5. ローディング表示 → フレーズ表示

---

## ステップ6: エラーハンドリング

以下のエラーケースに対応:
- APIキーが未設定
- ネットワークエラー
- API rate limit
- レスポンスのパースエラー
- 画像が大きすぎる場合のリサイズ（幅1024px以下に縮小）

---

## ステップ7: 動作確認

```
cd app/snap_english
flutter run
```

確認チェックリスト:
- [ ] アプリ起動 → ホーム画面表示
- [ ] 撮影ボタン → ギャラリーから画像選択
- [ ] ローディング表示
- [ ] 3つの英語フレーズが表示される
- [ ] 日本語訳が表示される
- [ ] 難易度バッジが色分けされている
- [ ] 「もう一度撮影」で戻れる
- [ ] ネットワークエラー時のエラー表示

---

## ステップ8: Git コミット

```
cd ~/Projects/ai-director-project
git add .
git commit -m "Day2: OpenAI Vision API連携 + 英語フレーズ生成機能"
```

---

## Claude Code CLIへのコピペ用プロンプト

```
docs/app_spec.md と docs/day2_dev_guide.md を読んで、Day 2の開発タスクを実行してください。

やること:
1. flutter_dotenv パッケージを追加
2. .env ファイルを作成（OPENAI_API_KEY のプレースホルダー）
3. .gitignore に .env を追加
4. lib/services/ai_service.dart を新規作成
   - OpenAI Vision API (gpt-4o-mini) を呼び出す
   - 画像をBase64エンコードして送信
   - プロンプトで英語フレーズ3つをJSON形式で生成
   - レスポンスをPhrase モデルにパース
5. lib/models/phrase.dart を更新（fromJson/toJson追加）
6. lib/screens/result_screen.dart を更新
   - ローディングインジケーター
   - フレーズカード3枚表示（英語・日本語訳・難易度バッジ）
   - エラーハンドリング
7. ホーム画面 → 撮影 → API呼び出し → 結果表示のフロー完成
8. 動作確認（flutter analyze, flutter build ios --simulator）

注意:
- APIキーはハードコードしない（.envで管理）
- 画像は送信前に1024px以下にリサイズ
- day2_dev_guide.md のAPIリクエスト形式とレスポンス形式に従う
- Day 1のコードを壊さないように注意

.envファイルにはAPIキーのプレースホルダーを入れてください。
実際のキーは後から手動で設定します。
```

---

## APIキー設定の手順（開発後に手動で実施）

Claude Code CLIでの開発が完了したら:

```bash
# .envファイルにAPIキーを設定
echo "OPENAI_API_KEY=sk-あなたのキー" > ~/Projects/ai-director-project/app/snap_english/.env
```

---

## トラブルシューティング

### API呼び出しで401エラー
- APIキーが正しく設定されているか確認
- .env ファイルのパスが正しいか確認

### レスポンスが遅い
- gpt-4o-mini は通常2-5秒で応答
- 画像サイズが大きすぎる可能性 → リサイズ処理を確認
- detail: "low" を指定してトークン節約

### JSONパースエラー
- response_format: json_object を指定しているか確認
- システムプロンプトで「JSON形式で」と明示しているか確認

### 画像がBase64に変換できない
- path_provider でファイルパスを正しく取得しているか確認
- 画像ファイルの読み込み権限があるか確認
