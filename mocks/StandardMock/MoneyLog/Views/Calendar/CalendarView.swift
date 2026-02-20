import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var store: ExpenseStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()

    private let calendar = Calendar.current
    private let weekdaySymbols = ["日", "月", "火", "水", "木", "金", "土"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    monthNavigation
                    calendarGrid
                    Divider()
                    selectedDayExpenses
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("カレンダー")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Month Navigation

    private var monthNavigation: some View {
        HStack {
            Button {
                moveMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
            }

            Spacer()

            Text(monthYearString)
                .font(.title3.bold())

            Spacer()

            Button {
                moveMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
            }
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Calendar Grid

    private var calendarGrid: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2.bold())
                        .foregroundStyle(
                            symbol == "日" ? .red :
                            symbol == "土" ? .blue :
                            .secondary
                        )
                        .frame(maxWidth: .infinity)
                }
            }

            let days = daysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 4) {
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        dayCell(for: date)
                    } else {
                        Color.clear
                            .frame(height: 52)
                    }
                }
            }
        }
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func dayCell(for date: Date) -> some View {
        let total = store.totalForDate(date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDateInToday(date)

        return Button {
            withAnimation(.spring(response: 0.25)) {
                selectedDate = date
            }
        } label: {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.caption.bold())
                    .foregroundStyle(
                        isSelected ? .white :
                        isToday ? .orange :
                        .primary
                    )

                if total > 0 {
                    Text(shortAmount(total))
                        .font(.system(size: 8, design: .rounded))
                        .foregroundStyle(
                            isSelected ? .white.opacity(0.8) : .secondary
                        )
                        .lineLimit(1)
                } else {
                    Text(" ")
                        .font(.system(size: 8))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                isSelected
                    ? AnyShapeStyle(.orange)
                    : isToday
                        ? AnyShapeStyle(.orange.opacity(0.1))
                        : AnyShapeStyle(.clear)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Selected Day Expenses

    private var selectedDayExpenses: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(selectedDateString)
                    .font(.headline)
                Spacer()
                let total = store.totalForDate(selectedDate)
                if total > 0 {
                    Text("¥\(total.formatted())")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
            }

            let expenses = store.expensesForDate(selectedDate)
            if expenses.isEmpty {
                Text("この日の記録はありません")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(24)
            } else {
                ForEach(expenses) { expense in
                    ExpenseRow(expense: expense)
                }
            }
        }
    }

    // MARK: - Helpers

    private func moveMonth(by value: Int) {
        withAnimation {
            if let newDate = calendar.date(byAdding: .month, value: value, to: currentMonth) {
                currentMonth = newDate
            }
        }
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年 M月"
        return formatter.string(from: currentMonth)
    }

    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日(E)"
        return formatter.string(from: selectedDate)
    }

    private func shortAmount(_ amount: Int) -> String {
        if amount >= 10000 {
            return "\(amount / 10000).\(amount % 10000 / 1000)万"
        }
        return "¥\(amount)"
    }

    private func daysInMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))
        else { return [] }

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
    CalendarView()
        .environmentObject(ExpenseStore())
}
