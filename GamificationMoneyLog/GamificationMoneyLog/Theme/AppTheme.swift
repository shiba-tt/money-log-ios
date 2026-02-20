import SwiftUI

struct AppTheme {
    // MARK: - Main Colors
    static let primary = Color(red: 0.384, green: 0.298, blue: 0.976)
    static let secondary = Color(red: 0.976, green: 0.384, blue: 0.498)
    static let accent = Color(red: 0.298, green: 0.878, blue: 0.706)
    static let warning = Color(red: 1.0, green: 0.757, blue: 0.027)
    static let background = Color(red: 0.96, green: 0.95, blue: 1.0)
    static let cardBackground = Color.white
    static let textPrimary = Color(red: 0.15, green: 0.12, blue: 0.25)
    static let textSecondary = Color(red: 0.5, green: 0.47, blue: 0.6)

    // MARK: - Gradient
    static let primaryGradient = LinearGradient(
        colors: [primary, Color(red: 0.55, green: 0.35, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let xpGradient = LinearGradient(
        colors: [accent, Color(red: 0.2, green: 0.75, blue: 0.95)],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let incomeGradient = LinearGradient(
        colors: [Color.green, accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let expenseGradient = LinearGradient(
        colors: [secondary, Color(red: 1.0, green: 0.5, blue: 0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Card Style
    static func cardStyle() -> some ViewModifier {
        CardModifier()
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardBackground)
            .cornerRadius(20)
            .shadow(color: AppTheme.primary.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
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
