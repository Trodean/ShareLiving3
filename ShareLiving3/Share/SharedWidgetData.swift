//
//  SharedWidgetData.swift
//  ShareLiving3
//
//  Created by Yang Peng on 9/10/2026.
//

import Foundation

enum SharedWidgetData {

    static let appGroupID =
        "group.com.yangpengpersonalteam.ShareLiving3"

    static let dueChoreCountKey =
        "dueChoreCount"

    static let repaymentCountKey =
        "repaymentCount"

    static var defaults: UserDefaults? {
        UserDefaults(
            suiteName: appGroupID
        )
    }

    static func save(
        dueChoreCount: Int,
        repaymentCount: Int
    ) {
        defaults?.set(
            dueChoreCount,
            forKey: dueChoreCountKey
        )

        defaults?.set(
            repaymentCount,
            forKey: repaymentCountKey
        )
    }

    static func dueChoreCount() -> Int {
        defaults?.integer(
            forKey: dueChoreCountKey
        ) ?? 0
    }

    static func repaymentCount() -> Int {
        defaults?.integer(
            forKey: repaymentCountKey
        ) ?? 0
    }
}
