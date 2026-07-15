//
//  MainSenderModel.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import Foundation

struct MessageGroup: Codable, Hashable {
    var messageArray: [MessageCore]
    let dateCreated: Date
}

struct Receiver: Codable, Identifiable, Hashable {
    let id: UInt
    var name: String
}

struct ReceiverGroup: Codable, Hashable, Identifiable {
    let id: UInt
    var name: String
    var messageGroup: MessageGroup
    var receivers: [Receiver]
}

struct ReceiverGroupList: Codable, Identifiable, Hashable {
    let id: UUID
    var receiverGroups: [ReceiverGroup]
}

struct Sender: Codable, Identifiable {
    let id: UInt
    var name: String
}
