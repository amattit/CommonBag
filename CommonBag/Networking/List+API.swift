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
        case getAll, create(DTO.UpsertListRq)
        var commonPath: String { "/api/v1/list" }
        var path: String {
            switch self {
            case .getAll:
                return commonPath
            case .create:
                return commonPath
            }
        }
        
        var method: String {
            switch self {
            case .getAll:
                return "GET"
            case .create:
                return "POST"
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
            case .getAll:
                return nil
            case .create(let dto):
                return try JSONEncoder().encode(dto)
            }
        }
    }
}
