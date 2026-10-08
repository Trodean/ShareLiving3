//
//  Untitled.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// Provides a form for entering basic grocery item information.
// The current version collects the item name, quantity & urgency status.
// will add in some persistent grocery management in the future.

import SwiftUI

struct AddGroceryItemView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var itemName = ""
    @State private var quantity = 1
    @State private var isUrgent = false

    var body: some View {
        Form {
            Section("Item Details") {
                TextField("Item name", text: $itemName)

                Stepper(
                    "Quantity: \(quantity)",
                    value: $quantity,
                    in: 1...20
                )

                Toggle("Urgent", isOn: $isUrgent)
            }

            Section {
                Button("Add Item") {
                }
            }
        }
        .navigationTitle("Add Grocery Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddGroceryItemView()
}
