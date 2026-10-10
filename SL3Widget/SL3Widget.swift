//
//  SL3Widget.swift
//  SL3Widget
//
//  Created by Yang Peng on 9/10/2026.
//

import WidgetKit
import SwiftUI

struct SL3WidgetEntry: TimelineEntry {

    let date: Date
    let dueChoreCount: Int
    let repaymentCount: Int
}

struct SL3WidgetProvider: TimelineProvider {

    func placeholder(
        in context: Context
    ) -> SL3WidgetEntry {

        SL3WidgetEntry(
            date: Date(),
            dueChoreCount: 2,
            repaymentCount: 1
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (
            SL3WidgetEntry
        ) -> Void
    ) {
        completion(
            makeEntry()
        )
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (
            Timeline<SL3WidgetEntry>
        ) -> Void
    ) {
        let entry = makeEntry()
        let nextUpdate =
            Calendar.current.date(
                byAdding: .minute,
                value: 30,
                to: Date()
            ) ?? Date()

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextUpdate)
        )

        completion(timeline)
    }

    private func makeEntry()
        -> SL3WidgetEntry {
        SL3WidgetEntry(
            date: Date(),
            dueChoreCount:
                SharedWidgetData
                    .dueChoreCount(),
            repaymentCount:
                SharedWidgetData
                    .repaymentCount()
        )
    }
}


struct SL3ChoreWidget: Widget {

    let kind =
        "SL3ChoreWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: SL3WidgetProvider()
        ) { entry in

            SmallWidgetView(
                entry: entry,
                mode: .chores
            )
        }
        .configurationDisplayName(
            "Chores Due"
        )
        .description(
            "See how many household chores need attention."
        )
        .supportedFamilies([
            .systemSmall
        ])
    }
}


struct SL3RepaymentWidget: Widget {

    let kind =
        "SL3RepaymentWidget"
    var body: some WidgetConfiguration {

        StaticConfiguration(
            kind: kind,
            provider: SL3WidgetProvider()
        ) { entry in

            SmallWidgetView(
                entry: entry,
                mode: .repayments
            )
        }
        .configurationDisplayName(
            "Repayments"
        )
        .description(
            "See how many household repayments are pending."
        )
        .supportedFamilies([
            .systemSmall
        ])
    }
}

struct SL3SummaryWidget: Widget {

    let kind =
        "SL3SummaryWidget"
    var body: some WidgetConfiguration {

        StaticConfiguration(
            kind: kind,
            provider: SL3WidgetProvider()
        ) { entry in

            MediumWidgetView(
                entry: entry
            )
        }
        .configurationDisplayName(
            "Household Summary"
        )
        .description(
            "See chores and repayments together."
        )
        .supportedFamilies([
            .systemMedium
        ])
    }
}
