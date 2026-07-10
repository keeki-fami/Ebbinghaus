//
//  EbbinghausApp.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/08.
//

import SwiftUI
import SwiftData

@main
struct EbbinghausApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ProblemData.self, ProblemSet.self])
    }
}
