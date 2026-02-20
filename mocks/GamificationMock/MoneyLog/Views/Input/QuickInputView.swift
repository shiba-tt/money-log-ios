import SwiftUI

struct QuickInputView: View {
    @EnvironmentObject var expenseStore: ExpenseStore
    @EnvironmentObject var userStats: UserStats
    @Environment(\.dismiss) private var dismiss

    @State private var amount: String = ""
    @State private var selectedCategory: ExpenseCategory = .food
    @State private var memo: String = ""
    @State private var isIncome = false
    @State private var selectedIncomeCategory: IncomeCategory = .partTime
    @State private var showSuccess = false
    @State private var earnedXP = 0

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                VStack(spacing: 24) {
                    typeToggle
                    amountDisplay

                    if isIncome {
                        incomeCategoryGrid
                    } else {
                        expenseCategoryGrid
                    }

                    memoField
                    numberPad
                    saveButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                if showSuccess {
                    successOverlay
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.textSecondary)
                }
                ToolbarItem(placement: .principal) {
                    Text(isIncome ? "収入を記録" : "支出を記録")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
        }
    }

    // MARK: - Type Toggle
    private var typeToggle: some View {
        HStack(spacing: 0) {
            Button(action: { withAnimation { isIncome = false } }) {
                Text("支出")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(!isIncome ? .white : AppTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(!isIncome ? AppTheme.secondary : Color.clear)
                    .cornerRadius(12)
            }

            Button(action: { withAnimation { isIncome = true } }) {
                Text("収入")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(isIncome ? .white : AppTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(isIncome ? Color.green : Color.clear)
                    .cornerRadius(12)
            }
        }
        .padding(4)
        .background(AppTheme.primary.opacity(0.08))
        .cornerRadius(14)
    }

    // MARK: - Amount Display
    private var amountDisplay: some View {
        VStack(spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("¥")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(isIncome ? .green : AppTheme.secondary)

                Text(amount.isEmpty ? "0" : formatAmount(amount))
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(amount.isEmpty ? AppTheme.textSecondary.opacity(0.3) : AppTheme.textPrimary)
                    .animation(.spring(response: 0.3), value: amount)
            }
        }
    }

    // MARK: - Expense Category Grid
    private var expenseCategoryGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(ExpenseCategory.allCases) { category in
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedCategory = category
                    }
                }) {
                    VStack(spacing: 4) {
                        Text(category.emoji)
                            .font(.system(size: 28))

                        Text(category.rawValue)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        selectedCategory == category
                            ? category.color.opacity(0.15)
                            : Color.clear
                    )
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedCategory == category ? category.color : Color.clear,
                                lineWidth: 2
                            )
                    )
                }
            }
        }
    }

    // MARK: - Income Category Grid
    private var incomeCategoryGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(IncomeCategory.allCases) { category in
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedIncomeCategory = category
                    }
                }) {
                    VStack(spacing: 4) {
                        Text(category.emoji)
                            .font(.system(size: 28))

                        Text(category.rawValue)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        selectedIncomeCategory == category
                            ? category.color.opacity(0.15)
                            : Color.clear
                    )
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedIncomeCategory == category ? category.color : Color.clear,
                                lineWidth: 2
                            )
                    )
                }
            }
        }
    }

    // MARK: - Memo Field
    private var memoField: some View {
        HStack {
            Image(systemName: "pencil")
                .foregroundColor(AppTheme.textSecondary)
            TextField("メモ (任意)", text: $memo)
                .font(.system(size: 14))
        }
        .padding(12)
        .background(AppTheme.primary.opacity(0.05))
        .cornerRadius(12)
    }

    // MARK: - Number Pad
    private var numberPad: some View {
        let buttons = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["00", "0", "⌫"]
        ]

        return VStack(spacing: 8) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            handleNumberPad(button)
                        }) {
                            Text(button)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(
                                    button == "⌫" ? AppTheme.secondary : AppTheme.textPrimary
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(AppTheme.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: saveEntry) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                Text("記録する (+25 XP)")
                    .font(.system(size: 17, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                (amount.isEmpty || amount == "0")
                    ? AppTheme.textSecondary.opacity(0.3)
                    : (isIncome ? Color.green : AppTheme.primary)
            )
            .cornerRadius(16)
        }
        .disabled(amount.isEmpty || amount == "0")
    }

    // MARK: - Success Overlay
    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 64))

                Text("記録完了!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)

                HStack(spacing: 4) {
                    Text("+\(earnedXP)")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(AppTheme.accent)
                    Text("XP")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.accent)
                }

                Text("連続\(userStats.streak)日目!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(40)
            .background(AppTheme.cardBackground)
            .cornerRadius(28)
            .shadow(color: AppTheme.primary.opacity(0.2), radius: 20, x: 0, y: 10)
        }
        .transition(.opacity.combined(with: .scale))
    }

    // MARK: - Actions
    private func handleNumberPad(_ button: String) {
        switch button {
        case "⌫":
            if !amount.isEmpty {
                amount.removeLast()
            }
        case "00":
            if !amount.isEmpty && amount != "0" {
                amount += "00"
            }
        default:
            if amount == "0" {
                amount = button
            } else if amount.count < 8 {
                amount += button
            }
        }
    }

    private func saveEntry() {
        guard let amountInt = Int(amount), amountInt > 0 else { return }

        if isIncome {
            let income = Income(amount: amountInt, category: selectedIncomeCategory, memo: memo)
            expenseStore.addIncome(income)
        } else {
            let expense = Expense(amount: amountInt, category: selectedCategory, memo: memo)
            expenseStore.addExpense(expense)
        }

        earnedXP = 25
        userStats.recordEntry()

        withAnimation(.spring(response: 0.5)) {
            showSuccess = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }

    private func formatAmount(_ str: String) -> String {
        guard let number = Int(str) else { return str }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: number)) ?? str
    }
}

#Preview {
    QuickInputView()
        .environmentObject(ExpenseStore())
        .environmentObject(UserStats())
}
