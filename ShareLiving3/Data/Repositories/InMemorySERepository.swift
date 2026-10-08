//
//  InMemorySERepository.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
// no using now only for testing

import Foundation

final class InMemorySERepository: SERepository {

    private var expenses: [SharedExpenses] = []
    private var settledMonths: [String: Date] = [:]

    func addExpenses(_ expense: SharedExpenses) {
        expenses.append(expense)
    }
    func getAllexpenses() -> [SharedExpenses] {
        expenses
    }
    func isMonthSettled(
        monthKey: String
    ) -> Bool {
        settledMonths[monthKey] != nil
    }

    func settleMonth(
        monthKey: String,
        settledDate: Date
    ) throws {

        guard settledMonths[monthKey] == nil else {
            throw MonthlySettlementRepositoryError.alreadySettled
        }

        settledMonths[monthKey] = settledDate
    }
}
