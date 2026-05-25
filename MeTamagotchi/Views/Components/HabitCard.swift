import SwiftUI

struct HabitCard: View {
    let habit: Habit
    let isChecked: Bool
    let onCheck: () -> Void

    var body: some View {
        Button(action: onCheck) {
            HStack(spacing: 12) {
                Text(habit.emoji)
                    .font(.title2)
                Text(habit.title)
                    .font(.body)
                    .foregroundStyle(isChecked ? .secondary : .primary)
                Spacer()
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isChecked ? Color.green : Color.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isChecked)
        .accessibilityLabel("\(habit.title)\(isChecked ? ", 완료" : "")")
    }
}

#Preview {
    VStack(spacing: 12) {
        HabitCard(
            habit: Habit(title: "운동 30분", emoji: "💪", order: 0),
            isChecked: false,
            onCheck: {}
        )
        HabitCard(
            habit: Habit(title: "성경 읽기", emoji: "📖", order: 1),
            isChecked: true,
            onCheck: {}
        )
    }
    .padding()
}
