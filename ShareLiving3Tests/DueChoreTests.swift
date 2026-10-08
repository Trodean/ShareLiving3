//
//  DueChoreTests.swift
//  ShareLiving3
//
//  Created by Yang Peng on 9/10/2026.
//

import XCTest
@testable import ShareLiving3

final class DueChoresUseCaseTests: XCTestCase {

    private var yang: Housemate!
    private var jason: Housemate!
    private var damian: Housemate!
    private var luna: Housemate!
    private var crystal: Housemate!
    private var phoebe: Housemate!

    override func setUp(){
        super.setUp()

        yang = Housemate(
            id: UUID(),
            name: "Yang"
        )

        jason = Housemate(
            id: UUID(),
            name: "Jason"
        )

        damian = Housemate(
            id: UUID(),
            name: "Damian"
        )

        luna = Housemate(
            id: UUID(),
            name: "Luna"
        )

        crystal = Housemate(
            id: UUID(),
            name: "Crystal"
        )

        phoebe = Housemate(
            id: UUID(),
            name: "Phoebe"
        )
    }

    func testDueChoresReturnsIncompleteChoreDueToday() throws {

        let repository = InMemoryChoreRepo()

        let useCase = DueChoresUseCase(
            repository: repository
        )

        let today = try XCTUnwrap(
            Calendar.current.date(
                from: DateComponents(
                    year: 2026,
                    month: 10,
                    day: 9,
                    hour: 12
                )
            )
        )

        let chore = Chore(
            id: UUID(),
            title: "Clean Kitchen",
            assignee: jason,
            dueDate: today,
            isCompleted: false
        )

        repository.addChore(chore)

        let result = useCase.execute(
            for: today
        )

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, chore.id)
    }


    func testDueChoresExcludesCompletedChore() throws {

        let repository = InMemoryChoreRepo()

        let useCase = DueChoresUseCase(
            repository: repository
        )

        let today = try XCTUnwrap(
            Calendar.current.date(
                from: DateComponents(
                    year: 2026,
                    month: 10,
                    day: 9,
                    hour: 12
                )
            )
        )

        let chore = Chore(
            id: UUID(),
            title: "Take Out Rubbish",
            assignee: damian,
            dueDate: today,
            isCompleted: true
        )

        repository.addChore(chore)

        let result = useCase.execute(
            for: today
        )

        XCTAssertTrue(result.isEmpty)
    }


    func testDueChoresExcludesFutureChore() throws {

        let repository = InMemoryChoreRepo()

        let useCase = DueChoresUseCase(
            repository: repository
        )

        let today = try XCTUnwrap(
            Calendar.current.date(
                from: DateComponents(
                    year: 2026,
                    month: 10,
                    day: 9,
                    hour: 12
                )
            )
        )

        let tomorrow = try XCTUnwrap(
            Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: today
            )
        )

        let chore = Chore(
            id: UUID(),
            title: "Vacuum Living Room",
            assignee: luna,
            dueDate: tomorrow,
            isCompleted: false
        )

        repository.addChore(chore)

        let result = useCase.execute(
            for: today
        )

        XCTAssertTrue(result.isEmpty)
    }
}
