import SwiftUI

enum ExpenseCategory: String, CaseIterable, Codable, Identifiable {
    case food = "食費"
    case transport = "交通費"
    case shopping = "買い物"
    case cafe = "カフェ"
    case entertainment = "娯楽"
    case daily = "日用品"
    case health = "医療"
    case education = "学習"
    case subscription = "サブスク"
    case other = "その他"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "tram.fill"
        case .shopping: return "bag.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .entertainment: return "gamecontroller.fill"
        case .daily: return "house.fill"
        case .health: return "cross.case.fill"
        case .education: return "book.fill"
        case .subscription: return "creditcard.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .shopping: return .pink
        case .cafe: return .brown
        case .entertainment: return .purple
        case .daily: return .green
        case .health: return .red
        case .education: return .cyan
        case .subscription: return .indigo
        case .other: return .gray
        }
    }
}

enum IncomeCategory: String, CaseIterable, Codable, Identifiable {
    case salary = "給料"
    case bonus = "ボーナス"
    case sideJob = "副業"
    case other = "その他"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .salary: return "yensign.circle.fill"
        case .bonus: return "star.circle.fill"
        case .sideJob: return "briefcase.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .salary: return .green
        case .bonus: return .yellow
        case .sideJob: return .teal
        case .other: return .gray
        }
    }
}
