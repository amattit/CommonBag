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
    @Route(.modal) var renameProduct = makeRenameProduct
    @Route(.modal) var profile = makeUserProfile
    @Route(.push) var settings = makeSettings
    
    let serviceLocator: ServiceLocatorProtocol
    let list: ListModel
    let viewModel: ProductListViewModel
    let userService: UserService?
    
    init(list: ListModel, serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
        self.userService = serviceLocator.getService()
        self.list = list
        self.viewModel = .init(
            list: list,
            networkClient: serviceLocator.getService(),
            userService: serviceLocator.getService()
        )
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
    
    func makeAddProduct(upcomingProducts: [ProductModel]) -> SuggestCoordinator {
        SuggestCoordinator(list: list, serviceLocator: serviceLocator)
//        NavigationViewCoordinator(AddProductCoordinator(list: list, upcomingProducts: upcomingProducts, serviceLocator: serviceLocator, completion: viewModel.load))
    }
    
    func makeRenameList(list: ListModel) -> NavigationViewCoordinator<RenameCoordinator> {
        let renameService: ProductListRenameService? = serviceLocator.getService()
        return NavigationViewCoordinator(
            RenameCoordinator(
                currentName: list.title,
                title: "Новое имя",
                subTitle: "Чтобы проще ориентироваться в списках продуктов",
                uid: list.id,
                renameService: renameService,
                completion: nil
            )
        )
    }
    
    func makeUserProfile(completion: @escaping () -> Void) -> NavigationViewCoordinator<RenameCoordinator> {
        let renameService: UsernameRenameService? = serviceLocator.getService()
        return NavigationViewCoordinator(
            RenameCoordinator(
                currentName: userService?.user?.username ?? "",
                title: "Введите имя",
                subTitle: "Под этим именем вас будут видеть пользователи с которыми вы делитесь списками покупок",
                uid: nil,
                renameService: renameService,
                completion: {
                    self.userService?.loadUser {
                        completion()
                    }
                }
            )
        )
    }
    
    func makeRenameProduct(product: ProductModel) -> NavigationViewCoordinator<RenameCoordinator>  {
        let renameService: ProductRenameService? = serviceLocator.getService()
        return NavigationViewCoordinator(
            RenameCoordinator(
                currentName: product.title + ": " + product.count,
                title: "Изменение продукта",
                subTitle: "Измените название продукта",
                uid: product.id,
                renameService: renameService,
                completion: { self.viewModel.load() }
            )
        )
    }
    
    func makeSettings() -> ProductListSettingsCoordinator {
        ProductListSettingsCoordinator(serviceLocator: serviceLocator, list: list)
    }
}
