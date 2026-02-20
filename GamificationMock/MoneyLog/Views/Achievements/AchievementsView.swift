import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var userStats: UserStats

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Text("実績")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                progressSummary
                achievementGrid
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }

    // MARK: - Progress Summary
    private var progressSummary: some View {
        let unlocked = userStats.achievements.filter { $0.isUnlocked }.count
        let total = userStats.achievements.count
        let progress = Double(unlocked) / Double(total)

        return VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("コンプリート率")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(unlocked)")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(AppTheme.primary)
                        Text("/ \(total)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(AppTheme.primary.opacity(0.12), lineWidth: 8)
                        .frame(width: 72, height: 72)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(AppTheme.primaryGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.primary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppTheme.primary.opacity(0.12))
                        .frame(height: 8)

                    Capsule()
                        .fill(AppTheme.primaryGradient)
                        .frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(20)
        .cardStyle()
    }

    // MARK: - Achievement Grid
    private var achievementGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(userStats.achievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
    }
}

// MARK: - Achievement Card
struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked
                            ? AppTheme.primaryGradient
                            : LinearGradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 64, height: 64)

                if achievement.isUnlocked {
                    Text(achievement.emoji)
                        .font(.system(size: 32))
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray.opacity(0.5))
                }
            }

            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(
                        achievement.isUnlocked ? AppTheme.textPrimary : AppTheme.textSecondary
                    )
                    .multilineTextAlignment(.center)

                Text(achievement.description)
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }

            if achievement.isUnlocked {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                    Text("達成!")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(AppTheme.accent)
            } else {
                Text("未達成")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary.opacity(0.6))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            achievement.isUnlocked
                ? AppTheme.cardBackground
                : AppTheme.cardBackground.opacity(0.6)
        )
        .cornerRadius(20)
        .shadow(
            color: achievement.isUnlocked ? AppTheme.primary.opacity(0.1) : Color.clear,
            radius: 8, x: 0, y: 4
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    achievement.isUnlocked ? AppTheme.primary.opacity(0.15) : Color.gray.opacity(0.1),
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    AchievementsView()
        .environmentObject(UserStats())
}
