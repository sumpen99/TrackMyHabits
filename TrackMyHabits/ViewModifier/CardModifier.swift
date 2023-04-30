//
//  CardModifier.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-30.
//

import SwiftUI

struct CardModifier: ViewModifier{
    let size:CGFloat
    func body(content: Content) -> some View {
        content
            .frame(height: size)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .fillSection()
    }
}
