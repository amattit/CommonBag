//
//  ProductListCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI
import Stinsen

final class ProductListCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \ProductListCoordinator.start)
    
    @Root var start = makeStart
    @Route(.fullScreen) var add = makeAddProduct
    
    let list: ListModel
    let service: ProductListService
    init(list: ListModel, service: ProductListService) {
        self.service = service
        self.list = list
    }
    
    @ViewBuilder func makeStart() -> some View {
        ProductListView(viewModel: .init(list: list, service: service))
    }
    
    func makeAddProduct(upcomingProducts: [ProductModel]) -> AddProductCoordinator {
        AddProductCoordinator(list: list, upcomingProducts: upcomingProducts, service: service)
    }
}
