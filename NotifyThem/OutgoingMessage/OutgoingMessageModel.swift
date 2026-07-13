//
//  OutgoingMessageModel.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import Foundation

struct MessageCore: Codable, Identifiable, Hashable {
    //    let id: UUID
    let id: UInt
    let message: String
    let senderID: UInt?
    let date: Date?
    let wasReceived: Bool
}
