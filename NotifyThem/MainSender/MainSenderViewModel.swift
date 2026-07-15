//
//  MainSenderViewModel.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import SwiftUI
import Combine

@MainActor
final class MainSenderViewModel: ObservableObject {
    @Published var wasRead: Bool = false
    @Published var receiverGroupList: [ReceiverGroup] = []
    @Published var receiverList: [Receiver] = []
    @Published var errorMessage: String?
    private let firestoreService = FirestoreService.shared
    private let currentSender = LocalSenderStore.shared.load()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Initialization

    init() {
        Task { await loadInitialData() }
    }

    func loadInitialData() async {
        do {
            async let groups = firestoreService.fetchReceiverGroups()
            async let receivers = firestoreService.fetchReceivers()
            receiverGroupList = try await groups
            receiverList = try await receivers
        } catch {
            errorMessage = "Loading data error: \(error.localizedDescription)"
            print("\(errorMessage ?? "Unknown error")")
        }
    }

    // MARK: - Service functions

    func dateFormatted(date: Date) -> String {
        dateFormatter.string(from: date)
    }

    func isReceiverNameUnique(_ name: String, excludingID: UInt? = nil) async -> Bool {
        do {
            return try await firestoreService.receiverNameExists(name, excludingID: excludingID)
        } catch {
            return false
        }
    }

    func isReceiverGroupNameUnique(_ name: String, excludingID: UInt? = nil) async -> Bool {
        do {
            return try await firestoreService.groupNameExists(name, excludingID: excludingID)
        } catch {
            return false
        }
    }

    // MARK: - Messages

    func addNewMessage(_ message: String, to groupID: UInt) {
        guard let index = receiverGroupList.firstIndex(where: {
            $0.id == groupID
        }) else { return }
        let newMessage = MessageCore(
            id: UInt(Int.random(in: 1000...9999)),
            message: message,
            senderID: currentSender.id,
            date: Date(),
            wasReceived: false)
        receiverGroupList[index].messageGroup.messageArray.insert(newMessage, at: 0)
        Task {
            do {
                try await firestoreService.addMessage(newMessage, senderName: "Teacher", toGroupID: groupID)
            } catch {
                errorMessage = "New message creation error: \(error.localizedDescription)"
                print("\(errorMessage ?? "Unknown error")")
            }
        }
    }

    // MARK: - Receivers

    func updateReceiver(_ receiver: Receiver) {
        for groupIndex in receiverGroupList.indices {
            for index in receiverGroupList[groupIndex].receivers.indices {
                if receiverGroupList[groupIndex].receivers[index].id == receiver.id {
                    receiverGroupList[groupIndex].receivers[index].name = receiver.name
                }
            }
        }
        guard let index = receiverList.firstIndex(where: {
            $0.id == receiver.id
        }) else { return }
        receiverList[index] = receiver
        Task {
            do {
                try await firestoreService.updateReceiver(receiver)
            } catch {
                errorMessage = "Receiver update error: \(error.localizedDescription)"
                print("\(errorMessage ?? "Unknown error")")
            }
        }
    }

    func addNewReceiver(_ name: String) {
        let newReceiver = Receiver(id: UInt(Int.random(in: 20...100)), name: name)
        receiverList.append(newReceiver)
        Task {
            do {
                try await firestoreService.addReceiver(newReceiver)
            } catch {
                errorMessage = "Receiver adding error: \(error.localizedDescription)"
                print("\(errorMessage ?? "Unknown error")")
            }
        }
    }

    func deleteReceiver(_ receiver: Receiver) {
        for index in receiverGroupList.indices {
            receiverGroupList[index].receivers.removeAll {
                $0.id == receiver.id
            }
            updateReceiverGroup(group: receiverGroupList[index])
        }
        receiverList.removeAll {
            $0.id == receiver.id
        }
        Task {
            do {
                try await firestoreService.deleteReceiver(id: receiver.id)
            } catch {
                errorMessage = "Receiver deletion error: \(error.localizedDescription)"
                print("\(errorMessage ?? "Unknown error")")
            }
        }
    }

    // MARK: - ReceiverGroups

    func addNewReceiverGroup(_ name: String, receivers: [Receiver] = []) {
        let newMessageGroup = MessageGroup(messageArray: [], dateCreated: .now)
        let newGroup = ReceiverGroup(id: UInt(Int.random(in: 105...999)), name: name, messageGroup: newMessageGroup, receivers: receivers)
        receiverGroupList.append(newGroup)
        Task {
            do {
                try await firestoreService.createReceiverGroup(newGroup)
            } catch {
                errorMessage = "Receiver group creation error: \(error.localizedDescription)"
                print("\(errorMessage ?? "Unknown error")")
            }
        }
    }

    func updateReceiverGroup(group: ReceiverGroup) {
        guard let index = receiverGroupList.firstIndex(where: { $0.id == group.id }) else { return }
        receiverGroupList[index] = group
        Task {
            do {
                try await firestoreService.updateReceiverGroupReceivers(
                    groupID: group.id,
                    name: group.name,
                    receiverIds: group.receivers.map { $0.id }
                )
            } catch {
                errorMessage = "Receiver group update error: \(error.localizedDescription)"
                print("\(errorMessage ?? "Unknown error")")
            }
        }
    }

    func deleteReceiverGroup(_ group: ReceiverGroup) {
        receiverGroupList.removeAll { $0.id == group.id }
        Task {
            do {
                try await firestoreService.deleteReceiverGroup(id: group.id)
            } catch {
                errorMessage = "Receiver group deletion error: \(error.localizedDescription)"
                print("\(errorMessage ?? "Unknown error")")
            }
        }
    }
}
