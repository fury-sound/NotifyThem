//
//  MainSenderViewModel.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import SwiftUI
import Combine

final class MainSenderViewModel: ObservableObject {
    @Published var wasRead: Bool = false
    @Published var receiverGroupList: [ReceiverGroup] = []
    @Published var receiverList: [Receiver] = []
//    @Published var messageCurrent: String = "No messages" {
//        didSet {
//            print("messageCurrent: \(messageCurrent)")
//        }
//    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    let newMessageArray: [MessageCore] = []
    let newReceiverArray: [Receiver] = []
//    @Published var editedGroupId: UInt = 0

    let message1 = MessageCore(id: 1, message: "Homework 1", senderID: 1, date: Date(), wasReceived: false)
    let message2 = MessageCore(id: 2, message: "Homework 2", senderID: 1, date: Date(), wasReceived: true)
    let message3 = MessageCore(id: 3, message: "Homework 3", senderID: 1, date: Date(), wasReceived: false)
    let message4 = MessageCore(id: 4, message: "Homework 4", senderID: 1, date: Date(), wasReceived: true)
    let receiver1 = Receiver(id: 11, name: "Alex")
    let receiver2 = Receiver(id: 12, name: "Jane")
    let receiver3 = Receiver(id: 14, name: "John")
    let receiver4 = Receiver(id: 15, name: "Jack")
    let receiver5 = Receiver(id: 16, name: "Alice")
//    let receiver1 = Receiver(id: 11, name: "Alex", messageGroup: [1])
//    let receiver2 = Receiver(id: 12, name: "Jane", messageGroup: [1, 2])
//    let receiver3 = Receiver(id: 14, name: "John", messageGroup: [1, 2])
//    let receiver4 = Receiver(id: 15, name: "Jack", messageGroup: [1])
//    let receiver5 = Receiver(id: 16, name: "Alice", messageGroup: [3])
    var receivers1: [Receiver] = []
    var receivers2: [Receiver] = []
    var receivers3: [Receiver] = []
    var messageGroup1: MessageGroup
    var messageGroup2: MessageGroup
    var messageGroup3: MessageGroup

    var receiverGroup1: ReceiverGroup
    var receiverGroup2: ReceiverGroup
    var receiverGroup3: ReceiverGroup

    init() {
        let messageGroupName1 = [message1, message2, message3]
        let messageGroupName2 = [message2, message3, message4]
        let messageGroupName3 = [message3, message4]
        messageGroup1 = MessageGroup(messageArray: messageGroupName1, dateCreated: Date.now)
        messageGroup2 = MessageGroup(messageArray: messageGroupName2, dateCreated: Date.now)
        messageGroup3 = MessageGroup(messageArray: messageGroupName3, dateCreated: Date.now)
        receivers1 = [receiver1, receiver2, receiver3, receiver4]
        receivers2 = [receiver2, receiver3]
        receivers3 = [receiver5]
        receiverGroup1 = ReceiverGroup(id: 100, name: "Student group 1", messageGroup: messageGroup1, receivers: receivers1)
        receiverGroup2 = ReceiverGroup(id: 101, name: "Student group 2", messageGroup: messageGroup2, receivers: receivers2)
        receiverGroup3 = ReceiverGroup(id: 102, name: "Student group 3", messageGroup: messageGroup3, receivers: receivers3)
//        receiverGroup1 = ReceiverGroup(id: 10, name: "Student group 1", receivers: receivers1)
//        receiverGroup2 = ReceiverGroup(id: 20, name: "Student group 2", receivers: receivers2)
//        receiverGroup3 = ReceiverGroup(id: 30, name: "Student group 3", receivers: receivers3)
        receiverList = [receiver1, receiver2, receiver3, receiver4, receiver5]
        receiverGroupList = [receiverGroup1, receiverGroup2, receiverGroup3]
    }

    func addNewMessage(_ message: String, to groupID: UInt) {
//        print("in addNewMessage")
//        group.messageArray.append(MessageCore(id: 222, message: message, senderID: 1, date: Date(), wasReceived: false))
        guard let index = receiverGroupList.firstIndex(where: {
            $0.id == groupID
        }) else { return }
//        print("1", receiverGroupList[index].messageGroup.messageArray.count)
        let newMessage = MessageCore(id: UInt(Int.random(in: 1000...9999)), message: message, senderID: 1, date: Date(), wasReceived: false)
        receiverGroupList[index].messageGroup.messageArray.insert(newMessage, at: 0)
//        print("2", receiverGroupList[index].messageGroup.messageArray.count)
        print("in addNewMessage current array:", receiverGroupList[index].messageGroup.messageArray.map { $0.message }.joined(separator: ", "))
    }

//    func loadLastMessage(group: MessageGroup) {
//        if let messageValue = group.messageArray.first {
//            print("messageValue.message", messageValue.message)
//            messageCurrent = messageValue.message
//        } else {
//            messageCurrent = "No message in the group"
//        }
//
//        //        messageCurrent = message1.message
//        //        if group.messageArray[0].message.isEmpty {
//        //            messageCurrent = group.messageArray[0].message
//    }

    func dateFormatted(date: Date) -> String {
        dateFormatter.string(from: date)
    }

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
        //            print("index", index)
        receiverList[index] = receiver
        print("in updateReceiver:", receiverList.map { $0.name }.joined(separator: ", "))
    }

    func addNewReceiver(_ name: String) {
        print("adding new person to receiverList: \(name)")
        let newReceiver = Receiver(id: UInt(Int.random(in: 20...100)), name: name)
        receiverList.append(newReceiver)
        print("in addNewReceiver:", receiverList.map { "\($0.id). \($0.name)" }.joined(separator: ", "))
    }

    func addNewReceiverGroup(_ name: String) {
        print("adding new group to receiverGroupList: \(name)")
        let newMessageGroup = MessageGroup(messageArray: newMessageArray, dateCreated: Date.now)
        let newGroup = ReceiverGroup(id: UInt(Int.random(in: 105...999)), name: name, messageGroup: newMessageGroup, receivers: newReceiverArray)
        receiverGroupList.append(newGroup)
    }

    func updateReceiverGroup(group: ReceiverGroup) {
//        print("update group")
//        let currentGroupId = group.id
//        print(receiverGroupList.firstIndex(of: group))
        guard let index = receiverGroupList.firstIndex(where: {
            $0.id == group.id
        }) else { return }
//            print("index", index)
            receiverGroupList[index] = group
    }

    func deleteReceiverGroup(_ group: ReceiverGroup) {
//        print("in deleteReceiverGroup, group.id: \(group.id)")
//        receiverGroupList.remove(at: Int(group.id))
        receiverGroupList.removeAll {
//            $0.name == group.name
            $0.id == group.id
        }
    }

    func deleteReceiver(_ receiver: Receiver) {
//        print("in deleteReceiver")
        for index in receiverGroupList.indices {
            receiverGroupList[index].receivers.removeAll {
                $0.id == receiver.id
            }
        }
        receiverList.removeAll {
            $0.id == receiver.id
        }
        print("in deleteReceiver:", receiverList.map { $0.name }.joined(separator: ", "))
    }

//    func deleteReceiverGroup() {
//        guard let indexSetToDelete else { return }
////        print("indexSetToDelete", indexSetToDelete.first)
//        receiverGroupList.remove(atOffsets: indexSetToDelete)
//    }

}
