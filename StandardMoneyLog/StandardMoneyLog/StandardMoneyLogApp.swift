import SwiftUI

@main
struct StandardMoneyLogApp: App {
    @StateObject private var store = ExpenseStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(store)
        }
    }
}
