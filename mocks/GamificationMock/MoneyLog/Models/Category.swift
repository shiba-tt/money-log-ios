import SwiftUI

enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case food = "食費"
    case transport = "交通費"
    case entertainment = "娯楽"
    case shopping = "買い物"
    case cafe = "カフェ"
    case subscription = "サブスク"
    case health = "健康"
    case education = "学び"
    case other = "その他"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .food: return "🍙"
        case .transport: return "🚃"
        case .entertainment: return "🎮"
        case .shopping: return "🛍️"
        case .cafe: return "☕"
        case .subscription: return "📱"
        case .health: return "💊"
        case .education: return "📚"
        case .other: return "💰"
        }
    }

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "tram.fill"
        case .entertainment: return "gamecontroller.fill"
        case .shopping: return "bag.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .subscription: return "creditcard.fill"
        case .health: return "cross.case.fill"
        case .education: return "book.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .entertainment: return .purple
        case .shopping: return .pink
        case .cafe: return Color(red: 0.6, green: 0.4, blue: 0.2)
        case .subscription: return .cyan
        case .health: return .green
        case .education: return .indigo
        case .other: return .gray
        }
    }
}

enum IncomeCategory: String, CaseIterable, Identifiable, Codable {
    case salary = "給料"
    case partTime = "バイト"
    case bonus = "ボーナス"
    case gift = "お小遣い"
    case other = "その他"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .salary: return "💼"
        case .partTime: return "🏪"
        case .bonus: return "🎉"
        case .gift: return "🎁"
        case .other: return "💵"
        }
    }

    var icon: String {
        switch self {
        case .salary: return "yensign.circle.fill"
        case .partTime: return "briefcase.fill"
        case .bonus: return "star.circle.fill"
        case .gift: return "gift.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .salary: return .green
        case .partTime: return .mint
        case .bonus: return .yellow
        case .gift: return .pink
        case .other: return .gray
        }
    }
}
