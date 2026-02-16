# 法的ページ デプロイガイド

新しいiOSアプリを作成した際に、プライバシーポリシー・利用規約ページを
marumi-works.com に追加する手順をまとめたノウハウドキュメント。

## 前提

- リポジトリ: `yuya-fujita-1201/marumi-works-site`
- ホスティング: Cloudflare Pages（GitHub Actions で自動デプロイ）
- URL: https://marumi-works.com
- Coworkスキル: `app-legal-pages` が利用可能

## アーキテクチャ

```
Cowork (ファイル生成・git操作)
  ↓ git push
GitHub (marumi-works-site / main)
  ↓ GitHub Actions (deploy.yml)
Cloudflare Pages (marumi-works.com)
```

## 新しいアプリを追加する手順

### Step 1: apps.json にアプリ情報を追加

スキルの設定ファイルにアプリを追記する:
- パス: `.claude/skills/app-legal-pages/references/apps.json`

必要な情報:
- `app_id`: URLスラッグ（例: "myapp"）→ `marumi-works.com/myapp/privacy`
- `app_name`: 表示名
- `description`: 簡単な説明
- `theme_color`: テーマカラー（HEX）
- `effective_date`: 施行日
- `pricing`: 料金プラン
- `third_party_services`: 外部サービス（API、Analytics等）
- `data_collected`: 収集データ一覧
- `data_storage`: データ保存先
- `children_privacy`: 子ども向けの場合の説明

### Step 2: ページ生成

```bash
python3 .claude/skills/app-legal-pages/scripts/generate_pages.py \
  --config .claude/skills/app-legal-pages/references/apps.json \
  --output /sessions/vibrant-clever-cerf/marumi-works-site
```

生成されるファイル:
- `<app_id>/privacy/index.html` — プライバシーポリシー
- `<app_id>/terms/index.html` — 利用規約
- `index.html` — トップページ（全アプリ一覧、自動更新）

### Step 3: git commit & push

```bash
cd /sessions/vibrant-clever-cerf/marumi-works-site
git add .
git commit -m "新アプリ <app_name> の法的ページ追加"
git push origin main
```

### Step 4: デプロイ確認

push後、GitHub Actions が自動で Cloudflare Pages にデプロイする。

- Actions 確認: https://github.com/yuya-fujita-1201/marumi-works-site/actions
- デプロイ完了まで約30秒
- 確認URL:
  - `https://marumi-works.com/<app_id>/privacy`
  - `https://marumi-works.com/<app_id>/terms`
  - `https://marumi-works.com/`（トップページ更新確認）

## Git認証情報

- 方式: GitHub Fine-grained Personal Access Token (PAT)
- トークン名: `cowork-marumi-deploy`
- スコープ: marumi-works-site リポジトリのみ
- 権限: Contents (Read and write), Metadata (Read-only)
- 有効期限: 2026年5月17日
- 設定場所: git remote URL に埋め込み済み

### PAT期限切れ時の再作成手順

1. GitHub → Settings → Developer Settings → Personal Access Tokens → Fine-grained tokens
2. 「Generate new token」をクリック
3. 設定:
   - Token name: `cowork-marumi-deploy`
   - Expiration: 90 days
   - Repository access: Only select repositories → `marumi-works-site`
   - Permissions: Contents → Read and write
4. 生成されたトークンでリモートURLを更新:
   ```bash
   cd /sessions/vibrant-clever-cerf/marumi-works-site
   git remote set-url origin https://yuya-fujita-1201:<NEW_TOKEN>@github.com/yuya-fujita-1201/marumi-works-site.git
   ```

## リポジトリの初期セットアップ（新セッション時）

Coworkの新セッションではファイルシステムがリセットされるため、初回にcloneが必要:

```bash
git clone https://github.com/yuya-fujita-1201/marumi-works-site.git /sessions/vibrant-clever-cerf/marumi-works-site
cd /sessions/vibrant-clever-cerf/marumi-works-site
git remote set-url origin https://yuya-fujita-1201:<PAT>@github.com/yuya-fujita-1201/marumi-works-site.git
git config user.name "yuya-fujita-1201"
git config user.email "sam.y.1201@gmail.com"
```

## デザイン仕様

全ページ共通のデザインシステム:
- フォント: -apple-system, 'Hiragino Sans', 'Noto Sans JP', sans-serif
- レイアウト: 最大幅 800px、レスポンシブ対応
- ヘッダー: h1 + テーマカラーのdivider
- フッター: © year marumi works + トップページ/相互リンク
- 連絡先: marumi.works@gmail.com

## 過去のトラブルと対策

### UTF-8文字化け（2026-02-16解決済み）

- 原因: GitHub Web UIでファイル作成時に`atob()`がBase64をLatin-1として解釈
- 対策: 本ガイドの手順（Coworkでファイル生成 → git push）なら発生しない
- もしブラウザUIでの直接編集が必要な場合:
  ```javascript
  const bytes = Uint8Array.from(atob(b64), c => c.charCodeAt(0));
  const content = new TextDecoder('utf-8').decode(bytes);
  ```

## Cloudflare Pages 設定

- Account ID: 75d7b4a9c3140b24cc2cb32015ce1b71
- プロジェクト名: marumi-works
- GitHub Secrets に設定済み:
  - `CLOUDFLARE_API_TOKEN`
  - `CLOUDFLARE_ACCOUNT_ID`

## 現在のアプリ一覧

| アプリ | app_id | テーマカラー | URL |
|--------|--------|-------------|-----|
| SnapEnglish AI | snapenglish | #0097A7 | /snapenglish/ |
| はじめてメモ ~First Steps~ | firststeps | #87CEEB | /firststeps/ |
| 三賢会議 | triad-council | #8B7FFF | /triad-council/ |
