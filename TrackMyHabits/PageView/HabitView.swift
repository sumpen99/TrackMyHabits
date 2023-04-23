//
//  HabitView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-20.
//

import SwiftUI
struct HabitView: View{
   
    
    var body: some View {
        NavigationStack {
            List {
                Section(header:HeaderSubHeaderView(header:"Status",subHeader: Date.dayDateMonth())){
                    StatusCardView(habits: 3, habitsDone: 1, viewMoveTo: AnyView(Text("Hepp")))
                        .fillSection()
                }
                Section(header: HStack{
                    Text("Vanor").sectionHeader()
                    Spacer()
                    NavigationLink(destination: Text("aaa")) {
                        Label("", systemImage: "plus").sectionHeader()
                    }
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
                NavigationButton(label:"Redigera min dag",
                                 viewMoveTo: AnyView(Text("aaa")))
               
           }
            .modifier(NavigationViewModifier(title: "Översikt"))
        }
    }
}
