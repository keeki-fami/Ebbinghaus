//
//  MyWidgetBundle.swift
//  MyWidgetExtension
//  
//  Created by keeki-fami on 2026/09/19
//  
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetControl()
//        MyWidgetLiveActivity()
    }
}

