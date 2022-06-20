//
//  DTO.swift
//  CommonBag
//
//  Created by MikhailSeregin on 20.06.2022.
//

import Foundation

struct DTO {
    struct UpsertListRq: Codable {
        var id: UUID?
        let title: String
    }
    
    struct ListRs: Codable {
        let id: UUID
        let title: String
        let count: String
    }
    
    struct CreateProductRq: Codable {
        let title: String?
        let count: String?
        let measureUnit: String?
    }
    
    struct ProductRs: Codable {
        let id: UUID
        let title: String
        let count: String?
        let isDone: Bool
    }
    
    struct UpdatePushTokenRq: Codable {
        let uid: String
        let pushToken: String?
        let os: String
    }
    
    struct Profile: Codable {
        let id: UUID
        let devices: [Device]
    }
    
    struct Device: Codable {
        let uid: String
        let pushToken: String?
        let os: String
    }
    
    struct ShareTokenRs: Codable {
        let token: String
        let expireAt: Date
    }
}
