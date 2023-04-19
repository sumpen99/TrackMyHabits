//
//  TrackMyHabitsApp.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

@main
struct TrackMyHabitsApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var phase
    @StateObject var firebaseAuth = FirebaseAuth()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
            .environmentObject(firebaseAuth)
          }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
                case .active:
                    firebaseAuth.refreshLoggedInStatus()
                    printAny("Active")
                case .inactive:
                    printAny("InActive")
                case .background:
                    printAny("Background")
                @unknown default:
                    printAny("Unknown Future Options")
            }
        }
    }
}
