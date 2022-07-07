//
//  Products+API.swift
//  CommonBag
//
//  Created by MikhailSeregin on 19.06.2022.
//

import Foundation
import Networking

extension API {
    enum Products: APICall {
        case getBy(ListModel), create(ListModel, ProductModel), setMade(ProductModel), setUpcomming(ProductModel), delete(ProductModel), rename(UUID, String, String), massCreate(ListModel, [ProductModel])
        var path: String {
            switch self {
            case .getBy(let listModel):
                return "/api/v1/list/\(listModel.id.uuidString)/product"
            case .create(let listModel, _):
                return "/api/v1/list/\(listModel.id.uuidString)/product"
            case .setMade(let productModel):
                return "/api/v1/product/\(productModel.id.uuidString)/done"
            case .setUpcomming(let productModel):
                return "/api/v1/product/\(productModel.id.uuidString)/un-done"
            case .delete(let productModel):
                return "/api/v1/product/\(productModel.id.uuidString)"
            case .rename(let uid, _, _):
                return "/api/v1/product/\(uid.uuidString)"
            case .massCreate(let listModel, _):
                return "/api/v1/list/\(listModel.id.uuidString)/products"
            }
        }
        
        var method: String {
            switch self {
            case .getBy:
                return "GET"
            case .create, .massCreate:
                return "POST"
            case .setMade:
                return "PUT"
            case .setUpcomming:
                return "PUT"
            case .delete:
                return "DELETE"
            case .rename:
                return "PATCH"
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
            case .create(_, let productModel):
                let dto = DTO.CreateProductRq(title: productModel.title, count: productModel.count, measureUnit: nil)
                return try JSONEncoder().encode(dto)
            case .massCreate(_, let products):
                let dto = products.map { productModel in
                    DTO.CreateProductRq(title: productModel.title, count: productModel.count, measureUnit: nil)
                }
                return try JSONEncoder().encode(dto)
            case .rename(_, let title, let count):
                let dto = DTO.CreateProductRq(title: title, count: count, measureUnit: nil)
                return try JSONEncoder().encode(dto)
            default:
                return nil
            }
        }
    }
}
