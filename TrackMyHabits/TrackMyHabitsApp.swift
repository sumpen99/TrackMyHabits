//
//  TrackMyHabitsApp.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
}

@main
struct TrackMyHabitsApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var phase
    @StateObject var notificationHandler = NotificationHandler()
    @StateObject var firestoreViewModel = FirestoreViewModel()
    @StateObject var firebaseAuth = FirebaseAuth()
  
    init(){
        FirebaseApp.configure()
    }
    
   
    
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
            .environmentObject(firebaseAuth)
            .environmentObject(firestoreViewModel)
            .environmentObject(notificationHandler)
          }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
                case .active:
                    firebaseAuth.isUserLoggedIn()
                case .inactive:
                    firebaseAuth.isUserLoggedIn()
                case .background:
                    printAny("Background")
                @unknown default:
                    printAny("Unknown Future Options")
            }
        }
    }
    
}
