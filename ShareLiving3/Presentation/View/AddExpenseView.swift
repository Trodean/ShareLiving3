//
//  AddExpenseView.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
//Collects the information needed to record a new shared expense.
//In this UI, users can type down the amount, category, payer, and portion split before submitting the expense.

import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var expenseViewModel: EViewModel
    
    let housemates: [Housemate]
    
    @State private var title = ""
    @State private var amount = ""
    @State private var selectedPayerID: UUID?
    @State private var portions: [UUID: Int] = [:]
    @State private var selectedCategory: ExpenseCategory = .groceries
    
    var body: some View {
        Form {
            
            Section("Expense Detail") {
                TextField("Name/Title:", text: $title)
                TextField("How much $? ", text: $amount)
                    .keyboardType(.decimalPad)
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(ExpenseCategory.allCases) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
            }
            
            Section("Paid by") {
                Picker("Payer", selection: $selectedPayerID){
                    ForEach(housemates) { housemate in
                        Text(housemate.name)
                            .tag(Optional(housemate.id))
                    }
                }
            }
            
            Section("Split Between") {
                ForEach(housemates) { housemate in
                    HStack {
                        Text(housemate.name)

                        Spacer()

                        Stepper(
                            "\(portions[housemate.id, default: 1])",
                            value: Binding(
                                get: {
                                    portions[housemate.id, default: 1]
                                },
                                set: {
                                    portions[housemate.id] = $0
                                }
                            ),
                            in: 0...10
                        )
                    }
                }
            }
            
            Section {
                Button("Comfirm and Add") {
                    saveExpense()
                }
            }
        }
        .alert(
            "Unable to Add Expense",
            isPresented: Binding(
                get: {
                    expenseViewModel.errorMsg != nil
                },
                set: { isPresented in
                    if !isPresented {
                        expenseViewModel.errorMsg = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                expenseViewModel.errorMsg = nil
            }
        } message: {
            Text(expenseViewModel.errorMsg ?? "")
        }
        .navigationTitle("ADD EXPENSE")
        .onAppear {
            if selectedPayerID == nil {
                selectedPayerID = housemates.first?.id
            }

            for housemate in housemates {
                if portions[housemate.id] == nil {
                    portions[housemate.id] = 1
                }
            }
        }
    }
    
    private func saveExpense() {

        guard let amountValue = Double(amount) else {
            expenseViewModel.errorMsg = "Please enter a valid amount."
            return
        }

        guard let payer = housemates.first(where: {
            $0.id == selectedPayerID
        }) else {
            expenseViewModel.errorMsg = "Please select who paid."
            return
        }

        let expenseShares = housemates.compactMap { housemate -> Shares? in
            let portion = portions[housemate.id, default: 0]

            guard portion > 0 else {
                return nil
            }

            return Shares(
                housemate: housemate,
                portions: portion
            )
        }

        let expense = SharedExpenses(
            id: UUID(),
            title: title,
            amount: amountValue,
            category: selectedCategory,
            payer: payer,
            shares: expenseShares,
            date: Date()
        )

        let success = expenseViewModel.recordExpense(expense)

        if success {
            dismiss()
        }
    }
}
