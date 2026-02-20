import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: ExpenseStore
    @Binding var showingInput: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    todaySummaryCard
                    monthlyBudgetCard
                    todayExpensesList
                    Spacer(minLength: 80)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("マネーログ")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Today Summary

    private var todaySummaryCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("今日の支出")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(todayDateString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text("¥\(store.todayTotal.formatted())")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .primary.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            if store.todayExpenses.isEmpty {
                Text("まだ記録がありません")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Monthly Budget

    private var monthlyBudgetCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("今月の予算")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("¥\(store.thisMonthTotal.formatted()) / ¥\(store.monthlyBudget.formatted())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemGray5))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(budgetColor)
                        .frame(
                            width: geometry.size.width * store.budgetProgress,
                            height: 12
                        )
                        .animation(.spring(response: 0.5), value: store.budgetProgress)
                }
            }
            .frame(height: 12)

            HStack {
                Label(budgetMessage, systemImage: budgetIcon)
                    .font(.caption)
                    .foregroundStyle(budgetColor)
                Spacer()
                Text("残り ¥\(store.budgetRemaining.formatted())")
                    .font(.caption.bold())
                    .foregroundStyle(store.budgetRemaining >= 0 ? .green : .red)
            }
        }
        .padding(20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Today's Expenses List

    private var todayExpensesList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("今日の記録")
                    .font(.headline)
                Spacer()
                if !store.todayExpenses.isEmpty {
                    Text("\(store.todayExpenses.count)件")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if store.todayExpenses.isEmpty {
                emptyStateView
            } else {
                ForEach(store.todayExpenses) { expense in
                    ExpenseRow(expense: expense)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "pencil.and.list.clipboard")
                .font(.system(size: 40))
                .foregroundStyle(.orange.opacity(0.6))

            Text("下の＋ボタンから\n記録してみましょう")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Helpers

    private var todayDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日(E)"
        return formatter.string(from: Date())
    }

    private var budgetColor: Color {
        if store.budgetProgress < 0.5 { return .green }
        if store.budgetProgress < 0.8 { return .orange }
        return .red
    }

    private var budgetMessage: String {
        if store.budgetProgress < 0.5 { return "いい調子です" }
        if store.budgetProgress < 0.8 { return "少し気をつけましょう" }
        return "予算オーバーに注意"
    }

    private var budgetIcon: String {
        if store.budgetProgress < 0.5 { return "face.smiling" }
        if store.budgetProgress < 0.8 { return "exclamationmark.triangle" }
        return "exclamationmark.circle"
    }
}

#Preview {
    HomeView(showingInput: .constant(false))
        .environmentObject(ExpenseStore())
}
