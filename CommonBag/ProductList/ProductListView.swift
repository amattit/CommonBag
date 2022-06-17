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
        VStack {
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
            
            List {
                // Предстоящие покупки
                ForEach(viewModel.upcomingProducts) { product in
                    UpcomingProductRowView(model: product)
                        .addAction {
                            viewModel.setMade(product)
                        }
                        .swipeActions {
                            Button(action: {
                                viewModel.deleteFromUpcoming(product)
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
                ForEach(viewModel.madeProducts) { product in
                    MadeProductRowView(model: product)
                        .addAction {
                            viewModel.setUpcoming(product)
                        }
                        .listRowBackground(Color.secondary.opacity(0.07))
                        .swipeActions {
                            Button(action: {
                                viewModel.deleteFromMade(product)
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
        }
        .navigationBarTitle(viewModel.list.title)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: viewModel.dismiss) {
                    Image(systemName: "1.square")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "person.2.wave.2")
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "mustache")
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
                ProductListView(viewModel: .init(list: .mock))
            }
            
            NavigationView {
                ProductListView(viewModel: .init(list: .mockEmpty))
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
