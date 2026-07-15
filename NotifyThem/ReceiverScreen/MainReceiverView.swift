//
//  MainReceiverView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 15.07.2026.
//

import SwiftUI

struct MainReceiverView: View {
    @StateObject private var viewModel = MainReceiverViewModel()
//    let messages: [MessageCore]
//    @State private var receiverName: String = "Receiver name"
//    @Binding private var receiverName: String = "Receiver name"
    @State private var isChangingName: Bool = false
    @State private var shownMessage: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .center, spacing: 8) {
                Label(viewModel.currentReceiverName, systemImage: "person")
                Button {
                    isChangingName = true
                } label: {
                    Text("Edit name")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.bordered)
                .sheet(isPresented: $isChangingName) {
                    NavigationStack {
                        EditReceiverView(editedName: viewModel.currentReceiverName) { newName in
//                            self.receiverName = newName
                            viewModel.setCurrentReceiverName(newName)
//                            print("self.receiverName", self.receiverName)
                            print("self.receiverName", viewModel.currentReceiverName)
                            Task { await viewModel.loadMessages() }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Label("Latest message", systemImage: "star.fill")
                .labelStyle(.titleOnly)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            let latestMessage = viewModel.messages.first
            let dateFormattedShown = viewModel.dateFormatted(date: latestMessage?.date ?? Date())
            Text("\(dateFormattedShown)")
                .font(.caption)

            let messageToShow = latestMessage?.message ?? "No messages yet. Check and edit receiver name, press reload."
            Text(messageToShow)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .font(.body)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Form {
                Section("Message History") {
                    if viewModel.messages.isEmpty {
                        Label("No history yet. Check and edit receiver name, press reload.", systemImage: "pencil.slash")
                            .font(.body)
                    } else {
                        ForEach(viewModel.messages) { message in
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
                        }
                    }
                }
            }
            Button {
//                print("Reload messages")
                Task { await viewModel.loadMessages() }
                //                    ReceiverView(viewModel: viewModel)
            } label: {
                Label("Load messages", systemImage: "tray.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.accentColor)
        }
        .padding()
        .alert(
            "App Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented { viewModel.errorMessage = nil }
                }
            )
        ) {
            Button("OK", role: .cancel ) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task {
//            self.receiverName = viewModel.getCurrentReceiverName()
            await viewModel.loadMessages()
//            print("current receiver name in viewModel:", viewModel.currentReceiverName)
//            self.receiverName = viewModel.getCurrentReceiverName()
//            await viewModel.loadMessages()
//            print("receiverName", receiverName)
        }
    }
}

#Preview("messages") {
//    let message1 = MessageCore(id: 1, message: "Homework 1", senderID: 1, date: Date(), wasReceived: false)
//    let message2 = MessageCore(id: 2, message: "Homework 2", senderID: 1, date: Date(), wasReceived: true)
//    let message3 = MessageCore(id: 3, message: "Homework 3", senderID: 1, date: Date(), wasReceived: false)
//    let message4 = MessageCore(id: 4, message: "Homework 4", senderID: 1, date: Date(), wasReceived: true)
//    let messageGroupName = [message1, message2, message3]
//    let messageGroupName2 = [message2, message3, message4]
//    let messageGroupName3 = [message3, message4]
//    let messageGroup1 = MessageGroup(messageArray: messageGroupName1, dateCreated: Date.now)
//    MainReceiverView(messages: messageGroupName)
    MainReceiverView()
}

//#Preview("no messages") {
//    let messageGroupName: [MessageCore] = []
////    let messageGroupName2 = [message2, message3, message4]
////    let messageGroupName3 = [message3, message4]
////    let messageGroup1 = MessageGroup(messageArray: messageGroupName1, dateCreated: Date.now)
//    MainReceiverView()
//}
