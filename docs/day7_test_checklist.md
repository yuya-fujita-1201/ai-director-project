# Day 7 最終テストチェックリスト & App Store審査提出手順書

---

## Part 1: テストチェックリスト

### 前提条件
- [ ] `.env` ファイルにOPENAI_API_KEY設定済み
- [ ] RevenueCat APIキーをビルド時に渡す（`--dart-define=REVENUECAT_API_KEY=appl_xxxxx`）
- [ ] GitHub Pagesにプライバシーポリシー・利用規約を公開済み
- [ ] Xcode: In-App Purchaseケイパビリティ有効化済み

### A. 起動・オンボーディング
- [ ] 初回起動でオンボーディング画面が表示される
- [ ] 3ページスワイプできる（撮って→学んで→続けて）
- [ ] スキップボタンでホーム画面に遷移する
- [ ] 「始める」ボタンでホーム画面に遷移する
- [ ] 2回目の起動ではオンボーディングが表示されない

### B. カメラ・撮影機能
- [ ] カメラボタンタップでボトムシート（カメラ/ギャラリー選択）が表示される
- [ ] カメラ撮影が正常に動作する
- [ ] ギャラリーから画像選択が正常に動作する
- [ ] カメラ権限ダイアログが適切に表示される
- [ ] 権限拒否時にエラーメッセージが表示される

### C. AI分析・結果画面
- [ ] 撮影後「AI分析中...」のローディングが表示される
- [ ] 3つの英語フレーズが表示される
- [ ] 各フレーズに日本語訳がある
- [ ] 難易度バッジ（初級/中級/上級）が表示される
- [ ] お気に入りハートをタップしてON/OFFできる
- [ ] 「もう一度撮影」ボタンでホームに戻れる
- [ ] ネットワークオフ時にエラーメッセージが表示される

### D. 履歴画面
- [ ] 過去のスキャン結果がカード形式で一覧表示される
- [ ] 日時・サムネイル・フレーズプレビューが表示される
- [ ] カードタップで結果詳細に遷移する
- [ ] 長押しで削除確認ダイアログが表示される
- [ ] 削除が正常に動作する
- [ ] Pull to Refreshが動作する
- [ ] 履歴なし時にEmpty Stateが表示される

### E. お気に入り画面
- [ ] お気に入りに追加したフレーズが表示される
- [ ] スワイプで削除（Undo付き）が動作する
- [ ] お気に入りなし時にEmpty Stateが表示される
- [ ] お気に入り画面のRefreshが動作する

### F. 課金・回数制限
- [ ] 無料プランで残り回数が正しく表示される（3/3 → 2/3 → ...）
- [ ] 残り0回でPaywall画面が表示される
- [ ] 日付が変わると回数がリセットされる
- [ ] Paywallの「プレミアムを始める」ボタンがRevenueCat購入フローを開始する
- [ ] 「購入を復元」ボタンが動作する
- [ ] 利用規約・プライバシーポリシーリンクがブラウザで開く
- [ ] サブスクリプション説明文（自動更新の注記）が表示されている
- [ ] プレミアム購入後は回数制限なしで撮影できる

### G. UI/UX全般
- [ ] ティール系カラーで統一されている
- [ ] ダークモード対応（または非対応の場合、明示的にlightモード固定）
- [ ] Bottom Navigationの3タブ（カメラ・履歴・お気に入り）が正しく動作する
- [ ] 画面回転時にレイアウトが崩れない
- [ ] iPhone SE（小画面）でレイアウトが崩れない
- [ ] iPhone 15 Pro Max（大画面）でレイアウトが正常
- [ ] セーフエリアが適切に処理されている

### H. エッジケース
- [ ] 機内モードでのカメラ撮影→AI呼び出しエラー表示
- [ ] 大きい画像（5MB以上）でのエラーメッセージ
- [ ] アプリをバックグラウンドにして戻った際の動作
- [ ] 急速にボタンを連打しても二重送信されない

---

## Part 2: App Store審査提出手順書

### ステップ1: ビルド準備
```bash
cd app/snap_english

# 1. 依存関係を更新
flutter pub get

# 2. コード品質チェック
flutter analyze

# 3. テスト実行（テストがある場合）
flutter test

# 4. .env ファイルを確認
# OPENAI_API_KEY=sk-xxxxx が設定されていること
```

