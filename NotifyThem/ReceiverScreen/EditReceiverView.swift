//
//  AddReceiverView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 14.07.2026.
//

import SwiftUI

struct EditReceiverView: View {
    @Environment(\.dismiss) var dismiss
//    @Binding var name: String
    @State var editedName: String
    let onEditName: (String) -> Void

//    init(
//        name: String,
//        onSave: @escaping (String) -> Void
//    ) {
//        _editedName = State(initialValue: name)
//        self.onEditName = onSave
//        //        print("editedGroup.receivers.count", editedGroup.receivers.count)
//    }

    var body: some View {
        Form {
            Section("Receiver") {
                TextField("Edit name", text: $editedName)
            }
        }
        .navigationTitle("Edit Name")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onEditName(editedName)
                    dismiss()
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .disabled(editedName.isEmpty)
            }
        }
    }
}

#Preview {
    let name: String = "test"
    NavigationStack {
        EditReceiverView(editedName: name,
                         onEditName: { name in
                print("Receiver name: \(name)")
            }
        )
    }
}
