//
//  SharedExpenses.swift
//  SharedLiving2
//
//  Created by Yang Peng on 15/9/2026.
//

import Foundation
// Represents one housemate's portion of a shared expense.
struct SharedExpenses: Identifiable, Codable {
    let id: UUID
    let title: String
    let amount: Double
    let category: ExpenseCategory
    let payer: Housemate
    let shares: [Shares]
    let date: Date
}
