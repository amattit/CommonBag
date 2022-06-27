//
//  Recipe+API.swift
//  CommonBag
//
//  Created by MikhailSeregin on 25.06.2022.
//

import Foundation
import Networking

extension API {
    enum Recipes: APICall {
        case getCategories, getRecipeInCategory(UUID), getRecipe(UUID)
        case addProducsToList(UUID, [DTO.RecipeProductRs])
        var basePath: String {
            "/api/v1/recipe"
        }
        var path: String {
            switch self {
            case .getCategories:
                return basePath + "/category"
            case .getRecipeInCategory(let id):
                return basePath + "/category/\(id.uuidString)"
            case .getRecipe(let id):
                return basePath + "/\(id)"
                
            //[POST]/api/v1/list/:listId/recipe
            case .addProducsToList(let listId, _):
                return "/api/v1/add/list/\(listId.uuidString)/recipe"
            }
        }
        
        var method: String {
            switch self {
            case .addProducsToList:
                return "POST"
            default:
                return "GET"
            }
        }
        
        var headers: [String : String]? {
            switch self {
            case .addProducsToList:
                return [
                    "Authorization": "Bearer \(API.authToken)",
                    "Content-Type": "application/json"
                ]
            default:
                return [
                    "Content-Type": "application/json"
                ]
            }
        }
        
        var query: [String : String]? {
            nil
        }
        
        func body() throws -> Data? {
            if case let .addProducsToList(_, products) = self {
                return try JSONEncoder().encode(products)
            }
            return nil
        }
    }
}
