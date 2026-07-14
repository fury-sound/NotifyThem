//
//  LocalSenderStore.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 14.07.2026.
//

import Foundation

final class LocalSenderStore {
    static let shared = LocalSenderStore()
    private let key = "currentSender"
    private init() {}

    func save(_ sender: Sender) {
        guard let data = try? JSONEncoder().encode(sender) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() -> Sender {
        if let data = UserDefaults.standard.data(forKey: key),
           let sender = try? JSONDecoder().decode(Sender.self, from: data) {
            return sender
        }
        let defaultSender = Sender(id: 1, name: "Teacher")
        save(defaultSender)
        return defaultSender
    }

}
