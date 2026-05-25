import XCTest
import SwiftData
@testable import MeTamagotchi

@MainActor
final class MeTamagotchiTests: XCTestCase {

    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUpWithError() throws {
        let schema = Schema([
            Character.self, Habit.self, CheckIn.self, EvolutionLog.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [config])
        context = container.mainContext
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
    }

    // MARK: - 체크인 중복

    func test_checkIn_sameDayDuplicate_isRejected() throws {
        let character = Character(name: "테스트", hp: 50)
        let habit = Habit(title: "운동", emoji: "💪", order: 0)
        context.insert(character)
        context.insert(habit)

        let now = makeDate(year: 2026, month: 1, day: 10, hour: 9)

        let first = try CheckInService.checkIn(habit: habit, character: character, context: context, now: now)
        XCTAssertTrue(first)
        XCTAssertEqual(character.hp, 65)
        XCTAssertEqual(character.totalChecks, 1)

        let laterSameDay = makeDate(year: 2026, month: 1, day: 10, hour: 22)
        let second = try CheckInService.checkIn(habit: habit, character: character, context: context, now: laterSameDay)
        XCTAssertFalse(second)
        XCTAssertEqual(character.hp, 65, "중복 체크는 HP를 더 올리면 안 된다")
        XCTAssertEqual(character.totalChecks, 1)

        let nextDay = makeDate(year: 2026, month: 1, day: 11, hour: 9)
        let third = try CheckInService.checkIn(habit: habit, character: character, context: context, now: nextDay)
        XCTAssertTrue(third)
        XCTAssertEqual(character.hp, 80)
        XCTAssertEqual(character.totalChecks, 2)
    }

    // MARK: - 다일 감쇠

    func test_applyDecay_skipsMultipleDays_zerosHPAndWilts() throws {
        let createdAt = makeDate(year: 2026, month: 1, day: 1, hour: 0, minute: 1)
        let character = Character(
            name: "테스트", createdAt: createdAt, hp: 100, lastDecayAt: createdAt
        )
        context.insert(character)

        // 1/1 ~ 1/3 동안 체크 0개. 1/4 오전에 앱 진입.
        let openedAt = makeDate(year: 2026, month: 1, day: 4, hour: 9)
        try DecayService.applyDecayIfNeeded(character: character, context: context, now: openedAt)

        // 3일치 × 3미체크 × 20 = -180. 100 → max(0, -80) = 0.
        XCTAssertEqual(character.hp, 0)
        XCTAssertTrue(character.isWilted)
        XCTAssertEqual(character.lastDecayAt, openedAt)
    }

    // MARK: - 진화 트리거

    func test_checkEvolution_steppedAndMultiJump() {
        let character = Character(name: "테스트")
        context.insert(character)

        // 5개: 진화 안 됨
        character.totalChecks = 5
        var logs = EvolutionService.checkEvolution(character: character, context: context)
        XCTAssertEqual(character.stage, 0)
        XCTAssertEqual(logs.count, 0)

        // 6개: 1단계
        character.totalChecks = 6
        logs = EvolutionService.checkEvolution(character: character, context: context)
        XCTAssertEqual(character.stage, 1)
        XCTAssertEqual(logs.count, 1)
        XCTAssertEqual(logs.first?.fromStage, 0)
        XCTAssertEqual(logs.first?.toStage, 1)

        // 90개: 1 → 2 → 3 → 4 (3단계 점프, 로그 3건)
        character.totalChecks = 90
        logs = EvolutionService.checkEvolution(character: character, context: context)
        XCTAssertEqual(character.stage, 4)
        XCTAssertEqual(logs.count, 3)
        XCTAssertEqual(logs.map(\.toStage), [2, 3, 4])

        // 어덜트 이후로는 추가 진화 없음
        character.totalChecks = 1000
        logs = EvolutionService.checkEvolution(character: character, context: context)
        XCTAssertEqual(character.stage, 4)
        XCTAssertEqual(logs.count, 0)
    }

    // MARK: - helpers

    private func makeDate(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }
}
