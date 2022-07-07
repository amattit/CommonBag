//
//  RenameService.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import Combine

protocol RenameServiceProtocol {
    var title: String? { get set }
    var uid: UUID? { get set }
    func rename() -> AnyPublisher<Bool, Error>
    func setTitle(_ title: String) -> RenameServiceProtocol
    func setUid(_ uid: UUID?) -> RenameServiceProtocol
}

class BaseRenameService: RenameServiceProtocol {
    var title: String?
    var uid: UUID?
    let networkClient: NetworkClientProtocol
    
    internal init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func rename() -> AnyPublisher<Bool, Error> {
        Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func setTitle(_ title: String) -> RenameServiceProtocol {
        self.title = title
        return self
    }
    
    func setUid(_ uid: UUID?) -> RenameServiceProtocol {
        self.uid = uid
        return self
    }
 }

final class ProductListRenameService: BaseRenameService {
    override func rename() -> AnyPublisher<Bool, Error> {
        guard let uid = uid, let title = title
        else {
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return networkClient
            .execute(api: API.List.rename(uid, title), type: DTO.ListRs.self)
            .map { item -> Bool in
                if item.title == self.title {
                    return true
                }
                return false
            }
            .eraseToAnyPublisher()
    }
}

final class UsernameRenameService: BaseRenameService {
    override func rename() -> AnyPublisher<Bool, Error> {
        guard let title = title else {
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return networkClient.execute(api: API.User.setUsername(title), type: DTO.Profile.self)
            .map { item -> Bool in
                if item.username == title {
                    return true
                }
                return false
            }
            .eraseToAnyPublisher()
    }
}

final class ProductRenameService: BaseRenameService {
    override func rename() -> AnyPublisher<Bool, Error> {
        guard let title = title, let uid = uid else {
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let items = title
            .split(separator: ",")
            .map(String.init)
            .map {
                $0
                    .split(separator: ":")
                    .map(String.init)
            }
            .compactMap { item -> ProductModel? in
                if let title = item.first, let count = item.last {
                    return ProductModel(id: uid, title: title.trimmingCharacters(in: .whitespaces), count: title == count ? "" : count.trimmingCharacters(in: .whitespaces))
                }
                return nil
            }
        
        guard let model = items.first else {
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return networkClient.execute(api: API.Products.rename(model.id, model.title, model.count), type: DTO.ProductRs.self)
            .map { item -> Bool in
                if item.title == model.title {
                    return true
                }
                return false
            }
            .eraseToAnyPublisher()
    }
}
