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
                OnboardingView()
                    .task {
                        do {
                            try await Task.sleep(nanoseconds: 3000000000)
                        } catch {
                            print("error: \(error)")
                        }
                        isOnboarding = true
                    }
            } else {
                ContentView()
            }
        }
        .modelContainer(for: [ProblemData.self, ProblemSet.self])
    }
}

struct OnboardingView: View {
    let opacityList = [0.25, 0.50, 0.75, 1]
    @State private var isAppeared = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue.opacity(0.1))
            .ignoresSafeArea()
            Image("Ebbinghaus_logo")
                .opacity(isAppeared ? 1 : 0)
        }
        .onAppear() {
            isAppeared = true
        }
    }
}

#Preview {
    OnboardingView()
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

