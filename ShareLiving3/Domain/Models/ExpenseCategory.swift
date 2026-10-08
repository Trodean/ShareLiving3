//
//  ExpenseCategory.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//

import Foundation
//Defines the category of a shared expense.
enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case groceries = "Groceries"
    case electricity = "Electricity Bill"
    case water = "Water Bill"
    case gas = "Gas Bill"
    case internet = "Internet"
    case rent = "Rent"
    case household = "Household"
    case transport = "Transport"
    case other = "Other"

    var id: String {
        rawValue
    }
}
