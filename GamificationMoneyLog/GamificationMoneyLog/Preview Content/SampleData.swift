import Foundation

struct SampleData {
    static let expenses: [Expense] = {
        let calendar = Calendar.current
        let now = Date()

        return [
            Expense(amount: 580, category: .food, memo: "ランチ", date: now),
            Expense(amount: 160, category: .transport, memo: "電車", date: now),
            Expense(amount: 490, category: .cafe, memo: "スタバ", date: now),
            Expense(amount: 1200, category: .food, memo: "夕食", date: calendar.date(byAdding: .day, value: -1, to: now)!),
            Expense(amount: 320, category: .transport, memo: "バス", date: calendar.date(byAdding: .day, value: -1, to: now)!),
            Expense(amount: 3500, category: .entertainment, memo: "映画", date: calendar.date(byAdding: .day, value: -1, to: now)!),
            Expense(amount: 850, category: .food, memo: "お弁当", date: calendar.date(byAdding: .day, value: -2, to: now)!),
            Expense(amount: 2980, category: .shopping, memo: "Tシャツ", date: calendar.date(byAdding: .day, value: -2, to: now)!),
            Expense(amount: 450, category: .cafe, memo: "タリーズ", date: calendar.date(byAdding: .day, value: -3, to: now)!),
            Expense(amount: 1500, category: .education, memo: "参考書", date: calendar.date(byAdding: .day, value: -3, to: now)!),
            Expense(amount: 680, category: .food, memo: "夕食", date: calendar.date(byAdding: .day, value: -3, to: now)!),
            Expense(amount: 980, category: .subscription, memo: "Netflix", date: calendar.date(byAdding: .day, value: -5, to: now)!),
            Expense(amount: 750, category: .food, memo: "ラーメン", date: calendar.date(byAdding: .day, value: -5, to: now)!),
            Expense(amount: 2400, category: .health, memo: "薬局", date: calendar.date(byAdding: .day, value: -7, to: now)!),
            Expense(amount: 560, category: .food, memo: "コンビニ", date: calendar.date(byAdding: .day, value: -7, to: now)!),
            Expense(amount: 4500, category: .entertainment, memo: "カラオケ", date: calendar.date(byAdding: .day, value: -10, to: now)!),
            Expense(amount: 890, category: .food, memo: "焼肉", date: calendar.date(byAdding: .day, value: -10, to: now)!),
        ]
    }()

    static let incomes: [Income] = {
        let calendar = Calendar.current
        let now = Date()

        return [
            Income(amount: 85000, category: .partTime, memo: "バイト代", date: calendar.date(byAdding: .day, value: -15, to: now)!),
            Income(amount: 10000, category: .gift, memo: "お小遣い", date: calendar.date(byAdding: .day, value: -20, to: now)!),
        ]
    }()
}
