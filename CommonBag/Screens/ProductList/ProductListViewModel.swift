//
//  ProductListViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen
import Combine

final class ProductListViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<ProductListCoordinator>?
    @Published var upcomingProducts: [ProductModel] = []
    @Published var madeProducts: [ProductModel] = []
    let list: ListModel
    
    let networkClient: NetworkClientProtocol
    
    var disposables = Set<AnyCancellable>()
    
    var backButtonName: String {
        "1.square"
    }
    
    init(list: ListModel, networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        self.list = list
        load()
        // TODO:
//        service.getProducts(for: list)
    }
    
    func load() {
        networkClient
            .execute(api: API.Products.getBy(list), type: [DTO.ProductRs].self)
            .map { items -> ([ProductModel], [ProductModel]) in
                let upcomingProducts = items
                    .filter({ $0.isDone == false })
                    .map { ProductModel(id: $0.id, title: $0.title, count: $0.count ?? "") }
                
                let madeProducts = items
                    .filter({ $0.isDone == true })
                    .map { ProductModel(id: $0.id, title: $0.title, count: $0.count ?? "") }
                
                return (upcomingProducts, madeProducts)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.upcomingProducts = response.0
                self.madeProducts = response.1
            }
            .store(in: &disposables)

    }
    
    func setMade(_ product: ProductModel) {
        networkClient
            .execute(api: API.Products.setMade(product), type: DTO.ProductRs.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.deleteFromUpcoming(product)
                self.madeProducts.append(product)
            }
            .store(in: &disposables)
    }
    
    func setUpcoming(_ product: ProductModel) {
        networkClient
            .execute(api: API.Products.setUpcomming(product), type: DTO.ProductRs.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.deleteFromMade(product)
                self.upcomingProducts.append(product)
            }
            .store(in: &disposables)
    }
    
    func delete(_ productModel: ProductModel) {
        networkClient
            .executeData(api: API.Products.delete(productModel))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.deleteFromMade(productModel)
                self.deleteFromUpcoming(productModel)
            }
            .store(in: &disposables)
    }
    
    private func deleteFromUpcoming(_ product: ProductModel) {
        upcomingProducts.removeAll {
            $0 == product
        }
    }
    
    private func deleteFromMade(_ product: ProductModel) {
        madeProducts.removeAll {
            $0 == product
        }
    }
    
    func dismiss() {
        router?.dismissCoordinator(nil)
    }
    
    func showAddProducts() {
        router?.route(to: \.add, upcomingProducts)
    }
}
