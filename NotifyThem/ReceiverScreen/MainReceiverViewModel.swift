//
//  MainReceiverViewModel.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 15.07.2026.
//

import SwiftUI
import Combine

final class MainReceiverViewModel: ObservableObject {
    @Published var matchedReceivers: [Receiver] = []
    @Published var groups: [ReceiverGroupDTO] = []
    @Published var messages: [MessageCore] = []
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared
    var currentReceiverName = LocalReceiverStore.shared.load()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Main functions

    func getCurrentReceiverName() -> String {
        currentReceiverName
    }

    func setCurrentReceiverName(_ name: String) {
        LocalReceiverStore.shared.save(name)
        currentReceiverName = name
    }

    func loadMessages() async {
        let name = getCurrentReceiverName()
        guard name != "Receiver name", !name.isEmpty else {
            errorMessage = "Please, set receiver name"
            print("\(errorMessage ?? "Unknown error")")
            return
        }
        do {
            let foundReceivers = try await firestoreService.findReceivers(byName: name)
            guard let receiver = foundReceivers.first else {
                errorMessage = "Receiver \(name) not found"
                print("\(errorMessage ?? "Unknown error")")
                messages = []
                return
            }
            groups = try await firestoreService.fetchGroups(forReceiverID: receiver.id)
            guard !groups.isEmpty else {
                errorMessage = "Groups with receiver \(name) not found"
                messages = []
                return
            }
            var allMessages: [MessageCore] = []
            for group in groups {
                allMessages += try await firestoreService.fetchMessages(groupID: UInt(group.id))
            }
            messages = allMessages.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
        } catch {
            errorMessage = "Fail to load messages: \(error.localizedDescription)"
            print("\(errorMessage ?? "Unknown error")")
        }
    }

//    func searchReceiver(byName name: String) async {
//        do {
//            matchedReceivers = try await firestoreService.findReceivers(byName: name)
//        } catch {
//            errorMessage = "Receiver search error: \(error.localizedDescription)"
//            print("\(errorMessage ?? "Unknown error")")
//        }
//    }
//
//    func loadGroups(for receiver: Receiver) async {
//        do {
//            groups = try await firestoreService.fetchGroups(forReceiverID: receiver.id)
//        } catch {
//            errorMessage = "Groups loading error: \(error.localizedDescription)"
//            print("\(errorMessage ?? "Unknown error")")
//        }
//    }
//
//    func loadMessages(groupID: UInt) async {
//        do {
//            messages = try await firestoreService.fetchMessages(groupID: groupID)
//        } catch {
//            errorMessage = "Messages loading error: \(error.localizedDescription)"
//            print("\(errorMessage ?? "Unknown error")")
//        }
//    }

    // MARK: - Service functions

    func dateFormatted(date: Date) -> String {
        dateFormatter.string(from: date)
    }

}
