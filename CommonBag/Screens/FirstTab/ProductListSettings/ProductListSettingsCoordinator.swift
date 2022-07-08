//
//  ProductListSettingsCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 08.07.2022.
//

import SwiftUI
import Stinsen

final class ProductListSettingsCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \ProductListSettingsCoordinator.start)
    
    @Root var start = makeStart
    
    let serviceLocator: ServiceLocatorProtocol
    var list: ListModel
    
    init(serviceLocator: ServiceLocatorProtocol, list: ListModel) {
        self.list = list
        self.serviceLocator = serviceLocator
    }
}

extension ProductListSettingsCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        ProductListSettingsView(viewModel: .init(list: list, networkClient: serviceLocator.getService(), userService: serviceLocator.getService()))
    }
}

