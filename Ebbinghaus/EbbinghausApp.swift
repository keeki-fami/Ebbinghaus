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
    @State var isOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if !isOnboarding {
                
            } else {
                ContentView()
            }
        }
        .modelContainer(for: [ProblemData.self, ProblemSet.self])
    }
}

struct OnboardingView: View {
    var body: some View {
        
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
