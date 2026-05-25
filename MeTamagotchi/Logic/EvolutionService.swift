import Foundation
import SwiftData

enum EvolutionService {
    /// 인덱스 = stage. thresholds[stage] = 그 stage에 도달하기 위한 최소 totalChecks.
    static let thresholds: [Int] = [0, 6, 21, 42, 90]
    static let maxStage = 4

    /// totalChecks가 임계값을 넘었으면 단계별로 진화시키고 각 단계에 대해 EvolutionLog를 남긴다.
    /// (한 번에 여러 단계를 뛸 수 있음 — 도감용 로그는 단계마다 1건씩 기록.)
    @discardableResult
    static func checkEvolution(
        character: Character,
        context: ModelContext,
        now: Date = Date()
    ) -> [EvolutionLog] {
        var logs: [EvolutionLog] = []
        while character.stage < maxStage {
            let nextStage = character.stage + 1
            guard character.totalChecks >= thresholds[nextStage] else { break }

            let log = EvolutionLog(
                characterId: character.id,
                fromStage: character.stage,
                toStage: nextStage,
                evolvedAt: now
            )
            context.insert(log)
            logs.append(log)
            character.stage = nextStage
        }
        return logs
    }
}
