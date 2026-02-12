# Note見出し画像テンプレート仕様

## 概要
AI監督プロジェクトのNote記事シリーズ統一デザイン。
Day番号とサブタイトルを差し替えるだけで新記事の見出し画像を生成可能。

## サイズ
- 1280 x 670 px（Note推奨サイズ）
- PNG形式、RGB

## デザイン要素

### 背景
- ダークテック系グラデーション（#0F0F1A → #1B2140）
- 右上に青グロウ、左下に紫グロウ（各半径200-220px、alpha 18-22）
- **グリッド線なし**（v1で入れたが不評だったため削除）

### 上部装飾
- ターミナルドット（赤・黄・緑）左上 (40, 28)
- コードデコレーション（右上、mono 13px、白alpha35）
  - Day内容に合わせて変える（例: `flutter analyze ✓`）

### メインコンテンツ（中央寄せ）
1. **シリーズラベル**「AI監督プロジェクト」 - 角丸枠つき、15px bold、白alpha140
2. **Day番号** - MonoBold 82px、青→紫グラデーション文字
3. **サブタイトル** - DualFont 27px bold、白、1-2行
4. **タグライン**「コード0行 — AIチャットだけでiOSアプリを作る7日間」 - 15px、白alpha100

### 下部
- プログレスドット（7個）: 完了=青、現在=紫、未着手=白枠のみ
- 進捗ラベル「N / 7 days」
- `@marumi_works`（右下）
- グラデーションバー（4px、青→紫→シアン→青）

## カラーパレット
```python
BLUE_ACCENT  = (96, 165, 250)
PURPLE_ACCENT = (167, 139, 250)
CYAN_ACCENT  = (6, 182, 212)
WHITE = (255, 255, 255)
```

## フォント構成
日本語と英数字の混在に対応するため DualFont クラスを使用:
- CJK: `/usr/share/fonts/truetype/droid/DroidSansFallbackFull.ttf`
- Latin: `/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf` / Bold
- Mono: `/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf` / Bold

## 生成方法

### スクリプト場所
プロジェクトルートの上位（作業ディレクトリ）に配置:
- `gen_header_v2.py` - Day 1-2用 + 共通ライブラリ
- `gen_header_day0.py` - Day 0用

### 新しいDay画像を作るには
`gen_header_day0.py` をコピーして以下を変更:

```python
# 1. 出力ファイル名
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "header_dayN.png")

# 2. コードデコレーション（右上のテキスト）
for i, line in enumerate(["flutter analyze ✓", "new feature ✓", "X lines generated"]):

# 3. Day番号
day_h = draw_gradient_text(img, "Day N", cy, MONO_BOLD_PATH, 82)

# 4. サブタイトル（1-2行）
sub_font = DualFont(27, bold=True)
draw_dual_text_centered(draw, cy, "1行目のテキスト", WHITE, sub_font)
cy += 44
draw_dual_text_centered(draw, cy, "2行目のテキスト", WHITE, sub_font)

# 5. プログレスドット（完了数を変える）
for i in range(7):
    cx = 40 + i * 22
    if i < N:           # ← 完了Day数
        draw.ellipse(... fill=BLUE_ACCENT)
    elif i == N:        # ← 現在Day
        draw.ellipse(... fill=PURPLE_ACCENT)
    else:               # ← 未着手
        draw.ellipse(... outline=(255,255,255,50))

# 6. 進捗ラベル
draw.text(..., "N / 7 days", ...)
```

### 実行コマンド
```bash
cd /sessions/stoic-trusting-hamilton
python3 gen_header_dayN.py
```

## 作成済み画像
| ファイル | 記事 | サブタイトル |
|---|---|---|
| `header_day0.png` | 記事① | Claude Opus 4.6がリリースされたので、全部AIに任せて1週間でiOSアプリを作ってみる |
| `header_day1-2.png` | 記事② | ターミナルって何？からスタートして、Claudeに聞いたら2時間で開発環境ができた |
| (未作成) | 記事②.5 | コード0行でアプリを作る「道具」の使い方 |
| (未作成) | 記事③ | (Day 3-4) |
| (未作成) | 記事④ | (Day 5-7) |
| (未作成) | 記事⑤ | (結果公開) |
