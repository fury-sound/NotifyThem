//
//  AddReceiverView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 14.07.2026.
//

import SwiftUI

struct AddReceiverView: View {
    @Environment(\.dismiss) var dismiss
    @State private var receiverName: String = ""
    let onAddReceiverName: (String) -> Void

    var body: some View {
        Form {
            Section("Receiver ID") {
                TextField("Enter receiver name", text: $receiverName)
            }
        }
        .navigationTitle("Add Receiver")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onAddReceiverName(receiverName)
                    dismiss()
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .disabled(receiverName.isEmpty ? true : false)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddReceiverView(
            onAddReceiverName: { name in
                print("Receiver name: \(name)")
            }
        )
    }
}

struct ReceiverScreenView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ReceiverScreenView()
}
