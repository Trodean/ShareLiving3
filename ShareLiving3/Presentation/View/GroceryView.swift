//
//  GroceryView.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//

//Displays grocery items shared by the household and separates urgent items from non-urgent items and also provides access to the Add Grocery Item screen.
import SwiftUI

struct GroceryView: View {

    let onHome: () -> Void

    @State private var showAddGroceryItem = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 12) {
                        Text("URGENT")
                            .font(.title2)
                            .fontWeight(.semibold)

                        VStack(spacing: 0) {
                            GroceryItemRow(
                                name: "Toilet Paper",
                                quantity: 1,
                                assignee: "Roommate"
                            )

                            Divider()

                            GroceryItemRow(
                                name: "Soy Sauce",
                                quantity: 1,
                                assignee: "You"
                            )
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 1)
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Non-urgent")
                            .font(.title2)
                            .fontWeight(.semibold)

                        VStack(spacing: 0) {
                            GroceryItemRow(
                                name: "Rubbish Bags",
                                quantity: 1,
                                assignee: "Roommate"
                            )

                            Divider()

                            GroceryItemRow(
                                name: "Milk",
                                quantity: 1,
                                assignee: "You"
                            )

                            Divider()

                            GroceryItemRow(
                                name: "Coke",
                                quantity: 1,
                                assignee: "You"
                            )

                            Divider()

                            GroceryItemRow(
                                name: "TimTam",
                                quantity: 1,
                                assignee: "Roommate"
                            )
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 1)
                        )
                    }

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .navigationTitle("Grocery List")
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
                        showAddGroceryItem = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddGroceryItem) {
            NavigationStack {
                AddGroceryItemView()
            }
        }
    }
}

struct GroceryItemRow: View {

    let name: String
    let quantity: Int
    let assignee: String

    var body: some View {
        HStack(spacing: 12) {

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)

                Text("×\(quantity)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(assignee)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding()
        .frame(minHeight: 68)
    }
}

#Preview {
    GroceryView(
        onHome: {}
    )
}
