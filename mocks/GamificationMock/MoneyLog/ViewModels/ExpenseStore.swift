import Foundation

class ExpenseStore: ObservableObject {
    @Published var expenses: [Expense] = SampleData.expenses
    @Published var incomes: [Income] = SampleData.incomes

    var todayExpenses: [Expense] {
        let calendar = Calendar.current
        return expenses.filter { calendar.isDateInToday($0.date) }
    }

    var todayTotal: Int {
        todayExpenses.reduce(0) { $0 + $1.amount }
    }

    var monthlyExpenseTotal: Int {
        let calendar = Calendar.current
        let now = Date()
        return expenses.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }
    }

    var monthlyIncomeTotal: Int {
        let calendar = Calendar.current
        let now = Date()
        return incomes.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }
    }

    var monthlyBalance: Int {
        monthlyIncomeTotal - monthlyExpenseTotal
    }

    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }

    func addIncome(_ income: Income) {
        incomes.append(income)
    }

    func expensesForDate(_ date: Date) -> [Expense] {
        let calendar = Calendar.current
        return expenses.filter { calendar.isDate($0.date, equalTo: date, toGranularity: .day) }
    }

    func categoryBreakdown() -> [(category: ExpenseCategory, total: Int)] {
        let calendar = Calendar.current
        let now = Date()
        let monthlyExpenses = expenses.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }

        var breakdown: [ExpenseCategory: Int] = [:]
        for expense in monthlyExpenses {
            breakdown[expense.category, default: 0] += expense.amount
        }

        return breakdown.map { (category: $0.key, total: $0.value) }
            .sorted { $0.total > $1.total }
    }
}
