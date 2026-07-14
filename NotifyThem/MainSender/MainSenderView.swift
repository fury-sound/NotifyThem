//
//  ContentView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 04.07.2026.
//

import SwiftUI
import FirebaseFirestore

struct MainSenderView: View {
    //    @StateObject private var viewModel = MainSenderViewModel()
    @EnvironmentObject private var viewModel: MainSenderViewModel
    @State private var editingGroup: ReceiverGroup?
    //    @State private var creatingGroup: ReceiverGroup?
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
                                //                                editGroup(group)
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
                                //                                editGroup(group)
                                editingGroup = group
                            }
                            .tint(.blue)
                        }
                        //                        Text(group.receivers.map(\.name).joined(separator: ", "))
                        //                        Text(group.messageGroup.messageArray.map(\.message).joined(separator: ", "))
                    }
                }
                .sheet(item: $editingGroup) { group in
                    NavigationStack {
                        EditGroupView(receiverList: viewModel.receiverList, group: group) { updatedGroup in
                            //                            viewModel.editedGroupId = group.id
                            //                            print("No of receivers in group:", updatedGroup.receivers.count)
                            //                            print("Saving receivers:", updatedGroup.receivers.map(\.id))
                            viewModel.updateReceiverGroup(group: updatedGroup)
                        }
                    }
                    .presentationDetents([.medium, .large])
                }
                .navigationDestination(for: ReceiverGroup.self) { group in
                    //                    DestinationView(group: group)
                    //                    OutgoingMessageView(viewModel: viewModel, group: group)
                    OutgoingMessageView(viewModel: viewModel, groupID: group.id)
                }
                // код для вызова проверки наличия соединения с Firebase
                //                .task {
                //                    await testConnection()
                //                }

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
                    }
                    .presentationDetents([.medium, .large])
                }
                .navigationTitle("Groups")
                .navigationBarTitleDisplayMode(.inline)

                NavigationLink {
                    ReceiverView()
                    //                    ReceiverView(viewModel: viewModel)
                } label: {
                    Label("Students", systemImage: "person.3.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.accentColor)

                //                List {
                //                    NavigationLink(value: viewModel.receiverGroup1){
                //                        Label(viewModel.receiverGroup1.name, systemImage: "1.square.fill")
                //                    }
                //                    .contextMenu {
                //                        Button("Edit Group", action: editGroup)
                //                        Button("Delete Group", role: .destructive, action: deleteGroup)
                //                    }
                //                    NavigationLink(value: viewModel.receiverGroup2){
                //                        Label(viewModel.receiverGroup2.name, systemImage: "2.square.fill")
                //                    }
                //                    NavigationLink(value: viewModel.receiverGroup3){
                //                        Label(viewModel.receiverGroup3.name, systemImage: "3.square.fill")
                //                    }
                //                    //                    Label("Group 1", systemImage: "star.fill")
                //                    //                    Label("Group 2", systemImage: "star.fill")
                //                    //                    Text("Hello, world!")
                //                    //                    Label(LocalizedStringKey, systemImage: <#T##String#>)
                //                }
                //                .navigationDestination(for: ReceiverGroup.self) { group in
                ////                    DestinationView(group: group)
                //                    OutgoingMessageView(group: group)
                //                }
                //                Button("Add Group", systemImage: "plus.circle", action: addGroup)
                //                    .buttonStyle(.borderedProminent)
                //                    .tint(Color.accentColor)

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
    //    private func addGroup() {
    //        print("Add Button tapped")
    //        //        viewModel.receiverGroup1.name = "New Group"
    //    }

    private func deleteGroup(_ group: ReceiverGroup) {
        viewModel.deleteReceiverGroup(group)
    }

    // код для вызова проверки наличия соединения с Firebase
    //    func testConnection() async {
    //        let db = Firestore.firestore()
    //        do {
    //            try await db.collection("_ping").document("test").setData(["ok": true])
    //            let snapshot = try await db.collection("_ping").document("test").getDocument()
    //            print("Firestore связь работает:", snapshot.data() ?? [:])
    //        } catch {
    //            print("Ошибка подключения к Firestore:", error)
    //        }
    //    }
}

#Preview {
    MainSenderView()
}

//struct DestinationView: View {
//    @State var group: ReceiverGroup
//
//    var body: some View {
//        Image(systemName: "globe")
//            .imageScale(.large)
//            .foregroundStyle(.tint)
//        Text(group.name)
//            .padding()
//    }
//}
