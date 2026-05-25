import SwiftUI
import SwiftData

struct HabitSetupView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var characterName: String = ""
    @State private var habitInputs: [HabitInput] = [
        HabitInput(emoji: "💪", title: ""),
        HabitInput(emoji: "📖", title: ""),
        HabitInput(emoji: "🧘", title: ""),
    ]

    var body: some View {
        Form {
            Section("캐릭터") {
                TextField("이름", text: $characterName)
                    .textInputAutocapitalization(.never)
            }

            Section("오늘의 습관 3개") {
                ForEach($habitInputs) { $input in
                    HStack(spacing: 12) {
                        TextField("🌱", text: $input.emoji)
                            .multilineTextAlignment(.center)
                            .frame(width: 44)
                        TextField("예: 운동 30분", text: $input.title)
                    }
                }
            }

            Section {
                Button(action: start) {
                    Text("시작하기")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!canStart)
            }
        }
        .navigationTitle("시작하기")
    }

    private var canStart: Bool {
        guard !characterName.trimmed.isEmpty else { return false }
        return habitInputs.allSatisfy { input in
            !input.emoji.trimmed.isEmpty && !input.title.trimmed.isEmpty
        }
    }

    private func start() {
        let character = Character(name: characterName.trimmed)
        modelContext.insert(character)

        for (index, input) in habitInputs.enumerated() {
            let firstGrapheme = String(input.emoji.trimmed.prefix(1))
            let habit = Habit(
                title: input.title.trimmed,
                emoji: firstGrapheme,
                order: index
            )
            modelContext.insert(habit)
        }
    }

    private struct HabitInput: Identifiable {
        let id = UUID()
        var emoji: String
        var title: String
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}

#Preview {
    NavigationStack {
        HabitSetupView()
    }
    .modelContainer(
        for: [Character.self, Habit.self, CheckIn.self, EvolutionLog.self],
        inMemory: true
    )
}
