//
//  SL3Widget.swift
//  SL3Widget
//
//  Created by Yang Peng on 9/10/2026.
//

import WidgetKit
import SwiftUI

struct SL3WidgetEntry: TimelineEntry{
    let date: Date
    let dueChoreCount: Int
    let repaymentCount: Int
}

struct SL3WidgetProvider: TimelineProvider{

    func placeholder(
        in context: Context
    ) -> SL3WidgetEntry {
        SL3WidgetEntry(
            date: Date(),
            dueChoreCount: 2,
            repaymentCount: 3
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SL3WidgetEntry) -> Void
    ) {
        let entry = SL3WidgetEntry(
            date: Date(),
            dueChoreCount: SharedWidgetData.dueChoreCount(),
            repaymentCount: SharedWidgetData.repaymentCount()
        )
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SL3WidgetEntry>) -> Void
    ) {
        let entry = SL3WidgetEntry(
            date: Date(),
            dueChoreCount: SharedWidgetData.dueChoreCount(),
            repaymentCount: SharedWidgetData.repaymentCount()
        )

        let nextUpdate = Calendar.current.date(
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
}

struct SL3WidgetEntryView: View {
    @Environment(\.widgetFamily)
    private var family

    let entry: SL3WidgetEntry

    var body: some View {
        switch family {
        case .systemMedium:
            mediumWidget
        default:
            smallWidget
        }
    }

    private var smallWidget: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            HStack {
                Image(systemName: "house.fill")

                Text("ShareLiving")
                    .font(.headline)
            }
            Spacer()
            Text("\(entry.dueChoreCount)")
                .font(.system(
                    size: 38,
                    weight: .bold
                ))
            Text(
                entry.dueChoreCount == 1
                    ? "Chore Due"
                    : "Chores Due"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Spacer()
            Label(
                "\(entry.repaymentCount) repayments",
                systemImage: "arrow.left.arrow.right"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }

    private var mediumWidget: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            HStack {
                Image(systemName: "house.fill")

                Text("ShareLiving")
                    .font(.headline)

                Spacer()
                Text("Household")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                widgetStat(
                    title: "Chores Due",
                    value: entry.dueChoreCount,
                    icon: "checkmark.square"
                )
                Divider()
                widgetStat(
                    title: "Repayments",
                    value: entry.repaymentCount,
                    icon: "arrow.left.arrow.right"
                )
            }
        }
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }

    private func widgetStat(
        title: String,
        value: Int,
        icon: String
    ) -> some View {
        HStack(spacing: 10) {

            Image(systemName: icon)
                .font(.title2)

            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

struct SL3Widget: Widget {

    let kind = "SL3Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: SL3WidgetProvider()
        ) { entry in
            SL3WidgetEntryView(
                entry: entry
            )
        }
        .configurationDisplayName(
            "ShareLiving"
        )
        .description(
            "View household chores and repayment status."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}
