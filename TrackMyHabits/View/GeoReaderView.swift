//
//  GeoReaderView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI
struct GeoReaderView<Content: View>: View {
    let ratio:CGFloat
    let widthRatio:CGFloat
    let heightRatio:CGFloat
    let alignment: Alignment
    let detectMax:Bool
    let equalWidth:Bool
    let equalHeight:Bool
    let content: Content

    init(ratio:CGFloat = 1.0,
         widthRatio:CGFloat = 1.0,
         heightRatio:CGFloat = 1.0,
         equalWidth:Bool = false,
         equalHeight:Bool = false,
         detectMax:Bool = false,
         alignment:Alignment = .center,
         @ViewBuilder content: () -> Content) {
        self.ratio = ratio
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        self.alignment = alignment
        self.equalWidth = equalWidth
        self.equalHeight = equalHeight
        self.detectMax = detectMax
        self.content = content()
    }

    var body: some View {
        GeometryReader { geo in
            if detectMax{
                if geo.size.width > geo.size.height{
                    HStack {
                        Spacer()
                        content.frame(width:geo.size.width*ratio,
                                      height: geo.size.width*ratio,
                                      alignment: self.alignment)
                        Spacer()
                    }
                }
                else{
                    VStack {
                        Spacer()
                        content.frame(width:geo.size.height*ratio,
                                      height: geo.size.height*ratio,
                                      alignment: self.alignment)
                        Spacer()
                    }
                }
            }
            else if equalWidth{
                HStack {
                    Spacer()
                    content.frame(width: geo.size.width*widthRatio, height: geo.size.width*widthRatio, alignment: self.alignment)
                    Spacer()
                }
            }
            else if equalHeight{
                HStack {
                    Spacer()
                    content.frame(width: geo.size.height*heightRatio, height: geo.size.height*heightRatio, alignment: self.alignment)
                    Spacer()
                }
            }
            else{
                HStack {
                    Spacer()
                    content.frame(width: geo.size.width*widthRatio, height: geo.size.height*heightRatio, alignment: self.alignment)
                    Spacer()
                }
            }
        }
    }
}
