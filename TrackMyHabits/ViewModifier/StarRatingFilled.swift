//
//  StarRatingFilled.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-05-04.
//
import SwiftUI
struct StarRatingFilled: ViewModifier{
    let rating:CGFloat
    let maxRating:CGFloat
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { g in
                    let width = rating / maxRating * g.size.width
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                            .foregroundColor(.yellow)
                    }
                }
                .mask(content)
            )
            .foregroundColor(.gray)
    }
}

