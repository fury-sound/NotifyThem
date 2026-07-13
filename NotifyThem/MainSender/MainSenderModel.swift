//
//  MainSenderModel.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import Foundation

struct MessageGroup: Codable, Hashable {
//    let id: UUID
    var messageArray: [MessageCore]
    let dateCreated: Date
}

struct Receiver: Codable, Identifiable, Hashable {
    let id: UInt
    var name: String
//    let lastName: String?
//    let photo: String?
//    let email: String?
//    let isActive: Bool
}

struct ReceiverGroup: Codable, Hashable, Identifiable {
//    let id: String
    let id: UInt
    var name: String
    var messageGroup: MessageGroup
    var receivers: [Receiver]
//    let dateCreated: Date
//    let isActive: Bool
}

struct ReceiverGroupList: Codable, Identifiable, Hashable {
    let id: UUID
    var receiverGroups: [ReceiverGroup]
}

struct Sender: Codable, Identifiable {
    let id: UInt
    var name: String
    //    let name: String?
    //    let lastName: String?
    //    let photo: String?
    //    let email: String?
    //    let isActive: Bool
}
