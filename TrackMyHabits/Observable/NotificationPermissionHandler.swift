//
//  NotificationPermissionHandler.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-26.
//

import SwiftUI
import UserNotifications
class NotificationPermissionHandler : ObservableObject{
    
    func checkPermission(completion: @escaping (UNNotificationSettings) -> Void){
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler:completion)
    }
    
    func requestPermission(completion: @escaping ((Bool, (any Error)?) -> Void)) {
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound , .alert , .badge ],completionHandler:completion)
    }
}
