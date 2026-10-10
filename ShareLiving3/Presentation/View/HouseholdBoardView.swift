//
//  HouseholdBoardView.swift
//  ShareLiving3
//
//  Created by Yang Peng on 10/10/2026.
//

import SwiftUI
import Combine

final class HouseholdBoardViewModel: ObservableObject {

    @Published var posts: [BoardPost] = []

    var openPosts: [BoardPost] {
        posts.filter { !$0.isResolved }
    }

    var resolvedPosts: [BoardPost] {
        posts.filter { $0.isResolved }
    }

    func refresh() {
        posts = BoardPostStore.loadPosts()
    }

    func toggleResolved(_ post: BoardPost) {
        BoardPostStore.toggleResolved(id: post.id)
        refresh()
    }

    func delete(_ post: BoardPost) {
        BoardPostStore.deletePost(id: post.id)
        refresh()
    }
}

struct HouseholdBoardView: View {

    @StateObject private var viewModel =
        HouseholdBoardViewModel()

    var body: some View {
        NavigationStack {
            List {

                if viewModel.posts.isEmpty {
                    ContentUnavailableView(
                        "No Household Posts",
                        systemImage: "megaphone",
                        description: Text(
                            "Share useful information from other apps to ShareLiving."
                        )
                    )
                } else {

                    if !viewModel.openPosts.isEmpty {
                        Section("Open") {
                            ForEach(viewModel.openPosts) { post in
                                boardPostRow(post)
                            }
                        }
                    }

                    if !viewModel.resolvedPosts.isEmpty {
                        Section("Resolved") {
                            ForEach(viewModel.resolvedPosts) { post in
                                boardPostRow(post)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Household Board")
            .onAppear {
                viewModel.refresh()
            }
        }
    }

    @ViewBuilder
    private func boardPostRow(
        _ post: BoardPost
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            HStack {
                Label(
                    post.category.displayName,
                    systemImage: categoryIcon(post.category)
                )
                .font(.caption)
                .fontWeight(.semibold)

                Spacer()

                if post.isResolved {
                    Label(
                        "Resolved",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }

            if let note = post.note,
               !note.isEmpty {

                Text(note)
                    .font(.headline)
            }

            if let sourceText = post.sourceText,
               !sourceText.isEmpty {

                Text(sourceText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let urlString = post.urlString,
               let url = URL(string: urlString) {

                Link(destination: url) {
                    HStack(spacing: 6) {
                        Image(systemName: "link")

                        Text(url.host ?? urlString)
                            .lineLimit(1)
                    }
                    .font(.subheadline)
                }
            }

            Text(
                post.createdAt.formatted(
                    date: .abbreviated,
                    time: .shortened
                )
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            Button {
                viewModel.toggleResolved(post)
            } label: {
                Label(
                    post.isResolved
                        ? "Mark as Open"
                        : "Mark as Resolved",
                    systemImage: post.isResolved
                        ? "arrow.uturn.backward.circle"
                        : "checkmark.circle"
                )
            }
            .font(.subheadline)
        }
        .padding(.vertical, 6)
        .swipeActions {
            Button(role: .destructive) {
                viewModel.delete(post)
            } label: {
                Label(
                    "Delete",
                    systemImage: "trash"
                )
            }
        }
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

#Preview {
    HouseholdBoardView()
}
