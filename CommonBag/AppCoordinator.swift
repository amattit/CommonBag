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

final class RootCoordinator: TabCoordinatable {
    var child = TabChild(startingItems: [
        \RootCoordinator.lists,
         \RootCoordinator.recipe
    ])
    
    @Route(tabItem: makeHomeTab) var lists = makeHome
    @Route(tabItem: makeTodosTab) var recipe = makeRecipes
    
    let networking: NetworkClientProtocol
    var cancellable = Set<AnyCancellable>()
    
    init(networking: NetworkClientProtocol) {
        self.networking = networking
    }
    
    func makeHome() -> NavigationViewCoordinator<MyListsCoordinator> {
        NavigationViewCoordinator(MyListsCoordinator(networkClient: networking))
    }
    
    @ViewBuilder func makeHomeTab(isActive: Bool) -> some View {
        Image(systemName: "list.bullet.rectangle" + (isActive ? ".fill" : ""))
        Text("Lists")
    }
    
    func makeRecipes() -> NavigationViewCoordinator<RecipesCategoryCoordinator> {
        return NavigationViewCoordinator(RecipesCategoryCoordinator(networking: networking))
    }
    
    @ViewBuilder func makeTodosTab(isActive: Bool) -> some View {
        Image(systemName: "book" + (isActive ? ".fill" : ""))
        Text("Todos")
    }
}

final class AppCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \AppCoordinator.load)
    
    @Root var start = makeStart
    @Root var load = makeLoad
    
    let networking: NetworkClientProtocol// = NetworkClient()
    
    var cancellable = Set<AnyCancellable>()
    
    init(networking: NetworkClientProtocol) {
        self.networking = networking
        signIn()
        updatePushToken()
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
    
    func updatePushToken() {
        networking
            .executeData(api: API.User.pushToken)
            .sink { completion in
                print(completion)
            } receiveValue: { _ in
                
            }
            .store(in: &cancellable)
    }
    
    func makeStart() -> RootCoordinator {
        RootCoordinator(networking: networking)
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
        root(\.start).focusFirst(\.lists).child.route(to: \.productList, list)
//        root(\.start).child.route(to: \.productList, list)
    }
}
