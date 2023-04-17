//
//  GeoReaderView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI
struct GeoReaderView<Content: View>: View {
    let widthRatio:CGFloat
    let heightRatio:CGFloat
    let content: Content

    init(widthRatio:CGFloat = 1.0,heightRatio:CGFloat = 1.0,@ViewBuilder content: () -> Content) {
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        self.content = content()
    }

    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                content.frame(width: geo.size.width*widthRatio, height: geo.size.height*heightRatio, alignment: .center)
                Spacer()
            }
        }
    }
}
