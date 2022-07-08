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
        var isOwn: Bool?
        var isShared: Bool?
        var profile: Profile?
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
    
    struct Profile: Codable, Hashable, Identifiable {
        let id: UUID
        let devices: [Device]
        let username: String?
    }
    
    struct Device: Codable, Hashable {
        let uid: String
        let pushToken: String?
        let os: String
    }
    
    struct ShareTokenRs: Codable {
        let token: String
        let expireAt: Date
    }
    
    struct SetUsernameRq: Codable {
        let username: String
    }
}
