//
//  SuggestCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 18.07.2022.
//

import SwiftUI
import Stinsen

final class SuggestCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \SuggestCoordinator.start)
    
    @Root var start = makeStart
    
    let serviceLocator: ServiceLocatorProtocol
    let viewModel: SuggestViewModel
    
    init(serviceLocator: ServiceLocatorProtocol, completion: @escaping ([DTO.SuggestRs]) -> Void) {
        self.serviceLocator = serviceLocator
        self.viewModel = .init(networkClient: serviceLocator.getService(), completion: completion)
    }
}

extension SuggestCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        ProductSuggestView(viewModel: viewModel)
    }
}

