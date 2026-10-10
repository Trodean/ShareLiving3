//
//  SL3WidgetViews.swift
//  ShareLiving3
//
//  Created by Yang Peng on 10/10/2026.
//

import SwiftUI
import WidgetKit

private enum WidgetTheme {

    static let background = Color(
        red: 250 / 255,
        green: 247 / 255,
        blue: 240 / 255
    )

    static let green = Color(
        red: 0.24,
        green: 0.50,
        blue: 0.36
    )

    static let orange = Color(
        red: 0.88,
        green: 0.53,
        blue: 0.25
    )
}

enum SmallWidgetMode {
    case chores
    case repayments
}

struct SmallWidgetView: View {
    let entry: SL3WidgetEntry
    let mode: SmallWidgetMode

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 6
        ) {

            HStack(spacing: 6) {

                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(accentColor)

                Text("ShareLiving")
                    .font(.caption)
                    .fontWeight(.semibold)

                Spacer()
            }

            Spacer()

            HStack(
                alignment: .center,
                spacing: 10
            ) {

                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(accentColor)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(
                                accentColor.opacity(0.13)
                            )
                    )

                Text("\(value)")
                    .font(
                        .system(
                            size: 42,
                            weight: .bold,
                            design: .rounded
                        )
                    )
            }

            Text(title)
                .font(.headline)

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .containerBackground(
            WidgetTheme.background,
            for: .widget
        )
        .widgetURL(targetURL)
    }

    private var value: Int {
        switch mode {
        case .chores:
            return entry.dueChoreCount

        case .repayments:
            return entry.repaymentCount
        }
    }

    private var title: String {
        switch mode {
        case .chores:
            return "Chores Due"
        case .repayments:
            return "Repayments"
        }
    }

    private var icon: String {
        switch mode {
        case .chores:
            return "checkmark.square.fill"
        case .repayments:
            return "arrow.left.arrow.right.circle.fill"
        }
    }

    private var detail: String {
        switch mode {
        case .chores:
            return entry.dueChoreCount == 0
                ? "All caught up"
                : "Needs attention"
        case .repayments:
            return entry.repaymentCount == 0
                ? "Nothing pending"
                : "Transfers pending"
        }
    }

    private var accentColor: Color {
        switch mode {
        case .chores:
            return WidgetTheme.green
        case .repayments:
            return WidgetTheme.orange
        }
    }

    private var targetURL: URL? {
        switch mode {
        case .chores:
            return URL(
                string: "shareliving3://chores"
            )
        case .repayments:
            return URL(
                string: "shareliving3://expenses"
            )
        }
    }
}

struct MediumWidgetView: View {
    let entry: SL3WidgetEntry
    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack {

                HStack(spacing: 7) {

                    Image(systemName: "house.fill")
                        .foregroundStyle(
                            WidgetTheme.green
                        )

                    Text("ShareLiving")
                        .font(.headline)
                }

                Spacer()

                Text("Household Summary")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {

                Link(
                    destination: URL(
                        string:
                            "shareliving3://chores"
                    )!
                ) {

                    metricCard(
                        icon: "checkmark.square.fill",
                        value: entry.dueChoreCount,
                        title: "Chores Due",
                        detail:
                            entry.dueChoreCount == 0
                            ? "All caught up"
                            : "Needs attention",
                        color: WidgetTheme.green
                    )
                }

                Link(
                    destination: URL(
                        string:
                            "shareliving3://expenses"
                    )!
                ) {

                    metricCard(
                        icon:
                            "arrow.left.arrow.right.circle.fill",
                        value:
                            entry.repaymentCount,
                        title: "Repayments",
                        detail:
                            entry.repaymentCount == 0
                            ? "Nothing pending"
                            : "Transfers pending",
                        color:
                            WidgetTheme.orange
                    )
                }
            }
        }
        .containerBackground(
            WidgetTheme.background,
            for: .widget
        )
    }

    private func metricCard(
        icon: String,
        value: Int,
        title: String,
        detail: String,
        color: Color
    ) -> some View {

        HStack(
            alignment: .center,
            spacing: 10
        ) {

            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(color)
                .frame(
                    width: 34,
                    height: 34
                )
                .background(
                    Circle()
                        .fill(
                            color.opacity(0.13)
                        )
                )

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text("\(value)")
                    .font(
                        .system(
                            size: 30,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.primary)

                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
            .fill(
                color.opacity(0.08)
            )
        )
    }
}
