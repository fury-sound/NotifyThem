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
//            ContentView()
//            MainReceiverView()
//            MainSenderView()
//                .environmentObject(senderViewModel)
//                .environmentObject(MainSenderViewModel())
        }
    }
}

// initialization code from FireBase
//import SwiftUI
//import FirebaseCore
//
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//
//        return true
//    }
//}
//
//@main
//struct YourApp: App {
//    // register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//
//    var body: some Scene {
//        WindowGroup {
//            NavigationView {
//                ContentView()
//            }
//        }
//    }
//}
