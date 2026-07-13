//
//  OutgoingMessageViewModel.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import SwiftUI
import Combine

final class OutgoingMessageViewModel: ObservableObject {
    @Published var messageCurrent: String = "No messages"

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

//    let message1 = MessageCore(id: 1,
//                               message: "Homework 1 Homework 1 Homework 1 Homework 1 Homework 1 Homework 1 ",
//                               senderID: 1,
//                               date: Date(),
//                               wasReceived: false)
//    let message2 = MessageCore(id: 2, message: "Homework 2", senderID: 1, date: Date(), wasReceived: true)
//    let message3 = MessageCore(id: 3, message: "Homework 3", senderID: 1, date: Date(), wasReceived: false)
//    let message4 = MessageCore(id: 4, message: "Homework 4", senderID: 1, date: Date(), wasReceived: true)

    func addNewMessage(message: String, group: MessageGroup) {
//        group.messageArray.append(MessageCore(id: 222, message: message, senderID: 1, date: Date(), wasReceived: false))

    }

    func loadLastMessage(group: MessageGroup) {
        if let messageValue = group.messageArray.first {
            print("messageValue.message", messageValue.message)
            messageCurrent = messageValue.message
        } else {
            messageCurrent = "No message in the group"
        }

//        messageCurrent = message1.message
//        if group.messageArray[0].message.isEmpty {
//            messageCurrent = group.messageArray[0].message
    }

    func dateFormatted(date: Date) -> String {
        dateFormatter.string(from: date)
    }




}
