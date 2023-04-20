//
//  HabitView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-20.
//

import SwiftUI

struct HabitView: View{
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
            .background( .black )
            
            .navigationBarTitle(Text("Fredrik Sundström"))
        }
    }
    
}


