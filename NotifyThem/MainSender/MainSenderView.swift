//
//  ContentView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import SwiftUI
import FirebaseFirestore

struct MainSenderView: View {
    @EnvironmentObject private var viewModel: MainSenderViewModel
    @State private var editingGroup: ReceiverGroup?
    @State private var isAddingGroup: Bool = false
    @State private var newGroupName: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                List {
                    ForEach(viewModel.receiverGroupList, id: \.self) { group in
                        NavigationLink(value: group) {
                            Label(group.name, systemImage: "person.text.rectangle")
                        }
                        .contextMenu {
                            Button("Edit Group", systemImage: "pencil")
                            {
                                editingGroup = group
                            }
                            Button("Delete Group", systemImage: "trash", role: .destructive)
                            {
                                deleteGroup(group)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                deleteGroup(group)
                            }
                            Button("Edit", systemImage: "pencil") {
                                editingGroup = group
                            }
                            .tint(.blue)
                        }
                    }
                }
                .sheet(item: $editingGroup) { group in
                    NavigationStack {
                        EditGroupView(receiverList: viewModel.receiverList, group: group) { updatedGroup in
                            viewModel.updateReceiverGroup(group: updatedGroup)
                        }
                    }
                    .presentationDetents([.medium, .large])
                }
                .navigationDestination(for: ReceiverGroup.self) { group in
                    OutgoingMessageView(groupID: group.id)
                }

                .toolbar {
                    Button("Add Group", systemImage: "plus.circle") {
                        isAddingGroup = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.accentColor)
                    .sheet(isPresented: $isAddingGroup) {
                        NavigationStack {
                            AddGroupView { groupName in
                                viewModel.addNewReceiverGroup(groupName)
                            }
                        }
                        .presentationDetents([.medium, .large])
                    }
                }
                .navigationTitle("Groups")
                .navigationBarTitleDisplayMode(.inline)

                NavigationLink {
                    ReceiverView()
                } label: {
                    Label("Students", systemImage: "person.3.fill")
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
        }
    }

    private func deleteGroup(_ group: ReceiverGroup) {
        viewModel.deleteReceiverGroup(group)
    }
}

#Preview {
    MainSenderView()
        .environmentObject(MainSenderViewModel())
}
