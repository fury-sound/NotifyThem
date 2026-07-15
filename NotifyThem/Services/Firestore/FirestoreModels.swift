//
//  FirestoreModels.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 13.07.2026.
//

import FirebaseFirestore

struct ReceiverDTO: Codable {
    let id: Int
    var name: String
}

struct ReceiverGroupDTO: Codable {
    let id: Int
    var name: String
    var receiverIds: [Int]
}

struct MessageGroupDTO: Codable {
    var dateCreated: Date
}

struct MessageDTO: Codable {
    var id: Int
    var message: String
    var senderID: Int?
    var senderName: String?
    var date: Date?
    var wasReceived: Bool
}
