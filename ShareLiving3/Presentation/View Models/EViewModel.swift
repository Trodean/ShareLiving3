//
//  EViewModel.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// This Viewmodel manages the expense data shown in the interface and connects the expense views with the recording use case. It updates the displayed expense list and provides user-friendly error messages when an expense cannot be recorded.

import Foundation
import Combine

final class EViewModel: ObservableObject {
    @Published var expenses: [SharedExpenses] = []
    @Published var errorMsg: String?
    
    private let recordUseCase: RecordUseCases
    
    init(recordUseCase: RecordUseCases) {
        self.recordUseCase = recordUseCase
        self.expenses = recordUseCase.getAllExpenses()
    }
    
    @discardableResult
    func recordExpense(_ expense: SharedExpenses) -> Bool {
        do {
            try recordUseCase.execute(expense)
            expenses.append(expense)
            errorMsg = nil
            return true
        } catch {
            errorMsg = String(describing: error)
            return false
        }
    }
}

