//
//  AddProductViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation

final class AddProductViewModel: ObservableObject {
    @Published var input: String = ""
    
    @Published var upcomingProducts: [ProductModel]
    
    init(upcomingProducts: [ProductModel]) {
        self.upcomingProducts = upcomingProducts
    }
    
    func handleInput() {
        let items = input
            .split(separator: ",")
            .map(String.init)
            .map {
                $0
                    .split(separator: ":")
                    .map(String.init)
            }
            .compactMap { item -> ProductModel? in
                if let title = item.first, let count = item.last {
                    
                    return ProductModel(id: UUID(), title: title.trimmingCharacters(in: .whitespaces), count: title == count ? "" : count.trimmingCharacters(in: .whitespaces))
                }
                return nil
            }
        self.upcomingProducts.append(contentsOf: items)
        print(items)
    }
}
