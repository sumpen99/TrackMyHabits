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
            List {
                ItemRow(Date.dayDateMonth())
                Section(header: Text("Status").sectionHeader()) {
                    StatusCardView()
                        .fillSection()
                }
                Section(header: HStack{
                    Text("Vanor").sectionHeader()
                    Spacer()
                    Text("Lägg till").sectionHeader()
                    
                }) {
                    NavigationLink(destination: Text("aaa")) {
                        Label("Buttons", systemImage: "capsule")
                    }
                    NavigationLink(destination: Text("aaa")) {
                        Label("Colors", systemImage: "paintpalette")
                    }
                    NavigationLink(destination: Text("aaa")) {
                        Label("Controls", systemImage: "slider.horizontal.3")
                    }
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
            //.listStyle(GroupedListStyle())
            //.listRowBackground(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .background( APP_BACKGROUND_COLOR )
            .navigationBarTitle(Text("Översikt"))
            /*.navigationBarItems(leading:
                VStack {
                    
                }
             )*/
        }
    }
    
}


