//
//  MainReceiverView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 15.07.2026.
//

import SwiftUI

struct MainReceiverView: View {
    @StateObject private var viewModel = MainReceiverViewModel()
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
                            viewModel.setCurrentReceiverName(newName)
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
                Task { await viewModel.loadMessages() }
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
            await viewModel.loadMessages()
        }
    }
}

#Preview("messages") {
    MainReceiverView()
}
