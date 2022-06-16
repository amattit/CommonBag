//
//  ProductListViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation

final class ProductListViewModel: ObservableObject {
    @Published var upcomingProducts: [ProductModel] = []
    @Published var madeProducts: [ProductModel] = []
    
    init() {
        upcomingProducts = [
            .init(id: UUID(), title: "Продукт", count: "2"),
            .init(id: UUID(), title: "Хлеб", count: ""),
        ]
        
        madeProducts = [
            .init(id: UUID(), title: "Сыр плавленный", count: "1"),
            .init(id: UUID(), title: "Агуша", count: "6"),
        ]
    }
    
    func setMade(_ product: ProductModel) {
        deleteFromUpcoming(product)
        
        madeProducts.append(product)
    }
    
    func setUpcoming(_ product: ProductModel) {
        deleteFromMade(product)
        
        upcomingProducts.append(product)
    }
    
    func deleteFromUpcoming(_ product: ProductModel) {
        upcomingProducts.removeAll {
            $0 == product
        }
    }
    
    func deleteFromMade(_ product: ProductModel) {
        madeProducts.removeAll {
            $0 == product
        }
    }
}
