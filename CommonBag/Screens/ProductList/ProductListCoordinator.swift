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
    @Route(.modal) var share = makeShareToken
    @Route(.modal) var rename = makeRenameList
    
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
    
    @ViewBuilder func makeShareToken(token: URL) -> some View {
        ShareSheetView(activityItems: [token]) { activityType, completed, returnedItems, error in
            if completed {
                self.popLast(nil)
            }
        }
    }
    
    func makeAddProduct(upcomingProducts: [ProductModel]) -> AddProductCoordinator {
        AddProductCoordinator(list: list, upcomingProducts: upcomingProducts, networkClient: networkClient, completion: viewModel.load)
    }
    
    func makeRenameList(list: ListModel) -> NavigationViewCoordinator<RenameCoordinator> {
        NavigationViewCoordinator(RenameCoordinator(currentName: list.title, title: "Новое имя", subTitle: "Чтобы проще ориентироваться в списках продуктов", uid: list.id, renameService: ProductListRenameService(networkClient: networkClient), completion: nil))
    }
}
