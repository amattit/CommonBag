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
    @Route(.modal) var share = makeShareToken
    @Route(.modal) var profile = makeUserProfile
    let serviceLocator: ServiceLocatorProtocol
    let userService: UserService?
    var list: ListModel
    
    init(serviceLocator: ServiceLocatorProtocol, list: ListModel) {
        self.list = list
        self.serviceLocator = serviceLocator
        self.userService = serviceLocator.getService()
    }
}

extension ProductListSettingsCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        ProductListSettingsView(viewModel: .init(list: list, networkClient: serviceLocator.getService(), userService: serviceLocator.getService()))
    }
    
    @ViewBuilder func makeShareToken(token: URL) -> some View {
        ShareSheetView(activityItems: [token]) { activityType, completed, returnedItems, error in
            if completed {
                self.popLast(nil)
            }
        }
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
}

