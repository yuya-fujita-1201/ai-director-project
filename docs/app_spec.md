# SnapEnglish ― アプリ設計書 v1
# 最終更新: 2026-02-11

---

## アプリ概要

**SnapEnglish（AI英語フレーズカメラ）**

カメラで身の回りのモノを撮影すると、AIが画像を認識して関連する英語フレーズを3つ生成するiOSアプリ。

---

## ターゲットユーザー

- 英語学習に興味がある日本人（初級〜中級）
- 日常の中で手軽に英語に触れたい人
- 従来の英語学習アプリに飽きた・続かない人

---

## コア機能

### 1. カメラ撮影 → AIフレーズ生成（Day 1-2）
- カメラを起動して身の回りのモノを撮影
- 撮影画像をAI Vision APIに送信
- AIが画像を認識し、関連する英語フレーズを3つ返す
- 各フレーズには日本語訳を付与
- フレーズの難易度表示（初級/中級/上級）

### 2. お気に入り保存（Day 3）
- 気に入ったフレーズをタップして保存
- 保存したフレーズの一覧表示
- フレーズの削除

### 3. 撮影履歴（Day 3）
- 過去に撮影した画像と生成されたフレーズの履歴
- 日付順で一覧表示

### 4. 利用回数制限 + 課金（Day 4）
- 無料ユーザー: 1日3回まで撮影可能
- 有料ユーザー（月額380円）: 無制限 + お気に入り保存機能
- RevenueCatで課金管理
- 残り回数の表示

### 5. オンボーディング（Day 5）
- 初回起動時の3ステップチュートリアル
- アプリの使い方を視覚的に説明

---

## 画面構成

### メイン画面（ホーム）
- 中央にカメラプレビュー or 撮影ボタン
- 上部: 残り回数表示（無料ユーザー）
- 下部: タブバー（ホーム / 履歴 / お気に入り / 設定）

### 結果画面
- 撮影した画像のサムネイル
- AIが生成した3つの英語フレーズ
  - フレーズ（英語）
  - 日本語訳
  - 難易度バッジ
- 各フレーズ横に「お気に入り」ハートボタン
- 「もう一度撮影」ボタン

### 履歴画面
- 撮影日時 + サムネイル + フレーズ一覧
- タップで結果画面を再表示

### お気に入り画面
- 保存したフレーズのリスト
- スワイプで削除

### 設定画面
- プレミアムプラン案内 / 購入ボタン
- 利用規約・プライバシーポリシーリンク
- アプリバージョン

---

## 技術スタック

| レイヤー | 技術 | 備考 |
|---|---|---|
| フレームワーク | Flutter 3.x / Dart | クロスプラットフォーム（iOS優先） |
| カメラ | camera パッケージ | or image_picker |
| AI画像認識 | OpenAI Vision API | GPT-4o-mini（コスト効率） |
| データ保存 | SQLite (sqflite) | ローカルDB（お気に入り・履歴） |
| 課金 | RevenueCat | purchases_flutter パッケージ |
| 状態管理 | Riverpod | provider の後継、推奨 |
| HTTP通信 | dio | API呼び出し用 |
| 画像保存 | path_provider | ローカル画像キャッシュ |

### AI API選定: OpenAI Vision API (GPT-4o-mini)
- 理由: コスト効率が良い、レスポンスが速い、Vision対応が安定
- 代替: Claude Vision（Anthropic）→ Day 2で比較検討可能
- APIキーはアプリにハードコードせず、Firebase Functions等で中継推奨
  - Day 1時点ではまず.envファイルでの管理から始めてOK

---

## フォルダ構成（Flutter プロジェクト）

```
app/snap_english/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   │   ├── theme.dart
│   │   └── constants.dart
│   ├── models/
│   │   ├── phrase.dart
│   │   └── scan_result.dart
│   ├── services/
│   │   ├── camera_service.dart
│   │   ├── ai_service.dart
│   │   ├── database_service.dart
│   │   └── purchase_service.dart
│   ├── providers/
│   │   └── app_providers.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── result_screen.dart
│   │   ├── history_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── settings_screen.dart
│   │   └── onboarding_screen.dart
│   └── widgets/
│       ├── phrase_card.dart
│       ├── camera_preview.dart
│       └── usage_counter.dart
├── assets/
│   └── images/
├── pubspec.yaml
└── README.md
```

---

## Day 別実装スコープ

### Day 1: 環境構築 + カメラ機能
- [ ] `flutter create snap_english` でプロジェクト生成
- [ ] pubspec.yaml に依存パッケージ追加
- [ ] iOS権限設定（カメラ、フォトライブラリ）
- [ ] カメラ起動 → 撮影 → 画像取得の基本フロー
- [ ] ホーム画面のベースUI
- [ ] シミュレータで動作確認

### Day 2: AI API連携
- [ ] OpenAI Vision API呼び出しサービス作成
- [ ] 撮影画像 → Base64変換 → API送信
- [ ] レスポンスパース（3フレーズ抽出）
- [ ] 結果画面の実装
- [ ] エラーハンドリング（API失敗時）

### Day 3: UI仕上げ + お気に入り
- [ ] SQLiteセットアップ
- [ ] お気に入り保存/削除機能
- [ ] 撮影履歴の保存/表示
- [ ] タブバーナビゲーション完成
- [ ] フレーズカードのデザイン調整

### Day 4: 課金 + 回数制限
- [ ] RevenueCatセットアップ
- [ ] App Store Connect で月額プラン作成
- [ ] 利用回数カウンター実装
- [ ] ペイウォール画面
- [ ] 購入フロー + リストア

### Day 5: デザイン + オンボーディング
- [ ] カラーテーマ統一
- [ ] オンボーディング3画面
- [ ] アニメーション追加
- [ ] アイコン・スプラッシュ画面

### Day 6: App Store素材
- [ ] スクリーンショット5枚作成
- [ ] App Store説明文
- [ ] キーワード最適化
- [ ] プライバシーポリシーURL用意

### Day 7: テスト + 提出
- [ ] 全画面の手動テスト
- [ ] エッジケース確認
- [ ] Archive → App Store Connect アップロード
- [ ] 審査提出

---

## デザイン方針（仮）

- カラー: ブルー系（学習・信頼感）+ ホワイト基調
- フォント: システムフォント（日本語対応重視）
- アイコンスタイル: ミニマル・フラット
- 全体トーン: シンプル・クリーン・親しみやすい

---

## 注意事項

- APIキーの管理: ハードコード厳禁、.env or Firebase Functions経由
- 画像のプライバシー: 撮影画像はローカル保存のみ（サーバー送信はAPI処理時のみ）
- App Store審査: カメラ使用理由の明示、プライバシーポリシー必須
