//
//  StatusCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-21.
//

import SwiftUI

struct StatusCardView: View{
  
        
    var title: String = "Idag"
       
    var body: some View {
        ZStack(alignment: .leading) {
            Color.darkBackground
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Text("Idag")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .padding(.bottom, 5)
                        Spacer()
                        Image(systemName: "mappin")
                    }
                    HStack{
                        Text("Igår")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .padding(.bottom, 5)
                        Spacer()
                        Image(systemName: "mappin")
                    }
                    HStack{
                        Text("Senaste veckan")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .padding(.bottom, 5)
                        Spacer()
                        Image(systemName: "mappin")
                    }
                    .padding(.bottom, 5)
                }
                .padding(.horizontal, 5)
                Spacer()
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.green,.brown, .black]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70, alignment: .center)
                    .onTapGesture { printAny("tap") }
            }
            .padding(15)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
