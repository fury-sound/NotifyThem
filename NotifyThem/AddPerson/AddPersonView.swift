//
//  AddPersonView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 12.07.2026.
//

import SwiftUI

struct AddPersonView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newReceiverName: String = ""
    @State private var showDuplicateAlert: Bool = false
    @State private var isChecking: Bool = false
    @EnvironmentObject private var viewModel: MainSenderViewModel
    let onCreateReceiver: (String) -> Void

    private var trimmedName: String {
        newReceiverName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func checkAndSave() async {
        isChecking = true
        defer { isChecking = false }

        if await viewModel.isReceiverNameUnique(trimmedName) {
            showDuplicateAlert = true
        } else {
            onCreateReceiver(trimmedName)
            dismiss()
        }
    }

    var body: some View {
        Form {
            Section("Person Name") {
                TextField("Enter new person name", text: $newReceiverName)
            }
        }
        .navigationTitle("Add Person")
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
    NavigationStack {
        AddPersonView(
            onCreateReceiver: { name in
                print("New person is: \(name)")
            }
        )
    }
}
