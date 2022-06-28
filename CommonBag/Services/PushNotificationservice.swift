//
//  PushNotificationservice.swift
//  CommonBag
//
//  Created by MikhailSeregin on 28.06.2022.
//

import Foundation
import UserNotifications
import UIKit

final class PushNotificationService: NSObject {
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func registerForPushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if granted {
                self?.getNotificationSettings()
            }
        }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
      }
    }
}

extension PushNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .badge, .banner]
    }
}
