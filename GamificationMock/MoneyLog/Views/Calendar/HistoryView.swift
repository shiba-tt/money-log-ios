import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var expenseStore: ExpenseStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()

    private let calendar = Calendar.current
    private let daysOfWeek = ["日", "月", "火", "水", "木", "金", "土"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("履歴")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                calendarCard
                dayDetailCard
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }

    // MARK: - Calendar Card
    private var calendarCard: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.primary)
                }

                Spacer()

                Text(currentMonth.monthString)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)

                Spacer()

                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.primary)
                }
            }

            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(
                            day == "日" ? .red.opacity(0.7) :
                            day == "土" ? .blue.opacity(0.7) :
                            AppTheme.textSecondary
                        )
                        .frame(maxWidth: .infinity)
                }
            }

            let days = generateDays()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 4) {
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        calendarDayCell(date: date)
                    } else {
                        Text("")
                            .frame(height: 44)
                    }
                }
            }
        }
        .padding(20)
        .cardStyle()
    }

    // MARK: - Calendar Day Cell
    private func calendarDayCell(date: Date) -> some View {
        let dayExpenses = expenseStore.expensesForDate(date)
        let total = dayExpenses.reduce(0) { $0 + $1.amount }
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDateInToday(date)

        return Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedDate = date
            }
        }) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 14, weight: isToday ? .bold : .regular))
                    .foregroundColor(
                        isSelected ? .white :
                        isToday ? AppTheme.primary :
                        AppTheme.textPrimary
                    )

                if total > 0 {
                    let intensity = min(Double(total) / 3000.0, 1.0)
                    Circle()
                        .fill(
                            isSelected ? Color.white.opacity(0.7) :
                            AppTheme.secondary.opacity(0.3 + intensity * 0.7)
                        )
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                isSelected ?
                    AppTheme.primary.cornerRadius(10) :
                    nil
            )
        }
    }

    // MARK: - Day Detail Card
    private var dayDetailCard: some View {
        let dayExpenses = expenseStore.expensesForDate(selectedDate)
        let dayTotal = dayExpenses.reduce(0) { $0 + $1.amount }

        return VStack(spacing: 16) {
            HStack {
                Text(selectedDate.shortDateString)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                if dayTotal > 0 {
                    Text(dayTotal.formattedYen)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.secondary)
                }
            }

            if dayExpenses.isEmpty {
                VStack(spacing: 8) {
                    Text("📭")
                        .font(.system(size: 40))
                    Text("この日の記録はありません")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding(.vertical, 20)
            } else {
                ForEach(dayExpenses) { expense in
                    HStack(spacing: 12) {
                        Text(expense.category.emoji)
                            .font(.system(size: 28))
                            .frame(width: 44, height: 44)
                            .background(expense.category.color.opacity(0.12))
                            .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(expense.category.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.textPrimary)
                            if !expense.memo.isEmpty {
                                Text(expense.memo)
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }

                        Spacer()

                        Text(expense.amount.formattedYen)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    .padding(.vertical, 4)

                    if expense.id != dayExpenses.last?.id {
                        Divider()
                            .foregroundColor(AppTheme.primary.opacity(0.08))
                    }
                }
            }
        }
        .padding(20)
        .cardStyle()
    }

    // MARK: - Helpers
    private func changeMonth(_ value: Int) {
        withAnimation {
            currentMonth = calendar.date(byAdding: .month, value: value, to: currentMonth)!
        }
    }

    private func generateDays() -> [Date?] {
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1

        var days: [Date?] = Array(repeating: nil, count: firstWeekday)

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }

        while days.count % 7 != 0 {
            days.append(nil)
        }

        return days
    }
}

#Preview {
    HistoryView()
        .environmentObject(ExpenseStore())
        .environmentObject(UserStats())
}
