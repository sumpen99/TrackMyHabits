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
                        .listRowBackground(Color.green)
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
            //.background( appLinearGradient() )
            .background( APP_BACKGROUND_COLOR )
            
            .navigationBarTitle(Text("Fredrik Sundström"),displayMode: .automatic)
            
            /*.onAppear(perform: {
                        setNavigationAppearance()
                    })*/
        }
    }
    
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
