//
//  MonthlySettlementTests.swift
//  ShareLiving3
//
//  Created by Yang Peng on 9/10/2026.
//

import Foundation
import XCTest
@testable import ShareLiving3

final class MonthlySettlementTests: XCTestCase {

    private var yang: Housemate!
    private var jason: Housemate!
    private var damian: Housemate!
    private var luna: Housemate!
    private var crystal: Housemate!
    private var phoebe: Housemate!

    private var housemates: [Housemate]!

    override func setUp() {
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

        housemates = [
            yang,
            jason,
            damian,
            luna,
            crystal,
            phoebe
        ]
    }


    //Successful Monthly Settlement
    func testSettleMonthFinalisesMonthWithExpenses() throws {

        let repository = InMemorySERepository()

        let useCase = SettleMonthUseCase(
            repository: repository
        )

        let octoberDate = try XCTUnwrap(
            Calendar.current.date(
                from: DateComponents(
                    year: 2026,
                    month: 10,
                    day: 9
                )
            )
        )

        let expense = makeExpense(
            title: "October Groceries",
            amount: 120,
            payer: yang,
            date: octoberDate
        )

        repository.addExpenses(expense)

        XCTAssertFalse(
            useCase.isSettled(
                for: octoberDate
            )
        )

        try useCase.execute(
            for: octoberDate
        )

        XCTAssertTrue(
            useCase.isSettled(
                for: octoberDate
            )
        )
    }


    //Cannot Settle Twice

    func testSettleMonthRejectsAlreadySettledMonth() throws {

        let repository = InMemorySERepository()

        let useCase = SettleMonthUseCase(
            repository: repository
        )

        let octoberDate = try XCTUnwrap(
            Calendar.current.date(
                from: DateComponents(
                    year: 2026,
                    month: 10,
                    day: 9
                )
            )
        )

        let expense = makeExpense(
            title: "Internet",
            amount: 90,
            payer: jason,
            date: octoberDate
        )

        repository.addExpenses(expense)

        try useCase.execute(
            for: octoberDate
        )

        XCTAssertThrowsError(
            try useCase.execute(
                for: octoberDate
            )
        ) { error in

            guard case SettleMonthError.alreadySettled = error else {
                XCTFail(
                    "Expected alreadySettled but received \(error)"
                )
                return
            }
        }
    }


    //Repository
    func testInMemoryRepositoryStoresMonthlySettlement() throws {

        let repository = InMemorySERepository()

        XCTAssertFalse(
            repository.isMonthSettled(
                monthKey: "2026-10"
            )
        )

        try repository.settleMonth(
            monthKey: "2026-10",
            settledDate: Date()
        )

        XCTAssertTrue(
            repository.isMonthSettled(
                monthKey: "2026-10"
            )
        )
    }


    //Helper

    private func makeExpense(
        title: String,
        amount: Double,
        payer: Housemate,
        date: Date
    ) -> SharedExpenses {

        let shares = housemates.map { housemate in
            Shares(
                housemate: housemate,
                portions: 1
            )
        }

        return SharedExpenses(
            id: UUID(),
            title: title,
            amount: amount,
            category: .groceries,
            payer: payer,
            shares: shares,
            date: date
        )
    }
}
