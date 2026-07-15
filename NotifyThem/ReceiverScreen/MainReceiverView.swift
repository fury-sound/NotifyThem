//
//  MainReceiverView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 15.07.2026.
//

import SwiftUI

struct MainReceiverView: View {
    @StateObject private var viewModel = MainReceiverViewModel()
    let messages: [MessageCore]
    @State private var receiverName: String = "Default"

    @State private var shownMessage: String = ""
    //    @State var group: ReceiverGroup
    //    let groupID: UInt
    //    var group: ReceiverGroup? {
    //        viewModel.receiverGroupList.first { $0.id == groupID }
    //    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Label("Receiver", systemImage: "person.fill")
                Text(receiverName)
            }
            .labelStyle(.automatic)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)

            Label("Latest message", systemImage: "star.fill")
                .labelStyle(.titleOnly)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)

            let latestMessage = messages.first
            let dateFormattedShown = viewModel.dateFormatted(date: latestMessage?.date ?? Date())
            Text("\(dateFormattedShown)")
                .font(.headline)

            let messageToShow = latestMessage?.message ?? "No messages yet"
            Text(messageToShow)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .font(.body)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Form {
                Section("Message History") {
                    if messages.isEmpty {
                        Label("No history yet", systemImage: "pencil.slash")
                            .font(.body)
                    } else {
                        ForEach(messages) { message in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(viewModel.dateFormatted(date: message.date ?? Date()))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                HStack(alignment: .top) {
                                    Image(systemName: "tray.full")
                                    Text(message.message)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.body)
                                }
                            }
                            .padding(8)
                            .background(.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            //                            Label(message.message, systemImage: "tray.full")
                            //                                .font(.body)
                        }
                        //                        .onDelete { indexSet in
                        //                            editedGroup.receivers.remove(atOffsets: indexSet)
                        //                            print(editedGroup.receivers)
                        //                        }
                    }
                }
            }
        }
        .padding()

        //            .task {
        //                viewModel.loadLastMessage(group: viewModel.group(by: group.id).messageGroup)
        //                viewModel.loadLastMessage(group: group?.messageGroup)
        //                print("group.receivers", group.receivers)
        //            }
    }
}

#Preview {
    let message1 = MessageCore(id: 1, message: "Homework 1", senderID: 1, date: Date(), wasReceived: false)
    let message2 = MessageCore(id: 2, message: "Homework 2", senderID: 1, date: Date(), wasReceived: true)
    let message3 = MessageCore(id: 3, message: "Homework 3", senderID: 1, date: Date(), wasReceived: false)
    let message4 = MessageCore(id: 4, message: "Homework 4", senderID: 1, date: Date(), wasReceived: true)
    let messageGroupName1 = [message1, message2, message3]
//    let messageGroupName2 = [message2, message3, message4]
//    let messageGroupName3 = [message3, message4]
//    let messageGroup1 = MessageGroup(messageArray: messageGroupName1, dateCreated: Date.now)
    MainReceiverView(messages: messageGroupName1)
}
