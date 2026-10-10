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
    let openBoard: () -> Void

    @State private var boardPosts: [BoardPost] = []

    @Environment(\.scenePhase) private var scenePhase

    private var latestBoardPosts: [BoardPost] {
        Array(
            boardPosts
                .filter { !$0.isResolved }
                .prefix(2)
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {

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

                // NEW: Household Board Preview
                boardPreview

                GeometryReader { geometry in

                    let availableHeight = max(
                        geometry.size.height - 16,
                        0
                    )

                    let cardHeight =
                        availableHeight / 2

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
            .background(
                Color("AppBackground")
                    .ignoresSafeArea()
            )
            .onAppear {
                refreshBoard()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    refreshBoard()
                }
            }
        }
    }

    //NEW: Household Board Preview

    private var boardPreview: some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack {

                HStack(spacing: 7) {
                    Image(systemName: "megaphone.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color("SharedGreen"))

                    Text("Household Board")
                        .font(.headline)
                }

                Spacer()

                Button {
                    openBoard()
                } label: {
                    HStack(spacing: 3) {
                        Text("See All")

                        Image(systemName: "chevron.right")
                            .font(.caption2)
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("SharedGreen"))
                }
            }

            if latestBoardPosts.isEmpty {

                HStack(spacing: 10) {

                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(Color("SharedGreen"))

                    Text("No new household updates")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()
                }
                .padding(.vertical, 6)

            } else {

                ForEach(
                    Array(latestBoardPosts.enumerated()),
                    id: \.element.id
                ) { index, post in

                    Button {
                        openBoard()
                    } label: {

                        VStack(
                            alignment: .leading,
                            spacing: 6
                        ) {

                            categoryBadge(post.category)

                            HStack(
                                alignment: .center,
                                spacing: 8
                            ) {

                                VStack(
                                    alignment: .leading,
                                    spacing: 3
                                ) {

                                    if let note = post.note,
                                       !note.isEmpty {

                                        Text(note)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundStyle(
                                                Color("PrimaryText")
                                            )
                                            .lineLimit(1)

                                    } else if let sourceText =
                                                post.sourceText,
                                              !sourceText.isEmpty {

                                        Text(sourceText)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundStyle(
                                                Color("PrimaryText")
                                            )
                                            .lineLimit(1)

                                    } else if let urlString =
                                                post.urlString {

                                        Text(urlString)
                                            .font(.subheadline)
                                            .foregroundStyle(
                                                Color("PrimaryText")
                                            )
                                            .lineLimit(1)
                                    }

                                    Text(
                                        post.createdAt.formatted(
                                            date: .abbreviated,
                                            time: .shortened
                                        )
                                    )
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if index <
                        latestBoardPosts.count - 1 {

                        Divider()
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    Color("SharedOrange")
                        .opacity(0.22)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    Color("SharedOrange")
                        .opacity(0.7),
                    lineWidth: 1
                )
        )
    }
    
    private func categoryBadge(
        _ category: BoardCategory
    ) -> some View {

        HStack(spacing: 5) {

            Image(
                systemName: categoryIcon(category)
            )

            Text(category.displayName)
        }
        .font(.caption2)
        .fontWeight(.semibold)
        .foregroundStyle(Color("SharedGreen"))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(
                    Color("SharedGreen")
                        .opacity(0.12)
                )
        )
    }
    
    private func refreshBoard() {
        boardPosts =
            BoardPostStore.loadPosts()
    }

    private func categoryIcon(
        _ category: BoardCategory
    ) -> String {

        switch category {

        case .notice:
            return "megaphone"

        case .shopping:
            return "cart"

        case .reminder:
            return "bell"

        case .bill:
            return "doc.text"

        case .other:
            return "square.grid.2x2"
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
                    .foregroundStyle(
                        Color("SharedGreen")
                    )

                Spacer()

                Text(title)
                    .font(.headline)
                    .padding(.bottom, 18)
                    .foregroundStyle(
                        Color("PrimaryText")
                    )
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 20
                )
                .fill(
                    Color("SharedOrange")
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 20
                )
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
        openHousemates: {},
        openBoard: {}
    )
}
