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
    
    init(upcomingProducts: [ProductModel]) {
        self.upcomingProducts = upcomingProducts
    }
}

extension AddProductCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        AddProductView(viewModel: .init(upcomingProducts: upcomingProducts))
    }
}
