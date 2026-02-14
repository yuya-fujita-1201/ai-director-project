# Claude Code CLI 指示テキスト ― Day 4 ビルド＆Day 5 実装

以下をClaude Code CLIにコピペしてください。

---

## 指示テキスト（ここからコピー）

```
CLAUDE.mdとCONTEXT.mdを読んでプロジェクト状況を把握してください。
このプロジェクトは「AI監督プロジェクト」で、SnapEnglishというFlutterアプリを開発中です。

Day 0〜4のコードはCowork側で全て作成済みです。以下のタスクを順番に実施してください。

## タスク1: Day 4 ビルド確認

app/snap_english/ ディレクトリで以下を順番に実行：

1. `flutter pub get`
2. `flutter analyze` — warningやerrorがあれば修正
3. `flutter build ios --simulator` — ビルドエラーがあれば修正
4. iPhoneシミュレータで起動確認（`flutter run` でシミュレータ起動）
5. 動作確認項目：
   - アプリが正常に起動する
   - ホーム画面に残り回数（3/3）が表示される
   - カメラ撮影→フレーズ生成のフローが動く
   - お気に入り・履歴タブが機能する
   - AppBarのプレミアムボタンから課金画面が開く
   - 課金画面にメリット一覧・購入ボタン・復元ボタンが表示される
6. 問題があれば自分で修正してください

## タスク2: Git コミット

確認できたらコミット：
- メッセージ: `Day4: 課金実装（RevenueCat + 回数制限 + Paywall UI）`
- リモートにpush

## タスク3: Day 5 デザイン調整 + オンボーディング

Day 5のタスクに進んでください。docs/にDay 5の開発手順書はまだないので、
CLAUDE.mdのスケジュール（Day 5: デザイン調整 + オンボーディング）に従って自分で計画・実装してください。

### Day 5 の要件：
1. **アプリテーマ・カラー統一**
   - 現状バラバラな色をブランドカラーに統一
   - ダークブルー系 or ティール系を推奨（英語学習アプリらしい爽やかさ）
   - マテリアルデザインのThemeDataで一括管理

2. **オンボーディング画面（初回起動時のみ）**
   - 3ページのスワイプ式チュートリアル
   - ページ1: 「撮って」— カメラで身の回りのモノを撮影するイメージ
   - ページ2: 「学んで」— AIが英語フレーズを3つ生成するイメージ
   - ページ3: 「続けて」— 毎日の学習習慣を作るイメージ
   - 最後に「始める」ボタンでホーム画面へ
   - shared_preferencesで初回表示フラグ管理

3. **UI改善**
   - フレーズカードのデザインを洗練
   - アニメーション追加（ページ遷移、カード表示）
   - アプリアイコン仮デザイン（flutter_launcher_iconsで設定）
   - スプラッシュスクリーン

4. **完了後**
   - `flutter analyze` でエラーなしを確認
   - `flutter build ios --simulator` 成功を確認
   - Git コミット: `Day5: デザイン調整 + オンボーディング`
   - リモートにpush
   - logs/day5.md に作業ログを記録（logs/day4.mdの形式に合わせて）
   - CLAUDE.md と CONTEXT.md を更新

### 注意事項：
- エラーが出たら自分で修正してください
- コミットメッセージは日本語で、Day番号を先頭につけてください
- 作業ログは別セッションが読んでも状況がわかるよう詳しく書いてください
- 新規パッケージを追加する場合はpubspec.yamlに追加してflutter pub getしてください
```

---

## 補足（CLI実行者へ）
- Flutterプロジェクトは `app/snap_english/` にあります
- RevenueCat APIキーは `--dart-define=REVENUECAT_API_KEY=test_VKTpEiMZTHJslwzfWhhdFxkmXTf` で渡します
- OpenAI APIキーも `--dart-define` で渡す設計です（既存コード参照）
- Xcode In-App Purchaseケイパビリティはまだ有効化されていません（手動タスク）
- 利用規約・プライバシーポリシーURLはまだ `example.com` のままです（後日差し替え）
