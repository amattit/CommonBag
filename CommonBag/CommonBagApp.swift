//
//  CommonBagApp.swift
//  CommonBag
//
//  Created by MikhailSeregin on 16.06.2022.
//

import SwiftUI
import Stinsen
import UserNotifications

@main
struct CommonBagApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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

class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationService = PushNotificationService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        notificationService.registerForPushNotification()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        UserDefaults.standard.set(deviceTokenString, forKey: "push-token")
    }
}
