//
//  MyListsCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen
import SwiftUI
import Combine

final class MyListsCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \MyListsCoordinator.start)
    
    @Root var start = makeStart
    @Route(.push) var productList = makeProductList
    @Route(.modal) var profile = makeUserProfile
    
//    var user: DTO.Profile?
    
//    let networkClient: NetworkClientProtocol
    let serviceLocator: ServiceLocatorProtocol
    let userService: UserService?
    
    var disposables = Set<AnyCancellable>()
    
    init(serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
        
        self.userService = serviceLocator.getService()
        self.userService?.loadUser()
        
    }
}

extension MyListsCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        MyListsView(viewModel: .init(networkClient: serviceLocator.getService()))
    }
    
    func makeProductList(list: ListModel) -> ProductListCoordinator {
        ProductListCoordinator(list: list, serviceLocator: serviceLocator)
    }
    
    func makeUserProfile() -> NavigationViewCoordinator<RenameCoordinator> {
        let renameService: UsernameRenameService? = serviceLocator.getService()
        return NavigationViewCoordinator(
            RenameCoordinator(
                currentName: userService?.user?.username ?? "",
                title: "Введите имя",
                subTitle: "Под этим именем вас будут видеть пользователи с которыми вы делитесь списками покупок",
                uid: nil,
                renameService: renameService,
                completion: { self.userService?.loadUser() }
            )
        )
    }
}
