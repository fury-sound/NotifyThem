//
//  NotifyThemApp.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import SwiftUI
import FirebaseCore

@main
struct NotifyThemApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @StateObject private var senderViewModel = MainSenderViewModel()

    init() {
        hasCompletedOnboarding = false
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainScreenView()
                    .environmentObject(senderViewModel)
            } else {
                OnboardingView()
            }
        }
    }
}
