import SwiftUI

struct CategoryButton: View {
    let category: ExpenseCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : category.color)
                    .frame(width: 44, height: 44)
                    .background(
                        isSelected
                            ? AnyShapeStyle(category.color.gradient)
                            : AnyShapeStyle(category.color.opacity(0.12))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(category.rawValue)
                    .font(.system(size: 10))
                    .foregroundStyle(isSelected ? category.color : .secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.25), value: isSelected)
    }
}

#Preview {
    HStack {
        CategoryButton(category: .food, isSelected: true) {}
        CategoryButton(category: .transport, isSelected: false) {}
        CategoryButton(category: .cafe, isSelected: false) {}
    }
    .padding()
}
