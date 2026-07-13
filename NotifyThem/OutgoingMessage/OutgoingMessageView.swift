//
//  OutgoingMessageView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import SwiftUI

struct OutgoingMessageView: View {
    //    @StateObject private var viewModel = OutgoingMessageViewModel()
    @ObservedObject var viewModel: MainSenderViewModel
    @State private var shownMessage: String = ""
    //    @State var group: ReceiverGroup
    let groupID: UInt
    var group: ReceiverGroup? {
        viewModel.receiverGroupList.first { $0.id == groupID }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Current message", systemImage: "star.fill")
                .labelStyle(.titleOnly)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)

            let lastMessage = group?.messageGroup.messageArray.first
            let dateFormattedShown = viewModel.dateFormatted(date: lastMessage?.date ?? Date())
            Text("\(dateFormattedShown)")
                .font(.headline)

            //                Text("\(viewModel.messageCurrent)")
            let messageToShow = lastMessage?.message ?? "No messages in the group"
            Text(messageToShow)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .font(.body)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            let messageArrayHistory = group?.messageGroup.messageArray ?? []
            Form {
                Section("Message History") {
                    if messageArrayHistory.isEmpty {
                        Label("No history for the group", systemImage: "pencil.slash")
                            .font(.body)
                    } else {
                        ForEach(messageArrayHistory) { message in
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
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .navigationBarTitle("Message to send")
        .navigationBarTitleDisplayMode(.inline)
        Spacer()
        TextField("Enter message", text: $shownMessage)
            .padding(8)
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.leading)
            .submitLabel(.send)
            .foregroundStyle(.tint)

            .onSubmit {
                let previousMessage = group?.messageGroup.messageArray.first?.message ?? "No previous messages in the group"
                print("Предыдущий текст: \(previousMessage)")
                //                print("Предыдущий текст: \(viewModel.messageCurrent)")
                //                viewModel.messageCurrent = shownMessage
                //                let newMessageCore = MessageCore(id: 222, message: shownMessage, senderID: 1, date: Date(), wasReceived: false)
                //                group.messageGroup.messageArray.append(newMessageCore)
                //                viewModel.addNewMessage(shownMessage, to: group.id)
                viewModel.addNewMessage(shownMessage, to: groupID)
                shownMessage = ""
            }
        //            .task {
        //                viewModel.loadLastMessage(group: viewModel.group(by: group.id).messageGroup)
        //                viewModel.loadLastMessage(group: group?.messageGroup)
        //                print("group.receivers", group.receivers)
        //            }
    }
}



//#Preview {
//    NavigationStack {
//        OutgoingMessageView(group: .preview)
//    }
//}
