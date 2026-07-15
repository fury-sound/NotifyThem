//
//  AddGroupView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 11.07.2026.
//

import SwiftUI

struct AddGroupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newGroupName: String = ""
    let onCreateGroup: (String) -> Void

    var body: some View {
        Form {
            Section("Group Name") {
                TextField("Enter new group name", text: $newGroupName)
            }
        }
        .navigationTitle("Add Group")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onCreateGroup(newGroupName)
                    dismiss()
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .disabled(newGroupName.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddGroupView(
            onCreateGroup: { name in
                print("New Group Name is: \(name)")
            }
        )
    }
}
