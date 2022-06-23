//
//  ListModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation

struct ListModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    var description: String
    
    static let mock: ListModel = .init(id: UUID(), title: "Список покупок", description: "Поимодры, Огурцы, Шоколад, Картофель, Макароны, Колбаса вареная, Сыр, Сыр плавленный, Блинчики, Арбуз, яблоки")
    static let mockEmpty: ListModel = .init(id: UUID(), title: "Жопа бобра", description: "")
    
    mutating func addProductInfo(product: ProductModel) {
        self.description += ", \(product.title)"
    }
}
