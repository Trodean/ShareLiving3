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
            ScrollView {
                VStack(spacing: 24) {

                    Button {
                    } label: {
                        VStack(spacing: 14) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 90))

                            Text("Yang")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("My Profile")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 28)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Housemates")
                            .font(.title2)
                            .fontWeight(.semibold)

                        VStack(spacing: 0) {
                            ForEach(housemates, id: \.self) { housemate in
                                HousemateRow(name: housemate)

                                if housemate != housemates.last {
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
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationTitle("Household")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onHome()
                    } label: {
                        Image(systemName: "house.fill")
                    }
                }
            }
        }
    }
}

struct HousemateRow: View {

    let name: String

    var body: some View {
        HStack {
            Text(name)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.down")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 64)
    }
}

#Preview {
    HousematesView(onHome: {})
}
