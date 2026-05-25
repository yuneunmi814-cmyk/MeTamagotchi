import Foundation
import SwiftData

@Model
final class Character {
    var id: UUID
    var name: String
    var createdAt: Date
    var hp: Int
    var totalChecks: Int
    var stage: Int
    var isWilted: Bool
    var lastDecayAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = Date(),
        hp: Int = 100,
        totalChecks: Int = 0,
        stage: Int = 0,
        isWilted: Bool = false,
        lastDecayAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.hp = hp
        self.totalChecks = totalChecks
        self.stage = stage
        self.isWilted = isWilted
        self.lastDecayAt = lastDecayAt
    }
}
