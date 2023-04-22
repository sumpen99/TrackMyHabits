//
//  HabitView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-20.
//

import SwiftUI
struct HabitView: View{
    @State private var selection: String? = nil
    var body: some View {
        NavigationStack {
            List {
                ItemRow(Date.dayDateMonth())
                Section(header: Text("Status").sectionHeader()) {
                    StatusCardView()
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
