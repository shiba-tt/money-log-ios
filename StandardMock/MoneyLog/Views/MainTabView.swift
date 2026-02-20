import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var store: ExpenseStore
    @State private var showingInput = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(showingInput: $showingInput)
                    .tabItem {
                        Label("ホーム", systemImage: "house.fill")
                    }
                    .tag(0)

                CalendarView()
                    .tabItem {
                        Label("カレンダー", systemImage: "calendar")
                    }
                    .tag(1)

                SettingsView()
                    .tabItem {
                        Label("設定", systemImage: "gearshape.fill")
                    }
                    .tag(2)
            }
            .tint(.orange)

            // Floating add button
            Button {
                showingInput = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(
                        LinearGradient(
                            colors: [.orange, .red.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: .orange.opacity(0.4), radius: 8, y: 4)
            }
            .offset(y: -24)
        }
        .sheet(isPresented: $showingInput) {
            QuickInputView()
                .environmentObject(store)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(ExpenseStore())
}
