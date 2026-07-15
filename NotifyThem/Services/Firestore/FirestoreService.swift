//
//  FirestoreService.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 13.07.2026.
//

import FirebaseFirestore

enum FirestoreError: Error {
    case invalidDocumentId(String)
    var errorDescription: String? {
        switch self {
            case .invalidDocumentId(let id):
                return "Повреждённые данные: Невалидный ID документа: \(id)"
        }
    }
}

final class FirestoreService {
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    private init() {}

    // MARK: - Receivers

    func fetchReceivers() async throws -> [Receiver] {
        let query = db.collection("receivers")
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.compactMap { document in
            let dto = try document.data(as: ReceiverDTO.self)
            return Receiver(id: UInt(dto.id), name: dto.name)
        }
//        return try snapshot.documents.map { document in
//            let dto = try document.data(as: ReceiverDTO.self)
//            guard let id = UInt(dto.id) else {
////                throw FirestoreError.invalidDocumentId(document.documentID)
//            }
//        return try snapshot.documents.compactMap { document in
//            let dto = try document.data(as: ReceiverDTO.self)
//            guard let id = UInt(dto.id) else {
//                print("⚠️ Невалидный ID в документе: \(dto.id)")
//                return nil
//            }
//            return Receiver(id: id, name: dto.name)
//        }
    }

    func addReceiver(_ receiver: Receiver) async throws {
        let dto = ReceiverDTO(id: Int(receiver.id), name: receiver.name)
        try await db.collection("receivers")
            .document(String(receiver.id))
            .setDataAsync(from: dto)
    }

    func updateReceiver(_ receiver: Receiver) async throws {
        try await db.collection("receivers")
            .document(String(receiver.id))
            .updateData(["name": receiver.name])
    }

    func deleteReceiver(id: UInt) async throws {
        try await db.collection("receivers")
            .document(String(id))
            .delete()
    }

    func fetchReceivers(withIDs ids: [Int]) async throws -> [Receiver] {
        guard !ids.isEmpty else { return [] }
        var result: [Receiver] = []
        for chunk in ids.chunked(into: 30) {
//            print("chunk.count", chunk.count)
            let snapshot = try await db.collection("receivers")
                .whereField("id", in: chunk)
                .getDocuments()
            // temp
//            print("in fetchReceivers - snapshot.documents.count", snapshot.documents.count)
//            for document in snapshot.documents {
//                print(document.documentID)
//                print(document.data())
//            }
            // end temp
            result += try snapshot.documents.map { document -> Receiver in
                let dto = try document.data(as: ReceiverDTO.self)
                return Receiver(id: UInt(dto.id), name: dto.name)
            }
//            print("in fetchReceivers - result.count", result.count)
        }
        return result
    }

    // MARK: - ReceiverGroup

    func createReceiverGroup(_ group: ReceiverGroup) async throws {
        // DTO для документов в БД (receiverGroups/{id} и messageGroups/{id}) - одинаковый id
        let groupDTO = ReceiverGroupDTO(id: Int(group.id), name: group.name, receiverIds: group.receivers.map { Int($0.id) } )
        let messageGroupDTO = MessageGroupDTO(dateCreated: group.messageGroup.dateCreated)
        // Ссылки на документы для БД
        let groupRef = db.collection("receiverGroups").document(String(group.id))
        let messageGroupRef = db.collection("messageGroups").document(String(group.id))
        // batch (атомарная) операция: либо создаем и группу записей, и группу сообщений для нее, либо ни то, ни другое
        let batch = db.batch()
        try batch.setData(from: groupDTO, forDocument: groupRef)
        try batch.setData(from: messageGroupDTO, forDocument: messageGroupRef)
        try await batch.commit()
    }

    func deleteReceiverGroup(id: UInt) async throws {
        print("3. In deleteReceiverGroup")
        let groupRef = db.collection("receiverGroups").document(String(id))
        let messageGroupRef = db.collection("messageGroups").document(String(id))
        let messageSnapshot = try await messageGroupRef.collection("messages").getDocuments()
        
        let batch = db.batch()
        for document in messageSnapshot.documents {
            batch.deleteDocument(document.reference)
        }
        batch.deleteDocument(groupRef)
        batch.deleteDocument(messageGroupRef)
        try await batch.commit()
//        print("3. In deleteReceiverGroup", try? await fetchReceiverGroups().map { "\($0.id). \($0.name)" }.joined(separator: ", "))
    }

