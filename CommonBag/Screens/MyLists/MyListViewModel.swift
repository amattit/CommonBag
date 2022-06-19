//
//  MyListViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen
import Combine

final class MyListsViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<MyListsCoordinator>?
    @Published var lists: [ListModel] = []
    let networkClient: NetworkClientProtocol
    var disposables = Set<AnyCancellable>()
    
    var lastViewedList: UUID? {
        get {
            guard let uuidString = UserDefaults.standard.string(forKey: "last-viewed") else { return nil }
            return UUID(uuidString: uuidString)
        }
        
        set {
            UserDefaults.standard.set(newValue?.uuidString, forKey: "last-viewed")
        }
    }
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        load()
    }
    
    ///  Загрузка списков
    func load() {
        networkClient
            .execute(api: API.List.getAll, type: [DTO.ListRs].self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.lists = response.map {
                    ListModel(id: $0.id, title: $0.title, description: $0.count)
                }
                self.next()
            }
            .store(in: &disposables)

    }
    
    private func next() {
        if lists.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.addList()
            }
        } else {
            guard let lastViewedList = lastViewedList, let item = lists.first(where: { $0.id == lastViewedList }) else {
                guard let item = lists.first else { return }
                showProductList(item)
                return
            }
            showProductList(item)
            // TODO: Выбрать последний выбранный список и открыть его
        }
    }
    
    /// Перейти к списку продуктов
    func showProductList(_ item: ListModel) {
        lastViewedList = item.id
        router?.route(to: \.productList, item)
    }
    
    /// Создать список продуктов, а потом перейти к нему
    func addList() {
        let dto = DTO.UpsertListRq(title: "Список покупок")
        networkClient
            .execute(api: API.List.create(dto), type: DTO.ListRs.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { response in
                let item = ListModel(id: response.id, title: response.title, description: response.count)
                self.lists.append(item)
                self.showProductList(item)
            }
            .store(in: &disposables)
    }
}
