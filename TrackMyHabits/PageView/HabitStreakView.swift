//
//  HabitStreakView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-05-04.
//

import SwiftUI
struct HabitStreakView: View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @State var showSettingsPage:Bool = false
    @State var habitDeleted:Bool = false
    var habit: Habit
    var body: some View{
        NavigationStack {
            Section{
                if !habit.streak.habitsDone.isEmpty{
                    ScrollView(.vertical,showsIndicators: false){
                        LazyVStack(alignment: .leading,spacing: 10.0){
                            ForEach(habit.streak.getHabitListItems(),id:\.id){ monthlyList in
                                Section(header: Text(monthlyList.month)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                ){
                                    ForEach(monthlyList.habitDone,id:\.id){ done in
                                        StreakCardView(timeOfExecution: done.getTimeFormatted(),
                                                       comments: done.comments,
                                                       rating: Int(done.rating))
                                    }
                                }
                             }
                            /*ForEach(habit.streak.getHabitsDone() ?? [],id:\.id){ done in
                                StreakCardView(timeOfExecution: done.getTimeFormatted(),
                                               comments: done.comments,
                                               rating: Int(done.rating))
                            }*/
                        }
                        .padding()
                    }
                }
                else{
                    ScrollView(.vertical,showsIndicators: false){
                        LazyVStack(alignment: .leading,spacing: 10.0){
                            ForEach(habit.streak.getTestData(),id:\.id){ monthlyList in
                                Section(header: Text(monthlyList.month)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                ){
                                    ForEach(monthlyList.habitDone,id:\.id){ done in
                                        StreakCardView(timeOfExecution: done.getTimeFormatted(),
                                                       comments: done.comments,
                                                       rating: Int(done.rating))
                                    }
                                }
                             }
                        }
                        .padding()
                    }
                    //fillSectionWithEmpy()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {}) {
                            Image(systemName: "calendar")
                        }

                    Button(action: {showSettingsPage.toggle()}) {
                            Image(systemName: "gear")
                        }
                }
            }
            .sheet(isPresented: $showSettingsPage){
                HabitSettingsView(habitDeleted: $habitDeleted,habit:habit)
            }
        }
        .onChange(of: habitDeleted){ deleted in
            if deleted{
                dismiss()
            }
        }
        .modifier(NavigationViewModifier(title: "Historik"))
    }
    
    func fillSectionWithEmpy() -> some View{
        return ZStack{ Spacer() }
    }
  
}
