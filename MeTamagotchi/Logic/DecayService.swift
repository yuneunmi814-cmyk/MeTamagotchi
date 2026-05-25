import Foundation
import SwiftData

enum DecayService {
    static let habitsPerDay = 3
    static let hpLossPerMiss = 20

    /// lastDecayAt 이후 자정을 넘긴 각 날짜에 대해 미체크당 HP를 깎는다.
    /// 처리 후 lastDecayAt = now.
    static func applyDecayIfNeeded(
        character: Character,
        context: ModelContext,
        now: Date = Date()
    ) throws {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: now)
        let lastDecayDay = calendar.startOfDay(for: character.lastDecayAt)

        guard lastDecayDay < todayStart else {
            character.lastDecayAt = now
            return
        }

        var day = lastDecayDay
        while day < todayStart {
            let dayStart = day
            let descriptor = FetchDescriptor<CheckIn>(
                predicate: #Predicate { ci in
                    ci.date == dayStart
                }
            )
            let checkedCount = try context.fetchCount(descriptor)
            let missed = max(0, habitsPerDay - checkedCount)
            character.hp = max(0, character.hp - missed * hpLossPerMiss)
            day = calendar.date(byAdding: .day, value: 1, to: day) ?? todayStart
        }

        if character.hp == 0 {
            character.isWilted = true
        }
        character.lastDecayAt = now
    }
}
