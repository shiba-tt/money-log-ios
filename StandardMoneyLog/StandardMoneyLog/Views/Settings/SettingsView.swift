import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: ExpenseStore
    @State private var budgetText = ""
    @State private var showingBudgetAlert = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Label("月の予算", systemImage: "yensign.circle")
                        Spacer()
                        Text("¥\(store.monthlyBudget.formatted())")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        budgetText = "\(store.monthlyBudget)"
                        showingBudgetAlert = true
                    }
                } header: {
                    Text("予算設定")
                }

                Section {
                    HStack {
                        Label("今月の支出", systemImage: "chart.bar")
                        Spacer()
                        Text("¥\(store.thisMonthTotal.formatted())")
                            .foregroundStyle(.orange)
                    }

                    HStack {
                        Label("記録数", systemImage: "list.bullet")
                        Spacer()
                        Text("\(store.expenses.count)件")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("今月のデータ")
                }

                Section {
                    ForEach(categoryBreakdown, id: \.category) { item in
                        HStack {
                            Image(systemName: item.category.icon)
                                .foregroundStyle(item.category.color)
                                .frame(width: 24)
                            Text(item.category.rawValue)
                            Spacer()
                            Text("¥\(item.total.formatted())")
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                } header: {
                    Text("カテゴリ別支出（今月）")
                }

                Section {
                    HStack {
                        Label("バージョン", systemImage: "info.circle")
                        Spacer()
                        Text("0.1.0 (モック)")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("アプリについて")
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.large)
            .alert("月の予算を設定", isPresented: $showingBudgetAlert) {
                TextField("金額", text: $budgetText)
                    .keyboardType(.numberPad)
                Button("保存") {
                    if let budget = Int(budgetText), budget > 0 {
                        store.monthlyBudget = budget
                    }
                }
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text("月の予算額を入力してください")
            }
        }
    }

    private var categoryBreakdown: [(category: ExpenseCategory, total: Int)] {
        var result: [(category: ExpenseCategory, total: Int)] = []
        for category in ExpenseCategory.allCases {
            let total = store.thisMonthExpenses
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.amount }
            if total > 0 {
                result.append((category: category, total: total))
            }
        }
        return result.sorted { $0.total > $1.total }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ExpenseStore())
}
