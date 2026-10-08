//
//  Repository.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//

import Foundation

// Defines the data operations for shared expenses.

enum MonthlySettlementRepositoryError: Error {
    case alreadySettled
}

protocol SERepository {
    func addExpenses(_ expense: SharedExpenses)
    func getAllexpenses() -> [SharedExpenses]
    
    func isMonthSettled(
        monthKey: String
    ) -> Bool

    func settleMonth(
        monthKey: String,
        settledDate: Date
    ) throws
}
