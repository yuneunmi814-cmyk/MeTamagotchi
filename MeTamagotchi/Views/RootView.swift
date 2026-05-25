import SwiftUI
import SwiftData

struct RootView: View {
    @Query private var characters: [Character]

    var body: some View {
        NavigationStack {
            if characters.isEmpty {
                HabitSetupView()
            } else {
                MainView()
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(
            for: [Character.self, Habit.self, CheckIn.self, EvolutionLog.self],
            inMemory: true
        )
}
