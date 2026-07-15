//
//  EditPersonView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 12.07.2026.
//

import SwiftUI

struct EditPersonView: View {
    @EnvironmentObject private var viewModel: MainSenderViewModel
    @Environment(\.dismiss) var dismiss
    private let originalReceiver: Receiver
    @State private var name: String
    @State private var showDuplicateAlert: Bool = false
    @State private var isChecking: Bool = false
    let onSaveReceiver: (Receiver) -> Void

    init(receiver: Receiver, onSave: @escaping (Receiver) -> Void) {
        self.originalReceiver = receiver
        _name = State(initialValue: receiver.name)
        self.onSaveReceiver = onSave
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func checkAndSave() async {
        guard trimmedName != originalReceiver.name else {
            var tempReceiver = originalReceiver
            tempReceiver.name = trimmedName
            onSaveReceiver(tempReceiver)
            dismiss()
            return
        }
        isChecking = true
        defer { isChecking = false }

        if await viewModel.isReceiverNameUnique(trimmedName, excludingID: originalReceiver.id) {
            showDuplicateAlert = true
        } else {
            var tempReceiver = originalReceiver
            tempReceiver.name = trimmedName
            onSaveReceiver(tempReceiver)
            dismiss()
        }
    }

    var body: some View {
        Form {
            Section("Person Name") {
                TextField("Edit person name", text: $name)
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task { await checkAndSave() }
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .disabled(trimmedName.isEmpty || isChecking)
            }
        }
        .alert("Such name already exists", isPresented: $showDuplicateAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("There is already a receiver with this name \(trimmedName). You can't add a receiver with the same name twice.")
        }
    }
}

#Preview {
    let receiver = Receiver(id: 11, name: "Alex")
    NavigationStack {
        EditPersonView(
            receiver: receiver, onSave: { receiver in
                print("New person name: \(receiver)")
            }
        )
    }
}
