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
    let serviceLocator: ServiceLocatorProtocol
    let list: ListModel
    let completion: (()-> Void)?
    init(list: ListModel, upcomingProducts: [ProductModel], serviceLocator: ServiceLocatorProtocol, completion: (()-> Void)?) {
        self.upcomingProducts = upcomingProducts
        self.serviceLocator = serviceLocator
        self.list = list
        self.completion = completion
    }
}

extension AddProductCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        AddProductView(viewModel: .init(networkClient: serviceLocator.getService(), list: list, upcomingProducts: upcomingProducts))
    }
}
