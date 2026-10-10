//
//  HouseholdBoardView.swift
//  ShareLiving3
//
//  Created by Yang Peng on 10/10/2026.
//

import SwiftUI
import Combine

final class HouseholdBoardViewModel: ObservableObject{

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
                if viewModel.posts.isEmpty{

                    ContentUnavailableView(
                        "No Household Posts",
                        systemImage: "megaphone",
                        description: Text(
                            "Share useful information from other apps to ShareLiving."
                        )
                    )
                    .listRowBackground(Color.clear)

                } else {
                    if !viewModel.openPosts.isEmpty {

                        Section {
                            ForEach(viewModel.openPosts) { post in
                                boardPostRow(post)
                            }
                        } header: {
                            sectionHeader(
                                title: "Open",
                                count: viewModel.openPosts.count
                            )
                        }
                    }

                    if !viewModel.resolvedPosts.isEmpty {
                        Section {
                            ForEach(viewModel.resolvedPosts) { post in
                                boardPostRow(post)
                            }
                        } header: {
                            sectionHeader(
                                title: "Resolved",
                                count: viewModel.resolvedPosts.count
                            )
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                Color("AppBackground")
                    .ignoresSafeArea()
            )
            .navigationTitle("Household Board")
            .tint(Color("SharedGreen"))
            .onAppear {
                viewModel.refresh()
            }
        }
    }

    //Section Header
    private func sectionHeader(
        title: String,
        count: Int
    ) -> some View {

        HStack(spacing: 7){

            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            Text("\(count)")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(Color("SharedGreen"))
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(
                            Color("SharedGreen")
                                .opacity(0.12)
                        )
                )

            Spacer()
        }
        .textCase(nil)
        .padding(.top, 8)
        .padding(.bottom, 2)
    }

//Board Post Card
    @ViewBuilder
    private func boardPostRow(
        _ post: BoardPost
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            // Category + Resolved status
            HStack {

                categoryBadge(post.category)

                Spacer()

                if post.isResolved {

                    Label(
                        "Resolved",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                }
            }
            //User  note
            if let note = post.note,
               !note.isEmpty {

                Text(note)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }

            //Shared source text
            if let sourceText = post.sourceText,
               !sourceText.isEmpty {

                Text(sourceText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            //URL
            if let urlString = post.urlString,
               let url = URL(string: urlString) {

                Link(destination: url) {

                    HStack(spacing: 7) {

                        Image(systemName: "link")
                            .font(.caption)

                        Text(
                            url.host ?? urlString
                        )
                        .lineLimit(1)

                        Spacer()

                        Image(
                            systemName:
                                "arrow.up.right"
                        )
                        .font(.caption2)
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(
                        Color("SharedGreen")
                    )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10
                        )
                        .fill(
                            Color("SharedGreen")
                                .opacity(0.08)
                        )
                    )
                }
            }

            Divider()
                .opacity(0.5)

            //Date + action
            HStack {

                Label(
                    post.createdAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    ),
                    systemImage: "clock"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Spacer()

                Button {
                    viewModel.toggleResolved(post)
                } label: {

                    Label(
                        post.isResolved
                            ? "Reopen"
                            : "Resolve",
                        systemImage:
                            post.isResolved
                            ? "arrow.uturn.backward"
                            : "checkmark"
                    )
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        post.isResolved
                            ? Color.secondary
                            : Color("SharedGreen")
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
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
                Color.black.opacity(0.05),
                lineWidth: 1
            )
        )
        .opacity(
            post.isResolved ? 0.72 : 1
        )
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(
            EdgeInsets(
                top: 6,
                leading: 16,
                bottom: 6,
                trailing: 16
            )
        )
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

//Category Badge
    private func categoryBadge(
        _ category: BoardCategory
    ) -> some View {

        Label(
            category.displayName,
            systemImage: categoryIcon(category)
        )
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundStyle(Color("SharedGreen"))
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(
                    Color("SharedGreen")
                        .opacity(0.12)
                )
        )
    }

//Category Icon
    private func categoryIcon(
        _ category: BoardCategory
    ) -> String {

        switch category {

        case .notice:
            return "megaphone.fill"

        case .shopping:
            return "cart.fill"

        case .reminder:
            return "bell.fill"

        case .bill:
            return "doc.text.fill"

        case .other:
            return "square.grid.2x2.fill"
        }
    }
}




#Preview {
    HouseholdBoardView()
}
