//
//  StatusCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-21.
//

import SwiftUI

struct StatusCardView: View{
    let habits:Int
    let habitsDone:Int
    var viewMoveTo: AnyView
    var body: some View {
        
        ZStack(alignment: .center) {
            NavigationLink(destination: viewMoveTo) {
              EmptyView()
            }
            Color.darkBackground
            ZStack{
                HalfCircleGradient(habits: habits, habitsDone: habitsDone)
                .frame(width: 200.0, height: 200.0)
            }.padding(.top,60)
            VStack(alignment:.trailing) {
                Spacer()
                HStack(alignment:.bottom) {
                    Spacer()
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 40, height: 80)
                        .rotationEffect(.degrees(45.0)).padding(.trailing,-10)
                }
                
            }
        }
        .frame(height: 200.0)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .fillSection()
    }
}

struct HalfCircleGradient: View {
    let habits:Int
    let habitsDone:Int
    var progress:CGFloat { Float(Float(habitsDone)/Float(habits)).remapValue(min1: 0.0, max1: 1.0, min2: 0.3, max2: 0.9) }
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.3, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(54.5))
            
            Circle()
                .trim(from: 0.3, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .fill(AngularGradient(gradient: Gradient(stops: [
                    .init(color: Color(hex: 0xED4D4D), location: 0.39000002),
                    .init(color: Color(hex: 0xE59148), location: 0.48000002),
                    .init(color: Color(hex: 0xEFBF39), location: 0.5999999),
                    .init(color: Color(hex: 0xEEED56), location: 0.7199998),
                    .init(color: Color(hex: 0x32E1A0), location: 0.8099997)]), center: .center))
                .rotationEffect(.degrees(54.5))
            
            VStack{
                Text("\(habitsDone)/\(habits)").font(Font.system(size: 44)).bold().foregroundColor(Color(hex: 0x314058))
                Text(progressText()).bold().foregroundColor(Color(hex: 0x314058))
            }
        }
    }
    
    func progressText() -> String{
        let progressRaw = Float(habitsDone) / Float(habits)
        if progressRaw == 1.0{ return "Bra jobbat idag"}
        else if progressRaw < 0.5 { return "Fortsätt kämpa"}
        else if progressRaw < 0.75{ return "Snart så"}
        return "Nästa klar"
        
    }
}


