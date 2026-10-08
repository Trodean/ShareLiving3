//
//  Errors.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//

import Foundation

//Define errors which can occur when recording a shared expense.
enum RecordSEError: Error, LocalizedError {
    case invalid_amount
    case no_expense_shares
    case invalid_share_portions

    var errorDescription: String? {
        switch self {
        case .invalid_amount:
            return "The expense amount must be higher than $0."

        case .no_expense_shares:
            return "Select at least one housemate."

        case .invalid_share_portions:
            return "Selected housemate must have at least one portion."
        }
    }
}
