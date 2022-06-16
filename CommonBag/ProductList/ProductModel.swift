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
}
