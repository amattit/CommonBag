//
//  API.swift
//  CommonBag
//
//  Created by MikhailSeregin on 19.06.2022.
//

import Foundation
import Networking

enum API {}

extension API {
    static var authToken: String {
        get {
            UserDefaults.standard.string(forKey: "auth-token") ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "auth-token")
        }
    }
}
