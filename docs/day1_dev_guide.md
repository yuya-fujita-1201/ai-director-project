# Day 1 開発手順書 ― Claude Code CLI用
# Flutter環境構築 + カメラ機能実装

---

## 概要

この手順書をClaude Code CLI（またはAntigravity経由）に渡して、Day 1の開発タスクを実行する。
目標: **シミュレータ上でカメラ撮影（or 画像選択）→ 撮影画像の表示ができる状態**

---

## ステップ1: Flutterプロジェクト作成

Claude Codeに以下を指示:

```
プロジェクトフォルダ ~/Projects/ai-director-project/app/ に移動して、
flutter create --org com.marumiworks snap_english
を実行してください。
```

確認ポイント:
- `app/snap_english/` にプロジェクトが生成されていること
- `flutter doctor` でiOS開発環境に問題がないこと

---

## ステップ2: 依存パッケージの追加

`app/snap_english/pubspec.yaml` に以下のパッケージを追加:

```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.0.7       # カメラ・ギャラリーから画像取得
  flutter_riverpod: ^2.5.1    # 状態管理
  dio: ^5.4.1                 # HTTP通信（Day 2で使用）
  sqflite: ^2.3.2             # ローカルDB（Day 3で使用）
  path_provider: ^2.1.2       # ファイルパス管理
  path: ^1.9.0                # パスユーティリティ
```

指示例:
```
pubspec.yaml を開いて上記のパッケージを追加し、flutter pub get を実行してください。
```

---

## ステップ3: iOS権限設定

`app/snap_english/ios/Runner/Info.plist` に追加:

```xml
<key>NSCameraUsageDescription</key>
<string>英語フレーズを生成するために、カメラで身の回りのモノを撮影します。</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>フォトライブラリから画像を選択して、英語フレーズを生成します。</string>
```

---

## ステップ4: 基本フォルダ構成の作成

以下のフォルダ・ファイルを作成:

```
lib/
├── main.dart              （書き換え）
├── app.dart               （新規）
├── config/
│   ├── theme.dart         （新規）
│   └── constants.dart     （新規）
├── models/
│   ├── phrase.dart        （新規・スタブ）
│   └── scan_result.dart   （新規・スタブ）
├── services/
│   └── camera_service.dart（新規）
├── screens/
│   ├── home_screen.dart   （新規）
│   └── result_screen.dart （新規・スタブ）
└── widgets/
    └── camera_preview.dart（新規・スタブ）
```

---

## ステップ5: カメラ機能の実装

### 5-1. main.dart
- ProviderScope でアプリ全体をラップ
- MaterialApp のルートウィジェットを app.dart に分離

### 5-2. camera_service.dart
- image_picker を使って以下の2つの機能:
  - `takePhoto()`: カメラで撮影
  - `pickFromGallery()`: ギャラリーから選択
- XFile を返す

### 5-3. home_screen.dart
- 画面中央に大きな撮影ボタン（カメラアイコン）
- タップでカメラ起動 or ギャラリー選択のモーダル
- 撮影成功 → result_screen に遷移（画像パスを渡す）
- 上部に「SnapEnglish」のタイトル
- 下部に残り回数表示（Day 1はモック: "残り3回"固定表示）

### 5-4. result_screen.dart（Day 1はスタブ）
- 撮影画像を上部に表示
- 下部に「AI分析中...」のプレースホルダーテキスト
- Day 2でAI APIのレスポンスに差し替え予定
- 「もう一度撮影」ボタンで home_screen に戻る

### 5-5. theme.dart
- ブルー系のプライマリカラー（#2196F3 or 類似）
- ホワイト基調の背景
- 日本語対応のフォント設定

---

## ステップ6: 動作確認

```
cd app/snap_english
flutter run
```

確認チェックリスト:
- [ ] iOSシミュレータでアプリが起動する
- [ ] ホーム画面に撮影ボタンが表示される
- [ ] 撮影ボタンをタップしてギャラリーから画像を選択できる
  - （シミュレータではカメラが使えないので、ギャラリー選択で代用）
- [ ] 選択した画像が結果画面に表示される
- [ ] 「もう一度撮影」で戻れる

---

## ステップ7: Git コミット

```
cd ~/Projects/ai-director-project
git add .
git commit -m "Day1: Flutter環境構築 + カメラ機能の基本実装"
```

---

## Claude Code CLIへのコピペ用プロンプト

以下をそのままClaude Code CLIに貼り付けて使えます:

```
docs/app_spec.md と docs/day1_dev_guide.md を読んで、Day 1の開発タスクを実行してください。

やること:
1. app/ フォルダ内に flutter create でプロジェクト作成
2. 必要なパッケージをpubspec.yamlに追加
3. iOS権限設定（カメラ・フォトライブラリ）
4. lib/ 以下のフォルダ構成を整備
5. image_picker を使ったカメラ/ギャラリー画像取得機能
6. ホーム画面（撮影ボタン）と結果画面（画像表示 + プレースホルダー）
7. iOSシミュレータで動作確認

app_spec.md のフォルダ構成とデザイン方針に従ってください。
Day 1ではAI API連携は不要です（結果画面はスタブでOK）。
```

---

## トラブルシューティング

### flutter doctor でエラーが出る場合
- Xcode Command Line Tools: `xcode-select --install`
- CocoaPods: `sudo gem install cocoapods`
- iOSシミュレータ: Xcode → Settings → Platforms → iOS Simulatorをダウンロード

### image_picker でカメラが動かない場合
- シミュレータではカメラ非対応 → ギャラリー選択で代用
- 実機テストは後日（Day 5以降）

### ビルドエラーが出る場合
- `flutter clean && flutter pub get` を実行
- ios/Podfile の iOS minimum version を 14.0 以上に設定
- `cd ios && pod install --repo-update`
