//
//  List+API.swift
//  CommonBag
//
//  Created by MikhailSeregin on 19.06.2022.
//

import Foundation
import Networking

extension API {
    enum List: APICall {
        case getAll, create(ListModel), delete(ListModel), rename(UUID, String)
        case getShareToken(UUID), applyShareToken(UUID), deleteShareToken(UUID)
        case settings(UUID), deleteUser(UUID, UUID)
        var commonPath: String { "/api/v1/list" }
        var path: String {
            switch self {
            case .getAll:
                return commonPath
            case .create:
                return commonPath
            case .delete(let list):
                return commonPath + "/\(list.id.uuidString)"
            case .rename(let uid, _):
                return commonPath + "/\(uid.uuidString)"
            case .getShareToken(let uid), .deleteShareToken(let uid):
                return commonPath + "/\(uid.uuidString)/share-token"
            case .applyShareToken(let uid):
                return commonPath + "/token" + "/\(uid.uuidString)"
            case .settings(let uid):
                return commonPath + "/\(uid.uuidString)/settings"
            case .deleteUser(let listId, let userId):
                return commonPath + "/\(listId)/user/\(userId)"
            }
        }
        
        var method: String {
            switch self {
            case .getAll, .getShareToken, .applyShareToken, .settings:
                return "GET"
            case .create: // settings to get
                return "POST"
            case .delete, .deleteUser, .deleteShareToken:
                return "DELETE"
            case .rename:
                return "PUT"
            }
        }
        
        var headers: [String : String]? {
            [
                "Authorization": "Bearer \(API.authToken)",
                "Content-Type": "application/json"
            ]
        }
        
        var query: [String : String]? {
            nil
        }
        
        func body() throws -> Data? {
            switch self {
            case .create(let dto):
                return try JSONEncoder().encode(DTO.UpsertListRq(id: nil, title: dto.title))
            case .rename(_, let title):
                return try JSONEncoder().encode(DTO.UpsertListRq(id: nil, title: title))
            default:
                return nil
            }
        }
    }
}
