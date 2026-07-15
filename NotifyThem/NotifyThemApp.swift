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
    @StateObject private var senderViewModel = MainSenderViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environmentObject(senderViewModel)
        }
    }
}
