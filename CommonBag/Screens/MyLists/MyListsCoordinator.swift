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
    
    var user: DTO.Profile?
    
    let networkClient: NetworkClientProtocol
    
    var disposables = Set<AnyCancellable>()
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        loadUser()
    }
}

extension MyListsCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        MyListsView(viewModel: .init(networkClient: networkClient))
    }
    
    func makeProductList(list: ListModel) -> ProductListCoordinator {
        ProductListCoordinator(list: list, networkClient: networkClient)
    }
    
    func makeUserProfile() -> NavigationViewCoordinator<RenameCoordinator> {
        NavigationViewCoordinator(
            RenameCoordinator(
                currentName: user?.username ?? "",
                title: "Введите имя",
                subTitle: "Под этим именем вас будут видеть пользователи с которыми вы делитесь списками покупок",
                uid: nil,
                renameService: UsernameRenameService(networkClient: networkClient),
                completion: loadUser
            )
        )
    }
}

extension MyListsCoordinator {
    func loadUser() {
        networkClient
            .execute(api: API.User.me, type: DTO.Profile.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { responseProfile in
                self.user = responseProfile
            }
            .store(in: &disposables)
    }
}
