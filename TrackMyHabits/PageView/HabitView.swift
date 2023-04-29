//
//  HabitView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-20.
//

import SwiftUI
struct HabitView: View{
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @State var showingAddNewHabitView:Bool = false
    var body: some View {
        NavigationStack {
            List {
                Section(header:HeaderSubHeaderView(header:"Status",subHeader: Date.now.dayDateMonth())){
                    StatusCardView(habits: 3, habitsDone: 1, viewMoveTo: AnyView(Text("Hepp")))
                }
                Section(header:HeaderButton(showingAddNewHabitView: $showingAddNewHabitView)){
                    if firestoreViewModel.habits.isEmpty{
                        NoHabitsView()
                    }
                    else{
                        ForEach(firestoreViewModel.habits, id: \.id){ habit in
                            HabitCardView(habit:habit)
                        }
                    }
                }
                NavigationButton(label:"Redigera min dag",
                                 viewMoveTo: AnyView(Text("aaa")))
               
           }
            .modifier(NavigationViewModifier(title: "Översikt"))
        }
        .sheet(isPresented: $showingAddNewHabitView){
            AddHabitView()
        }
        .onAppear(perform:{
            firestoreViewModel.getUserData(email:firebaseAuth.getUserEmail())
            firestoreViewModel.getUserHabits(email:firebaseAuth.getUserEmail())
        })
    }
}

struct HeaderButton: View{
    @Binding var showingAddNewHabitView:Bool
    var body: some View{
        HStack{
            Text("Vanor").sectionHeader()
            Spacer()
            Button(action: {showingAddNewHabitView.toggle()}) {
                Label("", systemImage: "plus").sectionHeader()
            }
        }
    }
}
