//
//  ProductSuggestView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 22.06.2022.
//

// TODO: подумать, как лучше сделать
import SwiftUI
import Stinsen
import Combine

struct ProductSuggestView: View {
    @ObservedObject var viewModel: ProductSuggestViewModel
    var body: some View {
        Text("Soon")
    }
}

final class ProductSuggestViewModel: ObservableObject {
    let networking: NetworkClientProtocol
    let searchPublisher: PassthroughSubject<String, Never>
    private var disposables = Set<AnyCancellable>()
    init(networking: NetworkClientProtocol, searchPublisher: PassthroughSubject<String, Never>) {
        self.searchPublisher = searchPublisher
        self.networking = networking
        bind()
    }
    
    private func bind() {
        searchPublisher
            .debounce(for: .seconds(1.5), scheduler: RunLoop.main)
            .sink(receiveValue: { searchValue in
                print(searchValue)
            })
            .store(in: &disposables)

    }
}

final class ProductSuggestCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \ProductSuggestCoordinator.start)
    @Root var start = makeStart

    let networking: NetworkClientProtocol
    let searchPublisher: PassthroughSubject<String, Never>
    
    init(networking: NetworkClientProtocol, searchPublisher: PassthroughSubject<String, Never>) {
        self.networking = networking
        self.searchPublisher = searchPublisher
    }

    @ViewBuilder func makeStart() -> some View {
        ProductSuggestView(viewModel: .init(networking: networking, searchPublisher: searchPublisher))
    }
}
