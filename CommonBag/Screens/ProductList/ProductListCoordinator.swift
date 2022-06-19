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
    let networkClient: NetworkClientProtocol
    let viewModel: ProductListViewModel
    init(list: ListModel, networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        self.list = list
        self.viewModel = .init(list: list, networkClient: networkClient)
    }
    
    @ViewBuilder func makeStart() -> some View {
        ProductListView(viewModel: viewModel)
    }
    
    func makeAddProduct(upcomingProducts: [ProductModel]) -> AddProductCoordinator {
        AddProductCoordinator(list: list, upcomingProducts: upcomingProducts, networkClient: networkClient, completion: viewModel.load)
    }
}
