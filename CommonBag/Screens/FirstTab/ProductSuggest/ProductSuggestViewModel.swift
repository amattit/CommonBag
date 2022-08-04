//
//  ProductSuggestViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 18.07.2022.
//

import Foundation
import Combine

final class SuggestViewModel: ObservableObject {
    var suggests: [DTO.SuggestRs] = []
    @Published var visible: [DTO.SuggestRs] = []
    @Published var search = ""
    @Published var selected = [DTO.SuggestRs]()
    
    let networkClient: NetworkClientProtocol?
    var disposables = Set<AnyCancellable>()
    let completion: ([DTO.SuggestRs]) -> Void
    
    init(networkClient: NetworkClientProtocol?, completion: @escaping ([DTO.SuggestRs]) -> Void) {
        self.networkClient = networkClient
        self.completion = completion
        bind()
        load()
    }
    
    func bind() {
        $search.sink { value in
            guard value.count > 1 else { return }
            self.visible = self.suggests.filter({ item in
                item.title.localizedCaseInsensitiveContains(value) || item.category.localizedCaseInsensitiveContains(value)
            })
        }
        .store(in: &disposables)
        
        $selected.sink { values in
            print(values)
            print(values.count)
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
            })
            .store(in: &disposables)
    }
}
