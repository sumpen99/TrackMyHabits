//
//  StreakCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-05-03.
//

import SwiftUI

struct StreakCardView: View{
    
    let timeOfExecution:(dateformatted:String,weekday:String)
    let comments:String
    let rating:Int
    let star = Image(systemName: "star.fill")
    var body: some View{
        HStack(alignment: .top,spacing:30.0){
            VStack(spacing:10.0){
                Circle()
                    .fill(.black)
                    .frame(width:15,height:15)
                    .background(
                        Circle()
                            .stroke(.black,lineWidth: 1.0)
                            .padding(-3)
                    )
                Rectangle()
                    .fill(.black)
                    .frame(width: 3.0)
                        
                    
            }
            
            VStack{
                HStack(alignment: .top,spacing: 10.0){
                    VStack(alignment: .leading,spacing:12){
                        Text(timeOfExecution.weekday)
                            .font(.title2.bold())
                        Text("Kommentar").lightCaption()
                        Text("\"\(comments)\"")
                            .lightCaption()
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .hLeading()
                    VStack(alignment: .trailing,spacing:12.0){
                        Text(timeOfExecution.dateformatted)
                        Text("Rating").lightCaption()
                        star.modifier(StarRatingFilled(rating: CGFloat(rating), maxRating: 5.0))
                    }
                    .padding(.top,5)
                    .hTrailing()
                }
            }
            .foregroundColor(.white)
            .padding()
            .hLeading()
            .background(Color.darkCardBackground)
            .cornerRadius(25.0)
        }
        .padding(.top)
        .hLeading()
    }
}
