import SwiftUI

@main
struct GamificationMoneyLogApp: App {
    @StateObject private var expenseStore = ExpenseStore()
    @StateObject private var userStats = UserStats()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(expenseStore)
                .environmentObject(userStats)
        }
    }
}
