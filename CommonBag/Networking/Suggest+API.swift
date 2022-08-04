//
//  Suggest+API.swift
//  CommonBag
//
//  Created by MikhailSeregin on 10.07.2022.
//

import Foundation
import Networking

extension API {
    enum Suggest: APICall {
        case search(String)
        
        var path: String {
            return "/api/v1/search"
        }
        
        var method: String {
            "GET"
        }
        
        var headers: [String : String]? {
            ["Content-Type": "application/json"]
        }
        
        var query: [String : String]? {
            if case let .search(query) = self {
                return ["title": query]
            }
            return nil
        }
        
        func body() throws -> Data? {
            nil
        }
    }
}
