# Day 6 App Store素材 ― チェックリスト＆手順書

## Coworkで作成済み
- [x] App Store説明文（日本語・英語） → `docs/appstore_metadata.md`
- [x] キーワード設定（日本語・英語） → `docs/appstore_metadata.md`
- [x] プライバシーポリシー HTML → `docs/privacy_policy.html`
- [x] 利用規約 HTML → `docs/terms_of_service.html`
- [x] スクリーンショット用モックアップ画像 5枚 → `assets/screenshots/`
- [x] スクリーンショットテキスト案 → `docs/appstore_metadata.md`

---

## Yuya手動タスク

### 1. Cloudflare Pagesでプライバシーポリシー・利用規約を公開
```bash
# 専用リポジトリ「marumi-works-site」を作成してCloudflare Pagesに接続
# marumi-works-site/ フォルダの中身をそのままpush

cd marumi-works-site
git init && git add . && git commit -m "Initial commit"
git remote add origin https://github.com/yuya-fujita-1201/marumi-works-site.git
git push -u origin main

# Cloudflare Pages → 新規プロジェクト → GitHubリポジトリ接続
# ビルドコマンド: なし / 出力ディレクトリ: /
# カスタムドメイン: marumi-works.com
# URL: https://marumi-works.com/snapenglish/privacy
# URL: https://marumi-works.com/snapenglish/terms
```

### 2. Xcode設定
- [ ] Signing & Capabilities → + Capability → In-App Purchase を追加
- [ ] Bundle ID: `com.marumiworks.snapEnglish` を確認
- [ ] Team: `5CMYP437MX` を確認

### 3. App Store Connectに素材を入力
- [ ] アプリ情報 → 説明文を入力（`docs/appstore_metadata.md`からコピー）
- [ ] プロモーションテキストを入力
- [ ] キーワードを入力
- [ ] カテゴリ: 教育（プライマリ）/ 仕事効率化（セカンダリ）
- [ ] プライバシーポリシーURL: https://marumi-works.com/snapenglish/privacy
- [ ] サポートURL: https://marumi-works.com/snapenglish/terms
- [ ] スクリーンショットをアップロード（6.7インチ: `assets/screenshots/` の5枚）
- [ ] What's New テキストを入力
- [ ] 年齢レーティング: 4+

### 4. シミュレータで実機スクリーンショット撮影（オプション）
上記モックアップ画像でも申請可能だが、実機スクリーンショットが望ましい場合:
```bash
# シミュレータ起動
cd app/snap_english
flutter run --device-id <iPhone 15 Pro Max>

# 各画面でスクリーンショット: Cmd + S
# 保存先: ~/Desktop/Simulator Screen Shot...
```

---

## App Store Connect 入力値まとめ

| フィールド | 値 |
|---|---|
| アプリ名 | SnapEnglish AI |
| サブタイトル | AI英語フレーズカメラ |
| カテゴリ（プライマリ） | 教育 |
| カテゴリ（セカンダリ） | 仕事効率化 |
| プライバシーポリシーURL | https://marumi-works.com/snapenglish/privacy |
| サポートURL | https://marumi-works.com/snapenglish/terms |
| 年齢レーティング | 4+ |
| 著作権 | 2026 marumi works |
| キーワード（日本語） | 英語,英語学習,AI,カメラ,フレーズ,英会話,翻訳,単語,リスニング,写真 |
| Keywords (EN) | english,learn,AI,camera,phrase,vocabulary,photo,translate,study,language |
| 価格 | 無料（アプリ内課金あり） |
| サブスクリプション | ¥400/月 プレミアムプラン |
