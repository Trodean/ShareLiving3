//
//  HomePageView.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// It provides the main entry point to the shared living app.
// Gives users quick access to expenses, chores, groceries and household member information.

import SwiftUI

struct HomePageView: View {

    let openExpenses: () -> Void
    let openChores: () -> Void
    let openGrocery: () -> Void
    let openHousemates: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {

                HStack {
                    Button {
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                    }

                    Spacer()

                    Button {
                    } label: {
                        Image(systemName: "bell")
                            .font(.title2)
                    }
                }

                HStack {
                    Text("Welcome Back, Yang!")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Spacer()
                }

                GeometryReader { geometry in
                    let availableHeight = max(geometry.size.height - 16, 0)
                    let cardHeight = availableHeight / 2

                    VStack(spacing: 16) {

                        HStack(spacing: 16) {
                            HomeMenuCard(
                                title: "Expenses",
                                icon: "dollarsign",
                                action: openExpenses
                            )

                            HomeMenuCard(
                                title: "Chores",
                                icon: "checkmark.square",
                                action: openChores
                            )
                        }
                        .frame(height: cardHeight)

                        HStack(spacing: 16) {
                            HomeMenuCard(
                                title: "Grocery",
                                icon: "cart",
                                action: openGrocery
                            )

                            HomeMenuCard(
                                title: "Housemates",
                                icon: "person.3.fill",
                                action: openHousemates
                            )
                        }
                        .frame(height: cardHeight)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .background(Color("AppBackground").ignoresSafeArea())
        }
    }
}

struct HomeMenuCard: View {

    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Spacer()

                Image(systemName: icon)
                    .font(.system(size: 48))
                    .frame(height: 60)
                    .foregroundStyle(Color("SharedGreen"))

                Spacer()

                Text(title)
                    .font(.headline)
                    .padding(.bottom, 18)
                    .foregroundStyle(Color("PrimaryText"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("SharedOrange"))
                )
            .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
            )
            
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomePageView(
        openExpenses: {},
        openChores: {},
        openGrocery: {},
        openHousemates: {}
    )
}
