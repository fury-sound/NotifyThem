//
//  OutgoingMessageView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import SwiftUI

struct OutgoingMessageView: View {
    @EnvironmentObject private var viewModel: MainSenderViewModel
    @State private var shownMessage: String = ""
    let groupID: UInt
    var group: ReceiverGroup? {
        viewModel.receiverGroupList.first { $0.id == groupID }
    }
    private var lastMessage: MessageCore? {
        group?.messageGroup.messageArray.first
    }
    private var messageToShow: String {
        lastMessage?.message ?? "No messages in the group"
    }
    private var messageArrayHistory: [MessageCore] {
        group?.messageGroup.messageArray ?? []
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Current message", systemImage: "star.fill")
                .labelStyle(.titleOnly)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)

            let dateFormattedShown = viewModel.dateFormatted(date: lastMessage?.date ?? Date())
            Text("\(dateFormattedShown)")
                .font(.headline)

            Text(messageToShow)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .font(.body)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

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
                        }
                    }
                }
            }
            Spacer()
            TextField("Enter message", text: $shownMessage)
                .padding(8)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.leading)
                .submitLabel(.send)
                .foregroundStyle(.tint)

                .onSubmit {
                    viewModel.addNewMessage(shownMessage, to: groupID)
                    shownMessage = ""
                }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .navigationBarTitle("Message to send")
        .navigationBarTitleDisplayMode(.inline)

    }
}


#Preview {
    NavigationStack {
        OutgoingMessageView(groupID: 1)
            .environmentObject(MainSenderViewModel())
    }
}
