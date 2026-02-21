import Foundation
import Combine

class UserStats: ObservableObject {
    @Published var currentXP: Int = 340
    @Published var level: Int = 5
    @Published var streak: Int = 7
    @Published var totalDaysLogged: Int = 23
    @Published var monthlyBudget: Int = 80000
    @Published var achievements: [Achievement] = Achievement.allAchievements

    var xpForCurrentLevel: Int { level * 100 }
    var xpProgress: Double { Double(currentXP % xpForCurrentLevel) / Double(xpForCurrentLevel) }

    var xpToNextLevel: Int {
        xpForCurrentLevel - (currentXP % xpForCurrentLevel)
    }

    func addXP(_ amount: Int) {
        currentXP += amount
        while currentXP >= level * 100 {
            currentXP -= level * 100
            level += 1
        }
    }

    func recordEntry() {
        streak += 1
        totalDaysLogged += 1
        addXP(25)

        if streak >= 3 {
            unlockAchievement("streak_3")
        }
        if streak >= 7 {
            unlockAchievement("streak_7")
        }
        if streak >= 30 {
            unlockAchievement("streak_30")
        }
    }

    func unlockAchievement(_ id: String) {
        if let index = achievements.firstIndex(where: { $0.id == id }) {
            achievements[index].isUnlocked = true
        }
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let emoji: String
    let requiredValue: Int
    var isUnlocked: Bool

    static let allAchievements: [Achievement] = [
        Achievement(id: "first_log", title: "はじめの一歩", description: "初めての記録をつけた", emoji: "👣", requiredValue: 1, isUnlocked: true),
        Achievement(id: "streak_3", title: "3日坊主卒業", description: "3日連続で記録をつけた", emoji: "🔥", requiredValue: 3, isUnlocked: true),
        Achievement(id: "streak_7", title: "一週間マスター", description: "7日連続で記録をつけた", emoji: "⭐", requiredValue: 7, isUnlocked: true),
        Achievement(id: "streak_30", title: "継続の達人", description: "30日連続で記録をつけた", emoji: "👑", requiredValue: 30, isUnlocked: false),
        Achievement(id: "level_5", title: "レベル5到達", description: "レベル5に到達した", emoji: "🎯", requiredValue: 5, isUnlocked: true),
        Achievement(id: "level_10", title: "レベル10到達", description: "レベル10に到達した", emoji: "🏆", requiredValue: 10, isUnlocked: false),
        Achievement(id: "budget_keep", title: "やりくり上手", description: "1ヶ月予算内に収めた", emoji: "💪", requiredValue: 1, isUnlocked: false),
        Achievement(id: "log_50", title: "記録の鬼", description: "50件の記録を達成", emoji: "📝", requiredValue: 50, isUnlocked: false),
        Achievement(id: "all_categories", title: "カテゴリマスター", description: "全カテゴリを使った", emoji: "🌈", requiredValue: 9, isUnlocked: false),
        Achievement(id: "saving_goal", title: "貯金の星", description: "月の収支がプラスだった", emoji: "🌟", requiredValue: 1, isUnlocked: true),
    ]
}
