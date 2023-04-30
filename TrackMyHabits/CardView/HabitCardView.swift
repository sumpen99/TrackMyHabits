//
//  HabitCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-24.
//

import SwiftUI
struct HabitCardView: View {
    let habit:Habit
    let textColor:Color = Color.cardColor
    var body: some View {
        ZStack(alignment:.center){
            Color.lightBackground
            HStack(alignment: .center) {
                Image(systemName: "brain.head.profile")
                    .font(.largeTitle)
                    .foregroundColor(textColor)
                    .padding()
                VStack(alignment: .leading,spacing: 5.0) {
                    CardRow(title:"Titel",msg:habit.title)
                    CardRow(title:"Motivation",msg:habit.motivation)
                    CardRow(title:"Mål",msg:habit.goal)
                    /*HStack(){
                        Spacer()
                        .badge(
                            Text("\(habit.streak) \(Image(systemName: "flame"))")
                                //.foregroundColor(textColor)
                                .font(.headline)
                        )
                        
                    }*/
                }
                CardGrayTrailing()
            }
            
       }
        .modifier(CardModifier(size: HABIT_CARDVIEW_HEIGHT))
    }
    
}

struct NoHabitsView: View {
     var body: some View {
        ZStack(alignment:.center){
            Color.clear
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
