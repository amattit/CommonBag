//
//  ProductSuggestView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 22.06.2022.
//

// TODO: подумать, как лучше сделать
import SwiftUI

struct ProductSuggestView: View {
    @ObservedObject var viewModel: SuggestViewModel
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.selected) { model in
                    SuggestRow(model: model)
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.search, prompt: Text("например, бакалея"), suggestions: {
                if viewModel.visible.isEmpty {
                    VStack {
                        Text("Ничего не нашлось :(")
                        Text("Чтобы добавить нажмите \"Найти\" на клавиатуре")
                    }
                } else {
                    ForEach(viewModel.visible) { model in
                        SearchProductSuggestRow(model: model, selected: $viewModel.selected)
                    }
                }
            })
            .onSubmit(of: .search) {
                self.viewModel.selected.append(DTO.SuggestRs(id: .init(), title: viewModel.search, category: "secondary", color: "white", count: 1))
            }
            .navigationTitle(Text("Список"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово", action: viewModel.save)
                }
            }
        }
    }
}
