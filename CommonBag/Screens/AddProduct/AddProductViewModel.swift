//
//  AddProductViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen

final class AddProductViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<AddProductCoordinator>?
    @Published var input: String = ""
    
    @Published var upcomingProducts: [ProductModel]
    let list: ListModel
    let service: ProductListService
    
    init(service: ProductListService, list: ListModel, upcomingProducts: [ProductModel]) {
        self.upcomingProducts = upcomingProducts
        self.list = list
        self.service = service
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
        self.service.addProduct(to: list, products: items)
        self.input = ""
        print(items)
    }
    
    func addCountDivider() {
        input += ": "
    }
    
    func dismiss() {
        handleInput()
        router?.dismissCoordinator(nil)
    }
}
