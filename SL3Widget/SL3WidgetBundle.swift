//
//  SL3WidgetBundle.swift
//  SL3Widget
//
//  Created by Yang Peng on 9/10/2026.
//

import WidgetKit
import SwiftUI

@main
struct SL3WidgetBundle: WidgetBundle {
    var body: some Widget {
        SL3Widget()
        SL3WidgetControl()
        SL3WidgetLiveActivity()
    }
}
