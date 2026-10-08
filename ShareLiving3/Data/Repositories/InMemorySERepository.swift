//
//  InMemorySERepository.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
// no using now only for testing

import Foundation

final class InMemorySERepository: SERepository {
    
    private var expenses: [SharedExpenses] = []
    
    func addExpenses(_ expense: SharedExpenses) {
        expenses.append(expense)
    }
    
    func getAllexpenses() -> [SharedExpenses] {
        expenses
    }
}
