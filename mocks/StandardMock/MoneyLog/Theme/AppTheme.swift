import SwiftUI

struct AppTheme {
    // MARK: - Main Colors
    static let primary = Color.orange
    static let secondary = Color(.systemGray)
    static let accent = Color.green
    static let background = Color(.systemGroupedBackground)
    static let cardBackground = Color(.systemBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
}

// MARK: - Formatters

extension Int {
    var formattedYen: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let formatted = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "¥\(formatted)"
    }
}

extension Date {
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M/d(E)"
        return formatter.string(from: self)
    }

    var monthString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: self)
    }
}
