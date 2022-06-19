//
//  AppCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen
import Combine
import SwiftUI

final class AppCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \AppCoordinator.load)
    
    @Root var start = makeStart
    @Root var load = makeLoad
    
    let networking: NetworkClientProtocol = NetworkClient()
    var cancellable: Cancellable?
    
    init() {
        signIn()
    }
    
    func signIn() {
        cancellable = networking.execute(api: API.Auth.signin, type: API.Auth.AuthRs.self).sink { completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                self.root(\.start)
            }
        } receiveValue: { response in
            API.authToken = response.token
        }
    }
    
    func makeStart() -> NavigationViewCoordinator<MyListsCoordinator> {
        NavigationViewCoordinator(MyListsCoordinator(networkClient: networking))
    }
    
    @ViewBuilder
    func makeLoad() -> some View {
        ProgressView()
    }
}
