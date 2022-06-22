//
//  ProductSuggestView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 22.06.2022.
//

import SwiftUI
import Stinsen

struct ProductSuggestView: View {
    @ObservedObject var viewModel: ProductSuggestViewModel
    var body: some View {
        Text("Soon")
    }
}

final class ProductSuggestViewModel: ObservableObject {
    let networking: NetworkClientProtocol
    init(networking: NetworkClientProtocol) {
        self.networking = networking
    }
}

final class ProductSuggestCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \ProductSuggestCoordinator.start)
    let networking: NetworkClientProtocol
    @Root var start = makeStart
    
    init(networking: NetworkClientProtocol) {
        self.networking = networking
    }

    @ViewBuilder func makeStart() -> some View {
        ProductSuggestView(viewModel: .init(networking: networking))
    }
}
