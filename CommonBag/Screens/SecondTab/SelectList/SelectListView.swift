//
//  SelectListView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 26.06.2022.
//

import SwiftUI

struct SelectListView: View {
    @ObservedObject var viewModel: SelectListViewModel
    var body: some View {
        List {
            ForEach(viewModel.lists) { list in
                HStack {
                    Text(list.title)
                    Spacer()
                    if list == viewModel.selected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.secondary)
                    }
                }
                .addAction {
                    viewModel.selectList(list: list)
                }
            }
        }
        .foregroundColor(.primary)
        .listStyle(.plain)
        .navigationTitle("Выберите список")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово") {
                    viewModel.save()
                }
            }
        }
    }
}

struct SelectListView_Previews: PreviewProvider {
    static var previews: some View {
        SelectListView(viewModel: .init(products: [], networking: NetworkClient()))
    }
}

import Combine
import Stinsen

final class SelectListViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<RecipeCoordinator>?
    @Published var lists: [ListModel] = []
    @Published var selected: ListModel?
    
    let products: [DTO.RecipeProductRs]
    let networking: NetworkClientProtocol?
    var disposables = Set<AnyCancellable>()
    
    init(products: [DTO.RecipeProductRs], networking: NetworkClientProtocol?) {
        self.networking = networking
        self.products = products
        self.loadLists()
    }
    
    private func loadLists() {
        networking?
            .execute(api: API.List.getAll, type: [DTO.ListRs].self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.lists = response.map {
                    ListModel(id: $0.id, title: $0.title, description: $0.count)
                }
                self.selected = self.lists.first
            }
            .store(in: &disposables)
    }
    
    func save() {
        guard let list = selected else {
            return
        }
        networking?
            .executeData(api: API.Recipes.addProducsToList(list.id, products))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { _ in
                self.router?.popLast()
            }
            .store(in: &disposables)
    }
    
    func selectList(list: ListModel) {
        self.selected = list
    }
}
