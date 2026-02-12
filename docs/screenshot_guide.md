# スクリーンショット撮影ガイド（Claude Code CLI用）
# Day 1-2 対応版

---

## 📋 概要

X投稿とNote記事②に使うスクリーンショットを一括撮影する。
Claude Code CLIに以下のプロンプトをコピペして実行。

---

## 🎯 コピペ用プロンプト（これをClaude Codeに貼り付ける）

```
以下の手順でスクリーンショットを撮影して保存してください。
全てのスクショを2つのフォルダに分けて保存します。

■ 保存先フォルダ作成
mkdir -p ~/Projects/ai-director-project/articles/images/note/
mkdir -p ~/Projects/ai-director-project/articles/images/x/

■ ステップ1: 事前情報の保存

1-1. プロジェクトのフォルダ構成をテキスト保存
tree ~/Projects/ai-director-project/app/snap_english/lib/ -L 3 > ~/Projects/ai-director-project/articles/images/note/project_structure.txt

1-2. flutter doctor の結果を保存
flutter doctor > ~/Projects/ai-director-project/articles/images/note/flutter_doctor.txt 2>&1

1-3. flutter analyze の結果を保存
cd ~/Projects/ai-director-project/app/snap_english && flutter analyze > ~/Projects/ai-director-project/articles/images/note/flutter_analyze.txt 2>&1

■ ステップ2: シミュレータ起動 + アプリ実行

cd ~/Projects/ai-director-project/app/snap_english
open -a Simulator
# シミュレータ起動を待つ
sleep 10
flutter run -d booted
# アプリが完全に起動するまで待つ

■ ステップ3: ホーム画面のスクショ（Note用 + X Day1用）

アプリが起動してホーム画面（撮影ボタンがある画面）が表示されたら：
xcrun simctl io booted screenshot ~/Projects/ai-director-project/articles/images/note/01_home_screen.png
cp ~/Projects/ai-director-project/articles/images/note/01_home_screen.png ~/Projects/ai-director-project/articles/images/x/day1_home.png

■ ステップ4: カメラ/ギャラリーから画像を選択

シミュレータで「ギャラリーから選択」ボタンをタップする操作を行い、
写真を選択した直後のスクショを撮る：
xcrun simctl io booted screenshot ~/Projects/ai-director-project/articles/images/note/02_gallery_select.png

■ ステップ5: AI分析中の画面（ローディング中のスクショ）

もし画像選択後にローディング画面があれば：
xcrun simctl io booted screenshot ~/Projects/ai-director-project/articles/images/note/03_loading.png

■ ステップ6: ★最重要★ フレーズ生成結果画面のスクショ（Note用 + X Day2用）

AIがフレーズ生成を完了し、英語フレーズ3つが難易度バッジ（緑・黄・赤）と共に
表示されている結果画面のスクショを撮影：
xcrun simctl io booted screenshot ~/Projects/ai-director-project/articles/images/note/04_result_phrases.png
cp ~/Projects/ai-director-project/articles/images/note/04_result_phrases.png ~/Projects/ai-director-project/articles/images/x/day2_result.png

■ ステップ7: 撮影完了確認

保存したファイル一覧を表示してください：
ls -la ~/Projects/ai-director-project/articles/images/note/
ls -la ~/Projects/ai-director-project/articles/images/x/

■ 注意事項
- シミュレータに写真がない場合は、事前にサンプル画像を追加してください：
  xcrun simctl addmedia booted /path/to/sample_image.jpg
- 渓流の写真が手元にあればそれを使うと、記事②の内容と一致して最高です
- フレーズ生成にはOpenAI APIキーが必要です（.envファイルに設定済みのはず）
- スクショが5枚以上撮れたら完了報告をお願いします

■ 完了後の確認
撮影した全ファイルのファイル名・パス・サイズを一覧で教えてください。
```

---

## 📁 保存先と用途

### Note記事②用（articles/images/note/）

| # | ファイル名 | 内容 | 記事の該当箇所 |
|---|---|---|---|
| 1 | 01_home_screen.png | ホーム画面（撮影ボタン） | セクション5「シミュレータで動いた」 |
| 2 | 02_gallery_select.png | ギャラリー選択画面 | セクション5 補足 |
| 3 | 03_loading.png | AI分析中画面 | セクション7「撮影したら、AIが英語を返してきた」 |
| 4 | 04_result_phrases.png | ★フレーズ結果画面 | セクション7（★最重要ビジュアル） |
| 5 | project_structure.txt | フォルダ構成 | セクション3「142ファイルが生成された」 |
| 6 | flutter_doctor.txt | flutter doctor結果 | 参考用 |
| 7 | flutter_analyze.txt | No issues found | セクション4「品質チェック」 |

### X投稿用（articles/images/x/）

| # | ファイル名 | 内容 | 投稿 |
|---|---|---|---|
| 1 | day1_home.png | ホーム画面 | Day 1 下書き投稿に添付 |
| 2 | day2_result.png | フレーズ結果画面 | Day 2 下書き投稿に添付 |

---

## 📝 手動で撮ると良い追加素材（Cmd+Shift+4 でMac画面キャプチャ）

1. ターミナルでClaude Codeが動いている画面 → 記事②のスクショ②
2. Claude Codeがコードを書いている瞬間 → 記事②のスクショ③
3. Coworkとのチャット画面 → 記事で「事務員が手順書を作った」の証拠
