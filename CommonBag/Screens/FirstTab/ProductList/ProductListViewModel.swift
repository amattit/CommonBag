//
//  ProductListViewModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen
import Combine

final class ProductListViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<ProductListCoordinator>?
    @Published var upcomingProducts: [ProductModel] = []
    @Published var madeProducts: [ProductModel] = []
    let list: ListModel
    @Published var newListName = ""
    let networkClient: NetworkClientProtocol?
    let userService: UserService?
    
    var disposables = Set<AnyCancellable>()
    
    var backButtonName: String {
        "1.square"
    }
    
    init(list: ListModel, networkClient: NetworkClientProtocol?, userService: UserService?) {
        self.networkClient = networkClient
        self.list = list
        self.newListName = list.title
        self.userService = userService
        bind()
        load()
    }
    
    func load() {
        networkClient?
            .execute(api: API.Products.getBy(list), type: [DTO.ProductRs].self)
            .map { items -> ([ProductModel], [ProductModel]) in
                let upcomingProducts = items
                    .filter({ $0.isDone == false })
                    .map { ProductModel(id: $0.id, title: $0.title, count: $0.count ?? "", color: $0.color) }
                
                let madeProducts = items
                    .filter({ $0.isDone == true })
                    .map { ProductModel(id: $0.id, title: $0.title, count: $0.count ?? "", color: $0.color) }
                
                return (upcomingProducts, madeProducts)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.upcomingProducts = response.0.sorted(by: { l, r in
                    self.getPriority(l) < self.getPriority(r)
                })
                self.madeProducts = response.1
            }
            .store(in: &disposables)

    }
    
    func getPriority(_ model: ProductModel) -> Int {
            switch model.color {
            case "red":
                return 0
            case "green":
                return 1
            case "blue":
                return 2
            case "yellow":
                return 3
            case "pink":
                return 4
            case "orange":
                return 5
            default:
                return 6
            }
    }
    
    func setMade(_ product: ProductModel) {
        networkClient?
            .execute(api: API.Products.setMade(product), type: DTO.ProductRs.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.deleteFromUpcoming(product)
                self.madeProducts.append(product)
            }
            .store(in: &disposables)
    }
    
    func setUpcoming(_ product: ProductModel) {
        networkClient?
            .execute(api: API.Products.setUpcomming(product), type: DTO.ProductRs.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.deleteFromMade(product)
                self.upcomingProducts.append(product)
            }
            .store(in: &disposables)
    }
    
    func delete(_ productModel: ProductModel) {
        networkClient?
            .executeData(api: API.Products.delete(productModel))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.deleteFromMade(productModel)
                self.deleteFromUpcoming(productModel)
            }
            .store(in: &disposables)
    }
    
    private func deleteFromUpcoming(_ product: ProductModel) {
        upcomingProducts.removeAll {
            $0 == product
        }
    }
    
    func getShareToken() {
        if let username = userService?.user?.username, !username.isEmpty {
            networkClient?
                .execute(api: API.List.getShareToken(list.id), type: DTO.ShareTokenRs.self)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print(error.localizedDescription)
                    }
                } receiveValue: { response in
                    guard let url = URL(string: "https://product-list-dev.herokuapp.com/list/token/\(response.token)") else { return }
                    self.router?.route(to: \.share, url)
                }
                .store(in: &disposables)
        } else {
            self.router?.route(to: \.profile, getShareToken)
        }
    }
    
    private func deleteFromMade(_ product: ProductModel) {
        madeProducts.removeAll {
            $0 == product
        }
    }
    
    func dismiss() {
        router?.dismissCoordinator({
            NotificationCenter.default.post(name: .reloadLists, object: nil)
        })
    }
    
    func showAddProducts() {
        router?.route(to: \.add, upcomingProducts)
    }
    
    func changeListTile() {
        router?.route(to: \.settings)
    }
    
    func renameProduct(_ product: ProductModel) {
        router?.route(to: \.renameProduct, product)
    }
    
    func bind() {
        NotificationCenter.default.publisher(for: .reloadLists).sink { _ in
        } receiveValue: { _ in
            self.networkClient?.execute(api: API.List.getAll, type: [DTO.ListRs].self)
                .sink { _ in
                } receiveValue: { lists in
                    if let title = lists.first(where: {
                        $0.id == self.list.id
                    })?.title {
                        self.newListName = title
                    }
                }
                .store(in: &self.disposables)

        }
        .store(in: &disposables)
        
        NotificationCenter.default.publisher(for: .reloadProducts).sink { _ in
            self.load()
        }
        .store(in: &disposables)
    }
}
