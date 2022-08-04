//
//  ProductSuggestViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 18.07.2022.
//

import Foundation
import Combine

final class SuggestViewModel: ObservableObject {
    @Published var suggests: [DTO.SuggestRs] = []
//    @Published var visible: [DTO.SuggestRs] = []
    @Published var search = ""
    
    let networkClient: NetworkClientProtocol?
    var disposables = Set<AnyCancellable>()
    let completion: ([DTO.SuggestRs]) -> Void
    
    init(networkClient: NetworkClientProtocol?, completion: @escaping ([DTO.SuggestRs]) -> Void) {
        self.networkClient = networkClient
        self.completion = completion
//        bind()
        load()
    }
    
    func select(_ model: DTO.SuggestRs) {
        
    }
    
    func check() {
        let items = suggests.filter {
            $0.count ?? 0 > 0
        }
        print(items)
    }
    
//    private func bind() {
//        $search
//            .receive(on: DispatchQueue.main)
//            .sink { input in
//                if input.isEmpty {
//                    self.visible = self.suggests
//                } else {
//                    self.visible = self.suggests.filter({ suggest in
//                        suggest.title.localizedCaseInsensitiveContains(input) || suggest.category.localizedCaseInsensitiveContains(input)
//                    })
//                }
//        }
//        .store(in: &disposables)
//    }
    
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
