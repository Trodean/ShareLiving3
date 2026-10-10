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
    private static var appGroupDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    static func loadPosts() -> [BoardPost] {
        loadPosts(from: appGroupDefaults)
    }
    static func addPost(_ post: BoardPost) {
        addPost(
            post,
            to: appGroupDefaults
        )
    }
    static func deletePost(id: UUID) {
        deletePost(
            id: id,
            from: appGroupDefaults
        )
    }
    static func toggleResolved(id: UUID) {
        toggleResolved(
            id: id,
            in: appGroupDefaults
        )
    }

    //MARK: For Unit Tests

    static func loadPosts(
        from defaults: UserDefaults?
    ) -> [BoardPost] {

        guard
            let data = defaults?.data(
                forKey: postsKey
            ),
            let posts = try? JSONDecoder()
                .decode(
                    [BoardPost].self,
                    from: data
                )
        else {
            return []
        }

        return posts
    }

    static func addPost(
        _ post: BoardPost,
        to defaults: UserDefaults?
    ) {

        var posts =
            loadPosts(from: defaults)

        posts.insert(
            post,
            at: 0
        )
        if posts.count > 50{
            posts = Array(
                posts.prefix(50)
            )
        }

        save(
            posts,
            to: defaults
        )
    }

    static func deletePost(
        id: UUID,
        from defaults: UserDefaults?
    ) {
        var posts =
            loadPosts(from: defaults)

        posts.removeAll {
            $0.id == id
        }

        save(
            posts,
            to: defaults
        )
    }
    static func toggleResolved(
        id: UUID,
        in defaults: UserDefaults?
    ) {
        var posts =
            loadPosts(from: defaults)

        guard let index =
                posts.firstIndex(
                    where: {
                        $0.id == id
                    }
                )
        else {
            return
        }

        posts[index]
            .isResolved
            .toggle()

        save(
            posts,
            to: defaults
        )
    }

    private static func save(
        _ posts: [BoardPost],
        to defaults: UserDefaults?
    ) {

        guard let data =
                try? JSONEncoder()
                    .encode(posts)
        else {
            return
        }

        defaults?.set(
            data,
            forKey: postsKey
        )
    }
}
