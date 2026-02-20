import SwiftUI

struct HomeView: View {
    @EnvironmentObject var expenseStore: ExpenseStore
    @EnvironmentObject var userStats: UserStats

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                headerSection
                levelCard
                streakCard
                todaySummaryCard
                monthlyOverviewCard
                categoryBreakdownCard
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("おはよう! 👋")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
                Text("今日も記録しよう")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(AppTheme.primaryGradient)
                    .frame(width: 48, height: 48)

                Text("🐱")
                    .font(.system(size: 24))
            }
        }
    }

    // MARK: - Level Card
    private var levelCard: some View {
        VStack(spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryGradient)
                        .frame(width: 56, height: 56)

                    VStack(spacing: 0) {
                        Text("Lv")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(userStats.level)")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.white)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("家計簿ルーキー")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)

                    HStack(spacing: 8) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(AppTheme.primary.opacity(0.15))
                                    .frame(height: 10)

                                Capsule()
                                    .fill(AppTheme.xpGradient)
                                    .frame(width: geo.size.width * userStats.xpProgress, height: 10)
                            }
                        }
                        .frame(height: 10)

                        Text("\(userStats.xpToNextLevel)XP")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppTheme.accent)
                    }
                }
                .padding(.leading, 8)
            }

            HStack(spacing: 0) {
                StatBubble(value: "\(userStats.totalDaysLogged)", label: "記録日数", emoji: "📅")
                StatBubble(value: "\(userStats.streak)", label: "連続日数", emoji: "🔥")
                StatBubble(value: "\(userStats.achievements.filter { $0.isUnlocked }.count)", label: "実績", emoji: "🏆")
            }
        }
        .padding(20)
        .cardStyle()
    }

    // MARK: - Streak Card
    private var streakCard: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("🔥")
                    .font(.system(size: 36))
                Text("\(userStats.streak)日連続!")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("今週の記録")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)

                HStack(spacing: 6) {
                    ForEach(0..<7, id: \.self) { day in
                        let isCompleted = day < userStats.streak % 7 || userStats.streak >= 7
                        Circle()
                            .fill(isCompleted ? AppTheme.primary : AppTheme.primary.opacity(0.15))
                            .frame(width: 28, height: 28)
                            .overlay(
                                isCompleted ?
                                    Text("✓")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                    : nil
                            )
                    }
                }
            }
        }
        .padding(20)
        .cardStyle()
    }

    // MARK: - Today's Summary
    private var todaySummaryCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("今日の支出")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text(Date().shortDateString)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
            }

            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(AppTheme.primary.opacity(0.12), lineWidth: 8)
                        .frame(width: 90, height: 90)

                    let dailyBudget = userStats.monthlyBudget / 30
                    let progress = min(Double(expenseStore.todayTotal) / Double(dailyBudget), 1.0)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            progress > 0.8 ? AppTheme.expenseGradient : AppTheme.xpGradient,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("予算消化")
                            .font(.system(size: 9))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("使った金額")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                        Text(expenseStore.todayTotal.formattedYen)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppTheme.secondary)
                    }

                    let dailyBudget = userStats.monthlyBudget / 30
                    let remaining = dailyBudget - expenseStore.todayTotal

                    VStack(alignment: .leading, spacing: 2) {
                        Text("残りの予算")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                        Text(remaining.formattedYen)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(remaining >= 0 ? AppTheme.accent : AppTheme.secondary)
                    }
                }

                Spacer()
            }
        }
        .padding(20)
        .cardStyle()
    }

    // MARK: - Monthly Overview
    private var monthlyOverviewCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Date().monthString)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            HStack(spacing: 12) {
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("収入")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    Text(expenseStore.monthlyIncomeTotal.formattedYen)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color.green.opacity(0.08))
                .cornerRadius(16)

                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(AppTheme.secondary)
                            .frame(width: 8, height: 8)
                        Text("支出")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    Text(expenseStore.monthlyExpenseTotal.formattedYen)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(AppTheme.secondary.opacity(0.08))
                .cornerRadius(16)
            }

            HStack {
                Text("収支バランス")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                Spacer()
                let balance = expenseStore.monthlyBalance
                Text((balance >= 0 ? "+" : "") + balance.formattedYen)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(balance >= 0 ? .green : AppTheme.secondary)
            }
            .padding(16)
            .background(AppTheme.background)
            .cornerRadius(12)
        }
        .padding(20)
        .cardStyle()
    }

    // MARK: - Category Breakdown
    private var categoryBreakdownCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("カテゴリ別")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text("今月")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
            }

            let breakdown = expenseStore.categoryBreakdown()
            let maxAmount = breakdown.first?.total ?? 1

            ForEach(breakdown, id: \.category) { item in
                HStack(spacing: 12) {
                    Text(item.category.emoji)
                        .font(.system(size: 24))
                        .frame(width: 36)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.category.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppTheme.textPrimary)
                            Spacer()
                            Text(item.total.formattedYen)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                        }

                        GeometryReader { geo in
                            Capsule()
                                .fill(item.category.color.opacity(0.7))
                                .frame(
                                    width: geo.size.width * CGFloat(item.total) / CGFloat(maxAmount),
                                    height: 6
                                )
                        }
                        .frame(height: 6)
                    }
                }
            }
        }
        .padding(20)
        .cardStyle()
    }
}

// MARK: - Stat Bubble
struct StatBubble: View {
    let value: String
    let label: String
    let emoji: String

    var body: some View {
        VStack(spacing: 4) {
            Text(emoji)
                .font(.system(size: 18))
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
        .environmentObject(ExpenseStore())
        .environmentObject(UserStats())
}
