import SwiftUI

struct QuickInputView: View {
    @EnvironmentObject var store: ExpenseStore
    @Environment(\.dismiss) private var dismiss

    @State private var amountText = ""
    @State private var selectedCategory: ExpenseCategory = .food
    @State private var memo = ""
    @State private var showSavedFeedback = false

    private let quickAmounts = [100, 300, 500, 1000, 3000, 5000]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                amountDisplay
                    .padding(.top, 8)

                quickAmountButtons
                    .padding(.vertical, 12)

                Divider()

                ScrollView {
                    VStack(spacing: 16) {
                        categoryGrid
                            .padding(.top, 16)
                        memoField
                    }
                    .padding(.horizontal)
                }

                Divider()

                numberPad
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("支出を記録")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveExpense()
                    }
                    .bold()
                    .disabled(currentAmount == 0)
                }
            }
            .overlay {
                if showSavedFeedback {
                    savedFeedbackOverlay
                }
            }
        }
    }

    // MARK: - Amount Display

    private var amountDisplay: some View {
        VStack(spacing: 4) {
            Text("¥\(amountText.isEmpty ? "0" : amountText)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(amountText.isEmpty ? .secondary : .primary)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.2), value: amountText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    // MARK: - Quick Amount Buttons

    private var quickAmountButtons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(quickAmounts, id: \.self) { amount in
                    Button {
                        amountText = "\(amount)"
                    } label: {
                        Text("¥\(amount)")
                            .font(.caption.bold())
                            .foregroundStyle(
                                currentAmount == amount ? .white : .orange
                            )
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                currentAmount == amount
                                    ? AnyShapeStyle(.orange)
                                    : AnyShapeStyle(.orange.opacity(0.12))
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Category Grid

    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("カテゴリ")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5),
                spacing: 12
            ) {
                ForEach(ExpenseCategory.allCases) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.25)) {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
    }

    // MARK: - Memo Field

    private var memoField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("メモ（任意）")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("何に使った？", text: $memo)
                .textFieldStyle(.roundedBorder)
                .font(.body)
        }
    }

    // MARK: - Number Pad

    private var numberPad: some View {
        let buttons: [[NumPadButton]] = [
            [.digit("1"), .digit("2"), .digit("3")],
            [.digit("4"), .digit("5"), .digit("6")],
            [.digit("7"), .digit("8"), .digit("9")],
            [.doubleZero, .digit("0"), .delete],
        ]

        return VStack(spacing: 6) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { button in
                        NumPadKey(button: button) {
                            handleNumPadInput(button)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Saved Feedback

    private var savedFeedbackOverlay: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)

            Text("記録しました！")
                .font(.headline)
        }
        .padding(32)
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Logic

    private var currentAmount: Int {
        Int(amountText) ?? 0
    }

    private func handleNumPadInput(_ button: NumPadButton) {
        switch button {
        case .digit(let d):
            guard amountText.count < 8 else { return }
            if amountText == "0" {
                amountText = d
            } else {
                amountText += d
            }
        case .doubleZero:
            guard amountText.count < 7, !amountText.isEmpty else { return }
            amountText += "00"
        case .delete:
            if !amountText.isEmpty {
                amountText.removeLast()
            }
        }
    }

    private func saveExpense() {
        guard currentAmount > 0 else { return }

        let expense = Expense(
            amount: currentAmount,
            category: selectedCategory,
            memo: memo
        )
        store.addExpense(expense)

        withAnimation(.spring(response: 0.3)) {
            showSavedFeedback = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            dismiss()
        }
    }
}

// MARK: - NumPad Types

enum NumPadButton: Hashable {
    case digit(String)
    case doubleZero
    case delete

    var label: String {
        switch self {
        case .digit(let d): return d
        case .doubleZero: return "00"
        case .delete: return "⌫"
        }
    }
}

struct NumPadKey: View {
    let button: NumPadButton
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if case .delete = button {
                    Image(systemName: "delete.left")
                        .font(.title3)
                } else {
                    Text(button.label)
                        .font(.title2.bold().monospacedDigit())
                }
            }
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuickInputView()
        .environmentObject(ExpenseStore())
}
