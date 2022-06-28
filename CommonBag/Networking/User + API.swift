//
//  User + API.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import Networking
import UIKit

extension API {
    enum User: APICall {
        case me, setUsername(String)
        case pushToken
        
        var path: String {
            switch self {
            case .me, .setUsername:
                return "/api/v1/me"
            case .pushToken:
                return "/api/v1/token"
            }
        }
        
        var method: String {
            switch self {
            case .me:
                return "GET"
            case .setUsername:
                return "POST"
            case .pushToken:
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
            if case let .setUsername(newName) = self {
                return try JSONEncoder().encode(DTO.SetUsernameRq(username: newName))
            }
            
            if case .pushToken = self {
                guard
                    let pushToken = UserDefaults.standard.string(forKey: "push-token"),
                    let uid = UIDevice.current.identifierForVendor?.uuidString
                else {
                    throw NSError(domain: "a", code: 1)
                }
                let dto = DTO.UpdatePushTokenRq(
                    uid: uid,
                    pushToken: pushToken,
                    os: "iOS"
                )
                return try JSONEncoder().encode(dto)
            }
            return nil
        }
        
    }
}
