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
    @Published var isCurrentMonthSettled = false

    private let recordUseCase: RecordUseCases
    private let settlementPlanUseCase: SettlementPlanUseCase
    private let settleMonthUseCase: SettleMonthUseCase

    init(
        recordUseCase: RecordUseCases,
        settlementPlanUseCase: SettlementPlanUseCase,
        settleMonthUseCase: SettleMonthUseCase
    ) {
        self.recordUseCase = recordUseCase
        self.settlementPlanUseCase = settlementPlanUseCase
        self.settleMonthUseCase = settleMonthUseCase

        self.expenses = recordUseCase.getAllExpenses()
        
        settleMonthUseCase.settlePastMonths()

        refreshSettlementPlan()
        refreshSettlementStatus()
    }

    @discardableResult
    func recordExpense(_ expense: SharedExpenses) -> Bool {
        do {
            try recordUseCase.execute(expense)

            expenses.append(expense)
            refreshSettlementPlan()
            errorMsg = nil
            return true

        } catch RecordSEError.invalid_amount {
            errorMsg = "Enter an expense amount greater than $0."
            return false

        } catch RecordSEError.no_expense_shares {
            errorMsg = "Select at least one housemate to share this expense."
            return false

        } catch RecordSEError.invalid_share_portions {
            errorMsg = "Each selected housemate must have at least one portion."
            return false

        } catch RecordSEError.monthAlreadySettled {
            errorMsg = "This month has already been finalised. Add the expense to the current month instead."
            return false

        } catch {
            errorMsg = "The expense could not be added. Please check the details and try again."
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
    
    func refreshSettlementStatus() {
        isCurrentMonthSettled =
            settleMonthUseCase.isSettled()
    }
    
    @discardableResult
    func settleCurrentMonth() -> Bool {
        do {
            try settleMonthUseCase.execute()

            refreshSettlementPlan()
            refreshSettlementStatus()

            errorMsg = nil
            return true

        } catch SettleMonthError.alreadySettled {
            errorMsg =
                "This month has already been settled."

            return false

        } catch SettleMonthError.noExpenses {
            errorMsg =
                "There are no expenses to settle this month."

            return false

        } catch {
            errorMsg =
                "This month could not be settled. Please try again."

            return false
        }
    }
}

