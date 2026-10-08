//
//  EViewModel.swift
//  SharedLiving3
//
//  Created by Yang Peng on 16/9/2026.
//  Add new stuffs for smart transfer plan 8/10/2026.
//
// This Viewmodel manages the expense data shown in the interface and connects the expense views with the recording use case. It updates the displayed expense list and provides user-friendly error messages when an expense cannot be recorded.

import Foundation
import Combine

final class EViewModel: ObservableObject {

    @Published var expenses: [SharedExpenses] = []
    @Published var settlementPlan: [SettlementTransfer] = []
    @Published var errorMsg: String?

    private let recordUseCase: RecordUseCases
    private let settlementPlanUseCase: SettlementPlanUseCase

    init(
        recordUseCase: RecordUseCases,
        settlementPlanUseCase: SettlementPlanUseCase
    ) {
        self.recordUseCase = recordUseCase
        self.settlementPlanUseCase = settlementPlanUseCase
        self.expenses = recordUseCase.getAllExpenses()
        refreshSettlementPlan()
    }

    @discardableResult
    func recordExpense(_ expense: SharedExpenses) -> Bool {
        do {
            try recordUseCase.execute(expense)

            expenses.append(expense)
            refreshSettlementPlan()
            errorMsg = nil
            return true

        } catch {
            errorMsg = String(describing: error)
            return false
        }
    }
    func refreshSettlementPlan() {
        do {
            settlementPlan = try settlementPlanUseCase.execute()

        } catch SettlementPlanError.invalidExpenseAmount {
            settlementPlan = []
            errorMsg =
                "A repayment plan could not be calculated because an expense has an invalid amount."

        } catch SettlementPlanError.noShares {
            settlementPlan = []
            errorMsg =
                "A repayment plan could not be calculated because an expense has no housemates assigned."

        } catch SettlementPlanError.invalidPortions {
            settlementPlan = []
            errorMsg =
                "A repayment plan could not be calculated because an expense has an invalid share."
        } catch {
            settlementPlan = []
            errorMsg =
                "The repayment plan could not be calculated. Please check the expense details and try again."
        }
    }
}

