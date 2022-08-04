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
        let color: String?
    }
    
    struct ProductRs: Codable {
        let id: UUID
        let title: String
        let count: String?
        let isDone: Bool
        let color: String?
    }
    
    struct UpdatePushTokenRq: Codable {
        let uid: String
        let pushToken: String?
        let os: String
    }
    
    struct Profile: Codable, Hashable, Identifiable, Equatable {
        let id: UUID
        let devices: [Device]
        let username: String?
        
        static func == (lhs: Profile, rhs: Profile) -> Bool {
            return lhs.id == rhs.id
        }
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

extension DTO {
    struct Settings: Codable {
        let shareToken: [String]?
        let users: [Profile]
    }
}

extension DTO {
    struct SuggestRs: Codable, Hashable, Identifiable {
        let id: UUID
        let title: String
        let category: String
        let color: String
        var count: Double?
        var mesureUnit: MesureUnit?; enum MesureUnit: CaseIterable, Identifiable, Hashable, Codable {
            var id: Int {
                hashValue
            }
            case kg, sht, gr, lit
            var title: String {
                switch self {
                case .kg:
                    return "кг"
                case .sht:
                    return "шт"
                case .gr:
                    return "гр"
                case .lit:
                    return "л"
                }
            }
        }
    }
}
