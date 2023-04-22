//
//  ItemRow.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-21.
//
import SwiftUI
struct ItemRow: View {
    let text: String
    let font:Font
    let color:Color
    let edgeInset:EdgeInsets
    init(_ text: String,
         color:Color = .gray,
         font:Font = .subheadline,
         edgeInset:EdgeInsets = EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0)) {
        self.text = text
        self.color = color
        self.font = font
        self.edgeInset = edgeInset
    }
    
    var body: some View {
        Text(self.text).foregroundColor(self.color).font(self.font)
            .frame(maxWidth: .infinity, alignment: .leading)
        .listRowBackground(Color.clear)
        .listRowInsets(self.edgeInset)
    }
}
