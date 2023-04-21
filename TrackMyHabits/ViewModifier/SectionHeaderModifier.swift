//
//  SectionHeaderModifier.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-21.
//

import SwiftUI

struct SectionHeaderModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .font(.system(size: 20,weight: .black).monospacedDigit())
            .foregroundColor(.white)
    }
}

