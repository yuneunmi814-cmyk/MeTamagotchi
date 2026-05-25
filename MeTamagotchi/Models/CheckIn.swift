import Foundation
import SwiftData

@Model
final class CheckIn {
    var id: UUID
    var habitId: UUID
    var date: Date
    var checkedAt: Date

    init(
        id: UUID = UUID(),
        habitId: UUID,
        date: Date,
        checkedAt: Date = Date()
    ) {
        self.id = id
        self.habitId = habitId
        self.date = date
        self.checkedAt = checkedAt
    }
}
