//
//  RecordExpenseSettlementTests.swift
//  ShareLiving3
//
//  Created by Yang Peng on 9/10/2026.
//

import Foundation
import XCTest
@testable import ShareLiving3

final class RecordExpenseSettlementTests: XCTestCase{

    func testRecordExpenseRejectsFinalisedMonth() throws {

        let repository = InMemorySERepository()
        let recordUseCase = RecordUseCases(
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

        let yang = Housemate(
            id: UUID(),
            name: "Yang"
        )
        let jason = Housemate(
            id: UUID(),
            name: "Jason"
        )
        let expense = SharedExpenses(
            id: UUID(),
            title: "October Dinner",
            amount: 100,
            category: .groceries,
            payer: yang,
            shares: [
                Shares(
                    housemate: yang,
                    portions: 1
                ),
                Shares(
                    housemate: jason,
                    portions: 1
                )
            ],
            date: octoberDate
        )

        try repository.settleMonth(
            monthKey: "2026-10",
            settledDate: Date()
        )

        XCTAssertThrowsError(
            try recordUseCase.execute(expense)
        ){ error in

            guard case RecordSEError.monthAlreadySettled = error else {
                XCTFail(
                    "Expected monthAlreadySettled but received \(error)"
                )
                return
            }
        }

        XCTAssertTrue(
            repository.getAllexpenses().isEmpty
        )
    }
}
