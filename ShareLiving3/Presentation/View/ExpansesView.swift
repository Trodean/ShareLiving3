//
//  ExpansesView.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// Displays shared household expenses and a summary of the total amount recorded, and it also provides access to the Add Expense screen through Add Button.

import SwiftUI

struct ExpensesView: View{
    let onHome: () -> Void
    @ObservedObject var expenseViewModel: EViewModel

    let housemates: [Housemate]

    @State private var showAddExpense = false
    private var totalSpent: Double {
        expenseViewModel.expenses.reduce(0) {
            $0 + $1.amount
        }
    }
    private var monthName: String {
        Date.now.formatted(.dateTime.month(.wide))
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    summaryCard

                    repaymentPlanSection

                    VStack(alignment: .leading, spacing: 12){
                        Text("Recent Expenses")
                            .font(.title2)
                            .fontWeight(.semibold)

                        recentExpenses
                    }

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onHome()
                    } label: {
                        Image(systemName: "house.fill")
                    }
                }

                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        showAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddExpense){
            NavigationStack {
                AddExpenseView(
                    expenseViewModel: expenseViewModel,
                    housemates: housemates
                )
            }
        }
    }
    
    private var currentUser: Housemate?{
        housemates.first
    }

    private var currentUserBalance: Double {
        guard let currentUser else {
            return 0
        }

        var balance = 0.0

        for transfer in expenseViewModel.settlementPlan {

            if transfer.from.id == currentUser.id {
                balance -= transfer.amount
            }

            if transfer.to.id == currentUser.id {
                balance += transfer.amount
            }
        }

        return balance
    }

    private var summaryCard: some View{
        VStack(alignment: .leading, spacing: 10) {

            Text("\(monthName) Shared Expenses")
                .font(.headline)
            Text("Total Spent")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("$\(totalSpent, specifier: "%.2f")")
                .font(.system(size: 38, weight: .semibold))
            ProgressView(value: 0.65)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(balanceTitle)
                    .font(.headline)

                Text("$\(balanceAmount, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        )
    }
    
    private var balanceTitle: String {
        if currentUserBalance < 0 {
            return "You owe"
        }

        if currentUserBalance > 0 {
            return "You are owed"
        }

        return "You're settled"
    }

    private var balanceAmount: Double {
        abs(currentUserBalance)
    }

    //NEw: Repayment Plan

    private var repaymentPlanSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Repayment Plan")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                if !expenseViewModel.settlementPlan.isEmpty {
                    Text(transferCountText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if expenseViewModel.settlementPlan.isEmpty {

                HStack(spacing: 12) {

                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color("SharedGreen"))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Everyone is settled")
                            .font(.headline)

                        Text("No repayments are currently needed.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 1)
                )

            } else {

                VStack(spacing: 0) {

                    ForEach(
                        Array(
                            expenseViewModel
                                .settlementPlan
                                .enumerated()
                        ),
                        id: \.element.id
                    ) { index, transfer in

                        repaymentRow(transfer)

                        if index <
                            expenseViewModel.settlementPlan.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 1)
                )
            }
        }
    }

    private func repaymentRow(
        _ transfer: SettlementTransfer
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: "arrow.right.circle.fill")
                .font(.title2)
                .foregroundStyle(Color("SharedGreen"))

            VStack(alignment: .leading, spacing: 5) {

                HStack(spacing: 6) {
                    Text(transfer.from.name)
                        .fontWeight(.semibold)

                    Image(systemName: "arrow.right")
                        .font(.caption)

                    Text(transfer.to.name)
                        .fontWeight(.semibold)
                }

                Text("Suggested repayment")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("$\(transfer.amount, specifier: "%.2f")")
                .font(.headline)
        }
        .padding()
        .frame(minHeight: 72)
    }

    private var transferCountText: String {
        let count = expenseViewModel.settlementPlan.count

        if count == 1 {
            return "1 transfer"
        }

        return "\(count) transfers"
    }

    //New: Recent Expenses

    private var recentExpenses: some View {
        VStack(spacing: 0) {

            if expenseViewModel.expenses.isEmpty {
                Text("No expenses recorded yet.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                ForEach(
                    Array(expenseViewModel.expenses.reversed())
                ) { expense in

                    ExpenseRowView(expense: expense)

                    if expense.id !=
                        expenseViewModel.expenses.first?.id {
                        Divider()
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        )
    }
}

struct ExpenseRowView: View {

    let expense: SharedExpenses

    var body: some View {
        HStack(spacing: 14) {

            Image(systemName: iconName)
                .font(.title2)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)

                Text("Paid by \(expense.payer.name)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(expense.amount, specifier: "%.2f")")
                    .font(.headline)

                Text("Recorded")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(minHeight: 78)
    }

    private var iconName: String {
        let title = expense.title.lowercased()

        if title.contains("grocery") {
            return "basket"
        }

        if title.contains("electric") {
            return "bolt.fill"
        }

        if title.contains("internet") {
            return "wifi"
        }

        return "dollarsign.circle"
    }
}

#Preview {
    let repository = InMemorySERepository()

    let recordUseCase = RecordUseCases(
        repository: repository
    )

    let settlementPlanUseCase = SettlementPlanUseCase(
        repository: repository
    )
    let settleMonthUseCase = SettleMonthUseCase(
        repository: repository
    )

    ExpensesView(
        onHome: {},
        expenseViewModel: EViewModel(
            recordUseCase: recordUseCase,
            settlementPlanUseCase: settlementPlanUseCase,
            settleMonthUseCase: settleMonthUseCase
        ),
        housemates: [
            Housemate(
                id: UUID(),
                name: "Phoebe"
            ),
            Housemate(
                id: UUID(),
                name: "Jason"
            )
        ]
    )
}
