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
                        ScrollView{
                            VStack() {
                                ForEach(firestoreViewModel.habits, id: \.id){ habit in
                                    NavigationLink(destination: HabitSettingsView(habit:habit)) {
                                        HabitCardView(habit:habit)
                                    }
                                }
                                
                            }
                        }
                        .listRowBackground(Color(hex: 0xFFFAFA,alpha: 0.1))
                        .frame(height:HABIT_CARDVIEW_HEIGHT*3)
                        
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
        .animation(.easeIn)
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
