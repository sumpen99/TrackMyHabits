//
//  NavigationViewModifier.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-23.
//

import SwiftUI

func appLinearGradient() -> some View{
    return LinearGradient(gradient: Gradient(colors: [Color(hex:0x3E5151),Color(hex:0xDECBA4)]), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
}

struct NavigationViewModifier: ViewModifier {
    let title:String
    func body(content: Content) -> some View {
        content
        //.listStyle(GroupedListStyle())
        //.listRowBackground(Color(.systemGroupedBackground))
        .scrollContentBackground(.hidden)
        //.background( APP_BACKGROUND_COLOR )
        //.edgesIgnoringSafeArea(.all)
        .background( appLinearGradient())
        .navigationBarTitle(Text(title),displayMode: .inline)
        //.navigationBarHidden(true)
    }
}
