//
//  SL3WidgetLiveActivity.swift
//  SL3Widget
//
//  Created by Yang Peng on 9/10/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SL3WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SL3WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SL3WidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SL3WidgetAttributes {
    fileprivate static var preview: SL3WidgetAttributes {
        SL3WidgetAttributes(name: "World")
    }
}

extension SL3WidgetAttributes.ContentState {
    fileprivate static var smiley: SL3WidgetAttributes.ContentState {
        SL3WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SL3WidgetAttributes.ContentState {
         SL3WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SL3WidgetAttributes.preview) {
   SL3WidgetLiveActivity()
} contentStates: {
    SL3WidgetAttributes.ContentState.smiley
    SL3WidgetAttributes.ContentState.starEyes
}
