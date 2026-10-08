//
//  CompleteChoreError.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//

import Foundation

// Define errors which can occur when completing a household chore.
enum CompleteChoreError: Error, LocalizedError {
    case alreadyCompleted

    var errorDescription: String? {
        switch self {
        case .alreadyCompleted:
            return "This chore has already been completed."
        }
    }
}
