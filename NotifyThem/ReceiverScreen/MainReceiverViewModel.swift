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
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Main functions

    func searchReceiver(byName name: String) async {
        do {
            matchedReceivers = try await firestoreService.findReceivers(byName: name)
        } catch {
            errorMessage = "Receiver search error: \(error.localizedDescription)"
            print("\(errorMessage ?? "Unknown error")")
        }
    }

    func loadGroups(for receiver: Receiver) async {
        do {
            groups = try await firestoreService.fetchGroups(forReceiverID: receiver.id)
        } catch {
            errorMessage = "Groups loading error: \(error.localizedDescription)"
            print("\(errorMessage ?? "Unknown error")")
        }
    }

    func loadMessages(groupID: UInt) async {
        do {
            messages = try await firestoreService.fetchMessages(groupID: groupID)
        } catch {
            errorMessage = "Messages loading error: \(error.localizedDescription)"
            print("\(errorMessage ?? "Unknown error")")
        }
    }

    // MARK: - Service functions

    func dateFormatted(date: Date) -> String {
        dateFormatter.string(from: date)
    }

}
