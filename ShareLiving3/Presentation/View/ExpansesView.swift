//
//  ExpansesView.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// Displays shared household expenses and a summary of the total amount recorded, and it also provides access to the Add Expense screen through Add Button.


import SwiftUI



struct ExpensesView: View {

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

                    VStack(alignment: .leading, spacing: 12) {
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

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddExpense) {
            NavigationStack {
                AddExpenseView(
                    expenseViewModel: expenseViewModel,
                    housemates: housemates
                )
            }
        }
    }

    private var summaryCard: some View {
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

            Text("You owe —")
                .font(.headline)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        )
    }

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

                    if expense.id != expenseViewModel.expenses.first?.id {
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
    let useCase = RecordUseCases(repository: repository)

    ExpensesView(
        onHome: {},
        expenseViewModel: EViewModel(recordUseCase: useCase),
        housemates: [
            Housemate(id: UUID(), name: "Phoebe"),
            Housemate(id: UUID(), name: "Jason")
        ]
    )
}
