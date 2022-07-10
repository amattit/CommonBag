//
//  ProductListSettingsViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 08.07.2022.
//

import Foundation
import Stinsen
import Combine
import SwiftUI

final class ProductListSettingsViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<ProductListSettingsCoordinator>?
    
    @Published var title: String
    @Published var users: [DTO.Profile] = []
    @Published var shareToken: [String] = []
    @Published var viewState: ViewState = .loading
    
    var list: ListModel
    let networkClient: NetworkClientProtocol?
    let userService: UserService?
    
    var disposables = Set<AnyCancellable>()
    
    init(list: ListModel, networkClient: NetworkClientProtocol?, userService: UserService?) {
        self.list = list
        self.title = list.title
        self.networkClient = networkClient
        self.userService = userService
        load()
    }
    
    /// Поделиться спискосм - открыть Экран поделиться
    func share(token: String) {
        if let url = URL(string: token) {
            router?.route(to: \.share, url)
        }
    }
    
    func copy(url: String) {
        UIPasteboard.general.string = url
    }
    
    ///  Переименовать список
    func remane() {
        let api = API.List.rename(list.id, title)
        networkClient?.execute(api: api, type: DTO.ListRs.self)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.viewState = .error(.init(error: error, action: self.remane))
                } else {
                    self.viewState = .loaded
                }
            }, receiveValue: { response in
                self.list = ListModel(id: response.id, title: response.title, description: response.count)
                self.title = response.title
                NotificationCenter.default.post(name: .reloadLists, object: nil)
            })
            .store(in: &disposables)
    }
    
    /// Загрузить данные о списке. Список пользователей + Токен для шаринга
    func load() {
        networkClient?
            .execute(api: API.List.settings(list.id), type: DTO.Settings.self)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.viewState = .error(ErrorModel(error: error, action: self.load))
                } else {
                    self.viewState = .loaded
                }
            }, receiveValue: { response in
                self.shareToken = (response.shareToken ?? []).map {
                    "https://product-list-dev.herokuapp.com/list/token/\($0)".lowercased()
                }
                self.users = response.users
            })
            .store(in: &disposables)
    }
    
    /// Удалить пользователя из списка
    func deleteUser(user: DTO.Profile) {
        networkClient?
            .executeData(api: API.List.deleteUser(list.id, user.id))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.viewState = .error(.init(error: error, action: {self.deleteUser(user: user)}))
                } else {
                    self.viewState = .loaded
                }
            }, receiveValue: { _ in
                self.users.removeAll { profile in
                    profile == user
                }
            })
            .store(in: &disposables)
    }
    
    /// Удалить список
    func deleteList() {
        networkClient?.executeData(api: API.List.delete(list))
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.viewState = .error(.init(error: error, action: self.deleteList))
                } else {
                    self.router?.popToRoot(nil)
                }
            }, receiveValue: { _ in
            })
            .store(in: &disposables)
    }
    
    /// Удалить токен для шаринга
    func deleteShareToken() {
        let api = API.List.deleteShareToken(list.id)
        networkClient?.executeData(api: api)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { _ in
                self.load()
            })
            .store(in: &disposables)
    }
    
    func createShareToken() {
        if let username = userService?.user?.username, !username.isEmpty {
            networkClient?
                .execute(api: API.List.getShareToken(list.id), type: DTO.ShareTokenRs.self)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.viewState = .error(.init(error: error, action: self.deleteList))
                    }
                }, receiveValue: { token in
                    let token = "https://product-list-dev.herokuapp.com/list/token/\(token.token)".lowercased()
                    self.shareToken.append(token)
                })
                .store(in: &disposables)
        } else {
            self.router?.route(to: \.profile, createShareToken)
        }
    }
    
    func doneButtonDisabled() -> Bool {
        title == list.title
    }
}

