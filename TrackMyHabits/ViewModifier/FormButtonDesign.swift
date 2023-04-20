//
//  FormButtonDesign.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-20.
//

import SwiftUI

struct FormButtonDesign: ViewModifier{
    var width:CGFloat
    var backgroundColor: Color
    func body(content: Content) -> some View{
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: width, height: 50)
            .background(backgroundColor)
            .cornerRadius(15.0)
    }
}
