import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var title: String
    var emoji: String
    var order: Int
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        emoji: String,
        order: Int,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.order = order
        self.createdAt = createdAt
    }
}
