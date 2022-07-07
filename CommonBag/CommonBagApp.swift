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
//    let coordinator = AppCoordinator(networking: NetworkClient())
    var body: some Scene {
        WindowGroup {
            delegate.appCoordinator!
//            coordinator
                .view()
                .onOpenURL { url in
                    delegate.appCoordinator!.handleDeepLink(url: url)
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
//    let notificationService = PushNotificationService()
    let serviceLocator = ServiceLocator()
    var appCoordinator: AppCoordinator?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        configureServices()
        let notificationService: PushNotificationService? = serviceLocator.getService()
        notificationService?.registerForPushNotification()
        appCoordinator = AppCoordinator(serviceLocator: serviceLocator)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        UserDefaults.standard.set(deviceTokenString, forKey: "push-token")
    }
    
    func configureServices() {
        let networkService: NetworkClientProtocol = NetworkClient()
        serviceLocator.addService(service: networkService)
        serviceLocator.addService(service: PushNotificationService())
        serviceLocator.addService(service: ProductListRenameService(networkClient: serviceLocator.getService()))
        serviceLocator.addService(service: UsernameRenameService(networkClient: serviceLocator.getService()))
        serviceLocator.addService(service: ProductRenameService(networkClient: serviceLocator.getService()))
        serviceLocator.addService(service: UserService(networkClient: serviceLocator.getService()))
    }
}
