//
//  ProductListView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI

struct ProductListView: View {
    @ObservedObject
    var viewModel: ProductListViewModel
    
    var body: some View {
        List {
            HStack {
                Text("+ Новый продукт")
                Spacer()
                Button(action: {}) {
                    Image(systemName: "book")
                }
                .foregroundColor(.accentColor)
            }
            .foregroundColor(.secondary)
            .padding(8)
            .background(
                Color.primary.opacity(0.07)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding()
            .addAction {
                viewModel.showAddProducts()
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
            // Предстоящие покупки
            ForEach(viewModel.upcomingProducts) { product in
                UpcomingProductRowView(model: product)
                    .addAction {
                        viewModel.setMade(product)
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .swipeActions {
                        Button(action: {
                            viewModel.delete(product)
                        }) {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        
                        Button(action: {
                            viewModel.renameProduct(product)
                        }) {
                            Image(systemName: "pencil")
                        }
                        .tint(.indigo)
                    }
            }
            ZStack {
                Rectangle()
                    .frame(height: 200)
                    .foregroundColor(.clear)
                if viewModel.upcomingProducts.isEmpty {
                    Text("Список пуст")
                }
            }
            .listRowSeparator(.hidden)
            
            // Купленные продукты
            if !viewModel.madeProducts.isEmpty {
                Text("Уже купил")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            ForEach(viewModel.madeProducts) { product in
                MadeProductRowView(model: product)
                    .addAction {
                        viewModel.setUpcoming(product)
                    }
                    .listRowBackground(Color.secondary.opacity(0.07))
                    .swipeActions {
                        Button(action: {
                            viewModel.delete(product)
                        }) {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        
                        Button(action: {
                            // TODO: Показать редактирование
                        }) {
                            Image(systemName: "pencil")
                        }
                        .tint(.indigo)
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.load()
        }
        .navigationBarTitle(viewModel.newListName)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: viewModel.dismiss) {
                    Image(systemName: "list.bullet.rectangle.portrait")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: viewModel.getShareToken) {
                        Image(systemName: "person.2.wave.2")
                    }
                    
                    Button(action: viewModel.changeListTile) {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}

struct ProductListView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ProductListView(viewModel: .init(list: .mock, networkClient: NetworkClient(), userService: UserService(networkClient: NetworkClient())))
            }
            
            NavigationView {
                ProductListView(viewModel: .init(list: .mock, networkClient: NetworkClient(), userService: UserService(networkClient: NetworkClient())))
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
