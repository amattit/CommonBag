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
    
    let networking: NetworkClientProtocol// = NetworkClient()
    
    var cancellable = Set<AnyCancellable>()
    
    init(networking: NetworkClientProtocol) {
        self.networking = networking
        signIn()
    }
    
    func signIn() {
        networking.execute(api: API.Auth.signin, type: API.Auth.AuthRs.self).sink { completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                self.root(\.start)
            }
        } receiveValue: { response in
            API.authToken = response.token
        }
        .store(in: &cancellable)
    }
    
    func makeStart() -> NavigationViewCoordinator<MyListsCoordinator> {
        NavigationViewCoordinator(MyListsCoordinator(networkClient: networking))
    }
    
    @ViewBuilder
    func makeLoad() -> some View {
        ProgressView()
    }
    
    func handleDeepLink(url: URL) {
        guard url.pathComponents.contains(where: { $0 == "token" }), let token = url.pathComponents.last, let uid = UUID(uuidString: token)
        else { return }
        networking
            .execute(api: API.List.applyShareToken(uid),
                     type: DTO.ListRs.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                let list = ListModel(
                    id: response.id,
                    title: response.title,
                    description: response.count
                )
                self?.navigateTo(list)
            }
            .store(in: &cancellable)
    }
    
    func navigateTo(_ list: ListModel) {
        root(\.start).child.route(to: \.productList, list)
    }
}
