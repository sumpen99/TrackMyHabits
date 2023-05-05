//
//  ContentView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI
struct ContentView: OptionalView {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @State var isMemoryWarning: Bool = false
    private let memoryWarningPublisher = NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
    
    var isPrimaryView: Bool { firebaseAuth.isLoggedIn }
    
    init(){
        UITabBar.changeAppearance()
        UINavigationBar.changeAppearance()
    }
    
   
    
    var primaryView: some View {
        ZStack{
            TabView {
                HabitView()
                    .tabItem {
                        Label("Översikt", systemImage: "house.fill")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profil", systemImage: "person.fill")
                    }
            }
        }
        .alert("App Recieved Memory Warning", isPresented: $isMemoryWarning) {
            Button("OK", role: .cancel) { }
        }
        .onReceive(memoryWarningPublisher) { _ in
            isMemoryWarning.toggle()
        }
        .onAppear(){
            firestoreViewModel.loadData(email: firebaseAuth.getUserEmail())
        }
        .onDisappear(){
            firestoreViewModel.releaseData()
        }
        
    }
    
    var optionalView: some View {
        LoginView()
    }
    
}
