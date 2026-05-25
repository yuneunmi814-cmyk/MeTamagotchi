import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var characters: [Character]
    @Query(sort: \Habit.order) private var habits: [Habit]
    @Query private var checkIns: [CheckIn]

    var body: some View {
        Group {
            if let character = characters.first {
                content(character: character)
            } else {
                ProgressView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink {
                    CollectionView()
                } label: {
                    Image(systemName: "book")
                }
                .accessibilityLabel("도감")
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel("설정")
            }
        }
    }

    @ViewBuilder
    private func content(character: Character) -> some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(character.name)
                    .font(.title2.bold())
                HPBar(hp: character.hp)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            CharacterImage(stage: character.stage, isWilted: character.isWilted)
                .frame(width: 160, height: 160)
                .transition(.opacity)
                .id(character.stage)

            Spacer()

            VStack(spacing: 12) {
                ForEach(habits) { habit in
                    HabitCard(
                        habit: habit,
                        isChecked: todayCheckedIds.contains(habit.id)
                    ) {
                        check(habit: habit, character: character)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("나의 다마고찌")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            do {
                try DecayService.applyDecayIfNeeded(character: character, context: modelContext)
            } catch {
                print("Decay failed: \(error)")
            }
        }
    }

    private var todayCheckedIds: Set<UUID> {
        let dayStart = Calendar.current.startOfDay(for: Date())
        return Set(checkIns.lazy.filter { $0.date == dayStart }.map(\.habitId))
    }

    private func check(habit: Habit, character: Character) {
        withAnimation(.easeInOut(duration: 0.4)) {
            do {
                let ok = try CheckInService.checkIn(
                    habit: habit, character: character, context: modelContext
                )
                if ok {
                    EvolutionService.checkEvolution(character: character, context: modelContext)
                }
            } catch {
                print("CheckIn failed: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
    .modelContainer(
        for: [Character.self, Habit.self, CheckIn.self, EvolutionLog.self],
        inMemory: true
    )
}
