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
//    @Published var groups: [ReceiverGroupDTO] = []
    @Published var messages: [MessageCore] = []
    @Published var errorMessage: String?
    @Published private(set) var loadingState: LoadingState = .loading

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
        loadingState = .loading
        errorMessage = nil

        let name = getCurrentReceiverName()
        guard name != "Receiver name", !name.isEmpty else {
            errorMessage = "Please, set receiver name"
            print("\(errorMessage ?? "Unknown error")")
//            messages = []
            loadingState = .loaded
            return
        }

        do {
            let foundReceivers = try await firestoreService.findReceivers(byName: name)
            guard let receiver = foundReceivers.first else {
                errorMessage = "Receiver \(name) not found"
                print("\(errorMessage ?? "Unknown error")")
//                messages = []
                loadingState = .loaded
                return
            }
            let groups = try await firestoreService.fetchGroups(forReceiverID: receiver.id)
            guard !groups.isEmpty else {
                errorMessage = "Groups with receiver \(name) not found"
//                messages = []
                return
            }
            var allMessages: [MessageCore] = []
            for group in groups {
                allMessages += try await firestoreService.fetchMessages(groupID: UInt(group.id))
            }
            messages = allMessages.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
            loadingState = .loaded
        } catch {
            loadingState = .failed
            errorMessage = "Fail to load messages: \(error.localizedDescription)"
            print("\(errorMessage ?? "Unknown error")")
        }
    }

    // MARK: - Service functions

    func dateFormatted(date: Date) -> String {
        dateFormatter.string(from: date)
    }

}

/*
 func loadMessages() async {
 loadingState = .loading
 errorMessage = nil

 let name = getCurrentReceiverName()
 guard name != "Receiver name", !name.isEmpty else {
 errorMessage = "Please, set receiver name"
 print("\(errorMessage ?? "Unknown error")")
 messages = []
 loadingState = .loaded
 return
 }

 do {
 let foundReceivers = try await firestoreService.findReceivers(byName: name)
 guard let receiver = foundReceivers.first else {
 errorMessage = "Receiver \(name) not found"
 print("\(errorMessage ?? "Unknown error")")
 messages = []
 loadingState = .loaded
 return
 }
 let groups = try await firestoreService.fetchGroups(forReceiverID: receiver.id)
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
 loadingState = .loaded
 } catch {
 loadingState = .failed
 errorMessage = "Fail to load messages: \(error.localizedDescription)"
 print("\(errorMessage ?? "Unknown error")")
 }
 }
 */

/*
 func loadMessages() async {

 loadingState = .loading

 do {
 let name = getCurrentReceiverName()
 guard name != "Receiver name", !name.isEmpty else {
 errorMessage = "Please, set receiver name"
 print("\(errorMessage ?? "Unknown error")")
 return
 }
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
 loadingState = .loaded
 } catch {
 loadingState = .failed
 errorMessage = "Fail to load messages: \(error.localizedDescription)"
 print("\(errorMessage ?? "Unknown error")")
 }
 }
 */
