//
//  UserService.swift
//  CommonBag
//
//  Created by MikhailSeregin on 07.07.2022.
//

import Foundation
import Combine

final class UserService {
    var user: DTO.Profile?
    
    let networkClient: NetworkClientProtocol?
    
    var disposables = Set<AnyCancellable>()
    
    init(networkClient: NetworkClientProtocol?) {
        self.networkClient = networkClient
        loadUser()
    }
    
    func loadUser() {
        networkClient?
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
