//
//  HabitCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-24.
//

import SwiftUI
struct HabitCardView: View {
    var title: String = "Läsa en bok"
    var subTitle: String = "För att hålla hjärna fräsch vore det bra att håll igång läsandet"
    
    var body: some View {
        ZStack(alignment:.center){
            NavigationLink(destination: Text("hepp")) {
              EmptyView()
            }
            Color.darkBackground
            HStack(alignment: .center) {
                Image(systemName: "brain.head.profile")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .accessibility(hidden: true)
               
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .accessibility(addTraits: .isHeader)
                    Spacer()
                    Text(subTitle)
                        .font(.caption)
                        .foregroundColor(.white)
                        //.fixedSize(horizontal: true, vertical: false)
                    HStack(alignment: .bottom){
                        Spacer()
                        .badge(
                            Text("31 \(Image(systemName: "flame"))")
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
        //.border(Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
        //.cornerRadius(15) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
        )
        .fillSection()
    }
    
}
