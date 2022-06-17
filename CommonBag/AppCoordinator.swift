//
//  AppCoordinator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import Foundation
import Stinsen

final class AppCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \AppCoordinator.start)
    
    @Root var start = makeStart
    
    func makeStart() -> NavigationViewCoordinator<MyListsCoordinator> {
        NavigationViewCoordinator(MyListsCoordinator())
    }
}
