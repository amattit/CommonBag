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
    @Published var notMyLists: [ListModel] = []
    @Published var viewState: Loadable = .idle
    let networkClient: NetworkClientProtocol?
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
    
    init(networkClient: NetworkClientProtocol?) {
        self.networkClient = networkClient
        bind()
        load()
    }
    
    ///  Загрузка списков
    func load() {
        self.viewState = .loading
        networkClient?
            .execute(api: API.List.getAll, type: [DTO.ListRs].self)
            .sink { completion in
                switch completion {
                case .finished:
                    self.viewState = .loaded
                case .failure(let error):
                    self.viewState = .error(ErrorModel(error: error, action: self.load))
                }
            } receiveValue: { response in
                let allLists = response.map {
                    ListModel(id: $0.id, title: $0.title, description: $0.count, isOwn: $0.isOwn, isShared: $0.isShared, profile: $0.profile)
                }
                self.lists = allLists.filter({ $0.isOwn == true })
                self.notMyLists = allLists.filter({ $0.isOwn == false })
                self.next()
            }
            .store(in: &disposables)
    }
    
    ///  Обновление списков
    func refresh() {
        networkClient?
            .execute(api: API.List.getAll, type: [DTO.ListRs].self)
            .sink { completion in
                switch completion {
                case .finished:
                    self.viewState = .loaded
                case .failure(let error):
                    self.viewState = .error(ErrorModel(error: error, action: self.load))
                }
            } receiveValue: { response in
                let allLists = response.map {
                    ListModel(id: $0.id, title: $0.title, description: $0.count, isOwn: $0.isOwn, isShared: $0.isShared, profile: $0.profile)
                }
                self.lists = allLists.filter({ $0.isOwn == true })
                self.notMyLists = allLists.filter({ $0.isOwn == false })
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
        }
    }
    
    /// Перейти к списку продуктов
    func showProductList(_ item: ListModel) {
        lastViewedList = item.id
        router?.route(to: \.productList, item)
    }
    
    /// Создать список продуктов, а потом перейти к нему
    func addList() {
        let dto = ListModel(id: .init(), title: "Список продуктов", description: "")
        networkClient?
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
    
    /// Удаление списка продуктов
    func delete(_ model: ListModel) {
        networkClient?
            .executeData(api: API.List.delete(model))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.lists.removeAll {
                    $0 == model
                }
            }
            .store(in: &disposables)
    }
    
    func showUserProfile() {
        router?.route(to: \.profile)
    }
    
    func bind() {
        NotificationCenter.default.publisher(for: .reloadLists).sink { _ in
        } receiveValue: { _ in
            self.refresh()
        }
        .store(in: &disposables)
    }
}
