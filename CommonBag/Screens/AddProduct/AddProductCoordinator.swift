//
//  AddProductCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI
import Stinsen

final class AddProductCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \AddProductCoordinator.start)
    let upcomingProducts: [ProductModel]
    @Root var start = makeStart
    let service: ProductListService
    let list: ListModel
    init(list: ListModel, upcomingProducts: [ProductModel], service: ProductListService) {
        self.upcomingProducts = upcomingProducts
        self.service = service
        self.list = list
    }
}

extension AddProductCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        AddProductView(viewModel: .init(service: service, list: list, upcomingProducts: upcomingProducts))
    }
}
