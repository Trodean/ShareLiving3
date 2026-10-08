//
//  SettlementPlanUseCase.swift
//  ShareLiving3
//
//  Created by Yang Peng on 8/10/2026.
//

import Foundation

enum SettlementPlanError: Error{
    case invalidExpenseAmount
    case noShares
    case invalidPortions
}
struct SettlementPlanUseCase {

    private let repository: SERepository
    private let calendar = Calendar.current

    init(repository: SERepository){
        self.repository = repository
    }

    func execute(
        for date: Date = Date()
    ) throws -> [SettlementTransfer] {

        let monthKey = makeMonthKey(for: date)

        if repository.isMonthSettled(
            monthKey: monthKey
        ) {
            return []
        }

        let expenses = repository
            .getAllexpenses()
            .filter {
                calendar.isDate(
                    $0.date,
                    equalTo: date,
                    toGranularity: .month
                )
            }

        var balances: [UUID: Int] = [:]
        var housemates: [UUID: Housemate] = [:]

        for expense in expenses{

            guard expense.amount > 0 else {
                throw SettlementPlanError.invalidExpenseAmount
            }

            guard !expense.shares.isEmpty else {
                throw SettlementPlanError.noShares
            }

            guard expense.shares.allSatisfy({
                $0.portions > 0
            }) else {
                throw SettlementPlanError.invalidPortions
            }

            let totalCents = Int(
                (expense.amount * 100).rounded()
            )
            housemates[expense.payer.id] = expense.payer

            balances[expense.payer.id, default: 0] += totalCents

            let allocations = splitExpense(
                totalCents: totalCents,
                shares: expense.shares
            )
            for allocation in allocations {

                let housemate = allocation.housemate

                housemates[housemate.id] = housemate

                balances[housemate.id, default: 0] -=
                    allocation.cents
            }
        }

        var netBalances: [Balance] = []
        for (id, cents) in balances {

            guard cents != 0,
                  let housemate = housemates[id]
            else {
                continue
            }

            netBalances.append(
                Balance(
                    housemate: housemate,
                    cents: cents
                )
            )
        }
        return findMinimumPlan(netBalances) ?? []
    }
    
    //New: Monthly check
    private func makeMonthKey(
        for date: Date
    ) -> String {

        let components = calendar.dateComponents(
            [.year, .month],
            from: date
        )

        let year = components.year ?? 0
        let month = components.month ?? 0

        return String(
            format: "%04d-%02d",
            year,
            month
        )
    }
    
    private func splitExpense(
        totalCents: Int,
        shares: [Shares]
    ) -> [(housemate: Housemate, cents: Int)] {

        let totalPortions = shares.reduce(0) {
            $0 + $1.portions
        }

        var allocations: [
            (
                housemate: Housemate,
                cents: Int,
                remainder: Int
            )
        ] = []

        var allocatedCents = 0

        for share in shares {

            let numerator =
                totalCents * share.portions

            let baseAmount =
                numerator / totalPortions

            let remainder =
                numerator % totalPortions

            allocatedCents += baseAmount

            allocations.append(
                (
                    housemate: share.housemate,
                    cents: baseAmount,
                    remainder: remainder
                )
            )
        }

        var remainingCents =
            totalCents - allocatedCents

        allocations.sort {
            $0.remainder > $1.remainder
        }

        var index = 0

        while remainingCents > 0 {

            allocations[index].cents += 1

            remainingCents -= 1

            index += 1

            if index >= allocations.count {
                index = 0
            }
        }

        return allocations.map {
            (
                housemate: $0.housemate,
                cents: $0.cents
            )
        }
    }


    //This section is for finding minimal transfer

    private func findMinimumPlan(
        _ balances: [Balance]
    ) -> [SettlementTransfer]? {

        let activeBalances = balances.filter {
            $0.cents != 0
        }

        if activeBalances.isEmpty {
            return []
        }

        guard activeBalances.count > 1 else {
            return []
        }

        let first = activeBalances[0]

        var bestPlan: [SettlementTransfer]?

        for index in 1..<activeBalances.count {

            let other = activeBalances[index]

            //They must be on opposite sides.
            guard first.cents.signum() !=
                    other.cents.signum()
            else {
                continue
            }

            let amount = min(
                abs(first.cents),
                abs(other.cents)
            )

            var nextBalances = activeBalances

            var firstUpdated = first
            var otherUpdated = other

            let transfer: SettlementTransfer

            if first.cents < 0 {

                // First person owes money.
                transfer = SettlementTransfer(
                    from: first.housemate,
                    to: other.housemate,
                    amount: Double(amount) / 100
                )

                firstUpdated.cents += amount
                otherUpdated.cents -= amount

            } else {

                //Other person owes money
                transfer = SettlementTransfer(
                    from: other.housemate,
                    to: first.housemate,
                    amount: Double(amount) / 100
                )

                firstUpdated.cents -= amount
                otherUpdated.cents += amount
            }

            nextBalances[0] = firstUpdated
            nextBalances[index] = otherUpdated

            guard let remainingPlan =
                    findMinimumPlan(nextBalances)
            else {
                continue
            }

            let candidatePlan =
                [transfer] + remainingPlan

            if bestPlan == nil ||
                candidatePlan.count < bestPlan!.count {

                bestPlan = candidatePlan
            }
        }

        return bestPlan
    }

    //Internal Balance
    private struct Balance {

        let housemate: Housemate
        var cents: Int
    }
}
