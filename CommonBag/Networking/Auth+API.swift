//
//  Auth+API.swift
//  CommonBag
//
//  Created by MikhailSeregin on 19.06.2022.
//

import Foundation
import Networking
import UIKit

extension API {
    enum Auth: APICall {
        case signin
        var path: String {
            switch self {
            case .signin:
                return "/api/v1/registration"
            }
        }
        
        var method: String {
            switch self {
            case .signin:
                return "POST"
            }
        }
        
        var headers: [String : String]? {
            ["Content-Type": "application/json"]
        }
        
        var query: [String : String]? {
            nil
        }
        
        func body() throws -> Data? {
            if let uid = UIDevice.current.identifierForVendor {
                let auth = AuthRq(uid: uid, pushToken: nil, os: "iOS")
                return try JSONEncoder().encode(auth)
            }
            return nil
        }
        
        struct AuthRq: Codable {
            let uid: UUID
            let pushToken: String?
            let os: String
        }
        
        struct AuthRs: Codable {
            let token: String
        }
    }
}
