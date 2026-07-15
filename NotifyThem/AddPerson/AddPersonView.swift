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
    let onCreateReceiver: (String) -> Void

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
                    onCreateReceiver(newReceiverName)
                    dismiss()
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .disabled(newReceiverName.isEmpty)
            }
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