    func fetchReceiverGroupsRaw() async throws -> [ReceiverGroupDTO] {
        let query = db.collection("receiverGroups")
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.map { try $0.data(as: ReceiverGroupDTO.self) }
    }

    func updateReceiverGroupReceivers(groupID: UInt, name: String, receiverIds: [UInt]) async throws {
        let dto = ReceiverGroupDTO(
            id: Int(groupID),
            name: name,
            receiverIds: receiverIds.map { Int($0) } 
        )
        try await db.collection("receiverGroups")
            .document(String(groupID))
            .setDataAsync(from: dto, merge: true)
    }

    // MARK: - Messages

    func fetchMessages(groupID: UInt) async throws -> [MessageCore] {
        let query = db.collection("messageGroups").document(String(groupID)).collection("messages").order(by: "date", descending: true)
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.map { document in
            let dto = try document.data(as: MessageDTO.self)
            return MessageCore(id: UInt(dto.id), message: dto.message, senderID: dto.senderID.map { UInt($0) }, date: dto.date, wasReceived: dto.wasReceived
            )
        }
    }

    func addMessage(_ message: MessageCore, senderName: String, toGroupID groupID: UInt) async throws {
        let dto = MessageDTO(
            id: Int(message.id),
            message: message.message,
            senderID: message.senderID.map { Int($0) },
            senderName: senderName,
            date: message.date,
            wasReceived: message.wasReceived
        )
        // документ записывается в подколлекцию messageGroups/{groupID}/messages/{id}
        // id сообщения используется как id документа
        let query = db.collection("messageGroups").document(String(groupID)).collection("messages").document(String(message.id))
        try await query.setDataAsync(from: dto)
    }

    func fetchReceiverGroups() async throws -> [ReceiverGroup] {
        let groupDTOs = try await fetchReceiverGroupsRaw()
        var result: [ReceiverGroup] = []
        for dto in groupDTOs {
            async let receivers = fetchReceivers(withIDs: dto.receiverIds)
            async let messages = fetchMessages(groupID: UInt(dto.id))
            async let messageGroupSnapshot = db.collection("messageGroups").document(String(dto.id)).getDocument()
//            print("dto in fetchReceiverGroups", dto.id, "\(type(of: dto.id))", dto.name)
//            print("dto.receiverIds in fetchReceiverGroups", dto.receiverIds)
//            print("in fetchReceiverGroups receivers.count", try? receivers.count, try? receivers.first?.id, try? receivers.first?.name)
//            print("messages.count", messages.count)
//            print("messageGroupSnapshot.count", messageGroupSnapshot.)
            let messageGroupDTO = try await messageGroupSnapshot.data(as: MessageGroupDTO.self)
            let messageGroup = MessageGroup(
                messageArray: try await messages, dateCreated: messageGroupDTO.dateCreated
            )
            result.append(
                ReceiverGroup(id: UInt(dto.id), name: dto.name, messageGroup: messageGroup, receivers: try await receivers)
            )
        }
        return result
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension DocumentReference {
    func setDataAsync<T: Encodable>(from value: T, merge: Bool = false) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                try self.setData(from: value, merge: merge) { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

// MARK: - functions for receivers

extension FirestoreService {
    func findReceivers(byName name: String) async throws -> [Receiver] {
        let query = db.collection("receivers")
        let snapshot = try await query.whereField("name", isEqualTo: name).getDocuments()
        return try snapshot.documents.map { document in
            let dto = try document.data(as: ReceiverDTO.self)
            return Receiver(id: UInt(dto.id), name: dto.name)
        }
    }

    func fetchGroups (forReceiverID receiverID: UInt) async throws -> [ReceiverGroupDTO] {
        let query = db.collection("receiverGroups")
        let snapshot = try await query.whereField("receiverIds", arrayContains: Int(receiverID)).getDocuments()
        return try snapshot.documents.map { try $0.data(as: ReceiverGroupDTO.self) }
    }

}
