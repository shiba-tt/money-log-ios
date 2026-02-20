import Foundation

struct Expense: Identifiable, Codable {
    let id: UUID
    let amount: Int
    let category: ExpenseCategory
    let memo: String
    let date: Date
    let isIncome: Bool

    init(id: UUID = UUID(), amount: Int, category: ExpenseCategory, memo: String = "", date: Date = Date(), isIncome: Bool = false) {
        self.id = id
        self.amount = amount
        self.category = category
        self.memo = memo
        self.date = date
        self.isIncome = isIncome
    }
}

struct Income: Identifiable, Codable {
    let id: UUID
    let amount: Int
    let category: IncomeCategory
    let memo: String
    let date: Date

    init(id: UUID = UUID(), amount: Int, category: IncomeCategory, memo: String = "", date: Date = Date()) {
        self.id = id
        self.amount = amount
        self.category = category
        self.memo = memo
        self.date = date
    }
}
