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
    let rating:Float
    
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
                        Text(comments)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    Text(timeOfExecution.dateformatted)
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
