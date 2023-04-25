//
//  ContentView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI
struct ContentView: OptionalView {

    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @State var isMemoryWarning: Bool = false
    private let memoryWarningPublisher = NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
    
    var isPrimaryView: Bool { firebaseAuth.isLoggedIn }
    
    let dummy = Dummy(name:"ContentView",printOnDestroy: true)
    
    
    init(){
        //UITabBar.changeAppearance()
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
        .alert("App Recieved Memory Warning", isPresented: $isMemoryWarning) {
            Button("OK", role: .cancel) { }
        }
        .onReceive(memoryWarningPublisher) { _ in
            isMemoryWarning.toggle()
        }
    }
    
    var optionalView: some View {
        LoginView()
    }
    
}
