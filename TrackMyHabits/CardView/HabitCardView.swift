//
//  HabitCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-24.
//

import SwiftUI
struct HabitCardView: View {
    let habit:Habit
    /*
    let title = "habbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbh55555"
    let motivation = "habbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbhhabbbbbbbh55555"
     */
    var body: some View {
        ZStack(alignment:.center){
            NavigationLink(destination: HabitSettingsView(habit:habit)) {
              EmptyView()
            }
            Color.darkBackground
            HStack(alignment: .center) {
                Image(systemName: "brain.head.profile")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                VStack(alignment: .leading) {
                    Text(habit.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .accessibility(addTraits: .isHeader)
                    Spacer()
                    Text(habit.motivation)
                        .font(.caption)
                        .foregroundColor(.white)
                    HStack(alignment: .bottom){
                        Spacer()
                        .badge(
                            Text("\(habit.streak) \(Image(systemName: "flame"))")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        
                    }
                }.padding(.top)
               Rectangle()
                    .fill(Color.darkCardBackground)
                    .frame(width:30)
            }
            
       }
        .frame(height:100.0)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
        )
        .fillSection()
    }
    
}

struct NoHabitsView: View {
     var body: some View {
        ZStack(alignment:.center){
            Color.darkBackground
            VStack(alignment: .center) {
                Image("HabitClock")
                    .resizable()
                    .frame(width: 100.0,height:100.0)
                    .padding()
            }
       }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
        )
        .fillSection()
    }
    
}
