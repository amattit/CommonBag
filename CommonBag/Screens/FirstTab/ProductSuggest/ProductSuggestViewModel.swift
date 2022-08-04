//
//  ProductSuggestViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 18.07.2022.
//

import Foundation
import Combine
import Stinsen

final class SuggestViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<SuggestCoordinator>?
    var suggests: [DTO.SuggestRs] = []
    @Published var visible: [DTO.SuggestRs] = []
    @Published var search = ""
    @Published var selected = [DTO.SuggestRs]()
    let list: ListModel
    let networkClient: NetworkClientProtocol?
    var disposables = Set<AnyCancellable>()
    
    init(list: ListModel, networkClient: NetworkClientProtocol?) {
        self.networkClient = networkClient
        self.list = list
        bind()
        load()
    }
    
    func bind() {
        
        $search.sink { value in
            guard !value.isEmpty else {
                self.visible = self.suggests
                return
            }
            self.visible = self.suggests
                .filter({ item in
                item.title.localizedCaseInsensitiveContains(value) || item.category.localizedCaseInsensitiveContains(value)
            })
        }
        .store(in: &disposables)
        
        $selected.sink { values in
            print(values)
            print(values.count)
            let search = self.search
            self.search = ""
            self.search = search
            
        }
        .store(in: &disposables)
    }
    
    func check() {
        let items = suggests.filter {
            $0.count ?? 0 > 0
        }
        print(items)
    }
    
    func load() {
        networkClient?
            .execute(api: API.Suggest.search(""), type: [DTO.SuggestRs].self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.suggests = response
                self.visible = response
            })
            .store(in: &disposables)
    }
    
    func save() {
        let products = selected.map(ProductModel.init)
        
        networkClient?
            .execute(api: API.Products.massCreate(list, products), type: [DTO.ProductRs].self)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in
                self.router?.dismissCoordinator(nil)
                NotificationCenter.default.post(name: .reloadProducts, object: nil)
            })
            .store(in: &disposables)
    }
}
