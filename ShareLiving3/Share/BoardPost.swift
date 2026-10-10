//
//  BoardPost.swift
//  ShareLiving3
//
//  Created by Yang Peng on 10/10/2026.
//

import Foundation

enum BoardCategory: String, Codable, CaseIterable {
    case notice
    case shopping
    case reminder
    
    case bill
    case other

    var displayName: String {
        switch self {
        case .notice:
            return "Notice"
        case .shopping:
            return "Shopping"
        case .reminder:
            return "Reminder"
        case .bill:
            return "Bill"
        case .other:
            return "Other"
        }
    }
}
struct BoardPost: Codable, Identifiable {
    let id: UUID
    let createdAt: Date

    let note: String?
    let sourceText: String?
    let urlString: String?

    let category: BoardCategory
    var isResolved: Bool

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        note: String? = nil,
        sourceText: String? = nil,
        urlString: String? = nil,
        category: BoardCategory = .notice,
        isResolved: Bool = false
    ) {
        self.id = id
        self.createdAt = createdAt
        self.note = note
        self.sourceText = sourceText
        self.urlString = urlString
        self.category = category
        self.isResolved = isResolved
    }
}

enum BoardPostStore{

    static let appGroupID =
        "group.com.yangpengpersonalteam.ShareLiving3"

    private static let postsKey =
        "householdBoardPosts"

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    static func loadPosts() -> [BoardPost] {
        guard
            let data = defaults?.data(forKey: postsKey),
            let posts = try? JSONDecoder().decode(
                [BoardPost].self,
                from: data
            )
        else {
            return []
        }
        return posts
    }

    static func addPost(_ post: BoardPost) {
        var posts = loadPosts()

        posts.insert(post, at: 0)
        if posts.count > 50 {
            posts = Array(posts.prefix(50))
        }
        save(posts)
    }

    static func deletePost(id: UUID) {
        var posts = loadPosts()

        posts.removeAll {
            $0.id == id
        }
        save(posts)
    }

    static func toggleResolved(id: UUID) {
        var posts = loadPosts()

        guard let index = posts.firstIndex(
            where: { $0.id == id }
        ) else {
            return
        }

        posts[index].isResolved.toggle()
        save(posts)
    }

    private static func save(
        _ posts: [BoardPost]
    ) {
        guard let data = try? JSONEncoder().encode(posts) else {
            return
        }
        defaults?.set(data, forKey: postsKey)
    }
}
