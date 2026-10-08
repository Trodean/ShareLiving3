//
//  SettleMonthUseCase.swift
//  ShareLiving3
//
//  Created by Yang Peng on 9/10/2026.
//

import Foundation

enum SettleMonthError: Error{
    case alreadySettled
    case noExpenses
}

struct SettleMonthUseCase{

    private let repository: SERepository
    private let calendar = Calendar.current

    init(repository: SERepository) {
        self.repository = repository
    }
    func execute(
        for date: Date = Date()
    ) throws {

        let monthKey = makeMonthKey(for: date)
  
        
        guard !repository.isMonthSettled(
            monthKey: monthKey
        ) else {
            throw SettleMonthError.alreadySettled
        }

        
        let monthlyExpenses =
            repository
                .getAllexpenses()
                .filter {
                    calendar.isDate(
                        $0.date,
                        equalTo: date,
                        toGranularity: .month
                    )
                }
        guard !monthlyExpenses.isEmpty else {
            throw SettleMonthError.noExpenses
        }

        try repository.settleMonth(
            monthKey: monthKey,
            settledDate: Date()
        )
    }

    
    
    func isSettled(
        for date: Date = Date()
    ) -> Bool {

        repository.isMonthSettled(
            monthKey: makeMonthKey(for: date)
        )
    }

    func monthKey(
        for date: Date = Date()
    ) -> String {
        makeMonthKey(for: date)
    }
    
    func settlePastMonths(
        referenceDate: Date = Date()
    ) {

        let currentMonthKey = makeMonthKey(
            for: referenceDate
        )

        let expenses = repository.getAllexpenses()

        let pastMonthKeys = Set(
            expenses
                .map {
                    makeMonthKey(for: $0.date)
                }
                .filter {
                    $0 < currentMonthKey
                }
        )

        for monthKey in pastMonthKeys {

            guard !repository.isMonthSettled(
                monthKey: monthKey
            ) else {
                continue
            }

            try? repository.settleMonth(
                monthKey: monthKey,
                settledDate: referenceDate
            )
        }
    }

    private func makeMonthKey(
        for date: Date
    ) -> String{

        let components =
            calendar.dateComponents(
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
