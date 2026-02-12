# Day 3 開発手順書 ― UI仕上げ + お気に入り保存

## 概要
Day 3ではアプリのUX面を大幅に強化する。具体的には以下を実装する。

1. **SQLiteデータベースサービス** ― お気に入り・撮影履歴の永続化
2. **お気に入り保存/削除機能** ― フレーズカードのハートボタンで保存・解除
3. **撮影履歴の保存/表示** ― 過去のスキャン結果を一覧で確認
4. **タブバーナビゲーション** ― ホーム / 履歴 / お気に入りの3タブ構成
5. **フレーズカードのデザイン調整** ― アニメーション・見た目の改善

## 前提条件
- Day 2完了（claude/nervous-haibt ブランチ、コミット 4be0b45）
- sqflite パッケージは pubspec.yaml に追加済み
- path_provider パッケージも追加済み

---

## Step 1: データベースサービスの作成

### `lib/services/database_service.dart`（新規作成）

SQLiteを使って2つのテーブルを管理する。

**テーブル設計:**

```
scan_history テーブル:
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- image_path: TEXT NOT NULL
- scanned_at: TEXT NOT NULL (ISO 8601)

phrases テーブル:
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- scan_id: INTEGER (外部キー → scan_history.id)
- english: TEXT NOT NULL
- japanese: TEXT NOT NULL
- difficulty: TEXT NOT NULL
- is_favorite: INTEGER DEFAULT 0 (0=false, 1=true)
- created_at: TEXT NOT NULL (ISO 8601)
```

**実装ポイント:**
- シングルトンパターンで1つのDBインスタンスを共有
- `sqflite` の `getDatabasesPath()` でDB保存先を取得
- バージョン管理（`version: 1`）で将来のマイグレーションに対応
- CRUD操作を全てメソッド化

---

## Step 2: モデルの拡張

### `lib/models/phrase.dart`（更新）
- `id` フィールド追加（DB保存後に付与）
- `isFavorite` フィールド追加
- `scanId` フィールド追加（どのスキャンに属するか）
- `toMap()` メソッド追加（SQLite保存用）
- `fromMap()` ファクトリ追加（SQLite読み込み用）
- `copyWith()` メソッド追加（お気に入りトグル用）

### `lib/models/scan_result.dart`（更新）
- `id` フィールド追加
- `toMap()` / `fromMap()` メソッド追加

---

## Step 3: タブバーナビゲーション

### `lib/screens/main_screen.dart`（新規作成）
- `BottomNavigationBar` で3タブ構成
- タブ: ホーム（カメラアイコン）/ 履歴（時計アイコン）/ お気に入り（ハートアイコン）
- `IndexedStack` でタブ切り替え時の状態保持

### `lib/app.dart`（更新）
- `HomeScreen` → `MainScreen` に変更

---

## Step 4: お気に入り画面

### `lib/screens/favorites_screen.dart`（新規作成）
- お気に入り登録済みフレーズの一覧表示
- スワイプで削除
- 空の場合は「まだお気に入りがありません」メッセージ

---

## Step 5: 撮影履歴画面

### `lib/screens/history_screen.dart`（新規作成）
- 撮影日時・画像サムネイル・フレーズプレビューの一覧
- タップで結果画面に遷移（再表示）
- 日付ごとにグループ化

---

## Step 6: フレーズカードの改善

### `lib/widgets/phrase_card.dart`（更新）
- お気に入りボタンの実装（ハートアイコンのトグル）
- お気に入りON/OFFアニメーション
- カードタップでフレーズ読み上げ（将来対応のスタブ）

---

## Step 7: 結果画面の更新

### `lib/screens/result_screen.dart`（更新）
- AI分析完了後にスキャン結果をDBに自動保存
- フレーズのお気に入りトグルをDBに反映

---

## 新規・変更ファイル一覧

| ファイル | 操作 |
|---|---|
| `lib/services/database_service.dart` | 新規作成 |
| `lib/screens/main_screen.dart` | 新規作成 |
| `lib/screens/favorites_screen.dart` | 新規作成 |
| `lib/screens/history_screen.dart` | 新規作成 |
| `lib/models/phrase.dart` | 更新 |
| `lib/models/scan_result.dart` | 更新 |
| `lib/screens/result_screen.dart` | 更新 |
| `lib/widgets/phrase_card.dart` | 更新 |
| `lib/app.dart` | 更新 |

---

## テスト項目
1. [ ] フレーズのお気に入り登録/解除が動作する
2. [ ] お気に入り画面にお気に入りフレーズが表示される
3. [ ] 撮影後のスキャン結果が履歴に保存される
4. [ ] 履歴画面に過去のスキャン結果が表示される
5. [ ] タブ切り替えが正常に動作する
6. [ ] アプリ再起動後もお気に入り・履歴が保持される
7. [ ] `flutter analyze` でエラーなし
8. [ ] `flutter build ios --simulator` 成功

---

## コミット計画
```
Day3: SQLiteデータベースサービス + お気に入り保存機能
Day3: 撮影履歴画面 + タブバーナビゲーション
Day3: フレーズカードデザイン調整 + UI仕上げ
```
