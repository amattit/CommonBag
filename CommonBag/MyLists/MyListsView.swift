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
                ForEach(viewModel.lists) { item in
                    Button(action: {viewModel.showProductList(item)}) {
                        MyListRow(item: item)
                    }
                }
            }
            .listStyle(.plain)
            
            Button(action: viewModel.addList) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 56))
            }
            .padding()
        }
        .navigationTitle("Мои списки")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "person")
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "gear")
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
                MyListsView(viewModel: .init())
            }
            
            NavigationView {
                MyListsView(viewModel: .init())
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
