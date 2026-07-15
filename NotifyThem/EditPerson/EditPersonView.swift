//
//  EditPersonView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 12.07.2026.
//

import SwiftUI

struct EditPersonView: View {
    @Environment(\.dismiss) var dismiss
//    @State private var editedPersonName: String = ""
    @State var editedReceiver: Receiver
    let onSaveReceiver: (Receiver) -> Void

    init(
        receiver: Receiver,
        onSave: @escaping (Receiver) -> Void
    ) {
        _editedReceiver = State(initialValue: receiver)
        self.onSaveReceiver = onSave
    }

    var body: some View {
        Form {
            Section("Person Name") {
                TextField("Edit person name", text: $editedReceiver.name)
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSaveReceiver(editedReceiver)
                    dismiss()
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .disabled(editedReceiver.name.isEmpty)
            }
        }
    }
}

#Preview {
    let receiver = Receiver(id: 11, name: "Alex")
    NavigationStack {
        EditPersonView(
            receiver: receiver, onSave: { receiver in
                print("New person name: \(receiver.name)")
            }
        )
    }
}

//struct EditPersonView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    EditPersonView()
//}
