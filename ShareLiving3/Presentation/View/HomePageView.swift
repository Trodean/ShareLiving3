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

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack {

                HStack(spacing: 8) {

                    Image(systemName: "megaphone.fill")
                        .foregroundStyle(
                            Color("SharedGreen")
                        )

                    Text("Household Board")
                        .font(.headline)
                }

                Spacer()

                Button("See All") {
                    openBoard()
                }
                .font(.subheadline)
            }

            if latestBoardPosts.isEmpty {

                Text("No new household updates.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 6)

            } else {

                ForEach(latestBoardPosts) { post in

                    Button {
                        openBoard()
                    } label: {

                        HStack(
                            alignment: .top,
                            spacing: 12
                        ) {

                            Image(
                                systemName:
                                    categoryIcon(
                                        post.category
                                    )
                            )
                            .foregroundStyle(
                                Color("SharedGreen")
                            )
                            .frame(width: 24)

                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {

                                Text(
                                    post.category
                                        .displayName
                                )
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    .secondary
                                )

                                if let note = post.note,
                                   !note.isEmpty {

                                    Text(note)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(
                                            Color("PrimaryText")
                                        )
                                        .lineLimit(2)

                                } else if
                                    let sourceText =
                                        post.sourceText,
                                    !sourceText.isEmpty {

                                    Text(sourceText)
                                        .font(.subheadline)
                                        .foregroundStyle(
                                            Color("PrimaryText")
                                        )
                                        .lineLimit(2)

                                } else if
                                    let urlString =
                                        post.urlString {

                                    Text(urlString)
                                        .font(.subheadline)
                                        .foregroundStyle(
                                            Color("PrimaryText")
                                        )
                                        .lineLimit(1)
                                }
                            }

                            Spacer()

                            Image(
                                systemName: "chevron.right"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)

                    if post.id !=
                        latestBoardPosts.last?.id {

                        Divider()
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color("SharedOrange")
                        .opacity(0.35)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
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
