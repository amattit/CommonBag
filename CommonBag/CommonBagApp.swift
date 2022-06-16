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
    var body: some Scene {
        WindowGroup {
            AppCoordinator().view()
        }
    }
}