### ステップ2: リリースビルド
```bash
# iOS Release Build
flutter build ios --release \
  --dart-define=REVENUECAT_API_KEY=appl_YOUR_PRODUCTION_KEY

# ※ テスト用キー（test_VKT...）ではなくプロダクション用キーを使うこと
```

### ステップ3: Xcode Archive
1. `app/snap_english/ios/Runner.xcworkspace` をXcodeで開く
2. Product → Scheme → Runner を選択
3. Device → Any iOS Device (arm64) を選択
4. Product → Archive
5. Archiveが完了するまで待つ

### ステップ4: App Store Connectにアップロード
1. Xcode Organizer → 最新のArchiveを選択
2. 「Distribute App」→「App Store Connect」
3. 「Upload」を選択
4. 自動署名を確認 → Upload

### ステップ5: App Store Connect設定
1. [App Store Connect](https://appstoreconnect.apple.com) にログイン
2. 「マイApp」→「SnapEnglish AI」を選択

#### 5a. バージョン情報
| フィールド | 値 |
|---|---|
| バージョン | 1.0.0 |
| ビルド | アップロードしたビルドを選択 |
| What's New | SnapEnglish の最初のリリースです！ |

#### 5b. App情報（`docs/appstore_metadata.md`から）
| フィールド | 値 |
|---|---|
| アプリ名 | SnapEnglish AI |
| サブタイトル | AI英語フレーズカメラ |
| カテゴリ | 教育 / 仕事効率化 |
| コンテンツ権 | ✓ 第三者の素材を含まない |
| 年齢レーティング | 4+ |

#### 5c. 説明文・キーワード
- 説明文: `docs/appstore_metadata.md` の日本語説明文をコピー
- プロモーションテキスト: 同ファイルからコピー
- キーワード: `英語,英語学習,AI,カメラ,フレーズ,英会話,翻訳,単語,リスニング,写真`

#### 5d. URL設定
| フィールド | URL |
|---|---|
| プライバシーポリシー | https://marumi-works.com/snapenglish/privacy |
| サポートURL | https://marumi-works.com/snapenglish/terms |

#### 5e. スクリーンショット
- 6.7インチ: `assets/screenshots/` の5枚をアップロード
- 6.5インチ: 同じ画像でOK（自動リサイズ）

#### 5f. 審査情報
| フィールド | 値 |
|---|---|
| 連絡先名前 | Yuya |
| メール | sam.y.1201@gmail.com |
| メモ | 「AI英語学習アプリです。カメラで撮影した画像をOpenAI APIで分析し、関連する英語フレーズを生成します。サブスクリプションはRevenueCatを通じて管理しています。」 |
| サインインが必要 | いいえ |
| デモアカウント | 不要 |

### ステップ6: 審査提出
1. 全フィールドの入力を確認
2. 「審査に追加」ボタンをクリック
3. 「送信」を確認

### ステップ7: 審査待ち
- 通常1〜3日で審査結果が来る
- 「審査待ち」→「審査中」→「承認」の流れ
- リジェクトされた場合は理由を確認して修正→再提出

---

## 修正済み問題（Day 7 コードレビュー）

| 問題 | 対応 |
|---|---|
| paywall_screen.dart のURLが example.com | → GitHub Pages URL に修正済み |
| database_service.dart にDB初期化エラーハンドリングなし | → try-catch + 再作成ロジック追加 |
| result_screen.dart Image.file()にerrorBuilder なし | → errorBuilder追加 |
| ai_service.dart DioException全タイプ未対応 | → badCertificate, cancel, server error 追加 |
| camera_preview.dart 未使用ウィジェット | → 削除マーク済み（手動削除推奨） |

## 手動対応が必要な問題

| 問題 | 対応方法 |
|---|---|
| .envファイルなし | `app/snap_english/.env` に `OPENAI_API_KEY=sk-xxxxx` を作成 |
| RevenueCat本番キー | RevenueCatダッシュボードで本番用キーを取得し `--dart-define` で渡す |
| GitHub Pagesデプロイ | `docs/privacy_policy.html` と `docs/terms_of_service.html` を公開 |
| Xcode In-App Purchase | Signing & Capabilities → + Capability → In-App Purchase |
