//
//  HabitStreak.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-05-03.
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
                        VStack(alignment: .leading,spacing: 10.0){
                            ForEach(habit.streak.getHabitsDone() ?? [],id:\.id){ done in
                                StreakCardView(timeOfExecution: done.getTimeFormatted(),
                                               comments: done.comments,
                                               rating: done.rating)
                            }
                        }
                        .padding()
                    }
                }
                else{
                    fillSectionWithEmpy()
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
    
    func closeView(){
        dismiss()
    }
}
