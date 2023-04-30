//
//  StatusCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-21.
//

import SwiftUI

struct CardRow: View{
    let title:String
    let msg:String
    var body: some View{
        VStack(alignment:.leading){
            Text(title).font(.caption).bold().foregroundColor(.black)
            Text(msg).font(.caption).foregroundColor(.gray)
        }
    }
}

struct StatusCardView: View{
    @Binding var userStatus:UserStatus
    var body: some View {
        
        ZStack(alignment: .center) {
            NavigationLink(destination: TodaysTodoView(userStatus:$userStatus)) {
              EmptyView()
            }
            Color.lightBackground
            HStack{
                VStack(alignment:.leading,spacing: 10.0){
                    CardRow(title:"Din dag",msg:userStatus.getTodayMsg())
                    CardRow(title:"Avklarade",msg:userStatus.getDoneMsg())
                    CardRow(title:"Nästa Aktivitet",msg:userStatus.getNextMsg())
                }.padding()
                Spacer()
                ZStack(){
                    HalfCircleGradient(progress: userStatus.getProgress())
                    .frame(width: PROGRESS_CIRCLE_SIZE, height: PROGRESS_CIRCLE_SIZE)
                }
                .padding([.trailing,.top],10)
                CardGrayTrailing()
                
            }
        }
        
        .modifier(CardModifier(size: 150.0))
        .padding()
    }
    
}

struct HalfCircleGradient: View {
    var progress:CGFloat
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.1, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(90.0))
            Circle()
                .trim(from: 0.1, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .fill(AngularGradient(gradient: Gradient(stops: [
                    .init(color: Color(hex: 0xED4D4D), location: 0.39000002),
                    .init(color: Color(hex: 0xE59148), location: 0.48000002),
                    .init(color: Color(hex: 0xEFBF39), location: 0.5999999),
                    .init(color: Color(hex: 0xEEED56), location: 0.7199998),
                    .init(color: Color(hex: 0x32E1A0), location: 0.8099997)]), center: .center))
                .rotationEffect(.degrees(90.0))
            
            /*Image(systemName: "face.smiling.fill")
                .resizable()
                .foregroundColor(Color(hex: 0xED4D4D,alpha: 0.5))
                .frame(width: PROGRESS_CIRCLE_SIZE/2,height: PROGRESS_CIRCLE_SIZE/2)*/
            
        }
    }
 
}
