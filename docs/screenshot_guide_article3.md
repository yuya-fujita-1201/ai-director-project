# 記事②.5 ツール解説編 ― スクショ撮影指示

ステータス: 📌 未撮影（記事はスクショなしで先行公開済み。後日追加予定）
Note記事URL: （公開済み。URLを追記すること）

---

## コピペ用プロンプト（Claude Code CLI or ターミナル）

```
記事②.5「ツール解説編」用のスクショを撮影してください。
以下の手順で進めてください。

### 1. 出力フォルダ作成
mkdir -p articles/images/article3

### 2. 撮影するスクショ一覧

以下の6枚を `screencapture -w` で撮影します。
各スクショの前に「次は○○のスクショを撮ります。該当ウィンドウを前面にしてEnterを押してください」と私に伝えてから実行してください。

**① Claudeデスクトップアプリ初期画面**
- ファイル名: articles/images/article3/01_claude_desktop_home.png
- 撮影内容: Claudeデスクトップアプリのメイン画面（チャット入力欄が見える状態）
- コマンド: screencapture -w articles/images/article3/01_claude_desktop_home.png

**② Cowork チャットタブ（指示を出している様子）**
- ファイル名: articles/images/article3/02_cowork_chat.png
- 撮影内容: Coworkのチャットタブで日本語の指示が表示されている画面
  - 例: 「docs/day1_dev_guide.md を読んで、Day 1の開発タスクを実行してください」の指示が見える状態
- コマンド: screencapture -w articles/images/article3/02_cowork_chat.png

**③ Cowork コードタブ（Claude Codeがタスク実行中）**
- ファイル名: articles/images/article3/03_cowork_code_tab.png
- 撮影内容: Coworkのコードタブ。Claude Codeがファイルを生成している様子やログが見える状態
- コマンド: screencapture -w articles/images/article3/03_cowork_code_tab.png

**④ Claude Codeのターミナル画面（実行ログ）**
- ファイル名: articles/images/article3/04_terminal_log.png
- 撮影内容: ターミナルでClaude Codeが動いている画面。コマンドと出力が見える状態
  - flutter analyze や flutter build の実行ログなど
- コマンド: screencapture -w articles/images/article3/04_terminal_log.png

**⑤ プロジェクトのファイル一覧（VSCodeまたはFinder）**
- ファイル名: articles/images/article3/05_file_tree.png
- 撮影内容: AIが生成したファイル構成が見える画面（VSCode、Finder、またはtreeコマンド出力）
  - app/snap_english/lib/ 以下のフォルダ構成が見えると良い
- コマンド: screencapture -w articles/images/article3/05_file_tree.png

**⑥ シミュレータで動くアプリ（完成形）**
- ファイル名: articles/images/article3/06_simulator_app.png
- 撮影内容: iOSシミュレータでSnapEnglishが動いている画面
  - ホーム画面または結果画面
- これはシミュレータが起動していれば以下で撮れます:
  xcrun simctl io booted screenshot articles/images/article3/06_simulator_app.png
  - シミュレータが起動していなければ screencapture -w で代用

### 3. 撮影後の確認
撮影が終わったら以下を実行:
ls -la articles/images/article3/
tree articles/images/article3/

### 4. git commit
git add articles/images/article3/
git commit -m "記事②.5: ツール解説編用スクショ追加"

各スクショの前に必ず私に声をかけて、該当画面を表示する時間をください。
```

---

## 補足: screencapture -w の使い方
- コマンド実行後、カーソルがカメラアイコンに変わる
- 撮りたいウィンドウをクリックするとそのウィンドウだけキャプチャされる
- Spaceキーでウィンドウ単位/範囲選択を切り替え可能

---

## Note記事への挿入手順（撮影後）
1. Noteの記事編集画面を開く
2. 各「📸 ※スクショ○」のプレースホルダー行を選択
3. 画像アップロード（ドラッグ&ドロップ or 画像挿入ボタン）
4. 📸行を削除して画像に置き換え
5. 更新を保存

## 記事内のプレースホルダー位置
- 📸 ※スクショ① → 「Claudeデスクトップアプリを入れた」セクション末尾
- 📸 ※スクショ② → 「チャットタブ」セクション冒頭
- 📸 ※スクショ③ → 「コードタブ」セクション冒頭
- 📸 ※スクショ④ → コードタブ説明の末尾
- 📸 ※スクショ⑤ → 「生成されたファイルの量に驚いた」セクション冒頭
- 📸 ※スクショ⑥ → 「ステップ4：結果を確認する」セクション末尾
