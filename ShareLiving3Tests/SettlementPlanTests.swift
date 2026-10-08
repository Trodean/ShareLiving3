//
//  Untitled.swift
//  ShareLiving3
//
//  Created by Yang Peng on 9/10/2026.
//

import XCTest
@testable import ShareLiving3

final class SettlementPlanUseCaseTests: XCTestCase {

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


    //Multiple Expenses
    func testSettlementPlanSimplifiesMultipleExpenses() throws {

        let repository = InMemorySERepository()

        let useCase = SettlementPlanUseCase(
            repository: repository
        )

        let date = try XCTUnwrap(
            Calendar.current.date(
                from: DateComponents(
                    year: 2026,
                    month: 10,
                    day: 9
                )
            )
        )

        let dinner = makeExpense(
            title: "Dinner",
            amount: 600,
            payer: jason,
            date: date
        )

        let groceries = makeExpense(
            title: "Groceries",
            amount: 600,
            payer: damian,
            date: date
        )

        repository.addExpenses(dinner)
        repository.addExpenses(groceries)

        let plan = try useCase.execute(
            for: date
        )

        //Without simplification there would be many individual debts. Net settlement only needs 4.
        XCTAssertEqual(plan.count, 4)

        XCTAssertEqual(
            plan.reduce(0) {
                $0 + $1.amount
            },
            800,
            accuracy: 0.01
        )

        for transfer in plan {
            XCTAssertEqual(
                transfer.amount,
                200,
                accuracy: 0.01
            )
        }
    }


    //Balanced Household

    func testSettlementPlanReturnsEmptyWhenBalancesCancelOut() throws {

        let repository = InMemorySERepository()

        let useCase = SettlementPlanUseCase(
            repository: repository
        )

        let date = try XCTUnwrap(
            Calendar.current.date(
                from: DateComponents(
                    year: 2026,
                    month: 10,
                    day: 9
                )
            )
        )

        // Each housemate pays exactly one $60 expense.
        // Every expense is shared equally by all 6 people.
        // Each person: Paid = $60
        // Total responsibility = $60
        // Net balance = $0
        for payer in housemates {

            let expense = makeExpense(
                title: "\(payer.name)'s Expense",
                amount: 60,
                payer: payer,
                date: date
            )

            repository.addExpenses(expense)
        }

        let plan = try useCase.execute(
            for: date
        )

        XCTAssertTrue(plan.isEmpty)
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
