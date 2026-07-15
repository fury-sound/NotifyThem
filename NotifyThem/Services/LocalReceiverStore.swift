//
//  LocalReceiverStore.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 15.07.2026.
//

import Foundation

final class LocalReceiverStore {
    static let shared = LocalReceiverStore()
    private let key = "currentReceiverName"
    private init() {}

    func save(_ receiver: String) {
        UserDefaults.standard.set(receiver, forKey: key)
    }

    func load() -> String {
        UserDefaults.standard.string(forKey: key) ?? "No name is stored"
    }

}

