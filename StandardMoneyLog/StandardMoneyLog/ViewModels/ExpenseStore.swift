import SwiftUI
import Combine

@MainActor
class ExpenseStore: ObservableObject {
    @Published var expenses: [Expense] = Expense.sampleData
    @Published var monthlyBudget: Int = 80000

    // MARK: - Computed Properties

    var todayExpenses: [Expense] {
        expenses.filter { Calendar.current.isDateInToday($0.date) && !$0.isIncome }
    }

    var todayTotal: Int {
        todayExpenses.reduce(0) { $0 + $1.amount }
    }

    var thisMonthExpenses: [Expense] {
        let calendar = Calendar.current
        let now = Date()
        return expenses.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .month) && !$0.isIncome
        }
    }

    var thisMonthTotal: Int {
        thisMonthExpenses.reduce(0) { $0 + $1.amount }
    }

    var budgetRemaining: Int {
        monthlyBudget - thisMonthTotal
    }

    var budgetProgress: Double {
        guard monthlyBudget > 0 else { return 0 }
        return min(Double(thisMonthTotal) / Double(monthlyBudget), 1.0)
    }

    // MARK: - Grouped by Date

    var expensesGroupedByDate: [(date: Date, expenses: [Expense])] {
        let grouped = Dictionary(grouping: expenses) { expense in
            Calendar.current.startOfDay(for: expense.date)
        }
        return grouped
            .map { (date: $0.key, expenses: $0.value) }
            .sorted { $0.date > $1.date }
    }

    // MARK: - Methods

    func addExpense(_ expense: Expense) {
        withAnimation(.spring(response: 0.3)) {
            expenses.insert(expense, at: 0)
        }
    }

    func deleteExpense(_ expense: Expense) {
        withAnimation {
            expenses.removeAll { $0.id == expense.id }
        }
    }

    func totalForDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return expenses
            .filter { calendar.isDate($0.date, equalTo: date, toGranularity: .day) && !$0.isIncome }
            .reduce(0) { $0 + $1.amount }
    }

    func expensesForDate(_ date: Date) -> [Expense] {
        let calendar = Calendar.current
        return expenses
            .filter { calendar.isDate($0.date, equalTo: date, toGranularity: .day) }
            .sorted { $0.date > $1.date }
    }
}

