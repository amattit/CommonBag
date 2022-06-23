//
//  User + API.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import Networking

extension API {
    enum User: APICall {
        case me, setUsername(String)
        
        var path: String {
            return "/api/v1/me"
        }
        
        var method: String {
            switch self {
            case .me:
                return "GET"
            case .setUsername:
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
            if case let .setUsername(newName) = self {
                return try JSONEncoder().encode(DTO.SetUsernameRq(username: newName))
            }
            return nil
        }
        
    }
}
