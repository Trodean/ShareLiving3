//
//  HousematesView.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// Displays the members who belong to the shared household.
//Current user is shown separately while the other housemates are presented as a simple list.

import SwiftUI

struct HousematesView: View {

    let onHome: () -> Void

    let housemates = [
        "Jason",
        "Phoebe",
        "Crystal",
        "Damian",
        "Luna"
    ]

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

                        myProfileCard

                        VStack(
                            alignment: .leading,
                            spacing: 12
                        ) {

                            HStack {

                                Text("Housemates")
                                    .font(.title2)
                                    .fontWeight(.semibold)

                                Spacer()

                                Text("\(housemates.count + 1) members")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            VStack(spacing: 0) {

                                ForEach(
                                    Array(housemates.enumerated()),
                                    id: \.element
                                ) { index, housemate in

                                    HousemateRow(
                                        name: housemate
                                    )

                                    if index < housemates.count - 1 {
                                        Divider()
                                            .padding(.leading, 64)
                                    }
                                }
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

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Household")
            .navigationBarTitleDisplayMode(.inline)
            .tint(Color("SharedGreen"))
            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button {
                        onHome()
                    } label: {
                        Image(systemName: "house.fill")
                    }
                }
            }
        }
    }

    private var myProfileCard: some View {

        VStack(spacing: 14) {

            ZStack {

                Circle()
                    .fill(
                        Color("SharedGreen")
                            .opacity(0.12)
                    )
                    .frame(
                        width: 94,
                        height: 94
                    )

                Image(
                    systemName:
                        "person.crop.circle.fill"
                )
                .font(.system(size: 72))
                .foregroundStyle(
                    Color("SharedGreen")
                )
            }

            VStack(spacing: 4) {

                Text("Yang")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("My Profile")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text("You")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color("SharedGreen"))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(
                            Color("SharedGreen")
                                .opacity(0.10)
                        )
                )
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.vertical, 26)
        .background(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .stroke(
                Color("SharedGreen")
                    .opacity(0.10),
                lineWidth: 1
            )
        )
    }
}

struct HousemateRow: View {

    let name: String

    var body: some View {

        HStack(spacing: 14) {

            ZStack {

                Circle()
                    .fill(
                        Color("SharedGreen")
                            .opacity(0.10)
                    )
                    .frame(
                        width: 40,
                        height: 40
                    )

                Text(initial)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        Color("SharedGreen")
                    )
            }

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(name)
                    .font(.headline)

                Text("Housemate")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(
                systemName: "person.fill"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 66)
    }

    private var initial: String {
        String(name.prefix(1))
    }
}





#Preview {
    HousematesView(
        onHome: {}
    )
}
