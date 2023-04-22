//
//  ContentView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI
struct ContentView: OptionalView {

    @EnvironmentObject var firebaseHandler: FirebaseHandler
    
    var isPrimaryView: Bool { firebaseHandler.isLoggedIn }
    
    let dummy = Dummy(name:"ContentView",printOnDestroy: true)
    
    
    init(){
        UITabBar.changeAppearance()
        UINavigationBar.changeAppearance()
    }
    
   
    
    var primaryView: some View {
        ZStack{
            TabView {
                HabitView()
                    .tabItem {
                        Label("Översikt", systemImage: "circle.dashed")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profil", systemImage: "person.fill")
                    }
            }
            //.accentColor(.green)
        }
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
