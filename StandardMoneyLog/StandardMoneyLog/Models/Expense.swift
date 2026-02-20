import Foundation

struct Expense: Identifiable, Codable {
    let id: UUID
    let amount: Int
    let category: ExpenseCategory
    let memo: String
    let date: Date
    let isIncome: Bool

    init(
        id: UUID = UUID(),
        amount: Int,
        category: ExpenseCategory,
        memo: String = "",
        date: Date = Date(),
        isIncome: Bool = false
    ) {
        self.id = id
        self.amount = amount
        self.category = category
        self.memo = memo
        self.date = date
        self.isIncome = isIncome
    }
}

extension Expense {
    static let sampleData: [Expense] = [
        Expense(amount: 850, category: .food, memo: "ランチ", date: Date()),
        Expense(amount: 350, category: .cafe, memo: "スタバ", date: Date()),
        Expense(amount: 160, category: .transport, memo: "電車", date: Date()),
        Expense(amount: 2980, category: .shopping, memo: "Tシャツ", date: Date()),
        Expense(amount: 500, category: .food, memo: "夕食コンビニ", date: Date()),
        Expense(amount: 1200, category: .entertainment, memo: "映画", date: Date().addingTimeInterval(-86400)),
        Expense(amount: 680, category: .food, memo: "お弁当", date: Date().addingTimeInterval(-86400)),
        Expense(amount: 250, category: .daily, memo: "洗剤", date: Date().addingTimeInterval(-86400 * 2)),
        Expense(amount: 3500, category: .health, memo: "薬局", date: Date().addingTimeInterval(-86400 * 3)),
        Expense(amount: 1980, category: .subscription, memo: "Netflix", date: Date().addingTimeInterval(-86400 * 5)),
    ]
}
