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

            ZStack {

                Color("AppBackground")
                    .ignoresSafeArea()

                ScrollView {

                    VStack(
                        alignment: .leading,
                        spacing: 26
                    ) {

                        grocerySection(
                            title: "Urgent",
                            icon: "exclamationmark.circle.fill",
                            color: .orange
                        ) {

                            GroceryItemRow(
                                name: "Toilet Paper",
                                quantity: 1,
                                assignee: "Roommate",
                                accentColor: .orange
                            )

                            Divider()
                                .padding(.leading, 54)

                            GroceryItemRow(
                                name: "Soy Sauce",
                                quantity: 1,
                                assignee: "You",
                                accentColor: .orange
                            )
                        }
                        grocerySection(
                            title: "Non-urgent",
                            icon: "cart.fill",
                            color: Color("SharedGreen")
                        ) {

                            GroceryItemRow(
                                name: "Rubbish Bags",
                                quantity: 1,
                                assignee: "Roommate",
                                accentColor: Color("SharedGreen")
                            )

                            Divider()
                                .padding(.leading, 54)

                            GroceryItemRow(
                                name: "Milk",
                                quantity: 1,
                                assignee: "You",
                                accentColor: Color("SharedGreen")
                            )

                            Divider()
                                .padding(.leading, 54)

                            GroceryItemRow(
                                name: "Coke",
                                quantity: 1,
                                assignee: "You",
                                accentColor: Color("SharedGreen")
                            )

                            Divider()
                                .padding(.leading, 54)

                            GroceryItemRow(
                                name: "TimTam",
                                quantity: 1,
                                assignee: "Roommate",
                                accentColor: Color("SharedGreen")
                            )
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Grocery List")
            .navigationBarTitleDisplayMode(.inline)
            .tint(Color("SharedGreen"))
            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button {
                        onHome()
                    } label: {
                        Image(
                            systemName: "house.fill"
                        )
                    }
                }

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {
                        showAddGroceryItem = true
                    } label: {

                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(
            isPresented: $showAddGroceryItem
        ) {

            NavigationStack {
                AddGroceryItemView()
            }
        }
    }

    private func grocerySection<Content: View>(
        title: String,
        icon: String,
        color: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack(spacing: 8) {

                Image(systemName: icon)
                    .foregroundStyle(color)

                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()
            }

            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
                .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
                .stroke(
                    Color.black.opacity(0.04),
                    lineWidth: 1
                )
            )
        }
    }
}

struct GroceryItemRow: View {

    let name: String
    let quantity: Int
    let assignee: String
    let accentColor: Color

    var body: some View {

        HStack(spacing: 14) {

            Image(
                systemName: "basket.fill"
            )
            .font(.headline)
            .foregroundStyle(accentColor)
            .frame(width: 38, height: 38)
            .background(
                Circle()
                    .fill(
                        accentColor.opacity(0.10)
                    )
            )

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(name)
                    .font(.headline)

                Text(
                    quantity == 1
                        ? "1 item"
                        : "\(quantity) items"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Text(assignee)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(
                    assignee == "You"
                        ? Color("SharedGreen")
                        : Color.secondary
                )
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(
                            assignee == "You"
                                ? Color("SharedGreen")
                                    .opacity(0.10)
                                : Color.gray
                                    .opacity(0.10)
                        )
                )
        }
        .padding(14)
        .frame(minHeight: 70)
    }
}




#Preview {
    GroceryView(
        onHome: {}
    )
}
