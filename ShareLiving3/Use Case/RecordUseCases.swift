//
//  RecordUseCases.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// This one handles the process of recording a shared household expense.
//It checks that the expense amount and sharing portions are valid before the expense is saved.

import Foundation

struct RecordUseCases {

    private let repository: any SERepository
    private let calendar = Calendar.current

    init(repository: any SERepository) {
        self.repository = repository
    }

    func execute(_ expense: SharedExpenses) throws {

        guard expense.amount > 0 else{
            throw RecordSEError.invalid_amount
        }
        guard !expense.shares.isEmpty else {
            throw RecordSEError.no_expense_shares
        }
        guard expense.shares.allSatisfy({
            $0.portions > 0
        }) else {
            throw RecordSEError.invalid_share_portions
        }
        let monthKey = makeMonthKey(
            for: expense.date
        )
        guard !repository.isMonthSettled(
            monthKey: monthKey
        ) else {
            throw RecordSEError.monthAlreadySettled
        }
        repository.addExpenses(expense)
    }

    func getAllExpenses() -> [SharedExpenses] {
        repository.getAllexpenses()
    }

    private func makeMonthKey(
        for date: Date
    ) -> String {

        let components = calendar.dateComponents(
            [.year, .month],
            from: date
        )

        let year = components.year ?? 0
        let month = components.month ?? 0

        return String(
            format: "%04d-%02d",
            year,
            month
        )
    }
}

