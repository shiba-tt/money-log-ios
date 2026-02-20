import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showInputSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)

                HistoryView()
                    .tag(1)

                Color.clear
                    .tag(2)

                AchievementsView()
                    .tag(3)
            }

            CustomTabBar(selectedTab: $selectedTab, showInputSheet: $showInputSheet)
        }
        .sheet(isPresented: $showInputSheet) {
            QuickInputView()
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showInputSheet: Bool

    var body: some View {
        HStack {
            TabBarButton(icon: "house.fill", label: "ホーム", isSelected: selectedTab == 0) {
                selectedTab = 0
            }

            TabBarButton(icon: "calendar", label: "履歴", isSelected: selectedTab == 1) {
                selectedTab = 1
            }

            Button(action: {
                showInputSheet = true
            }) {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryGradient)
                        .frame(width: 64, height: 64)
                        .shadow(color: AppTheme.primary.opacity(0.4), radius: 8, x: 0, y: 4)

                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .offset(y: -20)

            TabBarButton(icon: "trophy.fill", label: "実績", isSelected: selectedTab == 3) {
                selectedTab = 3
            }

            TabBarButton(icon: "gearshape.fill", label: "設定", isSelected: selectedTab == 4) {
                selectedTab = 4
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 24)
        .background(
            AppTheme.cardBackground
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppTheme.primary : AppTheme.textSecondary)

                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? AppTheme.primary : AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    MainTabView()
        .environmentObject(ExpenseStore())
        .environmentObject(UserStats())
}
