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
