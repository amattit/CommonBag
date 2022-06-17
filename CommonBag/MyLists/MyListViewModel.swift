//
//  MyListViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen

final class MyListsViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<MyListsCoordinator>?
    @Published var lists: [ListModel]
    
    init() {
        lists = [.mock, .mockEmpty]
    }
    
    func showProductList(_ item: ListModel) {
        router?.route(to: \.productList, item)
    }
    
    func addList() {
        let item = ListModel(id: UUID(), title: "Список покупок", description: "")
        lists.append(item)
        showProductList(item)
    }
}
