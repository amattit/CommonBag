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
    let list: ListModel
    init(list: ListModel) {
        self.list = list
    }
    
    @ViewBuilder func makeStart() -> some View {
        ProductListView(viewModel: .init(list: list))
    }
}
