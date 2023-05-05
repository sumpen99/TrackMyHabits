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
                    StatusCardView(userStatus:$firestoreViewModel.userStatus)
                }
                Section(header:HeaderButton(showingAddNewHabitView: $showingAddNewHabitView)){
                    if firestoreViewModel.habits.isEmpty{
                        //NoHabitsView()
                    }
                    else{
                        ScrollView(.vertical,showsIndicators: false){
                            VStack() {
                                ForEach(firestoreViewModel.habits, id: \.id){ habit in
                                    NavigationLink(destination: HabitStreakView(habit:habit)) {
                                        HabitCardView(title: habit.title,
                                                      motivation: habit.motivation,
                                                      goal: habit.goal)
                                    }
                                    .padding(.top)
                                }
                                
                            }
                        }
                        .listRowBackground(Color(hex: 0xFFFAFA,alpha: 0.1))
                    }
                }
           }
            .modifier(NavigationViewModifier(title: "Dina Vanor"))
        }
        .sheet(isPresented: $showingAddNewHabitView){
            AddHabitView()
        }
        //.fullScreenCover(isPresented: $showingAddNewHabitView, content: AddHabitView.init)
        //.onAppear(perform:{
            //firestoreViewModel.getUserData(email:firebaseAuth.getUserEmail())
            //firestoreViewModel.getUserHabits(email:firebaseAuth.getUserEmail())
        //})
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

struct HeaderButtonNavigationLink: View{
    @Binding var showingAddNewHabitView:Bool
    var body: some View{
        NavigationLink { AddHabitView() } label: {
            HStack{
                Text("Vanor").sectionHeader()
                Spacer()
                Label("", systemImage: "plus").sectionHeader()
            }
        }
    }
}
