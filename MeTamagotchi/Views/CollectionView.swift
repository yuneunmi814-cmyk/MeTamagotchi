import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query private var characters: [Character]
    @Query(sort: \EvolutionLog.evolvedAt) private var logs: [EvolutionLog]

    private static let stageNames = ["알", "베이비", "차일드", "틴", "어덜트"]

    var body: some View {
        List {
            ForEach(0..<5, id: \.self) { stage in
                row(stage: stage)
            }
        }
        .navigationTitle("도감")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func row(stage: Int) -> some View {
        let unlocked = isUnlocked(stage: stage)
        HStack(spacing: 16) {
            CharacterImage(stage: stage, isWilted: false)
                .frame(width: 48, height: 48)
                .opacity(unlocked ? 1.0 : 0.15)

            VStack(alignment: .leading, spacing: 4) {
                Text(Self.stageNames[stage])
                    .font(.headline)
                    .foregroundStyle(unlocked ? .primary : .secondary)
                if let date = unlockDate(stage: stage) {
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("미달성")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }

    private func isUnlocked(stage: Int) -> Bool {
        if stage == 0 { return characters.first != nil }
        return logs.contains { $0.toStage == stage }
    }

    private func unlockDate(stage: Int) -> Date? {
        if stage == 0 { return characters.first?.createdAt }
        return logs.first(where: { $0.toStage == stage })?.evolvedAt
    }
}

#Preview {
    NavigationStack {
        CollectionView()
    }
    .modelContainer(
        for: [Character.self, Habit.self, CheckIn.self, EvolutionLog.self],
        inMemory: true
    )
}
