import Foundation
import SwiftData

enum CheckInService {
    static let hpGain = 15
    static let maxHP = 100

    /// 오늘자 (habit) 체크인을 시도한다.
    /// 이미 체크된 날이면 false 반환 (HP/카운트 변동 없음).
    @discardableResult
    static func checkIn(
        habit: Habit,
        character: Character,
        context: ModelContext,
        now: Date = Date()
    ) throws -> Bool {
        let dayStart = Calendar.current.startOfDay(for: now)
        let habitId = habit.id

        let descriptor = FetchDescriptor<CheckIn>(
            predicate: #Predicate { ci in
                ci.habitId == habitId && ci.date == dayStart
            }
        )
        let existing = try context.fetch(descriptor)
        guard existing.isEmpty else { return false }

        let checkIn = CheckIn(habitId: habit.id, date: dayStart, checkedAt: now)
        context.insert(checkIn)

        character.totalChecks += 1
        character.hp = min(maxHP, character.hp + hpGain)
        if character.hp > 0 {
            character.isWilted = false
        }
        return true
    }
}
