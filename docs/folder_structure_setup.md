# AI監督プロジェクト ― フォルダ構成 & セットアップ手順

---

## 📁 フォルダ構成

```
ai-director-project/
├── README.md                          # プロジェクト概要
├── CONTEXT.md                         # コンテキスト引き継ぎドキュメント（チャット継続用）
│
├── app/                               # SnapEnglishアプリ本体
│   └── snap_english/                  # Flutter プロジェクト（Day 1 に flutter create で生成）
│       ├── lib/
│       ├── ios/
│       ├── android/
│       ├── pubspec.yaml
│       └── ...
│
├── docs/                              # 企画・設計ドキュメント
│   ├── project_plan.md                # 企画構想書（最新版）
│   ├── app_spec.md                    # アプリ仕様書（AI監督が作成予定）
│   ├── api_selection.md               # AI API選定メモ（Claude Vision vs OpenAI Vision）
│   └── revenue_model.md               # 収益モデル詳細
│
├── articles/                          # Note記事
│   ├── 01_planning.md                 # 記事① 企画編 ✅
│   ├── 02_environment.md              # 記事② 環境構築編
│   ├── 03_implementation.md           # 記事③ 実装編
│   ├── 04_release.md                  # 記事④ リリース編（有料）
│   ├── 05_revenue_report.md           # 記事⑤ 収益報告編（有料）
│   ├── extra_note_guide.md            # 番外編 Noteの始め方
│   └── images/                        # 記事用画像・スクショ
│       ├── thumbnails/                # サムネイル画像
│       └── screenshots/              # チャットスクショ等
│
├── x_posts/                           # X投稿の下書き
│   ├── daily_posts.md                 # Day別投稿テンプレート
│   └── buzz_posts.md                  # バズ狙い投稿案
│
├── assets/                            # アプリ用素材
│   ├── app_icon/                      # アプリアイコン
│   ├── screenshots/                   # App Store用スクリーンショット
│   └── store_description.md           # App Store説明文・キーワード
│
├── logs/                              # 開発ログ
│   ├── day1.md                        # Day 1 作業ログ
│   ├── day2.md                        # Day 2 作業ログ
│   ├── day3.md                        # Day 3 作業ログ
│   ├── day4.md                        # Day 4 作業ログ
│   ├── day5.md                        # Day 5 作業ログ
│   ├── day6.md                        # Day 6 作業ログ
│   ├── day7.md                        # Day 7 作業ログ
│   └── issues.md                      # つまずきポイント記録
│
└── revenue/                           # 収益データ
    ├── note_analytics.md              # Note記事のPV・売上
    ├── app_analytics.md               # アプリDL数・課金データ
    └── x_analytics.md                 # Xフォロワー・インプレッション
```

---

## 🔧 セットアップ手順

### 方法A：Antigravityのエージェントに指示する場合

Antigravityのエージェントチャットに以下を貼り付けてください：

```
以下のフォルダ構成を、ホームディレクトリ配下に作成してください。
場所: ~/Projects/ai-director-project/

作成するディレクトリ:
- docs/
- articles/images/thumbnails/
- articles/images/screenshots/
- x_posts/
- assets/app_icon/
- assets/screenshots/
- logs/
- revenue/

以下のファイルを空ファイルとして作成（touch）してください:
- README.md
- CONTEXT.md
- docs/project_plan.md
- docs/app_spec.md
- docs/api_selection.md
- docs/revenue_model.md
- articles/01_planning.md
- articles/02_environment.md
- articles/03_implementation.md
- articles/04_release.md
- articles/05_revenue_report.md
- articles/extra_note_guide.md
- x_posts/daily_posts.md
- x_posts/buzz_posts.md
- assets/store_description.md
- logs/day1.md
- logs/day2.md
- logs/day3.md
- logs/day4.md
- logs/day5.md
- logs/day6.md
- logs/day7.md
- logs/issues.md
- revenue/note_analytics.md
- revenue/app_analytics.md
- revenue/x_analytics.md

※ app/ ディレクトリはDay 1にFlutterプロジェクトを作成する際に生成されるので、今は作成不要です。

作成が完了したら、treeコマンドで構造を表示して確認してください。
```

### 方法B：Claude Code CLIで実行する場合

Antigravityのターミナル、またはMacのターミナルから以下を実行：

```bash
claude "以下のフォルダ構成を ~/Projects/ai-director-project/ に作成して。
ディレクトリ: docs, articles/images/thumbnails, articles/images/screenshots, x_posts, assets/app_icon, assets/screenshots, logs, revenue
空ファイル: README.md, CONTEXT.md, docs/project_plan.md, docs/app_spec.md, docs/api_selection.md, docs/revenue_model.md, articles/01_planning.md から 05_revenue_report.md, articles/extra_note_guide.md, x_posts/daily_posts.md, x_posts/buzz_posts.md, assets/store_description.md, logs/day1.md から day7.md, logs/issues.md, revenue/note_analytics.md, revenue/app_analytics.md, revenue/x_analytics.md
最後にtreeで確認して。"
```

### 方法C：シェルスクリプトを直接実行する場合

```bash
#!/bin/bash
# AI監督プロジェクト フォルダ構成セットアップ

BASE=~/Projects/ai-director-project

# ディレクトリ作成
mkdir -p $BASE/{docs,articles/images/{thumbnails,screenshots},x_posts,assets/{app_icon,screenshots},logs,revenue}

# ドキュメント系
touch $BASE/README.md
touch $BASE/CONTEXT.md
touch $BASE/docs/{project_plan,app_spec,api_selection,revenue_model}.md

# 記事系
touch $BASE/articles/{01_planning,02_environment,03_implementation,04_release,05_revenue_report,extra_note_guide}.md

# X投稿系
touch $BASE/x_posts/{daily_posts,buzz_posts}.md

# アセット系
touch $BASE/assets/store_description.md

# ログ系
for i in $(seq 1 7); do touch $BASE/logs/day${i}.md; done
touch $BASE/logs/issues.md

# 収益データ系
touch $BASE/revenue/{note_analytics,app_analytics,x_analytics}.md

echo "✅ セットアップ完了"
tree $BASE
```

---

## 📋 セットアップ後にやること

1. **CONTEXT.md にコンテキスト引き継ぎドキュメントをコピー**
   - 別途出力した `ai_director_project_context.md` の内容を貼り付ける

2. **articles/01_planning.md に記事①最終版をコピー**
   - 別途出力した `note_article_01_final.md` の内容を貼り付ける

3. **docs/project_plan.md に企画構想書をコピー**
   - 別途出力した `project_plan_v3.md` の内容を貼り付ける

4. **Antigravityでプロジェクトフォルダを開く**
   - `ai-director-project` フォルダをAntigravityで開く
   - エージェントがプロジェクト全体を把握できる状態にする

5. **Coworkにもフォルダをマウント**
   - Claude Desktop → Cowork → `ai-director-project` を指定
   - ファイル整理やドキュメント作成をCoworkに任せられるようにする

---

## 💡 フォルダ構成の意図

### logs/ が重要
毎日の作業ログを残すことで：
- 記事の素材になる（Day別の記録がそのまま記事に流し込める）
- 新しいチャットを始めるとき、直近のログを読み込ませれば精度が上がる
- つまずきポイント（issues.md）は記事③④で使う

### CONTEXT.md の運用ルール
- 毎日の作業終了時に最新状態に更新する
- 新しいチャットを開始するとき、このファイルの内容を冒頭に貼り付ける
- 重要な意思決定があったら「意思決定ログ」セクションに追記する
- ファイルが肥大化してきたら、古い情報を「アーカイブ」セクションに移動する
