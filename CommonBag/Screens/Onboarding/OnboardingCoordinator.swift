//
//  OnboardingCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 08.07.2022.
//

import SwiftUI
import Stinsen

final class OnboardingCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \OnboardingCoordinator.start)
    
    @Root var start = makeStart
    
    let serviceLocator: ServiceLocatorProtocol
    
    init(serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
    }
}

extension OnboardingCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        OnboardingView(viewModel: .init())
    }
}
