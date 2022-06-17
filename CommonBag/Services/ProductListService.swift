//
//  ProductListService.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Combine

final class ProductListService {
    private var lists: [ListModel] = []
    private var products: [UUID: [ProductModel]] = [:]

    var listsPublisher = PassthroughSubject<[ListModel], Never>()
    var productsPublisher = PassthroughSubject<[ProductModel], Never>()
    
    func createList(list: ListModel) {
        lists.append(list)
        listsPublisher.send(lists)
    }
    
    func addProduct(to list: ListModel, products: [ProductModel]) {
        self.products[list.id, default: []].append(contentsOf: products)
        productsPublisher.send(self.products[list.id, default: []])
    }
    
    func getProducts(for list: ListModel) {
        productsPublisher.send(products[list.id, default: []])
    }
    
    func getListCount() -> String {
        lists.count.description
    }
}
