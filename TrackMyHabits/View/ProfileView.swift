//
//  ProfileView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//

import SwiftUI
//https://www.hackingwithswift.com/forums/swiftui/background-color-of-a-list-make-it-clear-color/3379
struct ProfileView: View{
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ONSDAG 19 APRIL")) {
                    Text("Översikt").bold().font(.largeTitle)
                        .listRowBackground()
                }
                Section(header: Text("Your Info 1")) {
                    TextFieldsToTest()
                }
                Section(header: Text("Your Info 1")) {
                    TextFieldsToBeRemoved()
                }
                Section(header: Text("Your Info 2")) {
                    TextFieldsToBeRemoved()
                }
                Section(header: Text("Your Info 3")) {
                    TextFieldsToBeRemoved()
                }
            }
            .listRowBackground(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .background( appLinearGradient() )
            
            .navigationBarTitle(Text("Fredrik Sundström"))
            
            /*.onAppear(perform: {
                        setNavigationAppearance()
                    })*/
        }
    }
    
    /*private func setNavigationAppearance() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .red

            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.monospacedSystemFont(ofSize: 56, weight: .black)
            ]
            appearance.largeTitleTextAttributes = attrs
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }*/
}

struct TextFieldsToBeRemoved: View{
    var body: some View{
        Text("$user.name")
            .removePredictiveSuggestions()
            .textContentType(.name)
        Text("$user.email")
            .removePredictiveSuggestions()
            .textContentType(.emailAddress)
        
    }
}

struct TextFieldsToTest: View{
    var body: some View{
        Text("Onsdag 19 April")
            .removePredictiveSuggestions()
            .textContentType(.name)
        Text("Översikt")
            .removePredictiveSuggestions()
            .textContentType(.emailAddress)
        
    }
}
