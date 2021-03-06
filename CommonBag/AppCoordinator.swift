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
    
//    let networking: NetworkClientProtocol
    let serviceLocator: ServiceLocatorProtocol
    var cancellable = Set<AnyCancellable>()
    
    init(serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
    }
    
    func makeHome() -> NavigationViewCoordinator<MyListsCoordinator> {
        NavigationViewCoordinator(MyListsCoordinator(serviceLocator: serviceLocator))
    }
    
    @ViewBuilder func makeHomeTab(isActive: Bool) -> some View {
        Image(systemName: "list.bullet.rectangle" + (isActive ? ".fill" : ""))
        Text("Покупки")
    }
    
    func makeRecipes() -> NavigationViewCoordinator<RecipesCategoryCoordinator> {
        return NavigationViewCoordinator(RecipesCategoryCoordinator(serviceLocator: serviceLocator))
    }
    
    @ViewBuilder func makeTodosTab(isActive: Bool) -> some View {
        Image(systemName: "book" + (isActive ? ".fill" : ""))
        Text("Рецепты")
    }
}

final class AppCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \AppCoordinator.load)
    
    @Root var start = makeStart
    @Root var load = makeLoad
    
    let networking: NetworkClientProtocol?// = NetworkClient()
    let serviceLocator: ServiceLocatorProtocol
    
    var cancellable = Set<AnyCancellable>()
    
    init(serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
        self.networking = serviceLocator.getService()
        signIn()
    }
    
    func signIn() {
        if API.authToken == "" {
            networking?.execute(api: API.Auth.signin, type: API.Auth.AuthRs.self).sink { completion in
                switch completion {
                case .failure:
                    self.signIn()
                case .finished:
                    self.root(\.start)
                }
            } receiveValue: { [weak self] response in
                API.authToken = response.token
                self?.updatePushToken()
            }
            .store(in: &cancellable)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.root(\.start)
                self.updatePushToken()
            }
        }
    }
    
    func updatePushToken() {
        networking?
            .executeData(api: API.User.pushToken)
            .sink { completion in
                print(completion)
            } receiveValue: { _ in
                
            }
            .store(in: &cancellable)
    }
    
    func makeStart() -> RootCoordinator {
        RootCoordinator(serviceLocator: serviceLocator)
    }
    
    @ViewBuilder
    func makeLoad() -> some View {
        ProgressView()
    }
    
    func handleDeepLink(url: URL) {
        guard url.pathComponents.contains(where: { $0 == "token" }), let token = url.pathComponents.last, let uid = UUID(uuidString: token)
        else { return }
        networking?
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
