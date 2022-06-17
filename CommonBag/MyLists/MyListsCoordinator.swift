//
//  MyListsCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen
import SwiftUI

final class MyListsCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \MyListsCoordinator.start)
    
    @Root var start = makeStart
    @Route(.push) var productList = makeProductList
}

extension MyListsCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        MyListsView(viewModel: .init())
    }
    
    func makeProductList(list: ListModel) -> ProductListCoordinator {
        ProductListCoordinator(list: list)
    }
}