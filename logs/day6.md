# Day 6 作業ログ
**日付:** 2026-02-15
**担当:** Cowork

---

## 目標
- App Store素材を一式作成する
- 説明文・キーワード・プライバシーポリシー・利用規約・スクリーンショット

---

## 完了タスク

### App Store メタデータ
- [x] App Store説明文 作成（日本語・英語）（2026-02-15 Cowork）
  - プロモーションテキスト（170文字以内）
  - 説明文（機能紹介・利用シーン・サブスクリプション情報）
  - `docs/appstore_metadata.md` に保存

### キーワード設定
- [x] 日本語キーワード: 英語,英語学習,AI,カメラ,フレーズ,英会話,翻訳,単語,リスニング,写真
- [x] 英語キーワード: english,learn,AI,camera,phrase,vocabulary,photo,translate,study,language

### プライバシーポリシー・利用規約
- [x] プライバシーポリシー HTML作成（`docs/privacy_policy.html`）
- [x] 利用規約 HTML作成（`docs/terms_of_service.html`）
- GitHub Pages公開用URL: https://marumi-works.com/snapenglish/privacy & /terms
  - ※GitHub Pagesへのデプロイは手動タスク

### App Storeスクリーンショット
- [x] モックアップ画像 5枚生成（1290x2796px / iPhone 6.7インチ対応）
  - screenshot_01_home.png — ホーム画面
  - screenshot_02_result.png — AI結果画面
  - screenshot_03_favorites.png — お気に入り画面
  - screenshot_04_history.png — 履歴画面
  - screenshot_05_premium.png — プレミアムプラン画面
- `assets/screenshots/` に保存

### チェックリスト・手順書
- [x] Day 6チェックリスト作成（`docs/day6_checklist.md`）

---

## 手動タスク（Yuya実施待ち）
- [x] Cloudflare Pagesでプライバシーポリシー・利用規約を公開（2026-02-15 Coworkブラウザ経由）
  - GitHubリポジトリ: https://github.com/yuya-fujita-1201/marumi-works-site
  - GitHub Actions + wrangler-action で Cloudflare Pages に自動デプロイ
  - プライバシーポリシー: https://marumi-works.com/snapenglish/privacy
  - 利用規約: https://marumi-works.com/snapenglish/terms
- [ ] Xcode: In-App Purchaseケイパビリティ有効化
- [ ] App Store Connectに説明文・キーワード・スクショ入力
- [ ] （オプション）シミュレータで実機スクリーンショット撮影

---

## 所感
Day 6はApp Store申請に必要な素材を一式作成した。説明文は日本語・英語の両対応、プライバシーポリシー・利用規約はHTML作成済み。スクリーンショットはPillow + 混合フォント描画で5枚モックアップ生成。
