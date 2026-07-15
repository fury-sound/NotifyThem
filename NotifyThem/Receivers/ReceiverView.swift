//
//  ReceiverView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 10.07.2026.
//

import SwiftUI
import Combine

struct ReceiverView: View {
    @EnvironmentObject private var viewModel: MainSenderViewModel
    @State private var editingPerson: Receiver?
    @State private var isAddingPerson: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            Text("Total: \(viewModel.receiverList.count)")
            List {
                ForEach(viewModel.receiverList, id: \.self) { receiver in
                    Label(receiver.name, systemImage: "person.fill")
                    .contextMenu {
                        Button("Edit Person", systemImage: "pencil")
                        {
                            editingPerson = receiver
                        }
                        Button("Delete Person", systemImage: "trash", role: .destructive)
                        {
                            deletePerson(receiver)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            deletePerson(receiver)
                        }
                        Button("Edit", systemImage: "pencil") {
                            editingPerson = receiver
                        }
                        .tint(.blue)
                    }
                }
            }
            .sheet(item: $editingPerson) { receiver in
                NavigationStack {
                    EditPersonView(receiver: receiver) { updatedPersonName in
                        viewModel.updateReceiver(updatedPersonName)
                    }
                }
                .presentationDetents([.medium, .large])
            }
            .toolbar {
                Button("Add Person", systemImage: "plus.circle") {
                    isAddingPerson = true
                }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.accentColor)
                    .sheet(isPresented: $isAddingPerson) {
                        NavigationStack {
                            AddPersonView { personName in
                                viewModel.addNewReceiver(personName)
                            }
                        }
                        .presentationDetents([.medium, .large])
                    }
            }
        }
        .navigationTitle("Member List")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func deletePerson(_ receiver: Receiver) {
        viewModel.deleteReceiver(receiver)
    }
}

#Preview {
    ReceiverView()
        .environmentObject(MainSenderViewModel())
}


