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
    
    let service: ProductListService
    
    var disposables = Set<AnyCancellable>()
    
    var backButtonName: String {
        "\(service.getListCount()).square"
    }
    
    init(list: ListModel, service: ProductListService) {
        self.service = service
        self.list = list
        bind()
        service.getProducts(for: list)
    }
    
    func bind() {
        service.productsPublisher.sink { products in
            self.upcomingProducts = products
        }
        .store(in: &disposables)
    }
    
    func setMade(_ product: ProductModel) {
        deleteFromUpcoming(product)
        
        madeProducts.append(product)
    }
    
    func setUpcoming(_ product: ProductModel) {
        deleteFromMade(product)
        
        upcomingProducts.append(product)
    }
    
    func deleteFromUpcoming(_ product: ProductModel) {
        upcomingProducts.removeAll {
            $0 == product
        }
    }
    
    func deleteFromMade(_ product: ProductModel) {
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
