//
//  EditGroupView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 09.07.2026.
//

import SwiftUI

struct EditGroupView: View {
    //    @ObservedObject var viewModel: MainSenderViewModel
    @State var editedGroup: ReceiverGroup
    @Environment(\.dismiss) var dismiss
    let receiverList: [Receiver]
    let onSaveGroup: (ReceiverGroup) -> Void
    //    let onAddGroup: (String) -> Void
    var availableReceivers: [Receiver] {
        return receiverList.filter { receiver in
            !editedGroup.receivers.contains { $0.id == receiver.id }
        }
    }

    init(
    receiverList: [Receiver],
    group: ReceiverGroup,
    onSave: @escaping (ReceiverGroup) -> Void
    ) {
        self.receiverList = receiverList
        _editedGroup = State(initialValue: group)
        self.onSaveGroup = onSave
//        print("editedGroup.receivers.count", editedGroup.receivers.count)
    }

    var body: some View {
        Form {
            Section("Group Name") {
                TextField("Name:", text: $editedGroup.name)
            }
            Section("Group Members") {
                if editedGroup.receivers.isEmpty {
                    Label("Empty group", systemImage: "person.2.slash")
                } else {
                    ForEach(editedGroup.receivers) { receiver in
                        Label(receiver.name, systemImage: "person.fill")
//                        Text(editedGroup.receivers.map { "\($0.id). \($0.name)" }.joined(separator: ", "))
                    }
                    .onDelete { indexSet in
                        editedGroup.receivers.remove(atOffsets: indexSet)
//                        print("in EditGroupView - editedGroup.receivers", editedGroup.receivers)
                    }
                }
            }
            Section("Add Members") {
                Menu {
                    Section("Available Members") {
                        if availableReceivers.isEmpty {
                            Label("Empty group", systemImage: "person.2.slash")
                        } else {
                            ForEach(availableReceivers) { receiver in
                                Button {
                                    editedGroup.receivers.append(receiver)
                                } label: {
                                    Label(receiver.name, systemImage: "person.fill")
                                }
                            }
                        }
                    }
                } label: {
                    Label("Add Member", systemImage: "person.fill.badge.plus")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
        }
        .navigationTitle("Edit Group")
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear() {
//            print("On Appear receiverList", receiverList.map(\.name))
//            print("On Appear availableReceivers", availableReceivers.map(\.name))
//        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSaveGroup(editedGroup)
                    dismiss()
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .disabled(editedGroup.name.isEmpty)
            }
        }
    }
}

#Preview {
    let viewModel = MainSenderViewModel()

    let receiver1 = Receiver(id: 11, name: "Alex")
    let receiver2 = Receiver(id: 12, name: "Jane")
    let message1 = MessageCore(id: 1, message: "Homework 1", senderID: 1, date: Date(), wasReceived: false)
    let message2 = MessageCore(id: 2, message: "Homework 2", senderID: 1, date: Date(), wasReceived: true)
    let message3 = MessageCore(id: 3, message: "Homework 3", senderID: 1, date: Date(), wasReceived: false)
    let messageGroupName1 = [message1, message2, message3]
    NavigationStack {
        EditGroupView(
            receiverList: viewModel.receiverList,
            group: ReceiverGroup(
                id: 111,
                name: "Friends", messageGroup:  MessageGroup(messageArray: messageGroupName1, dateCreated: Date.now),
                receivers: []
                //                receivers: [receiver1, receiver2]
            ),
            onSave: { updatedGroup in
                print("New Group Name:", updatedGroup.name)
                print("Updated student list")
                updatedGroup.receivers.forEach { print($0.name) }
            }
        )
    }
}

//#Preview {
//    EditGroupView(editedGroup: .constant())
//}
