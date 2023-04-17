//
//  ContentView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI
struct ContentView: OptionalView {

    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    var isPrimaryView: Bool { firebaseAuth.isLoggedIn }
    
    let dummy = Dummy(name:"ContentView",printOnDestroy: true)
    
    init(){
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        //UITabBar.appearance().backgroundColor = UIColor.white
        //UITabBar.appearance().isTranslucent = false
    }
    
    var primaryView: some View {
        ZStack{
            TabView {
                /*GameMenuView()
                    .tabItem {
                        Label("Menu", systemImage: "list.dash")
                    }
                GameMenuView()
                    .tabItem {
                        Label("HighScore", systemImage: "star.square.fill")
                    }
                GameMenuView()
                    .tabItem {
                        Label("Person", systemImage: "person.fill")
                    }
                 */
            }
            .accentColor(.green)
            .animation(
              Animation
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: false),
              value: UUID()
            )
        }
        .animation(
          Animation
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: false),
          value: UUID()
        )
    }
    
    var optionalView: some View {
        LoginView()
        .animation(
          Animation
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: false),
          value: UUID()
        )
    }
    
}
