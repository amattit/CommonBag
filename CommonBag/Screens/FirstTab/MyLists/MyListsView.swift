//
//  MyListsView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI

struct MyListsView: View {
    @ObservedObject var viewModel: MyListsViewModel
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                Section("Мои") {
                    ForEach(viewModel.lists) { item in
                        Button(action: {viewModel.showProductList(item)}) {
                            MyListRow(item: item)
                        }
                        .swipeActions {
                            Button(action: {
                                viewModel.delete(item)
                            }) {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
                if !viewModel.notMyLists.isEmpty {
                    Section("Поделились") {
                        ForEach(viewModel.notMyLists) { item in
                            Button(action: {viewModel.showProductList(item)}) {
                                MyListRow(item: item)
                            }
                            .swipeActions {
                                Button(action: {
                                    viewModel.delete(item)
                                }) {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.refresh()
            }
            
            Button(action: viewModel.addList) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 56))
            }
            .padding()
        }
        .modifier(ViewStateModifier(state: $viewModel.viewState))
        .navigationTitle("Cписки")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: viewModel.showUserProfile) {
                        Image(systemName: "person")
                    }
                }
            }
        }
    }
}

struct MyListsView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                MyListsView(viewModel: .init(networkClient: NetworkClient()))
            }
            
            NavigationView {
                MyListsView(viewModel: .init(networkClient: NetworkClient()))
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
