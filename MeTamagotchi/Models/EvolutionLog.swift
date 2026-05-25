import Foundation
import SwiftData

@Model
final class EvolutionLog {
    var id: UUID
    var characterId: UUID
    var fromStage: Int
    var toStage: Int
    var evolvedAt: Date

    init(
        id: UUID = UUID(),
        characterId: UUID,
        fromStage: Int,
        toStage: Int,
        evolvedAt: Date = Date()
    ) {
        self.id = id
        self.characterId = characterId
        self.fromStage = fromStage
        self.toStage = toStage
        self.evolvedAt = evolvedAt
    }
}
