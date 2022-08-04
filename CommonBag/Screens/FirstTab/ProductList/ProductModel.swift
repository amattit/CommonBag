//
//  ProductModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation

struct ProductModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let count: String
    let color: String?
    
    internal init(id: UUID, title: String, count: String, color: String?) {
        self.id = id
        self.title = title
        self.count = count
        self.color = color
    }
    
    internal init(_ suggest: DTO.SuggestRs) {
        var count: String {
            if let value = suggest.count?.description {
                if value.contains(".0") {
                    return Int(suggest.count ?? 0).description
                } else {
                    return value.description
                }
            }
            return suggest.count?.description ?? "0"
        }
        
        id = .init()
        title = suggest.title
        self.count = count + (suggest.mesureUnit?.title ?? "")
        color = suggest.color
    }
    
}
