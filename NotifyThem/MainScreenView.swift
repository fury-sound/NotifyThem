//
//  MainScreenView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 15.07.2026.
//

import SwiftUI

struct MainScreenView: View {
    var body: some View {
        TabView {
            MainSenderView()
                .tabItem {
                    Label("Sender", systemImage: "paperplane")
                }
            MainReceiverView()
                .tabItem {
                    Label("Receiver", systemImage: "person.crop.circle.badge.exclamationmark")
                }
        }
    }
}

#Preview {
    MainScreenView()
}
