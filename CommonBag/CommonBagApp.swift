//
//  CommonBagApp.swift
//  CommonBag
//
//  Created by MikhailSeregin on 16.06.2022.
//

import SwiftUI
import Stinsen

@main
struct CommonBagApp: App {
    let coordinator = AppCoordinator(networking: NetworkClient())
    var body: some Scene {
        WindowGroup {
            coordinator
                .view()
                .onOpenURL { url in
                    coordinator.handleDeepLink(url: url)
                }
        }
    }
}
