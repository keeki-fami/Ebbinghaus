//
//  EbbinghausApp.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/08.
//

import SwiftUI
import SwiftData
import SwiftData

@main
struct EbbinghausApp: App {
    
    @UIApplicationDelegateAdaptor(MyAppleDelegate.self) var appleDelegate: MyAppleDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ProblemData.self, ProblemSet.self])
    }
}

class MyAppleDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print("failed: \(error.localizedDescription)")
            }
        }
        return true
    }
}
