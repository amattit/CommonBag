//
//  ProductListSettingsViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 08.07.2022.
//

import Foundation
import Stinsen

final class ProductListSettingsViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<ProductListSettingsCoordinator>?
    
    @Published var title: String
    @Published var users: [DTO.Profile] = []
    @Published var shareToken = ""
    
    var list: ListModel
    let networkClient: NetworkClientProtocol?
    let userService: UserService?
    
    init(list: ListModel, networkClient: NetworkClientProtocol?, userService: UserService?) {
        self.list = list
        self.title = list.title
        self.networkClient = networkClient
        self.userService = userService
    }
    
    /// Поделиться спискосм - открыть Экран поделиться
    func share() {
        
    }
    
    ///  Переименовать список
    func remane() {
        
    }
    
    /// Загрузить данные о списке. Список пользователей + Токен для шаринга
    func load() {
        
    }
    
    /// Удалить пользователя из списка
    func deleteUser(user: DTO.Profile) {
        
    }
    
    /// Удалить список
    func deleteList() {
        
    }
    
    /// Удалить токен для шаринга
    func deleteShareToken() {
        
    }
    
    func createShareToken() {
        
    }
}

