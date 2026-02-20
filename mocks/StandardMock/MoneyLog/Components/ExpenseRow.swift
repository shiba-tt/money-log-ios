import SwiftUI

struct ExpenseRow: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: expense.category.icon)
                .font(.body)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(expense.category.color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(expense.category.rawValue)
                    .font(.subheadline.bold())

                if !expense.memo.isEmpty {
                    Text(expense.memo)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text("¥\(expense.amount.formatted())")
                .font(.body.bold().monospacedDigit())
                .foregroundStyle(expense.isIncome ? .green : .primary)
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack {
        ExpenseRow(expense: Expense(amount: 850, category: .food, memo: "ランチ"))
        ExpenseRow(expense: Expense(amount: 160, category: .transport, memo: "電車"))
        ExpenseRow(expense: Expense(amount: 350, category: .cafe, memo: ""))
    }
    .padding()
}
