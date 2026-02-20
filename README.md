# money-log-ios

iOS向け家計簿アプリ「マネーログ」のモックプロジェクトです。
2つの異なるデザインアプローチのモックを収録しています。

## プロジェクト構成

```
money-log-ios/
├── StandardMock/          … 標準版モック
├── GamificationMock/      … ゲーミフィケーション版モック
└── README.md
```

両モックは共通の統一アーキテクチャ（MVVM）とフォルダ構成に基づいています。

```
MoneyLog/
├── App/              アプリエントリポイント
├── Models/           データモデル
├── ViewModels/       ビジネスロジック
├── Views/            画面（サブフォルダで分割）
├── Components/       再利用可能なUIコンポーネント
├── Theme/            テーマ・スタイル定義
└── Resources/        Assets、Preview Content
```

---

## StandardMock（標準版）

シンプルで使いやすいオーソドックスな家計簿アプリです。
オレンジを基調としたマテリアルデザインで、支出管理に特化しています。

### 画面構成

| 画面 | ファイル | 概要 |
|------|----------|------|
| ホーム | `Views/Home/HomeView.swift` | 今日の支出合計、月間予算の進捗バー、今日の支出一覧 |
| カレンダー | `Views/Calendar/CalendarView.swift` | 月間カレンダーで日別支出を可視化、日付タップで詳細表示 |
| 入力 | `Views/Input/QuickInputView.swift` | テンキー式の金額入力、クイック金額ボタン、カテゴリ選択 |
| 設定 | `Views/Settings/SettingsView.swift` | 月間予算の設定、カテゴリ別支出の内訳表示 |

### 主な機能

- **支出記録** — カテゴリ（10種）、金額、メモを入力して支出を記録
- **今日の支出サマリー** — 当日の合計支出をリアルタイム表示
- **月間予算管理** — 設定した予算に対する使用率をプログレスバーで表示（50%未満: 緑、80%未満: オレンジ、超過: 赤）
- **カレンダー表示** — 月間カレンダー上に日別支出額を表示、日付選択で詳細一覧を確認
- **クイック入力** — テンキーUIとクイック金額ボタン（¥100〜¥5,000）で素早く記録

### カテゴリ一覧

| カテゴリ | アイコン | カラー |
|----------|----------|--------|
| 食費 | fork.knife | オレンジ |
| 交通費 | tram.fill | ブルー |
| 買い物 | bag.fill | ピンク |
| カフェ | cup.and.saucer.fill | ブラウン |
| 娯楽 | gamecontroller.fill | パープル |
| 日用品 | house.fill | グリーン |
| 医療 | cross.case.fill | レッド |
| 学習 | book.fill | シアン |
| サブスク | creditcard.fill | インディゴ |
| その他 | ellipsis.circle.fill | グレー |

### データモデル

```swift
struct Expense: Identifiable, Codable {
    let id: UUID
    let amount: Int          // 金額（円）
    let category: ExpenseCategory
    let memo: String         // メモ（任意）
    let date: Date
    let isIncome: Bool       // 収入フラグ
}
```

---

## GamificationMock（ゲーミフィケーション版）

家計簿記録にゲーム要素を取り入れたモチベーション重視のアプリです。
パープルを基調としたカスタムテーマで、XP・レベル・実績システムを搭載しています。

### 画面構成

| 画面 | ファイル | 概要 |
|------|----------|------|
| ホーム | `Views/Home/HomeView.swift` | レベル・XPバー、連続記録ストリーク、今日の支出、月間収支、カテゴリ別内訳 |
| 履歴 | `Views/Calendar/HistoryView.swift` | 月間カレンダーで支出の濃淡を可視化、日付タップで詳細表示 |
| 入力 | `Views/Input/QuickInputView.swift` | 支出／収入の切替、テンキー入力、XP獲得アニメーション |
| 実績 | `Views/Achievements/AchievementsView.swift` | 実績一覧のグリッド表示、達成率のプログレス |

### 主な機能

- **XP・レベルシステム** — 記録をつけるたびに25XPを獲得、レベルアップで成長を実感
- **連続記録ストリーク** — 毎日の記録を継続すると連続日数がカウントアップ、週間チェックマーク表示
- **実績（アチーブメント）** — 10種類の実績を用意、条件達成で解除（3日坊主卒業、一週間マスター、継続の達人 など）
- **収入・支出の両方を管理** — 支出だけでなく収入も記録可能、月間収支バランスを表示
- **カテゴリ別分析** — 月間のカテゴリ別支出を棒グラフで可視化
- **カスタムタブバー** — 中央にフローティング追加ボタンを配置したオリジナルタブバー

### 実績一覧

| 実績名 | 条件 | 絵文字 |
|--------|------|--------|
| はじめの一歩 | 初めての記録 | 👣 |
| 3日坊主卒業 | 3日連続記録 | 🔥 |
| 一週間マスター | 7日連続記録 | ⭐ |
| 継続の達人 | 30日連続記録 | 👑 |
| レベル5到達 | レベル5に到達 | 🎯 |
| レベル10到達 | レベル10に到達 | 🏆 |
| やりくり上手 | 1ヶ月予算内に収めた | 💪 |
| 記録の鬼 | 50件の記録を達成 | 📝 |
| カテゴリマスター | 全カテゴリを使った | 🌈 |
| 貯金の星 | 月の収支がプラス | 🌟 |

### データモデル

```swift
struct Expense: Identifiable, Codable {
    let id: UUID
    let amount: Int          // 金額（円）
    let category: ExpenseCategory
    let memo: String         // メモ（任意）
    let date: Date
    let isIncome: Bool       // 収入フラグ
}

struct Income: Identifiable, Codable {
    let id: UUID
    let amount: Int          // 金額（円）
    let category: IncomeCategory
    let memo: String         // メモ（任意）
    let date: Date
}
```

### ゲーミフィケーション用モデル

```swift
class UserStats: ObservableObject {
    var currentXP: Int       // 現在のXP
    var level: Int           // 現在のレベル
    var streak: Int          // 連続記録日数
    var totalDaysLogged: Int // 総記録日数
    var monthlyBudget: Int   // 月間予算
    var achievements: [Achievement]
}
```

---

## 技術スタック

- **言語**: Swift 5
- **UI**: SwiftUI
- **アーキテクチャ**: MVVM（Model-View-ViewModel）
- **最低動作環境**: iOS 17.0
- **データ管理**: `@StateObject` / `@EnvironmentObject` によるリアクティブな状態管理
- **デザイン**: SF Symbols、マテリアルデザイン、スプリングアニメーション
