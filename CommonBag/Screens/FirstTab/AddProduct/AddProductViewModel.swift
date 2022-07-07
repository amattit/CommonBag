//
//  AddProductViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen
import Combine
import UIKit
// TODO: Добавить состояние экрана для переключения типа клавиатуры, когда нажимаешь : количество
final class AddProductViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<AddProductCoordinator>?
    @Published var input: String = ""
    @Published var upcomingProducts: [ProductModel]
    @Published var viewState: Loadable = .loaded
    let list: ListModel
    let networkClient: NetworkClientProtocol
    var disposables = Set<AnyCancellable>()
    
    init(networkClient: NetworkClientProtocol, list: ListModel, upcomingProducts: [ProductModel]) {
        self.upcomingProducts = upcomingProducts
        self.list = list
        self.networkClient = networkClient
    }
    
    func handleInput() {
        let items = input
            .split(separator: ",")
            .map(String.init)
            .map {
                $0
                    .split(separator: ":")
                    .map(String.init)
            }
            .compactMap { item -> ProductModel? in
                if let title = item.first, let count = item.last {
                    
                    return ProductModel(id: UUID(), title: title.trimmingCharacters(in: .whitespaces), count: title == count ? "" : count.trimmingCharacters(in: .whitespaces))
                }
                return nil
            }
        self.upcomingProducts.append(contentsOf: items)
        create(items)
        self.input = ""
    }
    
    func addCountDivider() {
        input += ": "
    }
    
    func dismiss() {
        handleInput()
        router?.dismissCoordinator(router?.coordinator.completion)
    }
    
    private func create(_ models: [ProductModel]) {
        self.viewState = .loading
        networkClient
            .execute(api: API.Products.massCreate(list, models), type: [DTO.ProductRs].self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.viewState = .error(ErrorModel(error: error, action: {
                        self.create(models)
                    }))
                case .finished:
                    self.viewState = .loaded
                }
            } receiveValue: { dto in
            }
            .store(in: &disposables)

    }
}
